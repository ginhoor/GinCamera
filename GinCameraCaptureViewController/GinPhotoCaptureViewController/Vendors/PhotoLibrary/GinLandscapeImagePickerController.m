//
//  GinLandscapeImagePickerController.m
//  YanCheBaoJia
//
//  Created by JunhuaShao on 2017/5/7.
//  Copyright © 2017年 Junhuashao. All rights reserved.
//

#import <UIColor+Hex.h>

#import "GinLandscapeImagePickerController.h"

@interface GinLandscapeImagePickerController ()

@end

@implementation GinLandscapeImagePickerController

//- (UIStatusBarStyle)preferredStatusBarStyle
//{
//    return UIStatusBarStyleLightContent;
//}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientationMask) supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscapeRight;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationLandscapeRight;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationBar.tintColor = [UIColor colorWithHex:0x4A4A4A];
    
    self.allowsEditing = NO;
    
    UIImagePickerControllerSourceType sourceType;
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    } else {
        sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    }
    
    self.sourceType = sourceType;
}

@end
