//
//  GinLandscapeImagePickerController+Router.h
//  GinCameraCaptureManager
//
//  Created by JunhuaShao on 2019/1/5.
//  Copyright © 2019 JunhuaShao. All rights reserved.
//

#import "GinLandscapeImagePickerController.h"

@interface GinLandscapeImagePickerController (Router)

+ (GinLandscapeImagePickerController *)VCWithDelegate:(id <UINavigationControllerDelegate, UIImagePickerControllerDelegate>)delegate;

@end
