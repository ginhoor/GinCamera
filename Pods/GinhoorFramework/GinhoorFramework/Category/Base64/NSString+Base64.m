//
//  NSString+Base64.m
//  FrameworkDemo
//
//  Created by JunhuaShao on 15/4/13.
//  Copyright (c) 2015年 JunhuaShao. All rights reserved.
//

#import "NSString+Base64.h"

@implementation NSString (Base64)

//Base64字符串转UIImage图片：

- (UIImage *)Base64ToImage
{
    NSData *decodedImageData = [[NSData alloc]
                                initWithBase64EncodedString:self options:NSDataBase64DecodingIgnoreUnknownCharacters];
    UIImage *decodedImage = [UIImage imageWithData:decodedImageData];
    return decodedImage;
}

@end
