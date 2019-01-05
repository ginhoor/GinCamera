//
//  UIImage+GinUnit.h
//  LOLBox
//
//  Created by Ginhoor on 14-8-16.
//  Copyright (c) 2014年 Ginhoor. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIImage+Color.h"
#import "UIImage+Filter.h"
#import "UIImage+Edit.h"
#import "UIImage+Compress.h"

@interface UIImage (GinUnit)

/**
 获得View的截图

 @param view 视图
 @return 图片
 */
+ (UIImage *)imageWithView:(UIView *)view;

@end
