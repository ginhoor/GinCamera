//
//  GinCapturePhotoLandspaceTipsView.m
//  GinCameraCaptureManager
//
//  Created by JunhuaShao on 2019/1/4.
//  Copyright © 2019 JunhuaShao. All rights reserved.
//

#import <Masonry.h>
#import <UIColor+Hex.h>

#import "GinCapturePhotoLandspaceTipsView.h"

@implementation GinCapturePhotoLandspaceTipsView

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
    self.backgroundColor = [UIColor colorWithHex:0x000000 alpha:0.5];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 4.f;
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.imgV];
}

- (void)updateConstraints
{
    [super updateConstraints];
    
    [self.imgV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(24);
        make.centerX.offset(20);
        make.size.sizeOffset(CGSizeMake(85, 96));
    }];
    
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.right.offset(0);
        make.top.equalTo(self.imgV.mas_bottom).offset(20);
        make.height.offset(20);
    }];
    
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"建议横屏拍摄";
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIImageView *)imgV
{
    if (!_imgV) {
        _imgV = [[UIImageView alloc] init];
        _imgV.image = [UIImage imageNamed:@"landspace_tips"];
    }
    return _imgV;
}

@end
