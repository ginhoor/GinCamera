//
//  GinPopupViewController.m
//  demo4TextKit
//
//  Created by JunhuaShao on 15/3/23.
//  Copyright (c) 2015年 JunhuaShao. All rights reserved.
//

#import "GinPopupViewController.h"

@interface GinPopupViewController ()

@end

@implementation GinPopupViewController

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.defaultTopOffset = 0;
    self.fadeInAnimationDuration = 0.3;
    self.transformPart1AnimationDuration = 0.2;
    self.transformPart2AnimationDuration = 0.1;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.backgroundView];
    [self.view addSubview:self.contentView];
}

- (void)showAnimated:(BOOL)animated
{
    if (!animated) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [UIView animateWithDuration:self.fadeInAnimationDuration animations:^{
            self.backgroundView.alpha = 1;
        }];
        
        self.contentView.alpha = 0;
        self.contentView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.4, 0.4);
        
        [UIView animateWithDuration:self.transformPart1AnimationDuration animations:^{
            
            self.contentView.alpha = 1;
            self.contentView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:self.transformPart2AnimationDuration animations:^{
                
                self.contentView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
                
            } completion:^(BOOL finished) {}];
        }];
    });
}

- (void)hideAnimated:(BOOL)animated completion:(void(^)(void))completion
{
    if (!animated) {
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [UIView animateWithDuration:self.fadeInAnimationDuration animations:^{
            self.backgroundView.alpha = 0;
        }];
        
        [UIView animateWithDuration:self.transformPart2AnimationDuration animations:^{
            self.contentView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:self.transformPart1AnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.contentView.alpha = 0;
                self.contentView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.4, 0.4);
                
            } completion:^(BOOL finished) {
                
                if (self.modelDidHideBlock) {
                    self.modelDidHideBlock();
                }
                if (completion) {
                    completion();
                }
            }];
        }];
        
    });
}


- (void)backgroundTapAction:(id)sender
{
    [self hideAnimated:YES completion:^{}];
    
    if (self.backgroundTapBlock) {
        self.backgroundTapBlock(sender);
    }
}

- (void)setPopupContentView:(UIView *)contentView
{
    CGRect contentViewRect = contentView.bounds;
    
    contentViewRect.origin.x = contentViewRect.origin.y = 0;
    
    contentViewRect.origin.x = round(CGRectGetMidX([UIScreen mainScreen].bounds)-CGRectGetMidX(contentViewRect));
    contentViewRect.origin.y = round(CGRectGetMidY([UIScreen mainScreen].bounds)-CGRectGetMidY(contentViewRect))- self.defaultTopOffset;
    self.contentView.frame = contentViewRect;
    [self.contentView addSubview:contentView];
}

- (void)switchPopupContentView:(UIView *)contentView completion:(void(^)(void))completion
{
    UIView *currentContentView = self.contentView.subviews.firstObject;
    [UIView animateWithDuration:0.1f animations:^{
        currentContentView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.contentView addSubview:contentView];
        contentView.alpha = 0;
        [UIView animateWithDuration:0.15 animations:^{
            contentView.alpha = 1;
        } completion:^(BOOL finished) {
            [currentContentView removeFromSuperview];
            currentContentView.alpha = 1;
            if (completion) {
                completion();
            }
        }];
    }];
}


- (GinPopupContentView *)contentView
{
    if (!_contentView) {
        _contentView = [[GinPopupContentView alloc] initWithFrame:self.view.bounds];
        _contentView.alpha = 0;
    }
    return _contentView;
}

- (GinPopupGradientView *)backgroundView
{
    if (!_backgroundView) {
        _backgroundView = [[GinPopupGradientView alloc] initWithFrame:self.view.bounds];
        _backgroundView.alpha = 0;
        _backgroundView.opaque = NO;
        [_backgroundView addTarget:self action:@selector(backgroundTapAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backgroundView;
}


@end
