//
//  UIImage+Compress.m
//  FrameworkDemo
//
//  Created by JunhuaShao on 2019/1/5.
//  Copyright © 2019 JunhuaShao. All rights reserved.
//

#import "UIImage+Compress.h"

@implementation UIImage (Compress)

- (NSData *)compressToMaxDataSizeKBytes:(CGFloat)size maxQuality:(CGFloat)maxQuality
{
    NSData * data = UIImageJPEGRepresentation(self, 1.0);
    CGFloat dataKBytes = data.length/1000.0;
    CGFloat lastData = dataKBytes;
    while (dataKBytes > size && maxQuality > 0.01f) {
        maxQuality = maxQuality - 0.01f;
        data = UIImageJPEGRepresentation(self, maxQuality);
        dataKBytes = data.length / 1000.0;
        if (lastData == dataKBytes) {
            break;
        } else {
            lastData = dataKBytes;
        }
    }
    return data;
}

@end
