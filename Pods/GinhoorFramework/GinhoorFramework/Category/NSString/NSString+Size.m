//
//  NSString+Size.m
//  LOLBox
//
//  Created by Ginhoor on 14-3-13.
//  Copyright (c) 2014年 Ginhoor. All rights reserved.
//

#import "NSString+Size.h"

@implementation NSString (Size)

- (CGSize)getSingleLineStringSizeWithFont:(UIFont *)font
{
    CGSize size = [self sizeWithAttributes:@{NSFontAttributeName:font}];
    return CGSizeMake(ceilf(size.width), ceilf(size.height));
}

- (CGSize)getStringSizeWithFont:(UIFont *)font width:(CGFloat)width
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:3];
    
    CGSize size = [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)  options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle} context:nil].size;
    
    return CGSizeMake(ceilf(size.width), ceilf(size.height));
}

- (CGSize)getStringSizeWithFont:(UIFont *)font height:(CGFloat)height
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:3];
    
    CGSize size = [self boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height)  options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle} context:nil].size;
    
    return CGSizeMake(ceilf(size.width), ceilf(size.height));
}

- (CGSize)getStringSizeByWidth:(CGFloat)width attributes:(NSDictionary *)attributes
{
    CGSize size = [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)  options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
    return CGSizeMake(ceilf(size.width), ceilf(size.height));
}

- (CGSize)getStringSizeByHeight:(CGFloat)height attributes:(NSDictionary *)attributes
{
    CGSize size = [self boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height)  options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
    return CGSizeMake(ceilf(size.width), ceilf(size.height));
}
@end
