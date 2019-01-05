//
//  GinPhotoQueueCaptureViewController+Router.h
//  GinCameraCaptureManager
//
//  Created by JunhuaShao on 2019/1/5.
//  Copyright © 2019 JunhuaShao. All rights reserved.
//

#import "GinPhotoQueueCaptureViewController.h"

@interface GinPhotoQueueCaptureViewController (Router)

+ (GinPhotoQueueCaptureViewController *)VCWithPhotoList:(NSArray <GinCapturePhoto *> *)photoList
                                        photoIndexQueue:(NSArray<GinCapturePhotoEnum *> *)photoIndexQueue
                        didPhotoCaptureListChangedBlock:(void(^) (GinCapturePhoto *photo, GinCapturePhotoEnum *item, GinMediaEditType option))didPhotoCaptureListChangedBlock
                                  didPhotoCapturedBlock:(void(^) (NSString *localPhotoFileName, GinCapturePhoto *photo ,GinCapturePhotoEnum *photoIndex, NSInteger indexInPhotoList))didPhotoCapturedBlock
                                  didStopCapturingBlock:(void(^)(GinCapturePhotoEnum *photoIndex, BOOL isCaturingFinished))didStopCapturingBlock
                                    canDeletePhotoBlock:(BOOL(^)(void))canDeletePhotoBlock;

- (void)presentPhotoCapture:(UIViewController *)presentedVC;

@end
