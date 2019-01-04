//
//  GinPhotoCaptureManager.h
//  GinCamera
//
//  Created by JunhuaShao on 2017/4/6.
//  Copyright © 2017年 GinhoorHome. All rights reserved.
//

#import "GinAVCaptureManager.h"

@interface GinStillImage : NSObject
// 压缩图
@property (strong,nonatomic) UIImage *thumbImage;
// 原图
@property (strong,nonatomic) UIImage *photoImage;
@property (strong, nonatomic) NSString *localIdentifier;

@end

@interface GinPhotoCaptureManager : GinAVCaptureManager

@property (strong, nonatomic, readonly) AVCaptureSession *session;

@property (strong, nonatomic, readonly) AVCapturePhotoOutput *captureOutput;
@property (strong, nonatomic, readonly) AVCapturePhotoSettings *photoSettings;
@property (strong, nonatomic, readonly) AVCaptureDevice *device;

@property (strong, nonatomic, readonly) AVCaptureDeviceInput *input;
@property (strong, nonatomic, readonly) AVCaptureMetadataOutput *output;

@property (strong, nonatomic, readonly) AVCaptureVideoPreviewLayer *preview;
/**
 图片压缩质量（取值范围0-1），默认：0.3
 */
@property (assign, nonatomic) CGFloat compressMaxQuality;

/**
 * 当切换到闪光灯不可用的状态时，保留上一次的状态。
 */
@property (assign, nonatomic, readonly) AVCaptureFlashMode lastFlashMode;

@property (copy, nonatomic) void(^currentFlashModeBeforeChangedBlock) (AVCaptureFlashMode newMode, AVCaptureFlashMode oldMode);

- (void)setupSession;

- (void)captureImageWithOrientation:(AVCaptureVideoOrientation)orientation completion:(void(^)(BOOL success, UIImage *image, NSError *error))completion;

- (void)saveImageToPhotoAlbum:(UIImage *)savedImage;

/**
 设置手动对焦

 @param focusMode 对焦模式
 @param exposureMode 曝光
 @param point 对焦点
 */
- (void)focusWithMode:(AVCaptureFocusMode)focusMode
         exposureMode:(AVCaptureExposureMode)exposureMode
              atPoint:(CGPoint)point;
/**
 重置 设备设置
 */
- (void)resetDeviceConfig;

@end
