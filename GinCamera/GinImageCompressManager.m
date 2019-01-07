//
//  GinImageCompressManager.m
//  GinCameraCaptureManager
//
//  Created by JunhuaShao on 2019/1/5.
//  Copyright © 2019 JunhuaShao. All rights reserved.
//

#import <GinhoorFramework/UIImage+GinUnit.h>

#import "GinImageCompressManager.h"

@implementation GinImageCompressManager

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
    self.compressMaxQuality = 1;
}

- (UIImage *)compressImage:(UIImage *)source
{
    UIImage *savedImage = source;
    if (!CGSizeEqualToSize(self.compressImageMaxSize, CGSizeZero)) {
        CGSize scaleSize = CGSizeZero;
        if (savedImage.size.width > savedImage.size.height) {
            if (savedImage.size.width > self.compressImageMaxSize.width) {
                scaleSize = CGSizeMake(self.compressImageMaxSize.width, self.compressImageMaxSize.width / savedImage.size.width * savedImage.size.height);
            }
        } else {
            if (savedImage.size.height > self.compressImageMaxSize.height) {
                scaleSize = CGSizeMake(self.compressImageMaxSize.height / savedImage.size.height * savedImage.size.width, self.compressImageMaxSize.height);
            }
        }
        if (!CGSizeEqualToSize(scaleSize, CGSizeZero)) {
            savedImage = [savedImage scaleToSize:scaleSize];
        }
    }
    if (self.compressMaxDataSize != 0) {
        if (self.compressMaxQuality == 0) {
            self.compressMaxQuality = 1;
        }
        savedImage = [UIImage imageWithData:[savedImage compressToMaxDataSizeKBytes:self.compressMaxDataSize maxQuality:self.compressMaxQuality]];
    }
    
    return savedImage;
}

@end
