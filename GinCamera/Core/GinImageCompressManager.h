//
//  GinImageCompressManager.h
//  GinCameraCaptureManager
//
//  Created by JunhuaShao on 2019/1/5.
//  Copyright © 2019 JunhuaShao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GinImageCompressManager : NSObject

/**
 size = CGSizeZero  不做处理
 size < 图片大小    进行缩放
 size > 图片大小    不做处理
 缩放方式：等比例缩放
 */
@property (assign, nonatomic) CGSize compressImageMaxSize;
/**
 图片文件压缩大小（单位：KB），值为0时不处理
 */
@property (assign, nonatomic) CGFloat compressMaxDataSize;

/**
 图片压缩质量（取值范围0-1），默认：1，值为0时输出质量为1
 */
@property (assign, nonatomic) CGFloat compressMaxQuality;

- (UIImage *)compressImage:(UIImage *)source;

@end

NS_ASSUME_NONNULL_END
