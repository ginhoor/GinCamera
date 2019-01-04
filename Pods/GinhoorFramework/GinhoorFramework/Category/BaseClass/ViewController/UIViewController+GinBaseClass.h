//
//  UIViewController+BaseClass.h
//  FrameworkDemo
//
//  Created by JunhuaShao on 15/4/14.
//  Copyright (c) 2015年 JunhuaShao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (GinBaseClass)

+ (instancetype)controller;
+ (instancetype)controllerByDefaultName;
+ (instancetype)controllerByStoryboard:(UIStoryboard *)storyboard;

+ (UIViewController *)lastPresentedViewController;
+ (UIViewController *)lastPresentedViewControllerByWindow:(UIWindow *)window;

@end
