//
//  NSString+Size.h
//  LOLBox
//
//  Created by Ginhoor on 14-3-13.
//  Copyright (c) 2014年 Ginhoor. All rights reserved.
//


#import <UIKit/UIKit.h>
@interface NSString (Size)

- (CGSize)getSingleLineStringSizeWithFont:(UIFont *)font;
- (CGSize)getStringSizeWithFont:(UIFont *)font width:(CGFloat)width;
- (CGSize)getStringSizeWithFont:(UIFont *)font height:(CGFloat)height;
- (CGSize)getStringSizeByWidth:(CGFloat)width attributes:(NSDictionary *)attributes;
- (CGSize)getStringSizeByHeight:(CGFloat)height attributes:(NSDictionary *)attributes;

@end
