//
//  GinEditPhotoMosaicAction.m
//  JunhuashaoInspector
//
//  Created by JunhuaShao on 2017/8/24.
//  Copyright © 2017年 Junhuashao. All rights reserved.
//

#import "GinEditPhotoMosaicAction.h"

@interface GinEditPhotoMosaicAction()

@property (strong, nonatomic, readwrite) NSMutableArray<NSValue *> *pointList;

@end

@implementation GinEditPhotoMosaicAction

+ (instancetype)action
{
    GinEditPhotoMosaicAction *action = [[GinEditPhotoMosaicAction alloc] init];
    action.actionType = GinEditPhotoActionTypeMosaic;
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
    self.pointList = [NSMutableArray array];
}

- (void)addPoint:(CGPoint)point
{
    NSValue *pointValue = [NSValue valueWithCGPoint:point];
    [self.pointList addObject:pointValue];
}

+ (CGPoint)convertPoint:(NSValue *)pointValue photo:(UIImage *)photoImage previewImage:(UIImage *)previewImage
{
    CGPoint point = [pointValue CGPointValue];
    point.x = point.x * photoImage.size.width/previewImage.size.width;
    point.y = point.y * photoImage.size.height/previewImage.size.height;
    return point;
}

@end
