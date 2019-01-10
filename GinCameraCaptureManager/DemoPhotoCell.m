//
//  DemoPhotoCell.m
//  GinCameraCaptureManager
//
//  Created by JunhuaShao on 2019/1/7.
//  Copyright © 2019 JunhuaShao. All rights reserved.
//

#import <Masonry.h>
#import <Gin_Macro.h>

#import "DemoPhotoCell.h"

@implementation DemoPhotoCell


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.photoImgV];
    [self setNeedsUpdateConstraints];
}

- (void)updateConstraints
{
    [super updateConstraints];
    
    CGFloat width = (SCREEN_WIDTH - 15*2 - 10)/2;
    [self.photoImgV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.offset(0);
        make.right.offset(0);
        make.height.offset(width/4*3);
    }];
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.photoImgV.mas_bottom);
        make.left.offset(0);
        make.right.offset(0);
        make.height.offset(20);
    }];
}

+ (CGSize)cellSize
{
    CGFloat width = (SCREEN_WIDTH - 15*2 - 10)/2;
    return CGSizeMake(width, width/4*3 + 20);
}

- (UIImageView *)photoImgV
{
    if (!_photoImgV) {
        _photoImgV = [[UIImageView alloc] init];
        _photoImgV.contentMode = UIViewContentModeScaleAspectFill;
        _photoImgV.layer.masksToBounds = YES;
    }
    return _photoImgV;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = [UIColor blackColor];
    }
    return _titleLabel;
}

@end
