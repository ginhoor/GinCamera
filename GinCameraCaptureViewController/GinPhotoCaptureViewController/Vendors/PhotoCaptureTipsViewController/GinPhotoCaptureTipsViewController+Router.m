//
//  GinPhotoCaptureTipsViewController+Router.m
//  GinCameraCaptureManager
//
//  Created by JunhuaShao on 2019/1/5.
//  Copyright © 2019 JunhuaShao. All rights reserved.
//

#import "GinPhotoCaptureTipsViewController+Router.h"

@implementation GinPhotoCaptureTipsViewController (Router)

+ (void)presentTips:(UIViewController *)presentedVC viewUrl:(NSString *)viewUrl
{
    GinPhotoCaptureTipsViewController *vc = [[GinPhotoCaptureTipsViewController alloc] init];
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    vc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    vc.modalPresentationCapturesStatusBarAppearance = YES;
    
    vc.url = viewUrl;
    
    [presentedVC presentViewController:vc animated:NO completion:nil];
}

@end
