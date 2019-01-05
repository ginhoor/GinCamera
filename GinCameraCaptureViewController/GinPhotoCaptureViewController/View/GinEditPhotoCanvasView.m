//
//  GinEditPhotoCanvasView.m
//  JunhuashaoInspector
//
//  Created by JunhuaShao on 2017/8/18.
//  Copyright © 2017年 Junhuashao. All rights reserved.
//

#import "GinEditPhotoCanvasView.h"

@interface GinEditPhotoCanvasView()

@property (strong, nonatomic) UIImage *resultImage;

@end

@implementation GinEditPhotoCanvasView

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
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
 
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    [[UIColor colorWithPatternImage:self.viewModel.filterGaussianImage] set];
    CGContextSetLineWidth(ctx, 20.0f);
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGContextSetLineJoin(ctx, kCGLineJoinRound);
    
    for (GinEditPhotoAction *action in self.viewModel.actionList) {
        
        if (action.actionType == GinEditPhotoActionTypeMosaic) {
            GinEditPhotoMosaicAction *mosaic = (GinEditPhotoMosaicAction *)action;
            for (NSInteger i = 0; i < mosaic.pointList.count; i++) {
                
                NSValue *pointValue = mosaic.pointList[i];
                CGPoint point = [pointValue CGPointValue];
                //            point.x = point.x * self.viewModel.previewImage.size.width / self.bounds.size.width;
                //            point.y = point.y * self.viewModel.previewImage.size.height / self.bounds.size.height;
                if (i == 0) {
                    CGContextMoveToPoint(ctx, point.x, point.y);
                    CGContextAddLineToPoint(ctx, point.x, point.y);
                } else {
                    CGContextAddLineToPoint(ctx, point.x, point.y);
                }
            }
        }        
    }
    CGContextStrokePath(ctx);
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    if (self.viewModel.currentActionType == GinEditPhotoActionTypeMosaic) {
        CGPoint point = [[touches anyObject] locationInView:self];
        
        GinEditPhotoMosaicAction *action = [GinEditPhotoMosaicAction action];
        [action addPoint:point];
        self.viewModel.currentAction = action;
        [self.viewModel addAction:action];
        [self setNeedsDisplay];
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    if (self.viewModel.currentActionType == GinEditPhotoActionTypeMosaic) {

        CGPoint point = [[touches anyObject] locationInView:self];
        
        GinEditPhotoMosaicAction *action = (GinEditPhotoMosaicAction *)self.viewModel.currentAction;
        
        [action addPoint:point];
        [self setNeedsDisplay];
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    
    if (self.viewModel.currentActionType == GinEditPhotoActionTypeMosaic) {
        CGPoint point = [[touches anyObject] locationInView:self];
        
        GinEditPhotoMosaicAction *action = (GinEditPhotoMosaicAction *)self.viewModel.currentAction;
        [action addPoint:point];

        self.viewModel.currentAction = nil;
        [self setNeedsDisplay];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    if (self.viewModel.currentActionType == GinEditPhotoActionTypeMosaic) {
        CGPoint point = [[touches anyObject] locationInView:self];
        
        GinEditPhotoMosaicAction *action = (GinEditPhotoMosaicAction *)self.viewModel.currentAction;
        [action addPoint:point];

        self.viewModel.currentAction = nil;
        [self setNeedsDisplay];
    }
}


@end
