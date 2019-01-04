//
//  ViewController.m
//  GinCameraCaptureManager
//
//  Created by JunhuaShao on 2019/1/4.
//  Copyright © 2019 JunhuaShao. All rights reserved.
//

#import "ViewController.h"
#import "GinVideoCaptureViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (IBAction)video:(id)sender {

    GinVideoCaptureViewController *vc = [[GinVideoCaptureViewController alloc] init];
    
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    vc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    vc.modalPresentationCapturesStatusBarAppearance = YES;
    
    vc.viewModel.getVehicleVideoBlock = ^(NSString *videoFilename) {
        NSLog(@"--->%@",videoFilename);
    };
    
    [self presentViewController:vc animated:YES completion:^{}];
}

- (IBAction)singlephoto:(id)sender {
}


@end
