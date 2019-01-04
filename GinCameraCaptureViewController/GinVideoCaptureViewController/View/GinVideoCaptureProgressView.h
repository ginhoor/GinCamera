//
//  GinVideoCaptureProgressView.h
//  demo4CaptureVideo
//
//  Created by JunhuaShao on 2018/2/23.
//  Copyright © 2018年 JunhuaShao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GinVideoCaptureProgressView : UIView

@property (assign, nonatomic) CGFloat totalProgress;
@property (assign, nonatomic) CGFloat currentProgress;

@property (strong, nonatomic) UIView *progressBar;
@property (strong, nonatomic) UIView *flashDotView;
@property (strong, nonatomic) UIView *selectedProgressView;

/**
 每一个元素代表一个进度段
 */
@property (strong, nonatomic) NSArray <NSNumber *> *progressValueList;

@property (assign, nonatomic) CGSize contentSize;

- (void)addProgressItem:(CGFloat)progress;
- (void)removeProgressItem:(NSInteger)index;
- (void)removeLastProgressItem;

- (void)selectedProgress:(NSUInteger)index;
- (void)unSelectedProgress;
- (void)updateProgress:(CGFloat)currentProgress;

- (void)flashDotView:(BOOL)flash;

- (void)startFlashDotViewAnimation;
- (void)stopFlashDotViewAnimation;

+ (CGFloat)viewHeight;

@end
