//
//  GinVideoCaptureManager.m
//  demo4CaptureVideo
//
//  Created by JunhuaShao on 2017/12/27.
//  Copyright © 2017年 JunhuaShao. All rights reserved.
//

#import <GinhoorFramework/NSString+GinUnit.h>
#import "GinVideoCaptureManager.h"

#define COUNT_DUR_TIMER_INTERVAL 0.05

@interface GinVideoCaptureManager () <AVCaptureFileOutputRecordingDelegate>

@property (assign, nonatomic) BOOL waitingForStop;
@property (strong, nonatomic) NSTimer *countDurTimer;

@property (assign, nonatomic) NSTimeInterval videoCurrentDuration;

@end

@implementation GinVideoCaptureManager

- (void)removeNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    self.sessionPreset = AVCaptureSessionPreset640x480;
    self.videoMinDuration = 1;
    self.videoMaxDuration = CGFLOAT_MAX;
    self.videoCurrentDuration = 0;
    self.captureVideoPreviewOrientation = AVCaptureVideoOrientationPortrait;
}

- (void)setupSession
{
    // 初始化Session
    self.captureSession = [[AVCaptureSession alloc] init];
    // 设置分辨率
    if ([self.captureSession canSetSessionPreset:self.sessionPreset]) {
        self.captureSession.sessionPreset = self.sessionPreset;
    }
    
    // 视频
    self.captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (!self.captureDevice) {
        NSLog(@"获取视频设备失败！");
        return;
    }
    
    NSError *error = nil;
    self.captureDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:self.captureDevice error:&error];
    if (error) {
        NSLog(@"取得视频设备输入时出错，错误原因：%@", error.localizedDescription);
        return;
    }
    if ([self.captureSession canAddInput:self.captureDeviceInput]) {
        [self.captureSession addInput:self.captureDeviceInput];
    }
    
    // 音频
    self.audioDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    if (!self.captureDevice) {
        NSLog(@"获取音频设备失败！");
        return;
    }
    
    self.audioDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:self.audioDevice error:&error];
    if (error) {
        NSLog(@"取得音频设备输入时出错，错误原因：%@", error.localizedDescription);
        return;
    }
    if ([self.captureSession canAddInput:self.audioDeviceInput]) {
        [self.captureSession addInput:self.audioDeviceInput];
    }
    
    self.captureMovieFileOutput = [[AVCaptureMovieFileOutput alloc] init];
    // 不设置这个属性，超过10s的视频会没有声音
    self.captureMovieFileOutput.movieFragmentInterval = kCMTimeInvalid;
    if ([self.captureSession canAddOutput:self.captureMovieFileOutput]) {
        [self.captureSession addOutput:self.captureMovieFileOutput];

        AVCaptureConnection *captureConnection = [self.captureMovieFileOutput connectionWithMediaType:AVMediaTypeVideo];
        // 开启视频防抖
        if ([captureConnection isVideoStabilizationSupported]) {
            captureConnection.preferredVideoStabilizationMode = AVCaptureVideoStabilizationModeAuto;
        }
    }
    // 预览层
    self.captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
    // 设置预览层方向
    AVCaptureConnection *captureConnection = [self.captureVideoPreviewLayer connection];
    captureConnection.videoOrientation = self.captureVideoPreviewOrientation;
    //填充模式
    self.captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self addNotificationToCaptureDevice:self.captureDevice];
}

- (void)addNotificationToCaptureDevice:(AVCaptureDevice *)captureDevice
{
    // 注意 添加区域改变捕获通知必须设置设备允许捕获
    [self changeDevice:captureDevice property:^(AVCaptureDevice *device) {
        device.subjectAreaChangeMonitoringEnabled = YES;
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:AVCaptureDeviceSubjectAreaDidChangeNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        // 当AVCaptureDevice实例检测到视频主题区域有实质性变化时。
        if (self.captureDeviceSubjectAreaDidChangeBlock) {
            self.captureDeviceSubjectAreaDidChangeBlock();
        }
    }];
}

//开始录制
- (void)startRecordVideo:(NSString *)filePath
{
    AVCaptureConnection *captureConnection = [self.captureMovieFileOutput connectionWithMediaType:AVMediaTypeVideo];
    // 如果正在录制，则重新录制，先暂停
    if ([self.captureMovieFileOutput isRecording]) {
        [self stopVideoRecoding];
    }
    // 预览图层 和 视频方向保持一致
    captureConnection.videoOrientation = [self.captureVideoPreviewLayer connection].videoOrientation;
    // 添加路径
    NSURL *fileUrl = [NSURL fileURLWithPath:filePath];
    self.videoFilePath = filePath;
    [self.captureMovieFileOutput startRecordingToOutputFileURL:fileUrl recordingDelegate:self];
}

//结束录制
- (void)stopVideoRecoding
{
    self.waitingForStop = YES;
    
    if ([self.captureMovieFileOutput isRecording]) {
        [self.captureMovieFileOutput stopRecording];
        self.videoFilePath = nil;
    }
    [self stopCountDurTimer];
}

- (void)switchVideoDevice:(void(^)(AVCaptureDeviceInput *newInput, AVCaptureDevicePosition position, AVCaptureDevicePosition newPosition))completion
{
    [self switchVideoDevice:self.captureSession completion:completion];
}

#pragma mark - 视频输出代理
- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections
{
    if (self.waitingForStop == YES) {
        [self stopVideoRecoding];
        return;
    }
    
    self.videoCurrentDuration = 0;
    [self startCountDurTimer];
    
    NSLog(@"开始录制视频--->%@",fileURL);
    
    if (self.didStartRecordingBlock) {
        self.didStartRecordingBlock(self.videoFilePath);
    }
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error
{
    self.waitingForStop = NO;
    
    if (!self.didFinishRecordingBlock) {
        return;
    }
    // 录制时间太短
    if (self.videoCurrentDuration < self.videoMinDuration) {
        // 移除视频文件
        [self removeCurrentVideoFile:self.videoFilePath];
        NSLog(@"录制时间太短");
        self.didFinishRecordingBlock(NO,
                                     self.videoFilePath,
                                     0,
                                     self.videoTotalDuration,
                                     NO);
    } else if (!error) {
        // 总时长加上当前时长
        self.videoTotalDuration += self.videoCurrentDuration;
        
        BOOL isOverDuration = self.videoTotalDuration >= self.videoMaxDuration;
        
        self.didFinishRecordingBlock(YES,
                                     self.videoFilePath,
                                     self.videoCurrentDuration,
                                     self.videoTotalDuration,
                                     isOverDuration);
        NSLog(@"录制完成,%lf/%lf,是否溢出：%d",self.videoCurrentDuration,self.videoTotalDuration,isOverDuration);
    } else {
        // 移除视频文件
        [self removeCurrentVideoFile:self.videoFilePath];
        self.didFinishRecordingBlock(YES,
                                     self.videoFilePath,
                                     self.videoCurrentDuration,
                                     self.videoTotalDuration,
                                     NO);
        NSLog(@"录制失败：%@",error);
    }
}

- (void)startCountDurTimer
{
    __weak typeof(self) _WeakSelf = self;
    self.countDurTimer = [NSTimer scheduledTimerWithTimeInterval:COUNT_DUR_TIMER_INTERVAL repeats:YES block:^(NSTimer * _Nonnull timer) {
        [_WeakSelf timerTask:timer];
    }];
    [[NSRunLoop currentRunLoop] addTimer:self.countDurTimer forMode:NSRunLoopCommonModes];
}

- (void)timerTask:(NSTimer *)timer
{
    if (self.didRecordingBlock) {
        self.didRecordingBlock(self.videoFilePath, self.videoCurrentDuration, self.videoTotalDuration);
    }
    // 当录制时长超过最长时长
    if (self.videoTotalDuration + self.videoCurrentDuration >= self.videoMaxDuration) {
        [self stopVideoRecoding];
    } else {
        self.videoCurrentDuration += COUNT_DUR_TIMER_INTERVAL;
    }
}

- (void)stopCountDurTimer
{
    if (self.countDurTimer) {
        [self.countDurTimer invalidate];
        self.countDurTimer = nil;
    }
}

#pragma mark- Private Method

- (void)removeCurrentVideoFile:(NSString *)filePath
{
    if (!filePath) {
        return;
    }
    BOOL flag = NO;
    NSError *__autoreleasing error = nil;
    
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]) {
        flag = [manager removeItemAtPath:filePath error:&error];
        if (flag == NO && error) {
            NSLog(@"file delete failed!!! error --> %@",error);
        } else {
//            NSLog(@"file in path:%@ deleted!",name);
        }
    }
}

+ (void)mergeAndExportVideos:(NSArray <NSString *> *)videoFilePathList
                  outputPath:(NSString *)outputPath
                  presetName:(NSString *)presetName
              outputFileType:(NSString *)outputFileType
                  completion:(void(^)(BOOL success))completion
{
    if (videoFilePathList.count == 0) {
        return;
    }

    NSLog(@"videoFilePathList--->%@",videoFilePathList);
    
    AVMutableComposition *mixComposition = [AVMutableComposition composition];
    
    AVMutableCompositionTrack *audioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    
    AVMutableCompositionTrack *videoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    
    __block CMTime totalDuration = kCMTimeZero;
    
    [videoFilePathList enumerateObjectsUsingBlock:^(NSString * _Nonnull filePath, NSUInteger idx, BOOL * _Nonnull stop) {
        
        AVURLAsset *asset = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:filePath]];
        
        NSError *audioError = nil;
        // 获取AVAsset中的音频
        AVAssetTrack *assetAudioTrack = [[asset tracksWithMediaType:AVMediaTypeAudio] firstObject];
        // 向通道内加入音频
        BOOL audioFlag = [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration)
                                             ofTrack:assetAudioTrack
                                              atTime:totalDuration
                                               error:&audioError];
        if (!audioFlag) {
            NSLog(@"audioTrack insert error:%@,%d",audioError,audioFlag);
        }
        
        // 向通道内加入视频
        NSError *videoError = nil;
        AVAssetTrack *assetVideoTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] firstObject];
        [videoTrack setPreferredTransform:assetVideoTrack.preferredTransform];
        
        BOOL videoFlag = [videoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration)
                                             ofTrack:assetVideoTrack
                                              atTime:totalDuration
                                               error:&videoError];
        
        if (!videoFlag) {
            NSLog(@"videoTrack insert error:%@,%d",videoError,videoFlag);
        }
        totalDuration = CMTimeAdd(totalDuration, asset.duration);
    }];

    NSURL *mergeFileURL = [NSURL fileURLWithPath:outputPath];
    // 分辨率
    if (![presetName isNotBlank]) {
        presetName = AVAssetExportPreset640x480;
    }
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:presetName];
    exporter.outputURL = mergeFileURL;
    // 转出格式
    if (![outputFileType isNotBlank]) {
        outputFileType = AVFileTypeMPEG4;
    }
    exporter.outputFileType = outputFileType;
    exporter.shouldOptimizeForNetworkUse = YES;
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        if (exporter.error) {
            NSLog(@"AVAssetExportSession Error：%@",exporter.error);
            if (completion) {
                completion(NO);
            }
            return;
        }
        // 导出状态为完成
        if ([exporter status] == AVAssetExportSessionStatusCompleted) {
            NSLog(@"视频合并完成--->%@",mergeFileURL);

            if (completion) {
                completion(YES);
            }
        } else {
            NSLog(@"AVAssetExportSession 当前压缩进度:%f",exporter.progress);
        }
    }];
}

+ (UIImage *)getVideoPreViewImage:(NSString *)filePath
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:filePath] options:nil];
    
    AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    generator.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    CMTime actualTime;
    NSError *error = nil;
    CGImageRef image = [generator copyCGImageAtTime:time actualTime:&actualTime error:&error];
    if (error) {
        NSLog(@"get preview image failed!! error：%@",error);
        CGImageRelease(image);
        return nil;
    }
    UIImage *videoImage = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return videoImage;
}

@end
