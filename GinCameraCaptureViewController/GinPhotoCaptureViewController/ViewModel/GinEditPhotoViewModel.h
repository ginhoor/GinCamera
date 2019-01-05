//
//  GinEditPhotoViewModel.h
//  JunhuashaoInspector
//
//  Created by JunhuaShao on 2017/8/18.
//  Copyright © 2017年 Junhuashao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIImage+GinUnit.h>
#import "GinEditPhotoAction.h"
#import "GinEditPhotoMosaicAction.h"
#import "GinEditPhotoMarkAction.h"

extern NSString * const kCEEditPhotoPreviousOrNextActionNotification;

@interface GinEditPhotoViewModel : NSObject

@property (assign, nonatomic) GinEditPhotoActionType currentActionType;
/**
 原图
 */
@property (strong, nonatomic) UIImage *photoImage;
/**
 预览图
 */
@property (strong, nonatomic, readonly) UIImage *previewImage;
/**
 原图高斯后的图片
 */
@property (strong, nonatomic, readonly) UIImage *filterGaussianImage;

@property (strong, nonatomic, readonly) NSMutableArray <GinEditPhotoAction *> *actionList;
@property (strong, nonatomic, readonly) NSMutableArray <GinEditPhotoAction *> *removeActionList;

@property (strong, nonatomic) GinEditPhotoAction *currentAction;

- (void)addAction:(GinEditPhotoAction *)action;
- (void)nextAction;
- (void)previousAction;
- (void)clearAllAction;

- (void)setPreviewAndFilterImageByDisplaySize:(CGSize)size;

- (UIImage *)getEditedImage;

/**
 获得旋转角度，范围为[0，2MI_P]
 
 @param transfrom 矩阵
 @param clockwise 是否顺时针
 @return 弧度
 */
+ (CGFloat)getDegree:(CGAffineTransform)transfrom clockwise:(BOOL)clockwise;

@end
