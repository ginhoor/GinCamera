//
//  GinVideoCaptureProgressView.m
//  demo4CaptureVideo
//
//  Created by JunhuaShao on 2018/2/23.
//  Copyright © 2018年 JunhuaShao. All rights reserved.
//

#import "GinVideoCaptureProgressView.h"

@interface GinVideoCaptureProgressView ()

@property (strong, nonatomic) NSMutableArray <UIView *> *progressItemList;

@end

@implementation GinVideoCaptureProgressView

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
    self.backgroundColor = [UIColor whiteColor];
    self.totalProgress = 60;
    self.currentProgress = 0;
    
    self.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [GinVideoCaptureProgressView viewHeight]);
    
    self.progressItemList = [NSMutableArray array];
    
    [self addSubview:self.progressBar];
    [self addSubview:self.flashDotView];
    [self addSubview:self.selectedProgressView];
}

- (void)addProgressItem:(CGFloat)progress
{
    NSMutableArray *arr = [NSMutableArray arrayWithArray:self.progressValueList];

    [arr addObject:@(progress)];
    self.progressValueList = arr;
    [self updateProgressItemUI];
}

- (void)removeLastProgressItem
{
    if (self.progressValueList.count > 0) {
        [self removeProgressItem:self.progressValueList.count - 1];
    }
}

- (void)removeProgressItem:(NSInteger)index
{
    NSMutableArray *arr = [NSMutableArray arrayWithArray:self.progressValueList];
    [arr removeObjectAtIndex:index];
    self.progressValueList = arr;
    [self updateProgressItemUI];
    
    __block CGFloat previousProgressValue = 0;
    
    [self.progressValueList enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        previousProgressValue += obj.doubleValue;
    }];
    
    [self updateProgress:previousProgressValue];
}


- (void)updateProgressItemUI
{
    if (self.progressItemList.count > 0) {
        [self.progressItemList enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];
        [self.progressItemList removeAllObjects];
    }
    
    __block CGFloat previousProgressValue = 0;
    
    [self.progressValueList enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        previousProgressValue += obj.doubleValue;
        
        UIView *item = [self createProgressItem];
        item.frame = CGRectMake(previousProgressValue/self.totalProgress*self.contentSize.width-1, 0, 1, self.contentSize.height);
        [self.progressItemList addObject:item];
        [self addSubview:item];
        
    }];
    
}

- (void)updateProgress:(CGFloat)currentProgress
{
    self.progressBar.frame = CGRectMake(0, 0, currentProgress/self.totalProgress*self.contentSize.width, self.contentSize.height);
}

- (void)selectedProgress:(NSUInteger)index
{
    NSNumber *selectedProgressValue = self.progressValueList[index];
    
    if (index == 0) {
        self.selectedProgressView.frame = CGRectMake(0, 0, selectedProgressValue.doubleValue/self.totalProgress*self.contentSize.width, self.contentSize.height);
    } else {
        NSArray *tempProgressValueList = [self.progressValueList subarrayWithRange:NSMakeRange(0, index)];
        
        __block CGFloat previousProgressValue = 0;
        [tempProgressValueList enumerateObjectsUsingBlock:^(NSNumber *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            previousProgressValue += obj.doubleValue;
        }];
        
        self.selectedProgressView.frame = CGRectMake(previousProgressValue/self.totalProgress*self.contentSize.width, 0, selectedProgressValue.doubleValue/self.totalProgress*self.contentSize.width, self.contentSize.height);
    }
}

- (void)unSelectedProgress
{
    self.selectedProgressView.frame = CGRectZero;
}

- (void)flashDotView:(BOOL)flash
{
    if (flash) {
        self.flashDotView.hidden = NO;
        
        __block CGFloat previousProgressValue = 0;
        [self.progressValueList enumerateObjectsUsingBlock:^(NSNumber *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            previousProgressValue += obj.doubleValue;
        }];
        
        self.flashDotView.frame = CGRectMake(previousProgressValue/self.totalProgress*self.contentSize.width, 0, 10, self.contentSize.height);
        [self startFlashDotViewAnimation];
    } else {
        self.flashDotView.hidden = YES;
        [self stopFlashDotViewAnimation];
    }
}

- (UIView *)createProgressItem
{
    UIView *v = [[UIView alloc] init];
    v.backgroundColor = [UIColor whiteColor];
    
    return v;
}

- (UIView *)selectedProgressView
{
    if (!_selectedProgressView) {
        _selectedProgressView = [[UIView alloc] init];
        _selectedProgressView.backgroundColor = [UIColor orangeColor];
    }
    return _selectedProgressView;
}

- (UIView *)flashDotView
{
    if (!_flashDotView) {
        _flashDotView = [[UIView alloc] init];
        _flashDotView.backgroundColor = [UIColor blackColor];
    }
    return _flashDotView;
}

- (UIView *)progressBar
{
    if (!_progressBar) {
        _progressBar = [[UIView alloc] init];
        _progressBar.backgroundColor = [UIColor blackColor];
    }
    return _progressBar;
}

+ (CGFloat)viewHeight
{
    return 5;
}

#pragma mark- Private Method

- (void)startFlashDotViewAnimation
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = @1;
    animation.toValue = @0;
    animation.duration = 1;
    animation.repeatCount = CGFLOAT_MAX;
    animation.autoreverses = YES;
    
    [self.flashDotView.layer addAnimation:animation forKey:@"flashDotViewAnimation"];
}

- (void)stopFlashDotViewAnimation
{
    [self.flashDotView.layer removeAnimationForKey:@"flashDotViewAnimation"];
}

@end
