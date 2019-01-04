//
//  GinVideoCaptureViewController.m
//  demo4CaptureVideo
//
//  Created by JunhuaShao on 2018/2/22.
//  Copyright © 2018年 JunhuaShao. All rights reserved.
//

#import <Masonry.h>
#import <BlocksKit.h>
#import <UIAlertController+GinUnit.h>

#import "GinVideoCaptureViewController.h"
#import "GinVideoCaptureManager.h"
#import "GinVideoCaptureActionView.h"

@interface GinVideoCaptureViewController ()

@property (strong, nonatomic) GinVideoCaptureManager *captureManager;
@property (strong, nonatomic) UIView *previewView;

@property (strong, nonatomic) UIButton *backBtn;
@property (strong, nonatomic) UIButton *flashBtn;
@property (strong, nonatomic) UIButton *switchCameraBtn;
@property (assign, nonatomic) BOOL isFlashLightOn;

@property (strong, nonatomic) GinVideoCaptureActionView *actionView;

@end

@implementation GinVideoCaptureViewController

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self.view addSubview:self.actionView];
    [self.captureManager setupSession];
    [self.view addSubview:self.previewView];
    [self.previewView.layer insertSublayer:self.captureManager.captureVideoPreviewLayer atIndex:0];
   
    [self.view addSubview:self.switchCameraBtn];
    [self.view addSubview:self.flashBtn];
    [self.view addSubview:self.backBtn];

    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);

        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(20);
        } else {
            make.top.offset(20);
        }
        make.size.sizeOffset(CGSizeMake(40, 40));
    }];
    
    [self.actionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.right.offset(0);
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset([self previewSize].height);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.top.offset([self previewSize].height);
            make.bottom.offset(0);
        }
    }];
    
    [self.switchCameraBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.top.equalTo(self.backBtn);
        make.size.sizeOffset(CGSizeMake(40, 40));
    }];
    
    [self.flashBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.switchCameraBtn.mas_left).offset(-30);
        make.top.equalTo(self.backBtn);
        make.size.sizeOffset(CGSizeMake(40, 40));
    }];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    CGSize size = [self previewSize];
    
    CGFloat topMargin = 0;
    
    if (@available(iOS 11.0, *)) {
        topMargin = self.view.safeAreaInsets.top;
    }
    self.previewView.frame = CGRectMake(0, topMargin, size.width, size.height);
        
    self.captureManager.captureVideoPreviewLayer.frame = self.previewView.bounds;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];

    __weak typeof(self) _WeakSelf = self;
    void (^jumpToSettingsBlock) (void) = ^{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{UIApplicationOpenURLOptionUniversalLinksOnly : @NO} completionHandler:nil];
        [_WeakSelf dismissViewControllerAnimated:YES completion:nil];
    };
    
    BOOL videoAuthorization = [GinVideoCaptureManager checkVideoAuthorization];
    BOOL audioAuthorization = [GinVideoCaptureManager checkAudioAuthorization];
    
    if (!videoAuthorization) {
        [UIAlertController alert:@"未获得相机使用授权" message:@"请在 '设置-隐私-相机' 中开启权限。" cancelTitle:@"确定" cancelBlock:^(UIAlertAction *action){
            jumpToSettingsBlock();
        } completionBlock:nil];
    } else if (!audioAuthorization) {
        [UIAlertController alert:@"未获得麦克风使用授权" message:@"请在 '设置-隐私-相机' 中开启权限。" cancelTitle:@"确定" cancelBlock:^(UIAlertAction *action){
            jumpToSettingsBlock();
        } completionBlock:nil];
    }
    
    if (videoAuthorization && audioAuthorization) {
        [self.captureManager.captureSession startRunning];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [self.captureManager.captureSession stopRunning];
}

#pragma mark- Getter & Setter

- (UIButton *)flashBtn
{
    if (!_flashBtn) {
        _flashBtn = [[UIButton alloc] init];
        [_flashBtn setImage:[UIImage imageNamed:@"icon_flash_close_24x24"] forState:UIControlStateNormal];
        [_flashBtn addTarget:self action:@selector(flashBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _flashBtn;
}

- (void)flashBtnAction:(id)sender
{
    self.isFlashLightOn = !self.isFlashLightOn;
    
    [self.captureManager changeDevice:self.captureManager.captureDevice property:^(AVCaptureDevice *device) {
        if (self.isFlashLightOn) {
            if ([device isTorchModeSupported:AVCaptureTorchModeOn]) {
                [device setTorchMode:AVCaptureTorchModeOn];
                [self.flashBtn setImage:[UIImage imageNamed:@"icon_flash_on_24x24"] forState:UIControlStateNormal];
            }
        } else {
            if ([device isTorchModeSupported:AVCaptureTorchModeOff]) {
                [device setTorchMode:AVCaptureTorchModeOff];
                [self.flashBtn setImage:[UIImage imageNamed:@"icon_flash_close_24x24"] forState:UIControlStateNormal];
            }
        }
    }];
}

- (UIButton *)switchCameraBtn
{
    if (!_switchCameraBtn) {
        _switchCameraBtn = [[UIButton alloc] init];
        [_switchCameraBtn setImage:[UIImage imageNamed:@"icon_camera_white_24x24"] forState:UIControlStateNormal];
        [_switchCameraBtn addTarget:self action:@selector(switchCameraAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _switchCameraBtn;
}

- (void)switchCameraAction:(UIBarButtonItem *)sender
{
    [self.captureManager switchVideoDevice:nil];
}

- (UIButton *)backBtn
{
    if (!_backBtn) {
        _backBtn = [[UIButton alloc] init];
        [_backBtn setImage:[UIImage imageNamed:@"icon_close_white_24x24"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (void)backBtnAction:(id)sender
{
    [UIAlertController alert:@"提示" message:@"是否放弃当前视频编辑？" submitTitle:@"确定" submitBlock:^(UIAlertAction * _Nonnull action) {
        [self.viewModel.videoItemList enumerateObjectsUsingBlock:^(GinVideoCaptureItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [GinMediaManager deleteVideoFile:obj.filePath];
        }];
        self.viewModel.videoItemList = nil;
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    } cancelTitle:@"取消" cancelBlock:^(UIAlertAction * _Nonnull action) {
        
    } completionBlock:^{
        
    }];
}

- (UIView *)previewView
{
    if (!_previewView) {
        _previewView = [[UIView alloc] init];
        _previewView.layer.backgroundColor = [UIColor blackColor].CGColor;
    }
    return _previewView;
}

- (CGSize)previewSize
{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    return CGSizeMake(screenSize.width, screenSize.width/480*640);
}

- (GinVideoCaptureActionView *)actionView
{
    if (!_actionView) {
        _actionView = [[GinVideoCaptureActionView alloc] init];
        _actionView.videoProgressView.totalProgress = 30;

        [_actionView.captureBtn addTarget:self action:@selector(captureBtnTouchDownAction:) forControlEvents:UIControlEventTouchDown];
        [_actionView.captureBtn addTarget:self action:@selector(captureBtnTouchUpAction:) forControlEvents:UIControlEventTouchUpInside];
        [_actionView.captureBtn addTarget:self action:@selector(captureBtnTouchUpAction:) forControlEvents:UIControlEventTouchUpOutside];
        [_actionView.captureBtn addTarget:self action:@selector(captureBtnTouchUpAction:) forControlEvents:UIControlEventTouchDragOutside];
        [_actionView.captureBtn addTarget:self action:@selector(captureBtnTouchUpAction:) forControlEvents:UIControlEventTouchDragExit];
        [_actionView.captureBtn addTarget:self action:@selector(captureBtnTouchUpAction:) forControlEvents:UIControlEventTouchCancel];

        [_actionView.undoBtn addTarget:self action:@selector(undoBtnActon:) forControlEvents:UIControlEventTouchUpInside];
        [_actionView.doneBtn addTarget:self action:@selector(doneBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_actionView.deleteBtn addTarget:self action:@selector(deleteBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _actionView;
}

- (void)captureBtnTouchDownAction:(id)sender
{
    if (![self.captureManager.captureMovieFileOutput isRecording]) {
        [self.captureManager startRecordVideo:[GinMediaManager filePath:[GinMediaManager getVideoFileName]]];
    }
}

- (void)captureBtnTouchUpAction:(id)sender
{
    if ([self.captureManager.captureMovieFileOutput isRecording]) {
        [self.captureManager stopVideoRecoding];
    }
}

- (void)undoBtnActon:(id)sender
{
    if (self.viewModel.videoItemList.count > 0) {
        self.actionView.status = CEVehicleVideoCaptureStatusUndo;
        [self.actionView.videoProgressView selectedProgress:self.viewModel.videoItemList.count-1];
    }
}

- (void)deleteBtnAction:(id)sender
{
    [UIAlertController alertOnWindow:[UIApplication sharedApplication].windows.firstObject title:@"提示" message:@"是否删除此段视频？" submitTitle:@"删除" submitBtnStyle:UIAlertActionStyleDestructive submitBlock:^(UIAlertAction * _Nonnull action) {
        NSUInteger index = self.viewModel.videoItemList.count-1;
        
        NSNumber *progressValue = self.actionView.videoProgressView.progressValueList[index];
        self.captureManager.videoTotalDuration -= progressValue.doubleValue;
        
        [self.actionView.videoProgressView removeProgressItem:index];
        
        GinVideoCaptureItem *previousVideo = self.viewModel.videoItemList.lastObject;
        [GinMediaManager deleteVideoFile:previousVideo.filePath];
        [self.viewModel removePreviousVideoFile];
        
        self.actionView.status = CEVehicleVideoCaptureStatusCaptured;
    } cancelTitle:@"取消" cancleBtnStyle:UIAlertActionStyleCancel cancelBlock:nil completionBlock:nil];
}

- (void)doneBtnAction:(id)sender
{
    if (self.viewModel.videoItemList.count == 0) {
        [UIAlertController alert:@"提示" message:@"请先拍摄视频" cancelTitle:@"确定" cancelBlock:nil completionBlock:nil];
    } else {
        NSString *videoFilename = [GinMediaManager getVideoFileName];
        NSString *outputVideoFilePath = [GinMediaManager filePath:videoFilename];
     
        [GinVideoCaptureManager mergeAndExportVideos:[self.viewModel.videoItemList bk_map:^id(GinVideoCaptureItem *obj) {
            return obj.filePath;
        }]
                                          outputPath:outputVideoFilePath
                                          presetName:nil
                                      outputFileType:nil
                                          completion:^(BOOL success) {
            if (success) {
                [self.viewModel.videoItemList enumerateObjectsUsingBlock:^(GinVideoCaptureItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [GinMediaManager deleteVideoFile:obj.filePath];
                }];
                self.viewModel.videoItemList = nil;
                
                if (self.viewModel.getVehicleVideoBlock) {
                    self.viewModel.getVehicleVideoBlock(videoFilename);
                }
                
                [self dismissViewControllerAnimated:YES completion:nil];
            } else {
                [UIAlertController alert:@"提示" message:@"视频合成失败！" cancelTitle:@"确定" cancelBlock:nil completionBlock:nil];
            }
        }];
    }
}

- (GinVideoCaptureManager *)captureManager
{
    if (!_captureManager) {
        _captureManager = [[GinVideoCaptureManager alloc] init];
        _captureManager.videoMaxDuration = 30;
        
        __weak typeof(self) _WeakSelf = self;
        _captureManager.didStartRecordingBlock = ^(NSString *currentFilePath) {
            _WeakSelf.actionView.status = CEVehicleVideoCaptureStatusCapturing;
            _WeakSelf.switchCameraBtn.hidden = YES;
            _WeakSelf.flashBtn.hidden = YES;
            _WeakSelf.backBtn.hidden = YES;

            [_WeakSelf.viewModel addVideoFile:currentFilePath];
        };
        
        _captureManager.didRecordingBlock = ^(NSString *currentFilePath, NSTimeInterval videoCurrentDuration, NSTimeInterval videoTotalDuration) {
            
            [_WeakSelf.actionView updateDurationLabel:videoTotalDuration+videoCurrentDuration];
            
            GinVideoCaptureItem *item = _WeakSelf.viewModel.videoItemList.lastObject;
            item.duration = videoCurrentDuration;
            
            [_WeakSelf.actionView.videoProgressView updateProgress:videoTotalDuration+videoCurrentDuration];
        };
        
        _captureManager.didFinishRecordingBlock = ^(BOOL success, NSString *currentFilePath, NSTimeInterval videoCurrentDuration, NSTimeInterval videoTotalDuration, BOOL isOverDuration) {
            
            _WeakSelf.switchCameraBtn.hidden = NO;
            _WeakSelf.flashBtn.hidden = NO;
            _WeakSelf.backBtn.hidden = NO;

            if (success) {
                GinVideoCaptureItem *item = _WeakSelf.viewModel.videoItemList.lastObject;
                item.duration = videoCurrentDuration;

                [_WeakSelf.actionView.videoProgressView addProgressItem:videoCurrentDuration];
                if (isOverDuration) {
                    _WeakSelf.actionView.status = CEVehicleVideoCaptureStatusFinished;
                } else {
                    _WeakSelf.actionView.status = CEVehicleVideoCaptureStatusCaptured;
                }
            } else {
                [_WeakSelf.viewModel removePreviousVideoFile];
                [_WeakSelf.actionView.videoProgressView updateProgress:videoTotalDuration];

                _WeakSelf.actionView.status = CEVehicleVideoCaptureStatusCaptured;
            }
        };
    }
    return _captureManager;
}

- (GinVideoCaptureViewModel *)viewModel
{
    if (!_viewModel) {
        _viewModel = [[GinVideoCaptureViewModel alloc] init];
    }
    return _viewModel;
}

@end

