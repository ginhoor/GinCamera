//
//  UIResponder+GinUnit.m
//  LOLBox
//
//  Created by JunhuaShao on 15/3/3.
//  Copyright (c) 2015年 Ginhoor. All rights reserved.
//

#import "UIResponder+GinUnit.h"

@implementation UIResponder (GinUnit)

- (UIViewController *)recentlyController
{
    return (UIViewController *)[self findObjectInResponderByclass:[UIViewController class]];
}

- (id)controlerByClass:(Class)mClass
{
    return [self findObjectInResponderByclass:mClass];
}

- (UINavigationController *)recentlyNavigationContoller
{
    return (UINavigationController *)[self findObjectInResponderByclass:[UINavigationController class]];
}

- (UIResponder *)findObjectInResponderByclass:(Class)className
{
    if ([self isKindOfClass:className]) {
        return self;
    } else if (self.nextResponder) {
        return [self.nextResponder findObjectInResponderByclass:className];
    } else {
        return nil;
    }
}

@end
