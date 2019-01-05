//
//  GinVerticalLayoutButton.h
//  YanCheBaoJia
//
//  Created by JunhuaShao on 2017/5/7.
//  Copyright © 2017年 Junhuashao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GinVerticalLayoutButton : UIButton

@property (strong, nonatomic) UIColor *selectedColor;
@property (assign, nonatomic) CGFloat imageTopOffset;
@property (assign, nonatomic) CGFloat titleTopOffset;
@property (assign, nonatomic) CGFloat titleLabelHeight;

- (void)setup;

@end
