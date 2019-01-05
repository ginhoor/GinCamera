//
//  GinEditPhotoMarkView.m
//  JunhuashaoInspector
//
//  Created by JunhuaShao on 2017/8/24.
//  Copyright © 2017年 Junhuashao. All rights reserved.
//

#import <Masonry.h>
#import "GinEditPhotoMarkView.h"

@interface GinEditPhotoMarkView()

@property (assign, nonatomic) CGPoint moveCenterPoint;
@property (assign, nonatomic) CGPoint moveActionStartCenter;

@property (assign, nonatomic) CGPoint moveActionStartPoint;



@property (assign, nonatomic) CGPoint lastTouchPoint;
@property (assign, nonatomic) CGAffineTransform rotationStartTransfrom;


@property (strong, nonatomic) UIPanGestureRecognizer *movePanGesture;
@property (strong, nonatomic) UIPanGestureRecognizer *rotatePanGesture;

@end

@implementation GinEditPhotoMarkView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}


- (void)setup
{
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.imageView];
    [self addSubview:self.cancelbtn];
    [self addSubview:self.rotateImgV];
    
    CGFloat offset = self.rotateImgV.image.size.width/2;
    self.contentView.frame = CGRectMake(offset, offset, self.frame.size.width-offset*2, self.frame.size.height-offset*2);
    
    CGSize size = self.contentView.bounds.size;
    
    self.imageView.frame = CGRectMake((size.width-self.imageView.image.size.width)/2, (size.height-self.imageView.image.size.height) /2, self.imageView.image.size.width, self.imageView.image.size.height);
    
    self.cancelbtn.frame = CGRectMake(0, self.frame.size.height - [self.cancelbtn imageForState:UIControlStateNormal].size.height, [self.cancelbtn imageForState:UIControlStateNormal].size.width, [self.cancelbtn imageForState:UIControlStateNormal].size.height);
    
    self.rotateImgV.frame = CGRectMake(self.frame.size.width - self.rotateImgV.image.size.width, self.frame.size.height - self.rotateImgV.image.size.height, self.rotateImgV.image.size.width, self.rotateImgV.image.size.height);
}

- (UIButton *)cancelbtn
{
    if (!_cancelbtn) {
        _cancelbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelbtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [_cancelbtn setImage:[UIImage imageNamed:@"edit_img_close"] forState:UIControlStateNormal];
        
    }
    return _cancelbtn;
}

- (void)cancelAction:(id)sender
{
    [self removeFromSuperview];
}

- (UIImageView *)rotateImgV
{
    if (!_rotateImgV) {
        _rotateImgV = [[UIImageView alloc] init];
        [_rotateImgV setImage:[UIImage imageNamed:@"edit_img_rotation"]];
        _rotateImgV.userInteractionEnabled = YES;
        
        _rotatePanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(rotationGestureAction:)];
        [_rotateImgV addGestureRecognizer:_rotatePanGesture];
    }
    return _rotateImgV;
}

- (void)rotationGestureAction:(UIPanGestureRecognizer *)recognizer
{

    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
            self.lastTouchPoint = [recognizer locationInView:self.superview];
            self.rotationStartTransfrom = self.transform;
            break;
            
        case UIGestureRecognizerStateChanged: {
            
            CGPoint currentTouchPoint = [recognizer locationInView:self.superview];
            
            CGPoint center = self.center;
            
            CGFloat angleInRadians = atan2f(currentTouchPoint.y - center.y, currentTouchPoint.x - center.x) - atan2f(self.lastTouchPoint.y - center.y, self.lastTouchPoint.x - center.x);
            
            CGAffineTransform t = CGAffineTransformRotate(self.rotationStartTransfrom, angleInRadians);
            
            self.transform = t;
            
        }
            break;
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateEnded:
            self.lastTouchPoint = [recognizer locationInView:self.superview];
            [self.markAction setMarkTransform:self.transform];
            break;
        default:
            break;
    }
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.image = [UIImage imageNamed:@"edit_img_mark_arrow"];
    }
    return _imageView;
}

- (UIView *)contentView
{
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.layer.borderWidth = 0.5;
        _contentView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        
        _movePanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveGestureAction:)];
        [_contentView addGestureRecognizer:_movePanGesture];
    }
    return _contentView;
}

- (void)moveGestureAction:(UIPanGestureRecognizer *)recognizer
{
    CGPoint point = [recognizer locationInView:self.superview];
    
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan: {
            self.moveActionStartPoint = point;
        }
            break;
            
        case UIGestureRecognizerStateChanged: {
            [self translateUsingTouchLocation:point];
            self.moveActionStartPoint = point;
        }
            break;
            
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateFailed:
            [self.markAction setMarkCenter:self.center];
            
            break;
        default:
            break;
    }
}

- (void)translateUsingTouchLocation:(CGPoint)touchPoint
{
    CGPoint newCenter = CGPointMake(self.center.x + touchPoint.x - self.moveActionStartPoint.x,
                                    self.center.y + touchPoint.y - self.moveActionStartPoint.y);
    // 是否限制在View范围内
//    CGFloat midPointX = CGRectGetMidX(self.bounds);
//    if (newCenter.x > self.superview.bounds.size.width - midPointX) {
//        newCenter.x = self.superview.bounds.size.width - midPointX;
//    }
//    if (newCenter.x < midPointX) {
//        newCenter.x = midPointX;
//    }
//    CGFloat midPointY = CGRectGetMidY(self.bounds);
//    if (newCenter.y > self.superview.bounds.size.height - midPointY) {
//        newCenter.y = self.superview.bounds.size.height - midPointY;
//    }
//    if (newCenter.y < midPointY) {
//        newCenter.y = midPointY;
//    }
    self.center = newCenter;
}

@end
