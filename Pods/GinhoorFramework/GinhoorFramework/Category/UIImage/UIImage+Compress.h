//
//  UIImage+Compress.h
//  FrameworkDemo
//
//  Created by JunhuaShao on 2019/1/5.
//  Copyright © 2019 JunhuaShao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Compress)

/**
 压缩图片到指定文件大小
 */
- (NSData *)compressToMaxDataSizeKBytes:(CGFloat)size maxQuality:(CGFloat)maxQuality;

@end

NS_ASSUME_NONNULL_END
