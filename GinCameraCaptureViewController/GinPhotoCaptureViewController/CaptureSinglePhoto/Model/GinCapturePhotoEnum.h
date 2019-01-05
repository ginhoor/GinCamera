//
//  GinCapturePhotoEnum.h
//  GinCameraCaptureManager
//
//  Created by JunhuaShao on 2019/1/4.
//  Copyright © 2019 JunhuaShao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GinCapturePhotoEnum : NSObject

@property (assign, nonatomic) NSInteger num;
@property (strong, nonatomic) NSString *key;
@property (strong, nonatomic) NSString *displayName;

/**
 预览图 URL
 */
@property (strong, nonatomic) NSString *sampleUrl;
/**
 提示H5 URL
 */
@property (strong, nonatomic) NSString *viewUrl;

@end
