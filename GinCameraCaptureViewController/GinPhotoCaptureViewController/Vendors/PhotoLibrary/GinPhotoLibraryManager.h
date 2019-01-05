//
//  CEPhotoLibraryService.h
//  Junhuashao
//
//  Created by JunhuaShao on 2017/4/25.
//  Copyright © 2017年 Junhuashao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@interface GinPhotoLibraryManager : NSObject

+ (instancetype)sharedInstance;

+ (void)setupService;
+ (void)checkAuthorizationStatus:(void(^)(BOOL allowed))completion;

+ (PHFetchResult<PHAsset *> *)getAllPhotoAsset;

+ (void)getHighQualityImageFromAsset:(PHAsset *)asset completion:(void(^)(UIImage *image, NSDictionary *info))completion;
+ (void)getHighQualityImageFromAsset:(PHAsset *)asset targetSize:(CGSize)size contentMode:(PHImageContentMode)contentMode completion:(void(^)(UIImage *image, NSDictionary *info))completion;

+ (void)getThumbnailImageFromAsset:(PHAsset *)asset targetSize:(CGSize)size contentMode:(PHImageContentMode)contentMode completion:(void(^)(UIImage *image, NSDictionary *info))completion;

+ (void)savePhotos:(NSArray <UIImage *> *)photos progress:(void(^)(NSString *localIdentifier, BOOL success, NSError *error))progress completion:(void(^)(void))completion;

+ (void)savePhoto:(UIImage *)photo completion:(void(^)(NSString *localIdentifier, BOOL success, NSError * error))completion;


@end
