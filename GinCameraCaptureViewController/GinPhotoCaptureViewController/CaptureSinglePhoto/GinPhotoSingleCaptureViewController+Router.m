//
//  GinPhotoSingleCaptureViewController+Router.m
//  GinCameraCaptureManager
//
//  Created by JunhuaShao on 2019/1/5.
//  Copyright © 2019 JunhuaShao. All rights reserved.
//

#import "GinPhotoSingleCaptureViewController+Router.h"

@implementation GinPhotoSingleCaptureViewController (Router)

+ (GinPhotoSingleCaptureViewController *)viewController
{
    GinPhotoSingleCaptureViewController *vc = [[GinPhotoSingleCaptureViewController alloc] init];
    
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    vc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    vc.modalPresentationCapturesStatusBarAppearance = YES;
    return vc;
}

- (void)presentSinglePhoto:(UIViewController *)presentedVC
                photoIndex:(GinCapturePhotoEnum *)photoIndex
                     photo:(GinCapturePhoto *)photo
       didSelectPhotoBlock:(void(^) (NSString *localPhotoFileName, GinCapturePhoto *photo ,GinCapturePhotoEnum *photoIndex))didSelectedPhotoBlock
       didDeletePhotoBlock:(void(^)(GinCapturePhoto *photo ,GinCapturePhotoEnum *photoIndex))didDeletePhotoBlock
{
    self.viewModel.photo = photo;
    self.viewModel.photoIndex = photoIndex;
    self.didSelectPhotoBlock = didSelectedPhotoBlock;
    self.didDeletePhotoBlock = didDeletePhotoBlock;
    
    [presentedVC presentViewController:self animated:NO completion:nil];
    [self showViewControllerAnimated];
}

@end
