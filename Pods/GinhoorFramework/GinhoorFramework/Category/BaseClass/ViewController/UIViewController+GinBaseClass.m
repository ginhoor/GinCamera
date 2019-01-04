//
//  UIViewController+BaseClass.m
//  FrameworkDemo
//
//  Created by JunhuaShao on 15/4/14.
//  Copyright (c) 2015年 JunhuaShao. All rights reserved.
//

#import "UIViewController+GinBaseClass.h"

@implementation UIViewController (GinBaseClass)

+ (instancetype)controller
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:NSStringFromClass([self class]) bundle:nil];
    return [storyBoard instantiateInitialViewController];
}

+ (instancetype)controllerByDefaultName
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:NSStringFromClass([self class]) bundle:nil];
    return [storyBoard instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
}

+ (instancetype)controllerByStoryboard:(UIStoryboard *)storyboard
{
    return [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
}

+ (UIViewController *)lastPresentedViewController
{
    UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    if ([vc isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController*)vc;
        return [self getChildPresentViewController:nav.visibleViewController];
    } else {
        return [self getChildPresentViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
    }
}

+ (UIViewController *)lastPresentedViewControllerByWindow:(UIWindow *)window
{
    UIViewController *vc = window.rootViewController;
    if ([vc isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController*)vc;
        return [self getChildPresentViewController:nav.visibleViewController];
    } else {
        return [self getChildPresentViewController:window.rootViewController];
    }
}

+ (UIViewController *)getChildPresentViewController:(UIViewController *)parentViewController
{
    if (parentViewController.presentedViewController == nil) {
        return parentViewController;
    } else {
        return [self getChildPresentViewController:parentViewController.presentedViewController];
    }
}

@end
