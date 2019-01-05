//
//  GinPhotoSingleCaptureViewModel.h
//  CommercialVehiclePlatform
//
//  Created by JunhuaShao on 2018/6/13.
//  Copyright © 2018年 JunhuaShao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "GinEditPhotoViewModel.h"
#import "GinCapturePhotoEnum.h"
#import "GinCapturePhoto.h"
#import "GinImageCompressManager.h"

@interface GinPhotoSingleCaptureViewModel : NSObject

@property (strong, nonatomic) GinCapturePhotoEnum *photoIndex;
@property (strong, nonatomic) GinCapturePhoto *photo;
@property (strong, nonatomic) GinEditPhotoViewModel *editViewModel;

@property (strong, nonatomic) GinImageCompressManager *compressManager;

@property (assign, nonatomic) BOOL showOriginPhoto;

- (void)updateEditedImageByCurrentCapturedPhoto;
- (void)deleteCapturedImage;

@end
