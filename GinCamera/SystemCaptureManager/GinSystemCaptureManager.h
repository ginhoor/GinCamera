//
//  GinSystemCaptureManager.h
//  CommercialVehiclePlatform
//
//  Created by JunhuaShao on 2018/1/29.
//  Copyright © 2018年 JunhuaShao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GinAVCaptureManager.h"

@interface GinSystemCaptureManager : GinAVCaptureManager

@property (weak, nonatomic, readonly) UIViewController *presentedViewController;

/**
 是否对图片做压缩处理
 */
@property (assign, nonatomic) BOOL compress;
/**
 如果size等于CGSizeZero则不会对结果图片进行处理，反之如果图片超过size，则会将图片缩放到指定大小
 */
@property (assign, nonatomic) CGSize compressImageMaxSize;
/**
 图片文件压缩大小（单位：KB）
 */
@property (assign, nonatomic) CGFloat compressMaxDataSize;

/**
 图片压缩质量（取值范围0-1）
 */
@property (assign, nonatomic) CGFloat compressMaxQuality;

@property (assign, nonatomic, readonly) BOOL imageEditable;
/**
 图片裁剪框的宽高比
 */
@property (assign, nonatomic) CGSize imageEditAspectRatio;

@property (copy, nonatomic) void(^didImageCapturedBlock) (UIImage *image);

+ (instancetype)sharedInstance;

/**
 拍摄或选择
 @param presentedViewController 展现层
 @param compressImageMaxSize 图片缩放大小
 @param didImageCapturedBlock 完成回调
 */
+ (void)toSystemCapture:(UIViewController *)presentedViewController   
   compressImageMaxSize:(CGSize)compressImageMaxSize
  didImageCapturedBlock:(void(^)(UIImage *image))didImageCapturedBlock;
/**
 拍摄或选择后可编辑

 @param presentedViewController 展现层
 @param imageEditAspectRatio 裁剪框宽高比
 @param compressImageMaxSize 图片缩放大小
 @param didImageCapturedBlock 完成回调
 */
+ (void)toEditableSystemCapture:(UIViewController *)presentedViewController
           imageEditAspectRatio:(CGSize)imageEditAspectRatio
           compressImageMaxSize:(CGSize)compressImageMaxSize
          didImageCapturedBlock:(void(^)(UIImage *image))didImageCapturedBlock;
/**
 开始图片拍摄或者选择

 @param presentedViewController 展现层
 @param imageEditable 是否可编辑
 @param imageEditAspectRatio 裁剪框宽高比
 @param compress 是否压缩
 @param compressImageMaxSize 图片缩放大小
 @param compressMaxQuality 压缩质量
 @param compressMaxDataSize 压缩后文件大小
 @param didImageCapturedBlock 完成回调
 */
+ (void)toSystemCapture:(UIViewController *)presentedViewController
          imageEditable:(BOOL)imageEditable
   imageEditAspectRatio:(CGSize)imageEditAspectRatio
               compress:(BOOL)compress
   compressImageMaxSize:(CGSize)compressImageMaxSize
     compressMaxQuality:(CGFloat)compressMaxQuality
    compressMaxDataSize:(CGFloat)compressMaxDataSize
  didImageCapturedBlock:(void(^)(UIImage *image))didImageCapturedBlock;

@end
