//
//  CEPhotoLibraryService.m
//  Junhuashao
//
//  Created by JunhuaShao on 2017/4/25.
//  Copyright © 2017年 Junhuashao. All rights reserved.
//

#import <UIAlertController+GinUnit.h>
#import "GinPhotoLibraryManager.h"

NSString * const kPhotoAlbumName = @"指定相册";

@implementation GinPhotoLibraryManager

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static id sharedInstance = nil;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
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

+ (void)setupService
{
    [self checkAuthorizationStatus:^(BOOL allowed) {
        if (allowed) {
            if (![self getAlbumByTitle:kPhotoAlbumName]) {
                [self createAlbum:kPhotoAlbumName];
            }
        }
    }];
    
}

+ (void)createAlbum:(NSString *)title
{
    [self checkAuthorizationStatus:^(BOOL allowed) {
        if (allowed) {
            [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:title];
            } completionHandler:^(BOOL success, NSError * _Nullable error) {
                NSLog(@"album create ---> %d",success);
                if (!success) {
                    [UIAlertController alert:@"提示" message:@"相册创建失败" cancelTitle:@"确定" cancelBlock:nil
                             completionBlock:nil];
                }
            }];
        }
    }];
}

+ (PHAssetCollection *)getAlbumByTitle:(NSString *)title
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"localizedTitle = %@",kPhotoAlbumName];
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    option.predicate = predicate;
    
    PHAssetCollection *album = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:option].firstObject;
    
    return album;
}

+ (void)savePhotos:(NSArray <UIImage *> *)photos progress:(void(^)(NSString *localIdentifier, BOOL success, NSError *error))progress completion:(void(^)(void))completion
{
    [GinPhotoLibraryManager setupService];

    [photos enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @synchronized(self) {
            [self savePhoto:obj toAlbum:kPhotoAlbumName completion:progress];
        }
    }];
    
    if (completion) {
        completion();
    }
}

+ (void)savePhoto:(UIImage *)photo completion:(void(^)(NSString *localIdentifier, BOOL success, NSError *error))completion
{
    [GinPhotoLibraryManager setupService];
    [self savePhoto:photo toAlbum:kPhotoAlbumName completion:completion];
}

+ (void)savePhoto:(UIImage *)photo toAlbum:(NSString *)title completion:(void(^)(NSString *localIdentifier, BOOL success, NSError *error))completion
{
    [self checkAuthorizationStatus:^(BOOL allowed) {
        if (allowed) {
            __block PHObjectPlaceholder *assetPlaceholder;
            [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                // Request creating an asset from the image.
                PHAssetChangeRequest *createAssetRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:photo];
                // Request editing the album.
                PHAssetCollectionChangeRequest *albumChangeRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:[self getAlbumByTitle:kPhotoAlbumName]];
                // Get a placeholder for the new asset and add it to the album editing request.
                assetPlaceholder = [createAssetRequest placeholderForCreatedAsset];
                
                [albumChangeRequest addAssets:@[assetPlaceholder]];
                
            } completionHandler:^(BOOL success, NSError * _Nullable error) {
                
                if (completion) {
                    completion(assetPlaceholder.localIdentifier, success, error);
                }
            }];
        }
    }];
}

+ (PHFetchResult<PHAsset *> *)getAllPhotoAsset
{
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    PHFetchResult<PHAsset *> *assetsFetchResults = [PHAsset fetchAssetsWithOptions:options];
    return assetsFetchResults;
}

+ (void)getHighQualityImageFromAsset:(PHAsset *)asset completion:(void(^)(UIImage *image, NSDictionary *info))completion
{
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeDefault options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        if (completion) {
            completion(result, info);
        }
    }];
}

+ (void)getThumbnailImageFromAsset:(PHAsset *)asset targetSize:(CGSize)size contentMode:(PHImageContentMode)contentMode completion:(void(^)(UIImage *image, NSDictionary *info))completion
{
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:contentMode options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        if (completion) {
            completion(result, info);
        }
    }];
}

+ (void)getHighQualityImageFromAsset:(PHAsset *)asset targetSize:(CGSize)size contentMode:(PHImageContentMode)contentMode completion:(void(^)(UIImage *image, NSDictionary *info))completion
{
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.synchronous = YES;
    
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:contentMode options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        if (completion) {
            completion(result, info);
        }
    }];
}

#pragma - Private Method

+ (void)checkAuthorizationStatus:(void(^)(BOOL allowed))completion
{
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    
    void (^jumpToSettingsBlock)(void) = ^{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{UIApplicationOpenURLOptionUniversalLinksOnly : @NO} completionHandler:nil];
    };
    
    switch (status) {
            // 用户暂未权限认证
        case PHAuthorizationStatusNotDetermined: {
            NSLog(@"PHAuthorizationStatusNotDetermined");
            // 权限认证
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                NSLog(@"PHAuthorizationStatus:%ld",(long)status);
                if (status == PHAuthorizationStatusAuthorized) {
                    if (completion) {
                        completion(YES);
                    }
                } else {
                    NSLog(@"PHAuthorizationStatusRestricted");
                    [UIAlertController alert:@"提示" message:@"未获得相册授权，请进入 设置 -> 隐私 -> 相册 开启权限" submitTitle:@"前往" submitBlock:^(UIAlertAction *action) {
                        jumpToSettingsBlock();
                    } cancelTitle:@"取消" cancelBlock:nil completionBlock:nil];
                    
                    if (completion) {
                        completion(NO);
                    }
                }
            }];
        }
            break;
            // APP禁止使用相册权限认证
        case PHAuthorizationStatusRestricted: {
            NSLog(@"PHAuthorizationStatusRestricted");
            [UIAlertController alert:@"提示" message:@"未获得相册授权，请进入 设置 -> 隐私 -> 相册 开启权限" submitTitle:@"前往" submitBlock:^(UIAlertAction *action) {
                jumpToSettingsBlock();
            } cancelTitle:@"取消" cancelBlock:nil completionBlock:nil];
            
            if (completion) {
                completion(NO);
            }

        }
            break;
            // 用户拒绝使用相册
        case PHAuthorizationStatusDenied: {
            NSLog(@"PHAuthorizationStatusDenied");
            [UIAlertController alert:@"提示" message:@"未获得相册授权，请进入 设置 -> 隐私 -> 相册 开启权限" submitTitle:@"前往" submitBlock:^(UIAlertAction *action) {
                jumpToSettingsBlock();
            } cancelTitle:@"取消" cancelBlock:nil completionBlock:nil];
            if (completion) {
                completion(NO);
            }
        }
            break;
            // 用户允许使用相册
        case PHAuthorizationStatusAuthorized: {
            NSLog(@"PHAuthorizationStatusAuthorized");
            if (completion) {
                completion(YES);
            }
        }
            break;
        default:
            break;
    }
}

@end

