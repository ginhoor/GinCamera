//
//  CECaptureHelpTipsView.m
//  CommercialVehiclePlatform
//
//  Created by JunhuaShao on 2018/3/30.
//  Copyright © 2018年 JunhuaShao. All rights reserved.
//

#import <Masonry.h>
#import "CECaptureHelpTipsView.h"

@implementation CECaptureHelpTipsView

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
    
    [self addSubview:self.tipsImgV];
    [self addSubview:self.titleLabel];
    
    [self setNeedsUpdateConstraints];
}

- (void)updateConstraints
{
    [super updateConstraints];
    
    [self.tipsImgV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.right.offset(0);
        make.bottom.offset(0);
        make.height.offset(20);
    }];
}

+ (CGSize)viewSize
{
    return CGSizeMake(100, 75);
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.backgroundColor = [UIColor blackColorWithAlpha:0.6];
    }
    return _titleLabel;
}

- (UIImageView *)tipsImgV
{
    if (!_tipsImgV) {
        _tipsImgV = [[UIImageView alloc] init];
    }
    return _tipsImgV;
}

@end
