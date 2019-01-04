//
//  GinPopupViewController.h
//  demo4TextKit
//
//  Created by JunhuaShao on 15/3/23.
//  Copyright (c) 2015年 JunhuaShao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GinPopupContentView.h"
#import "GinPopupGradientView.h"

@interface GinPopupViewController : UIViewController

@property (strong, nonatomic) GinPopupContentView *contentView;
@property (strong, nonatomic) GinPopupGradientView *backgroundView;

@property (assign, nonatomic) CGFloat defaultTopOffset;
@property (assign, nonatomic) CGFloat fadeInAnimationDuration;
@property (assign, nonatomic) CGFloat transformPart1AnimationDuration;
@property (assign, nonatomic) CGFloat transformPart2AnimationDuration;

@property (copy, nonatomic) void(^backgroundTapBlock)(id sender);
@property (copy, nonatomic) void(^modelDidHideBlock)(void);

- (void)setPopupContentView:(UIView *)contentView;
- (void)switchPopupContentView:(UIView *)contentView completion:(void(^)(void))completion;

- (void)showAnimated:(BOOL)animated;
- (void)hideAnimated:(BOOL)animated completion:(void(^)(void))completion;

@end
