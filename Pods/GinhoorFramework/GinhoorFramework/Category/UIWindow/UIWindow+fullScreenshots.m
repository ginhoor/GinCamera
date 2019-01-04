//
//  UIWindow+fullScreenshots.m
//  LOLBox
//
//  Created by Ginhoor on 14-7-25.
//  Copyright (c) 2014年 Ginhoor. All rights reserved.
//

#import "UIWindow+fullScreenshots.h"

@implementation UIWindow (fullScreenshots)

- (UIImage *)fullScreenshots {
    UIGraphicsBeginImageContext(self.frame.size);//全屏截图，包括window

    [self.layer renderInContext:UIGraphicsGetCurrentContext()];

    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return viewImage;
}

@end
