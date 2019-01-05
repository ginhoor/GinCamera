//
//  UIImage+Edit.h
//  FrameworkDemo
//
//  Created by JunhuaShao on 2019/1/5.
//  Copyright © 2019 JunhuaShao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Edit)

#pragma mark- 裁剪
/**
 截取图片
 
 @param rect 图片范围
 @return 图片
 */
- (UIImage *)cropImageByRect:(CGRect)rect;
/**
 截取部分图片
 
 @param path 图片保存路径
 @param r 范围rect
 */
- (void)savePartImage:(NSString *)path rect:(CGRect)r;
/**
 根据中心裁剪指定大小的图片
 */
- (UIImage *)imageByScalingAndCroppingForSize:(CGSize)targetSize;

#pragma mark- 缩放
/**
 缩放图片大小
 
 @param size 缩放到指定大小
 @param maxQuality 最大质量 0-1 使用框架方法压缩质量
 @return 图片
 */
- (UIImage *)scaleToSize:(CGSize)size maxQuality:(CGFloat)maxQuality;
- (UIImage *)scaleToSize:(CGSize)size;
/**
 缩放图片大小
 
 @param scaleSize 缩放比例
 @return 图片
 */
- (UIImage *)scaleImageTo:(CGFloat)scaleSize;
- (UIImage *)scaleImageByWidth:(CGFloat)width;

#pragma mark- 方向
/**
 改变图片方向
 */
- (UIImage *)changeOrientationTo:(UIImageOrientation)orientation;
/**
 解决保存图片或重绘图片后旋转90度
 */
- (UIImage *)fixOrientation;

@end

NS_ASSUME_NONNULL_END
