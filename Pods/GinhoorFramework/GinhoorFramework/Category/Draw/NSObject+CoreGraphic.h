//
//  NSObject+CoreGraphic.h
//  LOLBox
//
//  Created by JunhuaShao on 15/4/2.
//  Copyright (c) 2015年 Ginhoor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSObject (CoreGraphic)

/**
 使用方法
 [self maskImage:self.view.bounds clearRect:self.scanViewRect custom:^(CGRect frame, CGRect clearRect) {
    CGFloat maskLineWitdh = 4;
    CGFloat length = 18;
    NSArray *points =@[
    @[PointValue(CGRectGetMinX(clearRect), CGRectGetMinY(clearRect)+maskLineWitdh/2),
    PointValue(CGRectGetMinX(clearRect)+length, CGRectGetMinY(clearRect)+maskLineWitdh/2)],
 
    @[PointValue(CGRectGetMinX(clearRect)+maskLineWitdh/2, CGRectGetMinY(clearRect)+maskLineWitdh),
    PointValue(CGRectGetMinX(clearRect)+maskLineWitdh/2, CGRectGetMinY(clearRect)-maskLineWitdh/2+length)],
 ];
 
 [points enumerateObjectsUsingBlock:^(NSArray *twoPoints, NSUInteger idx, BOOL *stop) {
    NSValue *start = twoPoints.firstObject;
    NSValue *end = twoPoints.lastObject;
     [self drawLine:start.CGPointValue end:end.CGPointValue lineWidth:maskLineWitdh LineColor:[UIColor orangeColor]];
     }];
 }];

 @param rect 图片尺寸
 @param clearRect 镂空区域
 @param customBlock 自定义操作
 @return 图片
 */
- (UIImage *)maskImage:(CGRect)rect clearRect:(CGRect)clearRect custom:(void (^)(CGRect frame,CGRect clearRect))customBlock;

/**
 绘制直线
 @param start 起点
 @param end 重点
 @param lineWitdh 线宽
 @param color 颜色
 */
- (void)drawLine:(CGPoint)start end:(CGPoint)end lineWidth:(CGFloat)lineWitdh LineColor:(UIColor *)color;

@end
