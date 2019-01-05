//
//  GinLandscapeImagePickerController+Router.m
//  GinCameraCaptureManager
//
//  Created by JunhuaShao on 2019/1/5.
//  Copyright © 2019 JunhuaShao. All rights reserved.
//

#import "GinLandscapeImagePickerController+Router.h"

@implementation GinLandscapeImagePickerController (Router)

+ (GinLandscapeImagePickerController *)VCWithDelegate:(id <UINavigationControllerDelegate, UIImagePickerControllerDelegate>)delegate
{
    GinLandscapeImagePickerController *vc = [[GinLandscapeImagePickerController alloc] init];
    vc.delegate = delegate;
    return vc;
}

@end
