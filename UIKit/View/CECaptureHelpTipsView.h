//
//  CECaptureHelpTipsView.h
//  CommercialVehiclePlatform
//
//  Created by JunhuaShao on 2018/3/30.
//  Copyright © 2018年 JunhuaShao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CECaptureHelpTipsView : UIControl

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIImageView *tipsImgV;

+ (CGSize)viewSize;

@end
