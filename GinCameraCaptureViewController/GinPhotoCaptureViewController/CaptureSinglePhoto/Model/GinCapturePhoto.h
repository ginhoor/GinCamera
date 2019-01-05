//
//  GinCapturePhoto.h
//  GinCameraCaptureManager
//
//  Created by JunhuaShao on 2019/1/4.
//  Copyright © 2019 JunhuaShao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GinMediaManager.h"
#import "GinCapturePhotoEnum.h"

typedef NS_ENUM(NSUInteger, GinPhotoAuditStatusEnumType) {
    GinPhotoAuditStatusEnumTypeAudtingPass,
    GinPhotoAuditStatusEnumTypeRejected,
    GinPhotoAuditStatusEnumTypeEdited,
};

@interface GinCapturePhoto : NSObject

@property (assign, nonatomic) NSInteger photoId;
/**
 本地照片
 */
@property (strong, nonatomic) NSString *localFilename;
@property (strong, nonatomic) NSString *photoUrl;
/**
 本地编辑照片
 */
@property (strong, nonatomic) NSString *editedLocalFilename;
@property (strong, nonatomic) NSString *editedPhotoUrl;
/**
 缓存数据
 */
@property (strong, nonatomic) UIImage *localImage;
/**
 标识
 */
@property (assign, nonatomic) NSInteger photoEnumNum;

@property (assign, nonatomic) GinMediaEditType option;

@property (strong, nonatomic) NSString *remark;

+ (instancetype)photo:(GinCapturePhotoEnum *)index;

/**
 优先返回editedLocalFilename，再查看LocalFilename
 */
- (NSString *)fetchLocalFilename;
/**
 优先返回editedPhotoUrl，再查看pictureUrl
 */
- (NSString *)fetchPhotoUrl;

-  (BOOL)hasEditedPhoto;

@end

