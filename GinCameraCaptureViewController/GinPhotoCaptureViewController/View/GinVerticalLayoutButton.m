//
//  GinVerticalLayoutButton.m
//  YanCheBaoJia
//
//  Created by JunhuaShao on 2017/5/7.
//  Copyright © 2017年 Junhuashao. All rights reserved.
//

#import "GinVerticalLayoutButton.h"

@interface GinVerticalLayoutButton()
@property (assign, nonatomic) CGSize titleSize;
@property (assign, nonatomic) CGSize imageSize;

@end

@implementation GinVerticalLayoutButton

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
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.adjustsImageWhenHighlighted = NO;
    self.adjustsImageWhenDisabled = NO;
    self.showsTouchWhenHighlighted = NO;
    
    [self.titleLabel setFont:[UIFont systemFontOfSize:12]];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.titleLabelHeight = 20;
    self.titleTopOffset = 2;
}

- (void)setImageTopOffset:(CGFloat)imageTopOffset
{
    _imageTopOffset = imageTopOffset;
    [self layoutIfNeeded];
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake((contentRect.size.width - self.imageSize.width) / 2, self.imageTopOffset, self.imageSize.width, self.imageSize.height);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(0, self.imageTopOffset + self.imageView.bounds.size.height + self.titleTopOffset, contentRect.size.width, self.titleLabelHeight);
}

- (void)setImage:(UIImage *)image forState:(UIControlState)state
{
    self.imageSize = image.size;
    [super setImage:image forState:state];
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    NSString *content = self.titleLabel.text;
    CGSize size = [content boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.bounds), 0)  options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.titleLabel.font} context:nil].size;
    self.titleSize = CGSizeMake(ceilf(size.width), ceilf(size.height));
    [self layoutIfNeeded];
    [super setTitle:title forState:state];
}

- (void)setSelectedColor:(UIColor *)selectedColor
{
    _selectedColor = selectedColor;
}

@end
