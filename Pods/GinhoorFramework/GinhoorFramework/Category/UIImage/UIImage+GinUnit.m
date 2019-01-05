//
//  UIImage+GinUnit.m
//  LOLBox
//
//  Created by Ginhoor on 14-8-16.
//  Copyright (c) 2014年 Ginhoor. All rights reserved.
//

#import "UIImage+GinUnit.h"

@implementation UIImage (GinUnit)

+ (UIImage *)imageWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

@end
