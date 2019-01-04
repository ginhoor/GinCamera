//
//  UIView+Layer.m
//  LOLBox
//
//  Created by JunhuaShao on 15/4/8.
//  Copyright (c) 2015年 Ginhoor. All rights reserved.
//

#import "UIView+Layer.h"

@implementation UIView (Layer)

- (void)cornerMask:(UIRectCorner)type radii:(CGFloat)radii
{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:type cornerRadii:CGSizeMake(radii, radii)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}
@end

