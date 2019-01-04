//
//  GinAVCaptureManager.h
//  GinCamera
//
//  Created by JunhuaShao on 2017/4/6.
//  Copyright © 2017年 GinhoorHome. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface GinAVCaptureManager : NSObject

/**
 检查麦克风授权
 */
+ (BOOL)checkAudioAuthorization;
/**
 检测摄像头授权
 */
+ (BOOL)checkVideoAuthorization;
/**
 切换摄像头设备
 */
- (void)switchVideoDevice:(AVCaptureSession *)session completion:(void(^)(AVCaptureDeviceInput *newInput, AVCaptureDevicePosition position, AVCaptureDevicePosition newPosition))completion;

- (AVCaptureDevice *)videoDeviceByPosition:(AVCaptureDevicePosition)position;
- (AVCaptureConnection *)getVideoTypeConnection:(AVCaptureOutput *)captureOutput;

/**
 请求设备权限授权

 @param mediaType 设备类型
 @param successBlock 成功回调
 @param failtureBlock 失败回调
 */
- (void)requestCaptureAuthorizationByMediaType:(AVMediaType)mediaType successBlock:(void(^)(void))successBlock failture:(void(^)(void))failtureBlock;

/**
 安全设置设备属性
 @param captureDevice 设备
 @param propertyChange 修改回调
 */
- (void)changeDevice:(AVCaptureDevice *)captureDevice property:(void (^)(AVCaptureDevice *device))propertyChange;

@end
