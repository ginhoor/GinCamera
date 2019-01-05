//
//  GinEditPhotoAction.h
//  JunhuashaoInspector
//
//  Created by JunhuaShao on 2017/8/24.
//  Copyright © 2017年 Junhuashao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, GinEditPhotoActionType) {
    GinEditPhotoActionTypeMosaic,
    GinEditPhotoActionTypeMark,
};

@interface GinEditPhotoAction : NSObject

@property (assign, nonatomic) GinEditPhotoActionType actionType;

+ (instancetype)action;

@end
