//
//  GinAVCaptureManager.m
//  GinCamera
//
//  Created by JunhuaShao on 2017/4/6.
//  Copyright © 2017年 GinhoorHome. All rights reserved.
//

#import "GinAVCaptureManager.h"

@implementation GinAVCaptureManager

+ (BOOL)checkAudioAuthorization
{
    return [self checkAuthorizationStatus:AVMediaTypeAudio];
}

+ (BOOL)checkVideoAuthorization
{
    return [self checkAuthorizationStatus:AVMediaTypeVideo];
}

+ (BOOL)checkAuthorizationStatus:(AVMediaType)mediaType
{
    AVAuthorizationStatus authorStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if (authorStatus == AVAuthorizationStatusRestricted ||
        authorStatus == AVAuthorizationStatusDenied) {
        return NO;
    }
    return YES;
}

- (AVCaptureDevice *)videoDeviceByPosition:(AVCaptureDevicePosition)position
{
    AVCaptureDeviceDiscoverySession *session = [AVCaptureDeviceDiscoverySession  discoverySessionWithDeviceTypes:@[AVCaptureDeviceTypeBuiltInWideAngleCamera] mediaType:AVMediaTypeVideo position:position];
    
    NSArray *devices = session.devices;
    for (AVCaptureDevice *device in devices) {
        if ([device position] == position) {
            return device;
        }
    }
    return nil;
}

- (void)switchVideoDevice:(AVCaptureSession *)session completion:(void(^)(AVCaptureDeviceInput *newInput, AVCaptureDevicePosition position, AVCaptureDevicePosition newPosition))completion
{
    AVCaptureDevicePosition position = -1;
    AVCaptureDevice *newCamera = nil;
    AVCaptureDeviceInput *newInput = nil;
    AVCaptureDevicePosition newPosition = -1;
    
    NSArray *inputs = session.inputs;
    for (AVCaptureDeviceInput *input in inputs) {
        
        AVCaptureDevice *device = input.device;
        if ([device hasMediaType:AVMediaTypeVideo]) {
            position = device.position;
            newCamera = nil;
            newInput = nil;
            if (position == AVCaptureDevicePositionFront) {
                // 切换为后置
                newCamera = [self videoDeviceByPosition:AVCaptureDevicePositionBack];
                newPosition = AVCaptureDevicePositionBack;
            } else {
                // 切换为前置，前置摄像头不支持闪光灯
                newCamera = [self videoDeviceByPosition:AVCaptureDevicePositionFront];
                newPosition = AVCaptureDevicePositionFront;
            }
            
            newInput = [AVCaptureDeviceInput deviceInputWithDevice:newCamera error:nil];
            [session beginConfiguration];
            [session removeInput:input];
            [session addInput:newInput];
            [session commitConfiguration];
            break;
        }
    }
    if (completion) {
        completion(newInput, position, newPosition);
    }
}

- (AVCaptureConnection *)getVideoTypeConnection:(AVCaptureOutput *)captureOutput
{
    return [captureOutput connectionWithMediaType:AVMediaTypeVideo];
}

//改变设备属性的统一操作方法
- (void)changeDevice:(AVCaptureDevice *)captureDevice property:(void (^)(AVCaptureDevice *device))propertyChange
{
    NSError *error;
    //注意改变设备属性前一定要首先调用lockForConfiguration:调用完之后使用unlockForConfiguration方法解锁
    if ([captureDevice lockForConfiguration:&error]) {
        propertyChange(captureDevice);
        [captureDevice unlockForConfiguration];
    } else {
        NSLog(@"设置设备属性过程发生错误，错误信息：%@", error.localizedDescription);
    }
}

- (void)requestCaptureAuthorizationByMediaType:(AVMediaType)mediaType successBlock:(void(^)(void))successBlock failture:(void(^)(void))failtureBlock
{
    //  检测授权
    switch ([AVCaptureDevice authorizationStatusForMediaType:mediaType]) {
        //  已授权，可使用
        //  The client is authorized to access the hardware supporting a media type.
        case AVAuthorizationStatusAuthorized: {
            if (successBlock) {
                successBlock();
            }
            break;
        }
        //  未进行授权选择
        //  Indicates that the user has not yet made a choice regarding whether the client can access the hardware.
        case AVAuthorizationStatusNotDetermined: {
            // 再次请求授权
            [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
                //用户授权成功
                if (granted) {
                    if (successBlock) {
                        successBlock();
                    }
                } else {
                    //用户拒绝授权
                    if (failtureBlock) {
                        failtureBlock();
                    }
                }
            }];
            break;
        }
        //用户拒绝授权/未授权
        default: {
            if (failtureBlock) {
                failtureBlock();
            }
            break;
        }
    }
}


@end


