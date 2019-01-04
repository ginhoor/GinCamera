//
//  NSString+GinUnit.m
//  FrameworkDemo
//
//  Created by JunhuaShao on 15/9/7.
//  Copyright (c) 2015年 JunhuaShao. All rights reserved.
//

#import "NSString+GinUnit.h"

@implementation NSString (GinUnit)

- (BOOL)isNotBlank
{
    return ![self isEqualToString:@""];
}

- (BOOL)isImageType
{
    return
    [self hasSuffix:@".png"]
    ||[self hasSuffix:@".PNG"]
    ||[self hasSuffix:@".jpg"]
    ||[self hasSuffix:@".JPG"]
    ||[self hasSuffix:@".jpeg"]
    ||[self hasSuffix:@".JPEG"]
    ||[self hasSuffix:@".gif"]
    ||[self hasSuffix:@".GIF"]
    ||[self hasSuffix:@".bmp"]
    ||[self hasSuffix:@".BMP"];
}


- (BOOL)isGif
{
    return
    [self hasSuffix:@".gif"]
    ||[self hasSuffix:@".GIF"];
}

@end
