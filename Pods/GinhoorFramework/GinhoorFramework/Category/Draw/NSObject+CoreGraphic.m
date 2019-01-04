//
//  NSObject+CoreGraphic.m
//  LOLBox
//
//  Created by JunhuaShao on 15/4/2.
//  Copyright (c) 2015年 Ginhoor. All rights reserved.
//

#import "NSObject+CoreGraphic.h"

@implementation NSObject (CoreGraphic)

- (UIImage *)maskImage:(CGRect)rect clearRect:(CGRect)clearRect custom:(void (^)(CGRect frame,CGRect clearRect))customBlock
{
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(context, 0,0,0,0.5);
    
    CGContextFillRect(context, rect);   //draw the transparent layer
    CGContextClearRect(context, clearRect);  //clear the center rect  of the layer
    
    if (customBlock) {
        customBlock(rect,clearRect);
    }
    
    UIImage *returnimage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return returnimage;
}

- (void)drawLine:(CGPoint)start end:(CGPoint)end lineWidth:(CGFloat)lineWitdh LineColor:(UIColor *)color
{
    
    UIBezierPath *topPath = [UIBezierPath bezierPath];
    [topPath moveToPoint:start];
    [topPath addLineToPoint:end];
    topPath.lineWidth = lineWitdh;
    [color setStroke];
    [topPath stroke];
}

@end
