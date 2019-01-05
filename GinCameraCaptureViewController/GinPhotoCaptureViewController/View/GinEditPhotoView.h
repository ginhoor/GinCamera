//
//  GinEditPhotoView.h
//  JunhuashaoInspector
//
//  Created by JunhuaShao on 2017/8/18.
//  Copyright © 2017年 Junhuashao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GinEditPhotoCanvasView.h"
#import "GinEditPhotoViewModel.h"

@interface GinEditPhotoView : UIView

@property (strong, nonatomic) GinEditPhotoViewModel *viewModel;

@property (strong, nonatomic) UIImageView *photoImgV;
@property (strong, nonatomic) GinEditPhotoCanvasView *canvasView;

- (void)updateCanvas;

@end
