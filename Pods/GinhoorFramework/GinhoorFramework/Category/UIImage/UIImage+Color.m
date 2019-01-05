//
//  UIImage+Color.m
//  FrameworkDemo
//
//  Created by JunhuaShao on 2019/1/5.
//  Copyright © 2019 JunhuaShao. All rights reserved.
//

#import "UIImage+Color.h"

@implementation UIImage (Color)

- (UIImage *)changeColor:(UIColor *)color
{
    UIGraphicsBeginImageContextWithOptions(self.size, YES, [[UIScreen mainScreen] scale]);
    
    CGRect contextRect;
    contextRect.origin.x = 0.0f;
    contextRect.origin.y = 0.0f;
    contextRect.size = [self size];
    
    // Retrieve source image and begin image context
    CGSize itemImageSize = [self size];
    CGPoint itemImagePosition;
    itemImagePosition.x = ceilf((contextRect.size.width - itemImageSize.width) / 2);
    itemImagePosition.y = ceilf((contextRect.size.height - itemImageSize.height) );
    
    UIGraphicsBeginImageContextWithOptions(contextRect.size, NO, [[UIScreen mainScreen] scale]);
    
    CGContextRef c = UIGraphicsGetCurrentContext();
    // Setup shadow
    // Setup transparency layer and clip to mask
    CGContextBeginTransparencyLayer(c, NULL);
    CGContextScaleCTM(c, 1.0, -1.0);
    CGContextClipToMask(c, CGRectMake(itemImagePosition.x, -itemImagePosition.y, itemImageSize.width, -itemImageSize.height), [self CGImage]);
    // Fill and end the transparency layer
    CGColorSpaceRef colorSpace = CGColorGetColorSpace(color.CGColor);
    CGColorSpaceModel model = CGColorSpaceGetModel(colorSpace);
    const CGFloat* colors = CGColorGetComponents(color.CGColor);
    
    if(model == kCGColorSpaceModelMonochrome) {
        CGContextSetRGBFillColor(c, colors[0], colors[0], colors[0], colors[1]);
    } else {
        CGContextSetRGBFillColor(c, colors[0], colors[1], colors[2], colors[3]);
    }
    contextRect.size.height = -contextRect.size.height;
    contextRect.size.height -= 15;
    CGContextFillRect(c, contextRect);
    CGContextEndTransparencyLayer(c);
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

+ (UIImage *)imageByColor:(UIColor *)color
{
    return [self imageByColor:color imageSize:CGSizeMake(1, 1)];
}

+ (UIImage *)imageByColor:(UIColor *)color imageSize:(CGSize)imageSize
{
    UIGraphicsBeginImageContextWithOptions(imageSize, 0, [UIScreen mainScreen].scale);
    [color set];
    UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
    UIImage *pressedColorImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return pressedColorImg;
}

- (UIImage *)getGrayImage
{
    int width = self.size.width;
    int height = self.size.height;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate (nil,width,height,8,0,colorSpace,kCGImageAlphaPremultipliedLast|kCGBitmapByteOrderDefault);
    CGColorSpaceRelease(colorSpace);
    
    if (context == NULL) {
        return nil;
    }
    
    CGContextDrawImage(context,CGRectMake(0, 0, width, height), self.CGImage);
    CGImageRef cgImg = CGBitmapContextCreateImage(context);
    
    UIImage *grayImage = [UIImage imageWithCGImage:cgImg];
    
    CGImageRelease(cgImg);
    CGContextRelease(context);
    
    return grayImage;
}

@end
