//
//  GinPhotoSingleCaptureViewController.h
//  CommercialVehiclePlatform
//
//  Created by JunhuaShao on 2018/6/13.
//  Copyright © 2018年 JunhuaShao. All rights reserved.
//

#import "GinPhotoSingleCaptureViewModel.h"

@interface GinPhotoSingleCaptureViewController : UIViewController

@property (strong, nonatomic) GinPhotoSingleCaptureViewModel *viewModel;

@property (copy, nonatomic) BOOL (^canDeletePhotoBlock)(void);
@property (copy, nonatomic) void(^didSelectPhotoBlock) (NSString *localPhotoFileName, GinCapturePhoto *photo, GinCapturePhotoEnum *photoIndex);
@property (copy, nonatomic) void(^didDeletePhotoBlock) (GinCapturePhoto *photo ,GinCapturePhotoEnum *photoIndex);

- (void)showViewControllerAnimated;
- (void)dismissViewControllerAnimated;

@end
