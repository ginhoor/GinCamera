//
//  GinPopupGradientView.m
//  demo4TextKit
//
//  Created by JunhuaShao on 15/3/23.
//  Copyright (c) 2015年 JunhuaShao. All rights reserved.
//

#import "GinPopupGradientView.h"

@implementation GinPopupGradientView


- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context);

    size_t gradLocationsNum = 2;
    CGFloat gradLocations[2] = {0.0f, 1.0f};
    CGFloat gradColors[8] = {0, 0, 0, 0.3, 0, 0, 0, 0.8};

    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, gradColors, gradLocations, gradLocationsNum);

    CGColorSpaceRelease(colorSpace);
    colorSpace = NULL;
    
    CGPoint gradCenter = CGPointMake(round(CGRectGetMidX(self.bounds)), round(CGRectGetMidY(self.bounds)));
    CGFloat gradRadius = MAX(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    CGContextDrawRadialGradient(context, gradient, gradCenter, 0, gradCenter, gradRadius, kCGGradientDrawsAfterEndLocation);
    CGGradientRelease(gradient);
    gradient = NULL;

    CGContextRestoreGState(context);
}

@end
