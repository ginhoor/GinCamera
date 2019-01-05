//
//  GinPhotoQueueCaptureViewController.h
//  JunhuaShao
//
//  Created by JunhuaShao on 2017/11/2.
//  Copyright © 2017年 JunhuaShao. All rights reserved.
//

#import "GinPhotoCaptureViewModel.h"

@interface GinPhotoQueueCaptureViewController : UIViewController

@property (strong, nonatomic) GinPhotoCaptureViewModel *viewModel;

@property (copy, nonatomic) BOOL (^canDeletePhotoBlock)(void);

@property (copy, nonatomic) void(^didStopCapturingBlock)(GinCapturePhotoEnum *photoIndex, BOOL isCaturingFinished);

@property (copy, nonatomic) void(^didPhotoCapturedBlock) (NSString *localPhotoFileName, GinCapturePhoto *photo ,GinCapturePhotoEnum *photoIndex, NSInteger indexInPhotoList);

- (void)showViewControllerAnimated;
- (void)dismissViewControllerAnimated;

@end
