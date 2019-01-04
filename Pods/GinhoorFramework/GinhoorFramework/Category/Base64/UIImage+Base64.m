//
//  UIImage+Base64.m
//  FrameworkDemo
//
//  Created by JunhuaShao on 15/4/13.
//  Copyright (c) 2015年 JunhuaShao. All rights reserved.
//

#import "UIImage+Base64.h"

@implementation UIImage (Base64)


- (BOOL)imageHasAlpha:(UIImage *)image
{
    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(image.CGImage);
    return (alpha == kCGImageAlphaFirst ||
            alpha == kCGImageAlphaLast ||
            alpha == kCGImageAlphaPremultipliedFirst ||
            alpha == kCGImageAlphaPremultipliedLast);
}

//UIImage图片转成Base64字符串：
- (NSString *)imageToBase64
{
    NSData *data;
    if ([self imageHasAlpha: self]) {
        data = UIImagePNGRepresentation(self);
    } else {
        data = UIImageJPEGRepresentation(self, 1.0f);
    }
    
    NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    return encodedImageStr;
}

//Base64字符串转UIImage图片：

+ (UIImage *)Base64ToImage:(NSString *)encodedImageStr
{
    
    
    NSData *decodedImageData = [[NSData alloc]
                                initWithBase64EncodedString:encodedImageStr options:NSDataBase64DecodingIgnoreUnknownCharacters];
    UIImage *decodedImage = [UIImage imageWithData:decodedImageData];
    return decodedImage;
}


@end
