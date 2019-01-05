//
//  GinTitleSwitch.m
//  JunhuashaoInspector
//
//  Created by JunhuaShao on 2017/11/7.
//  Copyright © 2017年 Junhuashao. All rights reserved.
//

#import <Masonry.h>
#import <UIColor+Hex.h>

#import "GinTitleSwitch.h"

@implementation GinTitleSwitch

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
    self.backgroundColor = [UIColor colorWithHex:0x000000 alpha:0.7];
    self.layer.cornerRadius = 4.f;

    [self addSubview:self.toggleSwitch];
    [self addSubview:self.titleLabel];
    
    [self setNeedsUpdateConstraints];
}

- (void)updateConstraints
{
    [super updateConstraints];
    
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(5);
        make.centerY.offset(0);
        make.size.sizeOffset(CGSizeMake(40, 20));
    }];
    
    [self.toggleSwitch mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-5);
        make.centerY.offset(0);
        make.size.sizeOffset(CGSizeMake(50, 30));
    }];
}

- (UISwitch *)toggleSwitch
{
    if (!_toggleSwitch) {
        _toggleSwitch = [[UISwitch alloc] init];
    }
    return _toggleSwitch;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor whiteColor];
    }
    return _titleLabel;
}

@end
