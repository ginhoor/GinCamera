//
//  GinPhotoCaptureStatusEnum.h
//  GinCameraCaptureManager
//
//  Created by JunhuaShao on 2019/1/5.
//  Copyright © 2019 JunhuaShao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, GinPhotoCaptureStatus) {
    GinPhotoCaptureStatusReady,
    GinPhotoCaptureStatusCaptured,
    GinPhotoCaptureStatusMark,
    GinPhotoCaptureStatusMosaics,
};

@interface GinPhotoCaptureStatusEnum : NSObject

@end

NS_ASSUME_NONNULL_END
