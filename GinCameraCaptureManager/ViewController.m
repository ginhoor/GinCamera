//
//  ViewController.m
//  GinCameraCaptureManager
//
//  Created by JunhuaShao on 2019/1/4.
//  Copyright © 2019 JunhuaShao. All rights reserved.
//

#import "ViewController.h"
#import "GinVideoCaptureViewController.h"
#import "GinPhotoSingleCaptureViewController+Router.h"
#import "GinPhotoQueueCaptureViewController+Router.h"

@interface ViewController ()

@property (strong, nonatomic) GinPhotoSingleCaptureViewController *singleCaptureVC;
@property (strong, nonatomic) GinPhotoQueueCaptureViewController *queueCaptureVC;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.singleCaptureVC = [GinPhotoSingleCaptureViewController viewController];
    
    NSMutableArray *mArr = [NSMutableArray array];
    for (NSInteger i = 0; i < 10; i++) {
        GinCapturePhotoEnum *photoEnum = [[GinCapturePhotoEnum alloc] init];
        
        if (i < 5) {
            photoEnum.category = GinCapturePhotoCategoryNormal;
        } else {
            photoEnum.category = GinCapturePhotoCategoryUnlimited;
        }
        photoEnum.num = i;
        photoEnum.key = [NSString stringWithFormat:@"key%ld",i];
        photoEnum.displayName = [NSString stringWithFormat:@"第%ld张",i+1];
        photoEnum.sampleUrl = @"https://www.baidu.com/img/bd_logo1.png?qua=high&where=super";
        photoEnum.viewUrl = @"https://www.baidu.com";
        [mArr addObject:photoEnum];
    }
    
    self.queueCaptureVC = [GinPhotoQueueCaptureViewController VCWithPhotoList:nil photoIndexQueue:mArr didPhotoCaptureListChangedBlock:^(GinCapturePhoto * _Nonnull photo, GinCapturePhotoEnum * _Nonnull item, GinMediaEditType option) {
        ;
    } didPhotoCapturedBlock:^(NSString * _Nonnull localPhotoFileName, GinCapturePhoto * _Nonnull photo, GinCapturePhotoEnum * _Nonnull photoIndex, NSInteger indexInPhotoList) {
        ;
    } didStopCapturingBlock:^(GinCapturePhotoEnum * _Nonnull photoIndex, BOOL isCaturingFinished) {
        ;
    } canDeletePhotoBlock:^BOOL{
        return YES;
    }];
}

- (IBAction)video:(id)sender
{
    GinVideoCaptureViewController *vc = [[GinVideoCaptureViewController alloc] init];
    
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    vc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    vc.modalPresentationCapturesStatusBarAppearance = YES;
    
    vc.viewModel.getVehicleVideoBlock = ^(NSString *videoFilename) {
        NSLog(@"--->%@",videoFilename);
    };
    
    [self presentViewController:vc animated:YES completion:^{}];
}

- (IBAction)singlephoto:(id)sender
{
    GinCapturePhotoEnum *photoEnum = [[GinCapturePhotoEnum alloc] init];
    photoEnum.num = 1;
    photoEnum.key = @"key1";
    photoEnum.displayName = @"第一张图";
    photoEnum.sampleUrl = @"https://www.baidu.com/img/bd_logo1.png?qua=high&where=super";
    photoEnum.viewUrl = @"https://www.baidu.com";
    
    GinCapturePhoto *currentPhoto = [GinCapturePhoto photo:photoEnum];
    
    [self.singleCaptureVC presentSinglePhoto:self photoIndex:photoEnum photo:currentPhoto didSelectPhotoBlock:^(NSString * _Nonnull localPhotoFileName, GinCapturePhoto * _Nonnull photo, GinCapturePhotoEnum * _Nonnull photoIndex) {
        
        NSLog(@"photo-->%@", photo);
        NSLog(@"photoIndex--->%@", photoIndex);
    } didDeletePhotoBlock:^(GinCapturePhoto * _Nonnull photo, GinCapturePhotoEnum * _Nonnull photoIndex) {
    }];
    
}

- (IBAction)queueCapture:(id)sender
{
    self.queueCaptureVC.viewModel.currentPhotoIndex = self.queueCaptureVC.viewModel.photoIndexQueue.firstObject;

    [self.queueCaptureVC presentPhotoCapture:self];
}

@end
