//
//  GinPhotoCaptureViewModel.m
//  JunhuaShao
//
//  Created by JunhuaShao on 2017/11/2.
//  Copyright © 2017年 JunhuaShao. All rights reserved.
//

#import <SDWebImageDownloader.h>
#import <BlocksKit.h>
#import <NSString+GinUnit.h>
#import <Gin_Macro.h>

#import "GinPhotoCaptureViewModel.h"
#import "GinMediaManager.h"

@interface GinPhotoCaptureViewModel()

@property (strong, nonatomic) NSArray <GinCapturePhotoEnum *> *photoIndexQueue;
/**
 预览图
 */
@property (strong, nonatomic) NSMutableDictionary <NSString *, GinCapturePhoto *> *capturedPhotoMap;

@end

@implementation GinPhotoCaptureViewModel

+ (instancetype)viewModelWithPhotoIndexQueue:(NSArray<GinCapturePhotoEnum *> *)photoIndexQueue photoList:(NSArray <GinCapturePhoto *> *)photoList
{
    GinPhotoCaptureViewModel *vm = [[GinPhotoCaptureViewModel alloc] init];
    
    vm.photoIndexQueue = photoIndexQueue;
    
    [photoIndexQueue enumerateObjectsUsingBlock:^(GinCapturePhotoEnum * _Nonnull index, NSUInteger idx, BOOL * _Nonnull stop) {
        
        GinCapturePhoto *photo = [photoList bk_match:^BOOL(GinCapturePhoto *photo) {
            return photo.photoEnumNum == index.num;
        }];
        
        vm.capturedPhotoMap[index.key] = photo;
    }];
    
    return vm;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.capturedPhotoMap = [NSMutableDictionary dictionary];
}

- (GinEditPhotoViewModel *)editViewModel
{
    if (!_editViewModel) {
        _editViewModel = [[GinEditPhotoViewModel alloc] init];
    }
    return _editViewModel;
}

- (NSArray<GinCapturePhoto *> *)capturedPhotoList
{
    NSMutableArray *mArr = [NSMutableArray array];
    
    [self.photoIndexQueue enumerateObjectsUsingBlock:^(GinCapturePhotoEnum * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([self.capturedPhotoMap.allKeys containsObject:obj.key]) {
            [mArr addObject:self.capturedPhotoMap[obj.key]];
        }
    }];
    return mArr;
}

- (NSArray <GinCapturePhoto *> *)otherCapturedPhotoList
{
    NSMutableArray *mArr = [NSMutableArray array];
    
    [[self.photoIndexQueue bk_select:^BOOL(GinCapturePhotoEnum * _Nonnull obj) {
        return obj.category == GinCapturePhotoCategoryUnlimited;
    }] enumerateObjectsUsingBlock:^(GinCapturePhotoEnum * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([self.capturedPhotoMap.allKeys containsObject:obj.key]) {
            [mArr addObject:self.capturedPhotoMap[obj.key]];
        }
    }];
    return mArr;
}

- (GinCapturePhoto *)getPhotoAtIndex:(GinCapturePhotoEnum *)index
{
    if ([self.capturedPhotoMap.allKeys containsObject:index.key]) {
        return self.capturedPhotoMap[index.key];
    } else {
        return [GinCapturePhoto photo:index];
    }
}

- (GinCapturePhoto *)getExistPhotoAtIndex:(GinCapturePhotoEnum *)index
{
    if ([self.capturedPhotoMap.allKeys containsObject:index.key]) {
        return self.capturedPhotoMap[index.key];
    } else {
        return nil;
    }
}

- (GinCapturePhoto *)getCurrentPhoto
{
    return [self getPhotoAtIndex:self.currentPhotoIndex];
}

- (GinCapturePhotoEnum *)getIndexByPhoto:(GinCapturePhoto *)photo
{
    if ([self.capturedPhotoMap.allValues containsObject:photo]) {
        
        return [self.photoIndexQueue bk_match:^BOOL(GinCapturePhotoEnum *obj) {
            return obj.num == photo.photoEnumNum;
        }];
    } else {
        return nil;
    }
}

- (void)setCapturedPhoto:(GinCapturePhoto *)photo atIndex:(GinCapturePhotoEnum *)item
{
    if (photo) {
        self.capturedPhotoMap[item.key] = photo;
        
        if (photo.photoId == 0) {
            photo.option = GinMediaEditTypeCreate;
        } else {
            photo.option = GinMediaEditTypeEdited;
        }
        
        if (self.didPhotoCaptureListChangedBlock) {
            self.didPhotoCaptureListChangedBlock(photo, item, photo.option);
        }
        
    } else {
        [self.capturedPhotoMap removeObjectForKey:item.key];
    }
}

- (void)updateCapturedPhoto:(GinCapturePhoto *)photo atIndex:(GinCapturePhotoEnum *)item
{
    if (photo) {
        self.capturedPhotoMap[item.key] = photo;
        if (photo.photoId == 0) {
            photo.option = GinMediaEditTypeCreate;
        } else {
            photo.option = GinMediaEditTypeEdited;
        }
    } else {
        [self.capturedPhotoMap removeObjectForKey:item.key];
    }
}

- (void)setNextPhotoIndex:(GinCapturePhotoEnum *)nextPhotoIndex
{
    _nextPhotoIndex = nextPhotoIndex;
    if (nextPhotoIndex){
        self.nextType = GinPhotoQueueCaptureNextTypeCapturePhoto;
    } else {
        self.nextType = GinPhotoQueueCaptureNextTypeNothing;
    }
}

- (void)setCurrentPhotoIndex:(GinCapturePhotoEnum *)currentPhotoIndex
{
    _currentPhotoIndex = currentPhotoIndex;
    
    if (self.photoIndexQueue) {
        self.nextPhotoIndex = [self findNextPhotoIndex:self.currentPhotoIndex];
    }
}

- (GinCapturePhotoEnum *)findNextPhotoIndex:(GinCapturePhotoEnum *)currentPhotoIndex
{
    NSInteger index = [self.photoIndexQueue indexOfObject:currentPhotoIndex];
    
    __block NSInteger emptyPhotoIndex = -1;
    [self.photoIndexQueue enumerateObjectsUsingBlock:^(GinCapturePhotoEnum * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        GinCapturePhoto *photo = [self getExistPhotoAtIndex:obj];
        if (!photo && idx > index) {
            emptyPhotoIndex = idx;
            *stop = YES;
        }
    }];
    
    if (emptyPhotoIndex >= index &&
        index < self.photoIndexQueue.count - 1) {
//        如果照片不是最后一张
        currentPhotoIndex = self.photoIndexQueue[emptyPhotoIndex];
        
        GinCapturePhoto *photo = [self getPhotoAtIndex:currentPhotoIndex];
        NSString *localFilename = [photo fetchLocalFilename];
        NSString *photoUrl = [photo fetchPhotoUrl];
        
        if ([localFilename isNotBlank] ||
            [photoUrl isNotBlank]) {
            return [self findNextPhotoIndex:currentPhotoIndex];
        } else {
            return currentPhotoIndex;
        }
    } else if (index == self.photoIndexQueue.count - 1 || emptyPhotoIndex == -1) {
        return nil;
    } else {
        return [self cycelFindNextPhotoIndex];
    }
}

- (GinCapturePhotoEnum *)cycelFindNextPhotoIndex
{
    GinCapturePhotoEnum *firstPhotoIndex = self.photoIndexQueue.firstObject;
    
    GinCapturePhoto *firstPhoto = [self getPhotoAtIndex:firstPhotoIndex];
    NSString *localFilename = [firstPhoto fetchLocalFilename];
    NSString *photoUrl = [firstPhoto fetchPhotoUrl];
    
    if ([localFilename isNotBlank] || [photoUrl isNotBlank]) {
        GinCapturePhotoEnum *nextPhotoIndex = [self findNextPhotoIndex:firstPhotoIndex];
        if (nextPhotoIndex) {
            return nextPhotoIndex;
        } else {
            return nil;
        }
    } else {
        return firstPhotoIndex;
    }
}

- (void)updateEditedImageByCurrentCapturedPhoto
{
    GinCapturePhoto *currentPhoto = [self getCurrentPhoto];
    
    NSString *localFilename;
    NSString *pictureUrl;
    
    if (self.showOriginPhoto) {
        localFilename = currentPhoto.localFilename;
        pictureUrl = currentPhoto.photoUrl;
    } else {
        localFilename = [currentPhoto fetchLocalFilename];
        pictureUrl = [currentPhoto fetchPhotoUrl];
    }
    
    if ([localFilename isNotBlank]) {
        self.editViewModel.photoImage = [GinMediaManager getImageByName:localFilename];
        [self.editViewModel setPreviewAndFilterImageByDisplaySize:CGSizeMake(SCREEN_WIDTH*4/3, SCREEN_WIDTH)];
        [self.editViewModel clearAllAction];
        
    } else if ([pictureUrl isNotBlank]) {
        
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:pictureUrl] options:SDWebImageDownloaderHighPriority progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
            self.editViewModel.photoImage = image;
            [self.editViewModel setPreviewAndFilterImageByDisplaySize:CGSizeMake(SCREEN_WIDTH*4/3, SCREEN_WIDTH)];
            [self.editViewModel clearAllAction];
        }];
    }
}

- (void)deleteCapturedImage:(GinCapturePhotoEnum *)photoIndex
{
    GinCapturePhoto *photo = [self getPhotoAtIndex:photoIndex];
    
    NSInteger index = [self.photoIndexQueue indexOfObject:photoIndex];
    __block GinCapturePhotoEnum *nextIndex;
    
    if (photoIndex.category == GinCapturePhotoCategoryUnlimited) {
        [self.photoIndexQueue enumerateObjectsUsingBlock:^(GinCapturePhotoEnum * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx > index) {

                GinCapturePhoto *photo = [self getExistPhotoAtIndex:obj];
                GinCapturePhotoEnum *lastIndex = self.photoIndexQueue[idx-1];
                
                if (photo) {
                    photo.photoEnumNum = lastIndex.num;
                    if (photo.photoId != 0) {
                        photo.option = GinMediaEditTypeEdited;
                    }
            
                    self.capturedPhotoMap[lastIndex.key] = photo;
            
                    if (idx == self.photoIndexQueue.count - 1) {
                        [self.capturedPhotoMap removeObjectForKey:obj.key];
                        nextIndex = obj;
                    }
                    
                } else {
                    [self.capturedPhotoMap removeObjectForKey:lastIndex.key];
                    
                    nextIndex = lastIndex;
                    *stop = YES;
                }
            }
        }];
    } else {
        GinCapturePhotoEnum *currentIndex = self.photoIndexQueue[index];
        [self.capturedPhotoMap removeObjectForKey:currentIndex.key];
    }
    
    if ([photo.editedLocalFilename isNotBlank]) {
        [GinMediaManager deleteImageByName:photo.editedLocalFilename];
    }
    
    if ([photo.localFilename isNotBlank]) {
        [GinMediaManager deleteImageByName:photo.localFilename];
    }
    
    photo.localFilename = nil;
    photo.editedPhotoUrl = nil;
    photo.photoUrl = nil;
    photo.editedPhotoUrl = nil;
    photo.editedLocalFilename = nil;
    photo.option = GinMediaEditTypeDelete;
    
    if (self.didPhotoCaptureListChangedBlock) {
        self.didPhotoCaptureListChangedBlock(photo, photoIndex, GinMediaEditTypeDelete);
    }
    self.nextPhotoIndex = nextIndex;
}

- (GinImageCompressManager *)compressManager
{
    if (!_compressManager) {
        _compressManager = [[GinImageCompressManager alloc] init];
    }
    return _compressManager;
}

@end
