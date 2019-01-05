//
//  GinPhotoCaptureViewModel.h
//  JunhuaShao
//
//  Created by JunhuaShao on 2017/11/2.
//  Copyright © 2017年 JunhuaShao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GinImageCompressManager.h"

#import "GinEditPhotoViewModel.h"
#import "GinCapturePhotoEnum.h"
#import "GinCapturePhoto.h"

typedef NS_ENUM(NSUInteger, GinPhotoQueueCaptureNextType) {
    GinPhotoQueueCaptureNextTypeNothing,
    GinPhotoQueueCaptureNextTypeCapturePhoto,
};

@interface GinPhotoCaptureViewModel : NSObject
/**
 主线流程
 */
@property (strong, nonatomic, readonly) NSArray <GinCapturePhotoEnum *> *photoIndexQueue;

@property (assign, nonatomic) GinPhotoQueueCaptureNextType nextType;
@property (strong, nonatomic) GinCapturePhotoEnum *currentPhotoIndex;
@property (strong, nonatomic) GinCapturePhotoEnum *nextPhotoIndex;

@property (strong, nonatomic) GinEditPhotoViewModel *editViewModel;
@property (strong, nonatomic) GinImageCompressManager *compressManager;

@property (assign, nonatomic) BOOL showOriginPhoto;

@property (copy, nonatomic) void(^didPhotoCaptureListChangedBlock) (GinCapturePhoto *photo, GinCapturePhotoEnum *item, GinMediaEditType option);

+ (instancetype)viewModelWithPhotoIndexQueue:(NSArray<GinCapturePhotoEnum *> *)photoIndexQueue photoList:(NSArray <GinCapturePhoto *> *)photoList;

/**
 查找下一个 index
 */
- (GinCapturePhotoEnum *)findNextPhotoIndex:(GinCapturePhotoEnum *)currentPhotoIndex;
/**
 从头部循环查找是否存在下一步
 
 */
- (GinCapturePhotoEnum *)cycelFindNextPhotoIndex;
/**
 设置照片
 */
- (void)setCapturedPhoto:(GinCapturePhoto *)photo atIndex:(GinCapturePhotoEnum *)item;

- (void)updateCapturedPhoto:(GinCapturePhoto *)photo atIndex:(GinCapturePhotoEnum *)item;

/**
 通过index获取Photo
 */
- (GinCapturePhoto *)getPhotoAtIndex:(GinCapturePhotoEnum *)index;
- (GinCapturePhoto *)getExistPhotoAtIndex:(GinCapturePhotoEnum *)index;
- (GinCapturePhoto *)getCurrentPhoto;

/**
 通过Photo获取Index
 */
- (GinCapturePhotoEnum *)getIndexByPhoto:(GinCapturePhoto *)photo;

- (NSArray <GinCapturePhoto *> *)otherCapturedPhotoList;

- (void)updateEditedImageByCurrentCapturedPhoto;

- (void)deleteCapturedImage:(GinCapturePhotoEnum *)photoIndex;

@end
