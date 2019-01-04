//
//  GinVideoCaptureManager.h
//  demo4CaptureVideo
//
//  Created by JunhuaShao on 2017/12/27.
//  Copyright © 2017年 JunhuaShao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GinAVCaptureManager.h"

@interface GinVideoCaptureManager : GinAVCaptureManager

@property (strong, nonatomic) AVCaptureSession *captureSession;
/**
 分辨率 默认：AVCaptureSessionPreset640x480
 【需在setupSession调用前设置】
 */
@property (strong, nonatomic) AVCaptureSessionPreset sessionPreset;
/**
 视频设备
 */
@property (strong, nonatomic) AVCaptureDevice *captureDevice;
@property (strong, nonatomic) AVCaptureDeviceInput *captureDeviceInput;
/**
 音频设备
 */
@property (strong, nonatomic) AVCaptureDevice *audioDevice;
@property (strong, nonatomic) AVCaptureDeviceInput *audioDeviceInput;
/**
 视频输出流
 */
@property (strong, nonatomic) AVCaptureMovieFileOutput *captureMovieFileOutput;
/**
 预览层
 */
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;
/**
 预览层方向 默认为AVCaptureVideoOrientationPortrait
 【需在setupSession调用前设置】
 */
@property (assign, nonatomic) AVCaptureVideoOrientation captureVideoPreviewOrientation;

@property (strong, nonatomic) NSString *videoFilePath;

@property (assign, nonatomic) NSTimeInterval videoTotalDuration;
@property (assign, nonatomic) NSTimeInterval videoMinDuration;
@property (assign, nonatomic) NSTimeInterval videoMaxDuration;


/**
 当AVCaptureDevice实例检测到视频主题区域有实质性变化时。
 */
@property (copy, nonatomic) void(^captureDeviceSubjectAreaDidChangeBlock) (void);

@property (copy, nonatomic) void(^didFinishRecordingBlock) (BOOL success, NSString *videoFilePath, NSTimeInterval videoCurrentDuration, NSTimeInterval videoTotalDuration, BOOL isOverDuration);


@property (copy, nonatomic) void(^didStartRecordingBlock) (NSString * currentFilePath);
@property (copy, nonatomic) void(^didRecordingBlock) (NSString * currentFilePath, NSTimeInterval videoCurrentDuration, NSTimeInterval videoTotalDuration);

- (void)setupSession;
- (void)startRecordVideo:(NSString *)filePath;
- (void)stopVideoRecoding;
/**
 切换摄像头
 @param completion 完成回调
 */
- (void)switchVideoDevice:(void(^)(AVCaptureDeviceInput *newInput, AVCaptureDevicePosition position, AVCaptureDevicePosition newPosition))completion;
/**
 视频合成

 @param videoFilePathList 视频地址
 @param outputPath 输出地址
 @param presetName 分辨率，默认：AVAssetExportPreset640x480
 @param outputFileType 输出格式，默认：AVFileTypeMPEG4
 @param completion 完成回调
 */

+ (void)mergeAndExportVideos:(NSArray <NSString *> *)videoFilePathList
                  outputPath:(NSString *)outputPath
                  presetName:(NSString *)presetName
              outputFileType:(NSString *)outputFileType
                  completion:(void(^)(BOOL success))completion;

/**
 获得指定视频的预览图

 @param filePath 视频地址
 @return 预览图
 */
+ (UIImage *)getVideoPreViewImage:(NSString *)filePath;

@end
