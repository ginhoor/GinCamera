//
//  UIView+Layer.h
//  LOLBox
//
//  Created by JunhuaShao on 15/4/8.
//  Copyright (c) 2015年 Ginhoor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Layer)

/**
 创建圆角
 
 @param type 圆角位置 UIRectCorner
 @param radii 角度
 */
- (void)cornerMask:(UIRectCorner)type radii:(CGFloat)radii;

@end
