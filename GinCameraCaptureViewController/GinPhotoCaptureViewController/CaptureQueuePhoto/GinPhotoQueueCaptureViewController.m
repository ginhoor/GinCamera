//
//  GinPhotoQueueCaptureViewController.m
//  JunhuaShao
//
//  Created by JunhuaShao on 2017/11/2.
//  Copyright © 2017年 JunhuaShao. All rights reserved.
//

#import <UIImage+GinUnit.h>
#import <Masonry.h>
#import <UIImageView+WebCache.h>
#import <ReactiveObjC.h>
#import <NSString+GinUnit.h>
#import <Gin_Macro.h>

#import "GinPhotoQueueCaptureViewController.h"

#import "GinLandscapeImagePickerController+Router.h"
#import "GinPhotoCaptureTipsViewController+Router.h"
#import "GinLandSpaceAlertViewController.h"
#import "GinPhotoCaptureManager.h"
#import "GinPhotoCaptureView.h"

#import "GinMediaManager.h"

@interface GinPhotoQueueCaptureViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) GinPhotoCaptureView *captureView;
@property (strong, nonatomic) GinPhotoCaptureManager *captureManager;

@end

@implementation GinPhotoQueueCaptureViewController

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    [self setupViews];
    
    __weak typeof(self) _WeakSelf = self;
    [RACObserve(self.captureManager.photoSettings, flashMode) subscribeNext:^(NSNumber *mode) {
        NSInteger modeEnum = mode.integerValue;
        [_WeakSelf.captureView setFlashModeUI:modeEnum];
    }];
    
    [RACObserve(self.viewModel, nextType) subscribeNext:^(NSNumber *nextType) {
        if (nextType.integerValue == GinPhotoQueueCaptureNextTypeCapturePhoto) {
            [_WeakSelf.captureView.nextBtn setTitle:@"下一张" forState:UIControlStateNormal];
        } else {
            [_WeakSelf.captureView.nextBtn setTitle:@"完成" forState:UIControlStateNormal];
        }
    }];
//    [RACObserve(self.viewModel, self.currentPhotoIndex) subscribeNext:^(CEVehiclePhotoItem *index) {
//
//        [self.captureView setPhotoIndex:[self.viewModel.photoIndexQueue indexOfObject:index] count:self.viewModel.photoIndexQueue.count];
//
//        [self.captureView setupPhotoTitle:index.displayName];
//
//    }];
    
    // 屏幕旋转90度
    self.view.transform = CGAffineTransformMakeRotation(M_PI_2);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (![GinPhotoCaptureManager checkVideoAuthorization]) {
        
        GinLandSpaceAlertViewController *alertController = [GinLandSpaceAlertViewController alertControllerWithTitle:@"未获得授权使用摄像头" message:@"请在 '设置-隐私-相机' 中开启权限。" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        
        UIAlertAction *submit = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{UIApplicationOpenURLOptionUniversalLinksOnly : @NO} completionHandler:nil];
        }];
        
        [alertController addAction:cancel];
        [alertController addAction:submit];
        
        [self presentViewController:alertController animated:NO completion:^{
        }];
        return;
    }
    
    // 默认不开启原图模式
    self.viewModel.showOriginPhoto = NO;
    self.captureView.switchView.toggleSwitch.on = NO;
    
    [self.captureManager resetDeviceConfig];
    [self.captureManager.session startRunning];
    
    GinCapturePhoto *photo = [self.viewModel getCurrentPhoto];
    NSString *localFileName = [photo fetchLocalFilename];
    NSString *pictureUrl = [photo fetchPhotoUrl];

    if ([localFileName isNotBlank] || [pictureUrl isNotBlank]) {
        [self displayPhotoMode];
    } else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.1 animations:^{
                self.captureView.landSpaceTipsView.alpha = 1;
            } completion:^(BOOL finished) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [UIView animateWithDuration:0.1 animations:^{
                        self.captureView.landSpaceTipsView.alpha = 0;
                    }];
                });
            }];
        });
        
        [self capturePhotoMode];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.captureManager.session stopRunning];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    if (@available(iOS 11.0, *)) {
        self.captureView.safeAreaInsetsBottom = self.view.safeAreaInsets.bottom;
        self.captureView.safeAreaInsetsTop = self.view.safeAreaInsets.top;
    }
    
    if (CGRectEqualToRect(self.captureManager.preview.frame, CGRectZero)) {
        [self.captureView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.offset(0);
        }];
        self.captureManager.preview.frame = self.captureView.cameraView.bounds;
    }
}

- (void)setupCaptureManager
{
    self.captureManager = [[GinPhotoCaptureManager alloc] init];
    [self.captureManager setupSession];
    
    [self.captureView.cameraView.layer insertSublayer:self.captureManager.preview atIndex:0];
    self.captureManager.preview.backgroundColor = [UIColor blackColor].CGColor;
    self.captureManager.preview.transform = CATransform3DRotate(CATransform3DIdentity, -M_PI_2, 0, 0, 1);
}

- (void)setupViews
{
    [self.view addSubview:self.captureView];
    
    [self.captureView.flashBtn addTarget:self action:@selector(updateFlashModelAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.captureView.retryBtn addTarget:self action:@selector(retryAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.captureView.cameraBtn addTarget:self action:@selector(capturePhotoAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.captureView.nextBtn addTarget:self action:@selector(nextStepAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.captureView.backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.captureView.photoLibraryBtn addTarget:self action:@selector(showPhotoLibrary:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.captureView.switchView.toggleSwitch addTarget:self action:@selector(toggleSwitchAction:) forControlEvents:UIControlEventValueChanged];
    
    [self.captureView.finishBtn addTarget:self action:@selector(finishAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.captureView.mosaicsBtn addTarget:self action:@selector(mosaicsAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.captureView.markBtn addTarget:self action:@selector(markAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.captureView.cancelEditActionBtn addTarget:self action:@selector(cancelEditAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.captureView.deletePhotoBtn addTarget:self action:@selector(deletePhotoAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.captureView.nextEditionActionBtn addTarget:self action:@selector(nextEditAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.captureView.previousEditionActionBtn addTarget:self action:@selector(previousEditAction:) forControlEvents:UIControlEventTouchUpInside];

    [self.captureView.helpTipsView addTarget:self action:@selector(showHelpTips:) forControlEvents:UIControlEventTouchUpInside];
    [self setupCaptureManager];
}

- (void)showHelpTips:(id)sender
{
    [GinPhotoCaptureTipsViewController presentTips:self viewUrl:self.viewModel.currentPhotoIndex.viewUrl];
}

- (void)toggleSwitchAction:(UISwitch *)switchView
{
    self.viewModel.showOriginPhoto = switchView.on;
    [self displayPhotoMode];
}

- (void)previousEditAction:(id)sender
{
    [self.viewModel.editViewModel previousAction];
}

- (void)nextEditAction:(id)sender
{
    [self.viewModel.editViewModel nextAction];
}

- (void)cancelEditAction:(id)sender
{
    [self displayPhotoMode];
    [self.viewModel.editViewModel clearAllAction];
}

- (void)mosaicsAction:(id)sender
{
    self.captureView.status = GinPhotoCaptureStatusMosaics;

    self.captureView.editView.viewModel.currentActionType = GinEditPhotoActionTypeMosaic;
    
    [self.viewModel updateEditedImageByCurrentCapturedPhoto];
    [self.captureView.editView updateCanvas];
}

- (void)markAction:(id)sender
{
    self.captureView.status = GinPhotoCaptureStatusMark;
    self.captureView.editView.viewModel.currentActionType = GinEditPhotoActionTypeMark;
    
    [self.viewModel updateEditedImageByCurrentCapturedPhoto];
    [self.captureView.editView updateCanvas];
}

- (void)backAction:(id)sender
{
    if (self.didStopCapturingBlock) {
        self.didStopCapturingBlock(self.viewModel.currentPhotoIndex, self.viewModel.nextType == GinPhotoQueueCaptureNextTypeNothing);
    }

    [self dismissViewControllerAnimated];
    [self.viewModel.editViewModel clearAllAction];
}

- (void)nextStepAction:(id)sender
{
//    if (self.viewModel.nextPhotoIndex) {
    
    if (self.viewModel.nextPhotoIndex) {
        self.viewModel.currentPhotoIndex = self.viewModel.nextPhotoIndex;
    }
    
    [self capturePhotoMode];
//    } else {
//        if ([self.viewModel cycelFindNextPhotoIndex]) {
//            [self capturePhotoMode];
//        } else {
//            [self displayPhotoMode];
//        }
//    }
}

- (void)finishAction:(id)sender
{
    if (self.captureView.status == GinPhotoCaptureStatusCaptured) {
        [self backAction:sender];
    } else {
        UIImage *savedImage = [self.viewModel.editViewModel getEditedImage];
        
//        显示编辑后的照片
        self.viewModel.showOriginPhoto = NO;
        self.captureView.switchView.toggleSwitch.on = NO;
        [self.viewModel.editViewModel clearAllAction];

        savedImage = [self.viewModel.compressManager compressImage:savedImage];
        
        [self saveCapturedImage:savedImage isEdited:YES];
    }
}

//拍照
- (void)capturePhotoAction:(id)sender
{
    self.captureView.cameraBtn.enabled = NO;
    __weak typeof(self) _WeakSelf = self;
    [self.captureManager captureImageWithOrientation:AVCaptureVideoOrientationLandscapeRight completion:^(BOOL success, UIImage *image, NSError *error) {
        
        UIImage *savedImage = [self.viewModel.compressManager compressImage:image];
        [self saveCapturedImage:savedImage isEdited:NO];
        [_WeakSelf.captureManager resetDeviceConfig];
    }];
}

- (void)showPhotoLibrary:(id)sender
{
    // 跳转到相册页面
    [self presentViewController:[GinLandscapeImagePickerController VCWithDelegate:self] animated:YES completion:nil];
}

- (void)retryAction:(id)sender
{
    [self capturePhotoMode];
}

- (void)updateFlashModelAction:(id)sender
{
    if (self.captureManager.photoSettings.flashMode == AVCaptureFlashModeAuto) {
        self.captureManager.photoSettings.flashMode = AVCaptureFlashModeOff;
    } else {
        NSInteger currentFlashMode = self.captureManager.photoSettings.flashMode + 1;
        
        if ([[self.captureManager.captureOutput supportedFlashModes] containsObject:@(currentFlashMode)]) {
            self.captureManager.photoSettings.flashMode = currentFlashMode;
        }
    }
    
}

/**
 展示拍摄照片状态
 */
- (void)displayPhotoMode
{
    self.captureView.status = GinPhotoCaptureStatusCaptured;
    
    GinCapturePhoto *photo = [self.viewModel getCurrentPhoto];
    
    NSString *localFilename;
    NSString *pictureUrl;
    
    if (self.viewModel.showOriginPhoto) {
        localFilename = photo.localFilename;
        pictureUrl = photo.photoUrl;
    } else {
        localFilename = [photo fetchLocalFilename];
        pictureUrl = [photo fetchPhotoUrl];
    }

    if ([localFilename isNotBlank]) {
        self.captureView.capturedImageView.image = [GinMediaManager getImageByName:localFilename];
    } else if ([pictureUrl isNotBlank]) {
        __weak typeof(self) _WeakSelf = self;
        [self.captureView.capturedImageView sd_setImageWithURL:[NSURL URLWithString:pictureUrl] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if (error) {
                _WeakSelf.captureView.capturedImageView.image = [UIImage imageNamed:@"photo_loading_bg"];
            }
        }];
    }
    
    [self.captureView setPhotoIndex:[self.viewModel.photoIndexQueue indexOfObject:self.viewModel.currentPhotoIndex] count:self.viewModel.photoIndexQueue.count];

    [self.captureView setupPhotoRejectReason:[self.viewModel getCurrentPhoto].remark photoStatusType:GinPhotoAuditStatusEnumTypeAudtingPass];
}

/**
 开启拍摄模式
 */
- (void)capturePhotoMode
{
    self.captureView.status = GinPhotoCaptureStatusReady;
    
    self.captureView.cameraBtn.enabled = YES;
                   
    //标题
    [self.captureView setupPhotoTitle:self.viewModel.currentPhotoIndex.displayName imgUrl:self.viewModel.currentPhotoIndex.sampleUrl];
    
    [self.captureView setPhotoIndex:[self.viewModel.photoIndexQueue indexOfObject:self.viewModel.currentPhotoIndex] count:self.viewModel.photoIndexQueue.count];

    [self.captureView setupPhotoRejectReason:[self.viewModel getCurrentPhoto].remark photoStatusType:GinPhotoAuditStatusEnumTypeAudtingPass];

//    //引导线
//    if (self.viewModel.currentPhotoIndex.guideUrl) {
//        [self.captureView.tipsLineImgV sd_setImageWithURL:[NSURL URLWithString:self.viewModel.currentPhotoIndex.guideUrl] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//        }];
//    } else {
        self.captureView.tipsLineImgV.image = nil;
//    }

}

/**
 完成拍照
 */
- (void)saveCapturedImage:(UIImage *)capturedImage isEdited:(BOOL)isEdited
{
    NSDictionary *result = [GinMediaManager saveImage:capturedImage];
    NSString *name = result[@"name"];
    NSNumber *success = result[@"success"];
    
    if (success.boolValue) {
        GinCapturePhoto *photo = [self.viewModel getCurrentPhoto];
        
        if (isEdited) {
            photo.editedPhotoUrl = nil;
            photo.editedLocalFilename = name;
        } else {
            photo.localFilename = name;
            photo.photoUrl = nil;
            photo.editedPhotoUrl = nil;
            photo.editedLocalFilename = nil;
        }
        
        [self.viewModel setCapturedPhoto:photo atIndex:self.viewModel.currentPhotoIndex];

        if (self.didPhotoCapturedBlock) {
            self.didPhotoCapturedBlock(name, photo, self.viewModel.currentPhotoIndex, [self.viewModel.photoIndexQueue indexOfObject:self.viewModel.currentPhotoIndex]);
        }
        
        [self displayPhotoMode];
    } else {
        GinLandSpaceAlertViewController *alertController = [GinLandSpaceAlertViewController alertControllerWithTitle:@"提示" message:@"照片保存失败！" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *submit = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        
        [alertController addAction:submit];
        
        [self presentViewController:alertController animated:NO completion:^{}];
    }
}

- (void)deletePhotoAction:(id)sender
{
    GinLandSpaceAlertViewController *alertController = [GinLandSpaceAlertViewController alertControllerWithTitle:@"提示" message:@"是否删除当前照片？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *submit = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {

        [self.viewModel deleteCapturedImage:self.viewModel.currentPhotoIndex];
        [self nextStepAction:nil];
    }];
    
    
    [alertController addAction:cancel];
    [alertController addAction:submit];
    
    [self presentViewController:alertController animated:NO completion:^{
    }];
    
}

#pragma mark- Delegate & DataSource

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *editedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    if(!editedImage) {
        editedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    
    UIImage *savedImage = [self.viewModel.compressManager compressImage:editedImage];

    [picker dismissViewControllerAnimated:YES completion:nil];

    [self saveCapturedImage:savedImage isEdited:NO];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)showViewControllerAnimated
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.view.frame = CGRectMake(-SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.view.alpha = 0;
        [UIView animateWithDuration:0.25 animations:^{
            self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            self.view.alpha = 1;
        }];
    });
}

- (void)dismissViewControllerAnimated
{
    self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.view.alpha = 1;
    [UIView animateWithDuration:0.25 animations:^{
        self.view.frame = CGRectMake(-SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.view.alpha = 0;
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:^{
            ;
        }];
    }];
}

- (void)setCanDeletePhotoBlock:(BOOL (^)(void))canDeletePhotoBlock
{
    _canDeletePhotoBlock = canDeletePhotoBlock;
    self.captureView.canDeletePhotoBlock = canDeletePhotoBlock;
}

- (GinPhotoCaptureView *)captureView
{
    if (!_captureView) {
        _captureView = [[GinPhotoCaptureView alloc] init];
        _captureView.viewModel = self.viewModel;
        
        __weak typeof(self) _WeakSelf = self;
        _captureView.cameraTapBlock = ^(CGPoint touchPoint, CGPoint focusPoint) {
            // 设置聚焦
            [_WeakSelf.captureManager focusWithMode:AVCaptureFocusModeAutoFocus exposureMode:AVCaptureExposureModeAutoExpose atPoint:focusPoint];
        };
    }
    return _captureView;
}

@end
