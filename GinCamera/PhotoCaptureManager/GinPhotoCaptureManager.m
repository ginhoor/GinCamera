//
//  GinPhotoCaptureManager.m
//  GinCamera
//
//  Created by JunhuaShao on 2017/4/6.
//  Copyright © 2017年 GinhoorHome. All rights reserved.
//

#import <GinhoorFramework/UIImage+GinUnit.h>

#import "GinPhotoCaptureManager.h"

// 照片
@implementation GinStillImage
@end

@interface GinPhotoCaptureManager() <AVCapturePhotoCaptureDelegate>

@property (strong, nonatomic, readwrite) AVCaptureSession *session;
@property (strong, nonatomic, readwrite) AVCaptureDevice *device;

@property (strong, nonatomic, readwrite) AVCaptureDeviceInput *input;
@property (strong, nonatomic, readwrite) AVCaptureMetadataOutput *output;

@property (strong, nonatomic, readwrite) AVCapturePhotoOutput *captureOutput;
@property (assign, nonatomic, readwrite) AVCaptureFlashMode lastFlashMode;
@property (strong, nonatomic, readwrite) AVCapturePhotoSettings *photoSettings;

@property (strong, nonatomic, readwrite) AVCaptureVideoPreviewLayer *preview;

@property (strong, nonatomic) void(^capturePhotoBlock)(BOOL success, UIImage *image, NSError *error);

@end

@implementation GinPhotoCaptureManager

- (void)dealloc
{
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.compressMaxQuality = 0.3;
}

- (void)setupSession
{
    // 创建会话层
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    [self setupDevice];
    
    self.photoSettings = [AVCapturePhotoSettings photoSettingsWithFormat:@{AVVideoCodecKey:AVVideoCodecTypeJPEG}];
    // Input
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    // Output
    self.captureOutput = [[AVCapturePhotoOutput alloc] init];
    // Session
    self.session = [[AVCaptureSession alloc]init];
    // 设置为拍照高质量
    [self.session setSessionPreset:AVCaptureSessionPresetPhoto];
    if ([self.session canAddInput:self.input]) {
        [self.session addInput:self.input];
    }
    if ([self.session canAddOutput:self.captureOutput]) {
        [self.session addOutput:self.captureOutput];
    }
    [self setupPreviewLayer];
}

- (void)setupDevice
{
    __weak typeof(self) _WeakSelf = self;
    [self changeDevice:self.device property:^(AVCaptureDevice *device) {
        //  开启自动持续对焦
        if ([_WeakSelf.device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
            [_WeakSelf.device setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
        }
        // 开启自动曝光
        if ([_WeakSelf.device isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure]) {
            [_WeakSelf.device setExposureMode:AVCaptureExposureModeContinuousAutoExposure];
        }
    }];
}

- (void)setupPreviewLayer
{
    // 初始化预览框
    self.preview = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
}

- (void)switchVideoDevice:(AVCaptureSession *)session completion:(void (^)(AVCaptureDeviceInput *, AVCaptureDevicePosition, AVCaptureDevicePosition))completion
{
    __weak typeof(self) _WeakSelf = self;
    [super switchVideoDevice:session completion:^(AVCaptureDeviceInput *newInput, AVCaptureDevicePosition position, AVCaptureDevicePosition newPosition) {
        
        if (newPosition == AVCaptureDevicePositionBack) {
            // 后置摄像头
            if ([[_WeakSelf.captureOutput supportedFlashModes] containsObject:@(_WeakSelf.lastFlashMode)]) {
                _WeakSelf.photoSettings.flashMode = _WeakSelf.lastFlashMode;
            }
        } else {
            // 前置摄像头
            if ([[_WeakSelf.captureOutput supportedFlashModes] containsObject:@(AVCaptureFlashModeOff)]) {
                // 前置摄像头不支持闪光灯
                _WeakSelf.lastFlashMode = _WeakSelf.photoSettings.flashMode;
                _WeakSelf.photoSettings.flashMode = AVCaptureFlashModeOff;
            }
        }
        if (completion) {
            completion(newInput, position, newPosition);
        }
    }];
}

//拍照
- (void)captureImageWithOrientation:(AVCaptureVideoOrientation)orientation completion:(void(^)(BOOL success, UIImage *image, NSError *error))completion
{
    if (!completion) {
        return;
    }
    
    AVCaptureConnection *videoConnection = [self getVideoTypeConnection:self.captureOutput];
    [videoConnection setVideoOrientation:orientation];
    
    self.capturePhotoBlock = completion;
    
    [self.captureOutput capturePhotoWithSettings:[AVCapturePhotoSettings photoSettingsFromPhotoSettings:self.photoSettings] delegate:self];
}

#pragma - Private Method 保存至相册
- (void)saveImageToPhotoAlbum:(UIImage *)savedImage
{
    UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

// 指定回调方法
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        NSLog(@"保存照片过程中发生错误，错误信息:%@", error.localizedDescription);
    } else {
        NSLog(@"照片保存成功。");
    }
}

- (void)resetDeviceConfig
{
    [self.session setSessionPreset:AVCaptureSessionPresetPhoto];
    [self setupDevice];
}

- (void)focusWithMode:(AVCaptureFocusMode)focusMode
         exposureMode:(AVCaptureExposureMode)exposureMode
              atPoint:(CGPoint)point
{
    AVCaptureDevice *captureDevice = self.device;
    
    [self changeDevice:self.device property:^(AVCaptureDevice *device) {
        // 设置聚焦
        if ([captureDevice isFocusModeSupported:focusMode]) {
            [captureDevice setFocusMode:focusMode];
        }
        if ([captureDevice isFocusPointOfInterestSupported]) {
            [captureDevice setFocusPointOfInterest:point];
        }
        // 设置曝光
        if ([captureDevice isExposureModeSupported:exposureMode]) {
            [captureDevice setExposureMode:exposureMode];
        }
        if ([captureDevice isExposurePointOfInterestSupported]) {
            [captureDevice setExposurePointOfInterest:point];
        }
    }];
}

#pragma mark- Delegate & DataSource

- (void)captureOutput:(AVCapturePhotoOutput *)captureOutput didFinishProcessingPhotoSampleBuffer:(CMSampleBufferRef)photoSampleBuffer previewPhotoSampleBuffer:(CMSampleBufferRef)previewPhotoSampleBuffer resolvedSettings:(AVCaptureResolvedPhotoSettings *)resolvedSettings bracketSettings:(AVCaptureBracketedStillImageSettings *)bracketSettings error:(NSError *)error
{    
    if (error) {
        NSLog(@"error：%@", error.localizedDescription);
        if (self.capturePhotoBlock) {
            self.capturePhotoBlock(NO, nil, error);
        }
    } else {
        NSData *data = [AVCapturePhotoOutput JPEGPhotoDataRepresentationForJPEGSampleBuffer:photoSampleBuffer previewPhotoSampleBuffer:previewPhotoSampleBuffer];
        UIImage *t_image = [UIImage imageWithData:data];
        UIImage *image = [UIImage imageWithData:UIImageJPEGRepresentation(t_image, self.compressMaxQuality)];
        if (self.capturePhotoBlock) {
            self.capturePhotoBlock(YES, image, nil);
        }
    }
}

@end


