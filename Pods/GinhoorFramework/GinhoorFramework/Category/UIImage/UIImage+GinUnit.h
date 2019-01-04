//
//  UIImage+GinUnit.h
//  LOLBox
//
//  Created by Ginhoor on 14-8-16.
//  Copyright (c) 2014年 Ginhoor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (GinUnit)


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
 改变image的颜色（对单色image比较有用）

 @param color 颜色
 @return 图片
 */
- (UIImage *)changeColor:(UIColor*)color;

/**
 获得纯色图片
 
 @param color 颜色
 @return 图片
 */
+ (UIImage *)imageByColor:(UIColor *)color;

/**
 获得纯色图片

 @param color 颜色
 @param imageSize 图片大小
 @return 图片
 */
+ (UIImage *)imageByColor:(UIColor *)color imageSize:(CGSize)imageSize;

/**
 获得灰度图片
 */
- (UIImage *)getGrayImage;

/**
 缩放图片大小

 @param size 缩放到指定大小
 @return 图片
 */
- (UIImage *)scaleToSize:(CGSize)size;
- (UIImage *)scaleToSize:(CGSize)size maxQuality:(CGFloat)maxQuality;

/**
 缩放图片大小

 @param scaleSize 缩放比例
 @return 图片
 */
- (UIImage *)scaleImageTo:(CGFloat)scaleSize;
- (UIImage *)scaleImageByWidth:(CGFloat)width;

/**
 改变图片方向
 */
- (UIImage *)changeOrientationTo:(UIImageOrientation)orientation;
// 解决保存图片或重绘图片后旋转90度的方法
- (UIImage *)fixOrientation;

/**
 *  压缩图片到指定文件大小
 *
 *  @param image 目标图片
 *  @param maxQuality 目标大小（最大值）
 *
 *  @return 返回的图片文件
 */
- (NSData *)compressToMaxDataSizeKBytes:(CGFloat)size maxQuality:(CGFloat)maxQuality;

/**
 裁剪图片到指定大小
 */
- (UIImage *)imageByScalingAndCroppingForSize:(CGSize)targetSize;

/**
 圆角图片

 @param r 远角
 @return 图片
 */
- (UIImage *)addRoundedRectImageByRadius:(NSInteger)r;

/**
 获得View的截图

 @param view 视图
 @return 图片
 */
+ (UIImage *)imageWithView:(UIView *)view;

@end
