//
//  GinPhotoQueueCaptureViewController+Router.m
//  GinCameraCaptureManager
//
//  Created by JunhuaShao on 2019/1/5.
//  Copyright © 2019 JunhuaShao. All rights reserved.
//

#import "GinPhotoQueueCaptureViewController+Router.h"

@implementation GinPhotoQueueCaptureViewController (Router)

+ (GinPhotoQueueCaptureViewController *)VCWithPhotoList:(NSArray <GinCapturePhoto *> *)photoList
                                        photoIndexQueue:(NSArray<GinCapturePhotoEnum *> *)photoIndexQueue
                        didPhotoCaptureListChangedBlock:(void(^) (GinCapturePhoto *photo, GinCapturePhotoEnum *item, GinMediaEditType option))didPhotoCaptureListChangedBlock
                                    didPhotoCapturedBlock:(void(^) (NSString *localPhotoFileName, GinCapturePhoto *photo ,GinCapturePhotoEnum *photoIndex, NSInteger indexInPhotoList))didPhotoCapturedBlock
                                  didStopCapturingBlock:(void(^)(GinCapturePhotoEnum *photoIndex, BOOL isCaturingFinished))didStopCapturingBlock
                                    canDeletePhotoBlock:(BOOL(^)(void))canDeletePhotoBlock
{
    GinPhotoQueueCaptureViewController *vc = [[GinPhotoQueueCaptureViewController alloc] init];
    
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    vc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    vc.modalPresentationCapturesStatusBarAppearance = YES;
    
    vc.viewModel = [GinPhotoCaptureViewModel viewModelWithPhotoIndexQueue:photoIndexQueue photoList:photoList];
    
    vc.viewModel.didPhotoCaptureListChangedBlock = didPhotoCaptureListChangedBlock;
    vc.didPhotoCapturedBlock = didPhotoCapturedBlock;
    vc.didStopCapturingBlock = didStopCapturingBlock;
    vc.canDeletePhotoBlock = canDeletePhotoBlock;
    
    return vc;
}

- (void)presentPhotoCapture:(UIViewController *)presentedVC
{
    [presentedVC presentViewController:self animated:NO completion:^{}];
    [self showViewControllerAnimated];
}

@end
