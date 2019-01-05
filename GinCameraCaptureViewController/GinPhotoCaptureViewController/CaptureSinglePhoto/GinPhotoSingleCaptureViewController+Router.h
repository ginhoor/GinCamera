//
//  GinPhotoSingleCaptureViewController+Router.h
//  GinCameraCaptureManager
//
//  Created by JunhuaShao on 2019/1/5.
//  Copyright © 2019 JunhuaShao. All rights reserved.
//

#import "GinPhotoSingleCaptureViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface GinPhotoSingleCaptureViewController (Router)

+ (GinPhotoSingleCaptureViewController *)viewController;

- (void)presentSinglePhoto:(UIViewController *)presentedVC
                photoIndex:(GinCapturePhotoEnum *)photoIndex
                     photo:(GinCapturePhoto *)photo
       didSelectPhotoBlock:(void(^) (NSString *localPhotoFileName, GinCapturePhoto *photo ,GinCapturePhotoEnum *photoIndex))didSelectedPhotoBlock
       didDeletePhotoBlock:(void(^)(GinCapturePhoto *photo ,GinCapturePhotoEnum *photoIndex))didDeletePhotoBlock;

@end

NS_ASSUME_NONNULL_END
