//
//  DemoPhotoCell.h
//  GinCameraCaptureManager
//
//  Created by JunhuaShao on 2019/1/7.
//  Copyright © 2019 JunhuaShao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DemoPhotoCell : UICollectionViewCell

@property (strong, nonatomic) UIImageView *photoImgV;
@property (strong, nonatomic) UILabel *titleLabel;

+ (CGSize)cellSize;

@end
