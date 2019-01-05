//
//  GinEditPhotoMarkView.h
//  JunhuashaoInspector
//
//  Created by JunhuaShao on 2017/8/24.
//  Copyright © 2017年 Junhuashao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GinEditPhotoMarkAction.h"

@interface GinEditPhotoMarkView : UIView

@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIButton *cancelbtn;
@property (strong, nonatomic) UIImageView *rotateImgV;

@property (strong, nonatomic) GinEditPhotoMarkAction *markAction;


@end
