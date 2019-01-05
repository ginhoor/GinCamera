//
//  CEVehiclePhotoSingleCaptureView.h
//  CommercialVehiclePlatform
//
//  Created by JunhuaShao on 2018/6/13.
//  Copyright © 2018年 JunhuaShao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "GinVerticalLayoutButton.h"
#import "GinEditPhotoView.h"
#import "GinPhotoSingleCaptureViewModel.h"
#import "GinCapturePhotoLandspaceTipsView.h"
#import "GinCaptureHelpTipsView.h"
#import "GinTitleSwitch.h"
#import "GinCapturePhoto.h"

typedef NS_ENUM(NSUInteger, GinPhotoSingleCaptureStatus) {
    GinPhotoSingleCaptureStatusReady,
    GinPhotoSingleCaptureStatusCaptured,
    GinPhotoSingleCaptureStatusMark,
    GinPhotoSingleCaptureStatusMosaics,
};

@interface CEVehiclePhotoSingleCaptureView : UIView

@property (assign, nonatomic) CGFloat safeAreaInsetsTop;
@property (assign, nonatomic) CGFloat safeAreaInsetsBottom;

@property (assign, nonatomic) GinPhotoSingleCaptureStatus status;
@property (strong, nonatomic) GinPhotoSingleCaptureViewModel *viewModel;

@property (strong, nonatomic) UILabel *photoIndexLable;
@property (strong, nonatomic) UILabel *photoTitleLable;

@property (strong, nonatomic) GinCapturePhotoLandspaceTipsView *landSpaceTipsView;

/**
 图片编辑
 */
@property (strong, nonatomic) UILabel *statusTitleLable;
@property (strong, nonatomic) UIButton *previousEditionActionBtn;
@property (strong, nonatomic) UIButton *nextEditionActionBtn;
@property (strong, nonatomic) UIButton *cancelEditActionBtn;
@property (strong, nonatomic) GinEditPhotoView *editView;

/**
 左侧控制区域
 */
@property (strong, nonatomic) UIView *leftControlView;
@property (strong, nonatomic) UIButton *flashBtn;
@property (strong, nonatomic) UIButton *backBtn;
@property (strong, nonatomic) UIButton *photoLibraryBtn;
@property (strong, nonatomic) UIButton *deletePhotoBtn;
@property (strong, nonatomic) GinVerticalLayoutButton *markBtn;
@property (strong, nonatomic) GinVerticalLayoutButton *mosaicsBtn;

/**
 取景区域
 */
@property (strong, nonatomic) UIView *cameraView;
@property (strong, nonatomic) UIImageView *focusCursorImageView;

@property (strong, nonatomic) UITapGestureRecognizer *cameraTapGR;
@property (copy, nonatomic) void(^cameraTapBlock) (CGPoint touchPoint, CGPoint focusPoint);

/**
 信息展示区域
 */
@property (strong, nonatomic) UIView *infoContentView;
@property (strong, nonatomic) UIImageView *capturedImageView;
@property (strong, nonatomic) GinTitleSwitch *switchView;

/**
 提示区域
 */
@property (strong, nonatomic) UIView *tipsContentView;
/**
 辅助线
 */
@property (strong, nonatomic) UIImageView *tipsLineImgV;

/**
 拍摄提示器
 */
@property (strong, nonatomic) GinCaptureHelpTipsView *helpTipsView;

/**
 右侧控制区域
 */
@property (strong, nonatomic) UIView *rightControlView;
@property (strong, nonatomic) UIButton *finishBtn;
@property (strong, nonatomic) UIButton *cameraBtn;
@property (strong, nonatomic) UIButton *retryBtn;
@property (strong, nonatomic) UIButton *nextBtn;

@property (copy, nonatomic) BOOL (^canDeletePhotoBlock)(void);

- (void)setFocusCursorWithPoint:(CGPoint)point;
- (void)setFlashModeUI:(AVCaptureFlashMode)flashMode;
- (void)setupPhotoTitle:(NSString *)title imgUrl:(NSString *)imgUrl rejectReason:(NSString *)rejectReason photoStatusType:(GinPhotoAuditStatusEnumType)photoStatusType;


@end
