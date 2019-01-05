//
//  GinPhotoSingleCaptureViewModel.m
//  CommercialVehiclePlatform
//
//  Created by JunhuaShao on 2018/6/13.
//  Copyright © 2018年 JunhuaShao. All rights reserved.
//
#import <SDWebImageDownloader.h>
#import <ReactiveObjC.h>
#import <NSString+GinUnit.h>
#import <Gin_Macro.h>

#import "GinPhotoSingleCaptureViewModel.h"
#import "GinMediaManager.h"

@interface GinPhotoSingleCaptureViewModel()

@end

@implementation GinPhotoSingleCaptureViewModel

+ (instancetype)viewModelWithPhoto:(GinCapturePhoto *)photo
{
    GinPhotoSingleCaptureViewModel *vm = [[GinPhotoSingleCaptureViewModel alloc] init];
    vm.photo = photo;
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
}

- (void)setPhoto:(GinCapturePhoto *)photo
{
    _photo = photo;
    
    __weak typeof(self) _WeakSelf = self;
    [RACObserve(self.photo, localFilename) subscribeNext:^(NSString *x) {
        if ([x isNotBlank]) {
            if (_WeakSelf.photo.photoId == 0) {
                _WeakSelf.photo.option = GinMediaEditTypeCreate;
            } else {
                _WeakSelf.photo.option = GinMediaEditTypeEdited;
            }
        }
    }];
}
- (void)updateEditedImageByCurrentCapturedPhoto
{
    NSString *localFilename;
    NSString *pictureUrl;
    
    if (self.showOriginPhoto) {
        localFilename = self.photo.localFilename;
        pictureUrl = self.photo.photoUrl;
    } else {
        localFilename = [self.photo fetchLocalFilename];
        pictureUrl = [self.photo fetchPhotoUrl];
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

- (void)deleteCapturedImage
{
    if ([self.photo.editedLocalFilename isNotBlank]) {
        [GinMediaManager deleteImageByName:self.photo.editedLocalFilename];
        self.photo.editedLocalFilename = nil;
    }
    
    if ([self.photo.localFilename isNotBlank]) {
        [GinMediaManager deleteImageByName:self.photo.localFilename];
        self.photo.localFilename = nil;
    }
    
    self.photo.photoEnumNum = -1;
    self.photo.editedPhotoUrl = nil;
    self.photo.photoUrl = nil;
    self.photo.editedPhotoUrl = nil;
    self.photo.editedLocalFilename = nil;
    self.photo.option = GinMediaEditTypeDelete;
}

- (GinEditPhotoViewModel *)editViewModel
{
    if (!_editViewModel) {
        _editViewModel = [[GinEditPhotoViewModel alloc] init];
    }
    return _editViewModel;
}

- (GinImageCompressManager *)compressManager
{
    if (!_compressManager) {
        _compressManager = [[GinImageCompressManager alloc] init];
    }
    return _compressManager;
}

@end
