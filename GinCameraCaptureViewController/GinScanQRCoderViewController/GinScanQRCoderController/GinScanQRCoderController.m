//
//  GinScanQRCoderController.m
//  LOLBox
//
//  Created by JunhuaShao on 15/4/2.
//  Copyright (c) 2015年 Ginhoor. All rights reserved.
//

#import <Masonry.h>
#import <Gin_Macro.h>
#import <NSObject+CoreGraphic.h>

#import "GinScanQRCoderController.h"

@interface GinScanQRCoderController ()

@property (strong, nonatomic) UILabel *tipslabel;
@property (strong, nonatomic) UIImageView *maskImageView;
@property (strong, nonatomic) UIButton *dismissButton;

@property (assign, nonatomic) CGRect scanViewRect;

@end

@implementation GinScanQRCoderController

+ (void)startScanQRCorder:(UIViewController *)controller receivedBlock:(void(^)(NSString * resultString))resultDidReceivedBlock dismissBlock:(void(^)(void))dismissBlock;
{
    GinScanQRCoderController *picker = [[GinScanQRCoderController alloc] init];
    
    picker.resultDidReceivedBlock = resultDidReceivedBlock;
    picker.didDismissBlock = dismissBlock;
    
    [controller presentViewController:picker animated:YES completion:^{}];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"扫一扫";
    
    [self.view addSubview:self.maskImageView];
    [self.view addSubview:self.tipslabel];
    [self.view addSubview:self.dismissButton];
    
    CGFloat width = SCREEN_WIDTH * 0.6;
    
    self.scanViewRect = CGRectMake((SCREEN_WIDTH-width)/2, SCREEN_WIDTH * 0.3, width, width);
    self.maskImageView.image = [self maskImage:self.view.bounds clearRect:self.scanViewRect custom:^(CGRect frame, CGRect clearRect) {
        
        CGFloat maskLineWitdh = 4;
        CGFloat length = 18;
        
        NSArray *points =
        @[
          @[PointValue(CGRectGetMinX(clearRect), CGRectGetMinY(clearRect)+maskLineWitdh/2),
            PointValue(CGRectGetMinX(clearRect)+length, CGRectGetMinY(clearRect)+maskLineWitdh/2)],
          @[PointValue(CGRectGetMinX(clearRect)+maskLineWitdh/2, CGRectGetMinY(clearRect)+maskLineWitdh),
            PointValue(CGRectGetMinX(clearRect)+maskLineWitdh/2, CGRectGetMinY(clearRect)-maskLineWitdh/2+length)],
          
          @[PointValue(CGRectGetMaxX(clearRect), CGRectGetMinY(clearRect)+maskLineWitdh/2),
            PointValue(CGRectGetMaxX(clearRect)-length, CGRectGetMinY(clearRect)+maskLineWitdh/2)],
          @[PointValue(CGRectGetMaxX(clearRect)-maskLineWitdh/2, CGRectGetMinY(clearRect)+maskLineWitdh),
            PointValue(CGRectGetMaxX(clearRect)-maskLineWitdh/2, CGRectGetMinY(clearRect)-maskLineWitdh/2+length)],
          
          @[PointValue(CGRectGetMinX(clearRect), CGRectGetMaxY(clearRect)-maskLineWitdh/2),
            PointValue(CGRectGetMinX(clearRect)+length, CGRectGetMaxY(clearRect)-maskLineWitdh/2)],
          @[PointValue(CGRectGetMinX(clearRect)+maskLineWitdh/2, CGRectGetMaxY(clearRect)-maskLineWitdh),
            PointValue(CGRectGetMinX(clearRect)+maskLineWitdh/2, CGRectGetMaxY(clearRect)+maskLineWitdh/2-length)],
          
          @[PointValue(CGRectGetMaxX(clearRect), CGRectGetMaxY(clearRect)-maskLineWitdh/2),
            PointValue(CGRectGetMaxX(clearRect)-length, CGRectGetMaxY(clearRect)-maskLineWitdh/2)],
          @[PointValue(CGRectGetMaxX(clearRect)-maskLineWitdh/2, CGRectGetMaxY(clearRect)-maskLineWitdh),
            PointValue(CGRectGetMaxX(clearRect)-maskLineWitdh/2, CGRectGetMaxY(clearRect)+maskLineWitdh/2-length)],
          ];
        
        [points enumerateObjectsUsingBlock:^(NSArray *twoPoints, NSUInteger idx, BOOL *stop) {
            
            NSValue *start = twoPoints.firstObject;
            NSValue *end = twoPoints.lastObject;
            
            [self drawLine:start.CGPointValue end:end.CGPointValue lineWidth:maskLineWitdh LineColor:[UIColor orangeColor]];
        }];
    }];
    
    [self setConstraints];
}

// 设置 view 的初次约束
- (void)setConstraints
{
    [self.maskImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.tipslabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(self.scanViewRect.origin.y+self.scanViewRect.size.height+20);
        make.centerX.equalTo(self.view);
        make.size.sizeOffset(CGSizeMake(240, 20));
    }];
    
    [self.dismissButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.offset(60);
    }];

}

- (UIImageView *)maskImageView
{
    if (!_maskImageView) {
        _maskImageView = [[UIImageView alloc] init];
    }
    return _maskImageView;
}

- (UILabel *)tipslabel
{
    if (!_tipslabel) {
        _tipslabel = [[UILabel alloc] init];
        _tipslabel.text = @"请将扫描框对准二维码进行扫描";
        _tipslabel.textColor = [UIColor lightGrayColor];
    }
    return _tipslabel;
}

- (UIButton *)dismissButton
{
    if (!_dismissButton) {
        _dismissButton = [[UIButton alloc] init];
        _dismissButton.backgroundColor = [UIColor lightGrayColor];
        [_dismissButton setTitle:@"取消" forState:UIControlStateNormal];
        
        [_dismissButton addTarget:self action:@selector(dismissAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _dismissButton;
}

- (void)dismissAction:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
        if (self.didDismissBlock) {
            self.didDismissBlock();
        }
    }];
}

@end
