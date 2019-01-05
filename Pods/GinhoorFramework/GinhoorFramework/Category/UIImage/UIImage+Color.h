//
//  UIImage+Color.h
//  FrameworkDemo
//
//  Created by JunhuaShao on 2019/1/5.
//  Copyright © 2019 JunhuaShao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Color)

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

@end

NS_ASSUME_NONNULL_END
