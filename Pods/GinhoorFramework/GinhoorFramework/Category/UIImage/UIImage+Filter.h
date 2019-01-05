//
//  UIImage+Filter.h
//  FrameworkDemo
//
//  Created by JunhuaShao on 2019/1/5.
//  Copyright © 2019 JunhuaShao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Filter)

/**
 圆角图片
 @param r 远角
 @return 图片
 */
- (UIImage *)addRoundedRectImageByRadius:(NSInteger)r;

/**
 马赛克
 @param level 代表一个点转为多少level*level的正方形
 */
- (UIImage *)transToMosaicImageByblockLevel:(NSUInteger)level;

/**
 高斯模糊
 */
- (UIImage *)filterForGaussianBlur;

@end

NS_ASSUME_NONNULL_END
