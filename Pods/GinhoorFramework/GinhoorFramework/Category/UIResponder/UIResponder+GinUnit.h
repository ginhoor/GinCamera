//
//  UIResponder+GinUnit.h
//  LOLBox
//
//  Created by JunhuaShao on 15/3/3.
//  Copyright (c) 2015年 Ginhoor. All rights reserved.
//

#import <UIKit/UIKit.h>

#define currentRootVC [UIApplication sharedApplication].delegate.window.rootViewController

@interface UIResponder (GinUnit)

- (UIViewController *)recentlyController;
- (id)controlerByClass:(Class)mClass;
- (UINavigationController *)recentlyNavigationContoller;
- (UIResponder *)findObjectInResponderByclass:(Class)className;

@end
