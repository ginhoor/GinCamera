//
//  GinEditPhotoMarkAction.m
//  JunhuashaoInspector
//
//  Created by JunhuaShao on 2017/8/24.
//  Copyright © 2017年 Junhuashao. All rights reserved.
//

#import "GinEditPhotoMarkAction.h"

@interface GinEditPhotoMarkAction()

@property (assign, nonatomic, readwrite) CGPoint center;
@property (assign, nonatomic, readwrite) CGAffineTransform transform;

@end

@implementation GinEditPhotoMarkAction

+ (instancetype)action
{
    GinEditPhotoMarkAction *action = [[GinEditPhotoMarkAction alloc] init];
    action.actionType = GinEditPhotoActionTypeMark;
    return action;

}

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
    self.markImage = [UIImage imageNamed:@"edit_img_mark_arrow"];
    self.transform = CGAffineTransformIdentity;
}

- (void)setMarkCenter:(CGPoint)point
{
    self.center = point;
}

- (void)setMarkTransform:(CGAffineTransform)transform
{
    self.transform = transform;
}

- (CGPoint)convertCenterInPhoto:(UIImage *)photoImage previewImage:(UIImage *)previewImage
{
    CGPoint point = self.center;

    point.x = point.x * (photoImage.size.width/previewImage.size.width);
    point.y = point.y * (photoImage.size.height/previewImage.size.height);

    return point;
}

- (CGRect)getRectInPhoto:(UIImage *)photoImage previewImage:(UIImage *)previewImage markImageSize:(CGSize)imgSize
{
    CGPoint center = [self convertCenterInPhoto:photoImage previewImage:previewImage];

    CGRect newFrame = CGRectMake(center.x-imgSize.width/2, center.y-imgSize.height/2, imgSize.width, imgSize.height);
    
    return newFrame;
}

@end
