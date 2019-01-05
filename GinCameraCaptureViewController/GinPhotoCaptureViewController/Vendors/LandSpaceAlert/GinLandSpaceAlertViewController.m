//
//  GinLandSpaceAlertViewController.m
//  CommercialVehiclePlatform
//
//  Created by JunhuaShao on 2018/3/29.
//  Copyright © 2018年 JunhuaShao. All rights reserved.
//

#import "GinLandSpaceAlertViewController.h"

@interface GinLandSpaceAlertViewController ()

@end

@implementation GinLandSpaceAlertViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.transform = CGAffineTransformMakeRotation(M_PI_2);
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.view.hidden = YES;
}

- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion
{
    [super dismissViewControllerAnimated:flag completion:completion];
    self.view.transform = CGAffineTransformMakeRotation(M_PI_2);
}


@end
