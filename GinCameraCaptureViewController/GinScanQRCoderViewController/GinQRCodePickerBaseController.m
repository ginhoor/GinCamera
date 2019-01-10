//
//  Created by Ginhoor on 13-11-29.
//  Copyright (c) 2013年 Ginhoor. All rights reserved.
//

#import <UIAlertController+GinUnit.h>

#import "GinQRCodePickerBaseController.h"

@interface GinQRCodePickerBaseController ()<AVCaptureMetadataOutputObjectsDelegate>

@property (strong, nonatomic) AVCaptureDevice *device;
@property (strong, nonatomic) AVCaptureDeviceInput *input;
@property (strong, nonatomic) AVCaptureMetadataOutput *output;
@property (strong, nonatomic) AVCaptureSession *session;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *preview;

@end

@implementation GinQRCodePickerBaseController

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.opaque = YES;
    [self setupCamera];
}

- (void)setupCamera
{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus == AVAuthorizationStatusRestricted ||
       authStatus == AVAuthorizationStatusDenied){
        
        [UIAlertController alert:@"未获得授权使用摄像头" message:@"请在 '设置-隐私-相机' 中开启权限。" cancelTitle:@"确定" cancelBlock:^(UIAlertAction *action){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{UIApplicationOpenURLOptionUniversalLinksOnly : @NO} completionHandler:nil];
            [self.navigationController popViewControllerAnimated:YES];
            [self.presentingViewController dismissViewControllerAnimated:YES completion:^{}];
        } completionBlock:^{}];
        
        return;
    }

    // Device
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Input
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    // Output
    self.output = [[AVCaptureMetadataOutput alloc]init];
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // Session
    self.session = [[AVCaptureSession alloc]init];
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([self.session canAddInput:self.input])
        [self.session addInput:self.input];
    
    if ([self.session canAddOutput:self.output])
        [self.session addOutput:self.output];
    
    // 条码类型 AVMetadataObjectTypeQRCode
    self.output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
    // Preview
    self.preview = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.preview.frame = self.view.frame;
    [self.view.layer insertSublayer:self.preview atIndex:0];
    
    // Start
    [self.session startRunning];
}

#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    NSString *stringValue;
    if ([metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
    }

//    扫描到结果后就停止
    [self.session stopRunning];
    
    if (self.navigationController) {
        [CATransaction begin];
        [CATransaction setCompletionBlock:^{
            if (self.resultDidReceivedBlock) {
                self.resultDidReceivedBlock(stringValue);
            }
        }];
        
        [self.navigationController popViewControllerAnimated:YES];
        [CATransaction commit];
    } else {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
            if (self.resultDidReceivedBlock) {
                self.resultDidReceivedBlock(stringValue);
            }
        }];
    }
}

@end
