//
//  GinEditPhotoMosaicAction.h
//  JunhuashaoInspector
//
//  Created by JunhuaShao on 2017/8/24.
//  Copyright © 2017年 Junhuashao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GinEditPhotoAction.h"

@interface GinEditPhotoMosaicAction : GinEditPhotoAction

@property (strong, nonatomic, readonly) NSMutableArray<NSValue *> *pointList;

+ (instancetype)action;

- (void)setup;
- (void)addPoint:(CGPoint)point;
+ (CGPoint)convertPoint:(NSValue *)pointValue photo:(UIImage *)photoImage previewImage:(UIImage *)previewImage;

@end

