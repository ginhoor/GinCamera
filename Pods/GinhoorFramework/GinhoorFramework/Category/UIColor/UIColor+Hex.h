//
//  UIColor+Hex.h
//  FrameworkDemo
//
//  Created by JunhuaShao on 15/5/23.
//  Copyright (c) 2015年 JunhuaShao. All rights reserved.
//

#import <UIKit/UIKit.h>

#define UIColorFromRGBA(r,g,b,a)    [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

@interface UIColor (Hex)

+ (UIColor *)colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue;
+ (UIColor *)colorWithHex:(NSInteger)hexValue;
+ (UIColor *)whiteColorWithAlpha:(CGFloat)alphaValue;
+ (UIColor *)blackColorWithAlpha:(CGFloat)alphaValue;

@end
