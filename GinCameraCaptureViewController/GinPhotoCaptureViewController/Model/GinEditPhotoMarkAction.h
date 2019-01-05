//
//  GinEditPhotoMarkAction.h
//  JunhuashaoInspector
//
//  Created by JunhuaShao on 2017/8/24.
//  Copyright © 2017年 Junhuashao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GinEditPhotoAction.h"

@interface GinEditPhotoMarkAction : GinEditPhotoAction

@property (assign, nonatomic, readonly) CGPoint center;
@property (assign, nonatomic, readonly) CGAffineTransform transform;
@property (strong, nonatomic) UIImage *markImage;

@property (weak, nonatomic) UIView *markView;

+ (instancetype)action;

- (void)setup;
- (void)setMarkCenter:(CGPoint)point;
- (void)setMarkTransform:(CGAffineTransform)transform;

- (CGPoint)convertCenterInPhoto:(UIImage *)photoImage previewImage:(UIImage *)previewImage;
- (CGRect)getRectInPhoto:(UIImage *)photoImage previewImage:(UIImage *)previewImage markImageSize:(CGSize)imgSize;

@end
