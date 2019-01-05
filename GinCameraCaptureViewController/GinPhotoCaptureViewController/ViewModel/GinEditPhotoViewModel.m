//
//  GinEditPhotoViewModel.m
//  JunhuashaoInspector
//
//  Created by JunhuaShao on 2017/8/18.
//  Copyright © 2017年 Junhuashao. All rights reserved.
//

#import "GinEditPhotoViewModel.h"
#import <UIImage+GinUnit.h>

NSString * const kCEEditPhotoPreviousOrNextActionNotification = @"kCEEditPhotoPreviousOrNextActionNotification";

@interface GinEditPhotoViewModel()

@property (strong, nonatomic, readwrite) NSMutableArray <GinEditPhotoAction *> *actionList;
@property (strong, nonatomic, readwrite) NSMutableArray <GinEditPhotoAction *> *removeActionList;
@property (strong, nonatomic, readwrite) UIImage *filterGaussianImage;
@property (strong, nonatomic, readwrite) UIImage *previewImage;

@end

@implementation GinEditPhotoViewModel


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
    self.actionList = [NSMutableArray array];
    self.removeActionList = [NSMutableArray array];
}

- (void)postActionListChangedNotification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kCEEditPhotoPreviousOrNextActionNotification object:@{@"actionList":self.actionList, @"removeActionList":self.removeActionList}];
}

- (void)addAction:(GinEditPhotoAction *)action
{
    [self.actionList addObject:action];
    
    if (self.removeActionList.count > 0) {
        [self.removeActionList removeAllObjects];
    }
    [self postActionListChangedNotification];
}

- (void)previousAction
{
    if (self.actionList.count > 0) {
        GinEditPhotoAction *action = self.actionList.lastObject;
        [self.removeActionList addObject:action];
        [self.actionList removeLastObject];
        [self postActionListChangedNotification];
    }
}

- (void)nextAction
{
    if (self.removeActionList.count > 0) {
        GinEditPhotoAction *action = self.removeActionList.lastObject;
        [self.removeActionList removeLastObject];
        [self.actionList addObject:action];
        [self postActionListChangedNotification];
    }
}

- (void)clearAllAction
{
    [self.removeActionList removeAllObjects];
    [self.actionList removeAllObjects];
    [self postActionListChangedNotification];
}

- (void)setPreviewAndFilterImageByDisplaySize:(CGSize)size
{
    if (self.photoImage) {
        self.previewImage = [self.photoImage scaleToSize:size];
        self.filterGaussianImage = [self.previewImage transToMosaicImageByblockLevel:10];
    }
}

- (UIImage *)getEditedImage
{
    UIGraphicsBeginImageContext(self.photoImage.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineCap(context, kCGLineCapRound);
    
    [self.photoImage drawInRect:CGRectMake(0, 0,self.photoImage.size.width,self.photoImage.size.height)];
    
    CGFloat ratio = self.photoImage.size.width/self.previewImage.size.width;
    
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithPatternImage:[self.photoImage transToMosaicImageByblockLevel:10*ratio]].CGColor);
    
    CGContextSetLineWidth(context, 20 * self.photoImage.size.width/self.previewImage.size.width);
    
    for (GinEditPhotoAction *action in self.actionList) {
        
        if (action.actionType == GinEditPhotoActionTypeMosaic) {
            
            GinEditPhotoMosaicAction *mosaic = (GinEditPhotoMosaicAction *)action;
            
            for (NSInteger i = 0; i < mosaic.pointList.count; i++) {
                
                NSValue *pointValue = mosaic.pointList[i];
                CGPoint point = [GinEditPhotoMosaicAction convertPoint:pointValue photo:self.photoImage previewImage:self.previewImage];
                if (i == 0) {
                    CGContextMoveToPoint(context, point.x, point.y);
                    CGContextAddLineToPoint(context, point.x, point.y);
                } else {
                    CGContextAddLineToPoint(context, point.x, point.y);
                }
            }
        } else if (action.actionType == GinEditPhotoActionTypeMark) {
            GinEditPhotoMarkAction *mark = (GinEditPhotoMarkAction *)action;
            
            CGAffineTransform tran = CGAffineTransformIdentity;
            tran = CGAffineTransformRotate(tran, [GinEditPhotoViewModel getDegree:mark.transform clockwise:NO]);
            
            UIImage *image = [UIImage imageWithCIImage:[[CIImage imageWithCGImage:mark.markImage.CGImage] imageByApplyingTransform:tran]];
            
            [image drawInRect:[mark getRectInPhoto:self.photoImage previewImage:self.previewImage markImageSize:image.size]]; // 拉伸
        }
    }
    CGContextDrawPath(context, kCGPathStroke);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    // 结束绘制
    UIGraphicsEndImageContext();
    
    return image;
}

+ (CGFloat)getDegree:(CGAffineTransform)transfrom clockwise:(BOOL)clockwise
{
    CGFloat rotate = acosf(transfrom.a);
    
    // 旋转180度后，需要处理弧度的变化
    if (transfrom.b < 0) {
        rotate = 2*M_PI - rotate;
    }
    
    // 将弧度转换为角度
    //    CGFloat degree = rotate/M_PI * 180;
    
    if (!clockwise) {
        rotate = 2*M_PI - rotate;
    }
    return rotate;
}

@end
