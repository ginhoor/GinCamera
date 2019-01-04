//
//  GinPopup.h
//  LOLBox
//
//  Created by JunhuaShao on 14-10-18.
//  Copyright (c) 2014年 Ginhoor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GinPopupViewController.h"

static NSString *const kGinPopupDidHideNotification = @"kGinPopupDidHideNotification";

@interface GinPopup : NSObject

@property (strong, nonatomic,readonly) UIWindow *window;
@property (strong, nonatomic) GinPopupViewController *viewController;

+ (instancetype)sharedInstance;

+ (void)showWithContentView:(UIView *)contentView;
+ (void)showWithContentViewWithoutBackgroundTapDimsmiss:(UIView *)contentView;
+ (void)dismissWhenCompletion:(void(^)(void))block;

@end
