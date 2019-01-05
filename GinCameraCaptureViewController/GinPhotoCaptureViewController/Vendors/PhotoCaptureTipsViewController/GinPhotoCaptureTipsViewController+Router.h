//
//  GinPhotoCaptureTipsViewController+Router.h
//  GinCameraCaptureManager
//
//  Created by JunhuaShao on 2019/1/5.
//  Copyright © 2019 JunhuaShao. All rights reserved.
//

#import "GinPhotoCaptureTipsViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface GinPhotoCaptureTipsViewController (Router)

+ (void)presentTips:(UIViewController *)presentedVC viewUrl:(NSString *)viewUrl;

@end

NS_ASSUME_NONNULL_END
