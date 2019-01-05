//
//  GinPhotoCaptureView.m
//  JunhuaShao
//
//  Created by JunhuaShao on 2017/11/2.
//  Copyright © 2017年 JunhuaShao. All rights reserved.
//

#import <Masonry.h>
#import <UIImageView+WebCache.h>
#import <NSString+GinUnit.h>
#import <Gin_Macro.h>
#import <NSString+Size.h>
#import <UIColor+Hex.h>
#import <ReactiveObjC.h>

#import "GinPhotoCaptureView.h"

@interface GinPhotoCaptureView() <UIGestureRecognizerDelegate>

@property (strong, nonatomic) NSArray <UIView *> *readyStatusControls;
@property (strong, nonatomic) NSArray <UIView *> *capturedStatusControls;
@property (strong, nonatomic) NSArray <UIView *> *editStatusControls;

@end

@implementation GinPhotoCaptureView

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
    self.backgroundColor = [UIColor colorWithHex:0x343434];
    
    self.readyStatusControls = @[self.photoLibraryBtn,
                                 self.flashBtn,
                                 self.cameraBtn,
                                 self.backBtn,
                                 self.photoIndexLable,
                                 self.helpTipsView,
//                                 self.photoTitleLable
                                 ];
    
    self.capturedStatusControls = @[self.deletePhotoBtn,
                                    self.markBtn,
                                    self.mosaicsBtn,
                                    self.retryBtn,
                                    self.nextBtn,
                                    self.finishBtn,
                                    self.backBtn,
                                    self.photoIndexLable,
//                                    self.photoTitleLable,
                                    self.switchView,
                                    self.capturedImageView];
    self.editStatusControls = @[self.backBtn,
                                self.statusTitleLable,
                                self.finishBtn,
                                self.cancelEditActionBtn,
//                                self.imageEditActionBar,
                                self.nextEditionActionBtn,
                                self.previousEditionActionBtn,
                                self.editView];
    
    self.status = GinPhotoCaptureStatusReady;
    
    //取景区域
    [self addSubview:self.cameraView];
    [self.cameraView addSubview:self.focusCursorImageView];

    //提示区域
    [self addSubview:self.tipsContentView];
    //辅助线
    [self.tipsContentView addSubview:self.tipsLineImgV];
    [self.tipsContentView addSubview:self.helpTipsView];
    
    //信息展示区域
    [self addSubview:self.infoContentView];
    [self.infoContentView addSubview:self.capturedImageView];
    [self.infoContentView addSubview:self.switchView];
    
    //图片编辑区域
    [self addSubview:self.editView];
    
    //图片标示信息
    [self addSubview:self.photoIndexLable];
    [self addSubview:self.photoTitleLable];
    
//    [self addSubview:self.imageEditActionBar];
    
    //左侧控制区域
    [self addSubview:self.leftControlView];
    [self.leftControlView addSubview:self.flashBtn];
    //返回
    [self.leftControlView addSubview:self.statusTitleLable];

    [self.leftControlView addSubview:self.backBtn];
    [self.leftControlView addSubview:self.photoLibraryBtn];
    [self.leftControlView addSubview:self.deletePhotoBtn];
    
    [self.leftControlView addSubview:self.mosaicsBtn];
//    [self.leftControlView addSubview:self.markBtn];
    
    [self.leftControlView addSubview:self.previousEditionActionBtn];
    [self.leftControlView addSubview:self.nextEditionActionBtn];

    //右侧控制区域
    [self addSubview:self.rightControlView];
    //取消
    [self.rightControlView addSubview:self.retryBtn];
    //拍照
    [self.rightControlView addSubview:self.cameraBtn];
    //完成
    [self.rightControlView addSubview:self.nextBtn];
    [self.rightControlView addSubview:self.finishBtn];
    [self.rightControlView addSubview:self.cancelEditActionBtn];
    
    [self addSubview:self.landSpaceTipsView];
    
    [self setNeedsUpdateConstraints];
}

- (void)setViewModel:(GinPhotoCaptureViewModel *)viewModel
{
    _viewModel = viewModel;
    
    self.editView.viewModel = viewModel.editViewModel;

    __weak typeof(self) _WeakSelf = self;
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:kCEEditPhotoPreviousOrNextActionNotification object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * _Nullable x) {
        
        if (_WeakSelf.viewModel.editViewModel.actionList.count > 0) {
            [_WeakSelf.previousEditionActionBtn setImage:[UIImage imageNamed:@"edit_image_previous_selected"] forState:UIControlStateNormal];
        } else {
            [_WeakSelf.previousEditionActionBtn setImage:[UIImage imageNamed:@"edit_image_previous_unselected"] forState:UIControlStateNormal];
        }
        
        if (_WeakSelf.viewModel.editViewModel.removeActionList.count > 0) {
            [_WeakSelf.nextEditionActionBtn setImage:[UIImage imageNamed:@"edit_image_next_selected"] forState:UIControlStateNormal];
        } else {
            [_WeakSelf.nextEditionActionBtn setImage:[UIImage imageNamed:@"edit_image_next_unselected"] forState:UIControlStateNormal];
        }
    }];
}

- (void)updateConstraints
{
    [super updateConstraints];
    
    [self.landSpaceTipsView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.offset(0);
        make.size.sizeOffset(CGSizeMake(200, 200));
    }];
    
    //上部控制区域
    [self.leftControlView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        if (self.safeAreaInsetsTop > 0) {
            make.left.offset(self.safeAreaInsetsTop);
        } else {
            make.left.offset(0);
        }
        make.bottom.offset(0);
        make.width.offset(85);
    }];
    
    [self.backBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.right.offset(0);
        make.left.offset(0);
        make.height.offset(60);
    }];
    
    [self.flashBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(0);
        make.left.offset(0);
        make.right.offset(0);
        make.height.offset(60);
    }];
    
    [self.photoLibraryBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset(0);
        make.left.offset(0);
        make.right.offset(0);
        make.height.offset(40);
    }];
    
    [self.deletePhotoBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset(0);
        make.left.offset(0);
        make.right.offset(0);
        make.height.offset(40);
    }];
    
//    [self.markBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.offset(0);
//        make.left.offset(0);
//        make.right.offset(0);
//        make.height.offset(40);
//    }];
    
    [self.mosaicsBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(0);
        make.left.offset(0);
        make.right.offset(0);
        make.height.offset(60);
    }];
    
    //取景区域
    [self.cameraView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.offset(0);
        make.height.offset(SCREEN_WIDTH);
        make.width.offset(SCREEN_WIDTH*4/3);
    }];
    
    //提示区域
    [self.tipsContentView mas_remakeConstraints:^(MASConstraintMaker *make) {        
        make.edges.equalTo(self.cameraView);
    }];
    
    //辅助线
    [self.tipsLineImgV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.offset(0);
        make.height.equalTo(self.tipsContentView);
        make.width.equalTo(self.tipsContentView.mas_height).multipliedBy(500.f/375.f);
    }];
    
    [self.helpTipsView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(-10);
        make.left.offset(10);
        make.size.sizeOffset([GinCaptureHelpTipsView viewSize]);
    }];
    
    //信息区域
    [self.infoContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.cameraView);
    }];
    
    [self.capturedImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    
    [self.switchView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(10);
        make.right.offset(-10);
        make.size.sizeOffset(CGSizeMake(100, 40));
    }];
    
    [self.editView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.cameraView);
    }];
    
    [self.statusTitleLable mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset(0);
        make.left.offset(0);
        make.right.offset(0);
        make.height.offset(20);
    }];
    
//    [self.imageEditActionBar mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.offset(-20);
//        make.centerX.equalTo(self);
//        make.size.sizeOffset(CGSizeMake(100, 30));
//    }];
    
    [self.previousEditionActionBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.bottom.equalTo(self.nextEditionActionBtn.mas_top).offset(-15);
        make.size.sizeOffset(CGSizeMake(30, 30));
    }];
    
    [self.nextEditionActionBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.bottom.offset(-20);
        make.size.sizeOffset(CGSizeMake(30, 30));
    }];
    
    [self.cancelEditActionBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(0);
        make.left.offset(0);
        make.right.offset(0);
        make.height.offset(80);
    }];
    
    //右侧控制区域
    [self.rightControlView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        if (self.safeAreaInsetsBottom > 0) {
            make.right.offset(-self.safeAreaInsetsBottom);
        } else {
            make.right.offset(0);
        }
        make.bottom.offset(0);
        make.width.offset(80);
    }];
    
    [self.finishBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.right.offset(0);
        make.left.offset(0);
        make.height.offset(80);
    }];
    
    [self.nextBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset(0);
        make.left.offset(0);
        make.right.offset(0);
        make.height.offset(40);
    }];
    
    [self.retryBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(0);
        make.left.offset(0);
        make.right.offset(0);
        make.height.offset(80);
    }];
    
    [self.cameraBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.offset(0);
        make.size.sizeOffset(CGSizeMake(60, 60));
    }];
    
    //照片标识
    [self.photoIndexLable mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.cameraView);
        make.bottom.offset(-20);
        make.size.sizeOffset(CGSizeMake(100, 20));
    }];
    
}

- (void)setPhotoIndex:(NSUInteger)index count:(NSUInteger)count
{
    self.photoIndexLable.text = [NSString stringWithFormat:@"%@／%@", @(index+1), @(count)];
}


- (void)setupPhotoRejectReason:(NSString *)rejectReason photoStatusType:(GinPhotoAuditStatusEnumType)photoStatusType
{
    self.photoTitleLable.hidden = photoStatusType != GinPhotoAuditStatusEnumTypeRejected;
    
    CGSize size = [rejectReason getStringSizeWithFont:self.photoTitleLable.font height:20];
    
    [self.photoTitleLable mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.offset(20);
        make.size.sizeOffset(CGSizeMake(size.width + 8, 20));
    }];
    
    self.photoTitleLable.text = rejectReason;
}

- (void)setupPhotoTitle:(NSString *)title imgUrl:(NSString *)imgUrl
{
    self.helpTipsView.titleLabel.text = title;
    [self.helpTipsView.tipsImgV sd_setImageWithURL:[NSURL URLWithString:imgUrl]];
}

- (void)setStatus:(GinPhotoCaptureStatus)status
{
    _status = status;
    
    switch (status) {
        case GinPhotoCaptureStatusReady: {
            self.cameraView.alpha = 1;
            self.tipsContentView.alpha = 1;
            self.infoContentView.alpha = 0;

            [self.editStatusControls enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.hidden = YES;
            }];
            
            [self.capturedStatusControls enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.hidden = YES;
            }];
            
            [self.readyStatusControls enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                if (obj == self.helpTipsView &&
                    ![self.viewModel.currentPhotoIndex.viewUrl isNotBlank] &&
                    ![self.viewModel.currentPhotoIndex.sampleUrl isNotBlank]) {
                    obj.hidden = YES;
                } else {
                    obj.hidden = NO;
                }
            }];
            
        }
            break;
            
        case GinPhotoCaptureStatusCaptured: {
            self.cameraView.alpha = 0;
            self.infoContentView.alpha = 1;
            self.tipsContentView.alpha = 0;

            [self.editStatusControls enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.hidden = YES;
            }];
            
            [self.readyStatusControls enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.hidden = YES;
            }];
            
            [self.capturedStatusControls enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                GinCapturePhoto *photo = [self.viewModel getCurrentPhoto];
                if (obj == self.nextBtn && self.viewModel.nextType == GinPhotoQueueCaptureNextTypeNothing) {
                    obj.hidden = YES;
                } else if (obj == self.switchView && ![photo hasEditedPhoto]) {
                    obj.hidden = YES;
                } else if (obj == self.deletePhotoBtn) {
                    if (self.canDeletePhotoBlock) {
                        obj.hidden = !self.canDeletePhotoBlock();
                    } else {
                        obj.hidden = NO;
                    }
                } else {
                    obj.hidden = NO;
                }
            }];
            
            break;
        }
        case GinPhotoCaptureStatusMark: {
            self.statusTitleLable.text = @"标记中";
            
            [self.capturedStatusControls enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.hidden = YES;
            }];
            
            [self.readyStatusControls enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.hidden = YES;
            }];
            
            [self.editStatusControls enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.hidden = NO;
            }];
        }
            break;
            
        case GinPhotoCaptureStatusMosaics: {
            self.statusTitleLable.text = @"涂抹中";
            
            [self.capturedStatusControls enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.hidden = YES;
            }];
            
            [self.readyStatusControls enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.hidden = YES;
            }];
            
            [self.editStatusControls enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.hidden = NO;
            }];
            
        }
            break;
            
        default:
            break;
    }
}

- (void)setFlashModeUI:(AVCaptureFlashMode)flashMode
{
    switch (flashMode) {
        case AVCaptureFlashModeOn:
            [self.flashBtn setImage:[UIImage imageNamed:@"icon_flash_open"] forState:UIControlStateNormal];
            break;
        case AVCaptureFlashModeAuto:
            [self.flashBtn setImage:[UIImage imageNamed:@"icon_flash_auto"] forState:UIControlStateNormal];
            break;
        default:
            [self.flashBtn setImage:[UIImage imageNamed:@"icon_flash_close"] forState:UIControlStateNormal];
            break;
    }
}

/**
 *  设置聚焦光标位置
 *
 *  @param point 光标位置
 */
- (void)setFocusCursorWithPoint:(CGPoint)point
{
    self.focusCursorImageView.center = point;
    CABasicAnimation *scale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scale.fromValue = @1.5;
    scale.toValue = @1;
    scale.duration = 0.2;
    [self.focusCursorImageView.layer addAnimation:scale forKey:@"FocusScaleAnimationKey"];
    
    CABasicAnimation *opacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacity.fromValue = @1;
    opacity.toValue = @0;
    opacity.duration = 1;
    
    [self.focusCursorImageView.layer addAnimation:opacity forKey:@"FocusOpacityAnimationKey"];
}

#pragma mark- Delegate & DataSource

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    NSArray *dontReceiveList = @[self.helpTipsView];
    
    if ([dontReceiveList containsObject:touch.view]) {
        return NO;
    }
    return  YES;
}

#pragma mark- Getter & Setter

- (GinCapturePhotoLandspaceTipsView *)landSpaceTipsView
{
    if (!_landSpaceTipsView) {
        _landSpaceTipsView = [[GinCapturePhotoLandspaceTipsView alloc] init];
        _landSpaceTipsView.alpha = 0;
    }
    return _landSpaceTipsView;
}

- (UIView *)cameraView
{
    if (!_cameraView) {
        _cameraView = [[UIView alloc] init];
        _cameraView.backgroundColor = [UIColor colorWithHex:0x343434];
    }
    return _cameraView;
}

- (UITapGestureRecognizer *)cameraTapGR
{
    if (!_cameraTapGR) {
        _cameraTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cameraTapHandler:)];
        
        _cameraTapGR.delegate = self;
    }
    return _cameraTapGR;
}

- (void)cameraTapHandler:(UITapGestureRecognizer *)sender
{
    if (self.status != GinPhotoCaptureStatusReady) {
        return;
    }
    
    CGPoint point = [sender locationInView:self.cameraView];
    
    CGFloat width = self.cameraView.bounds.size.width;
    CGFloat height = self.cameraView.bounds.size.height;
    
    CGPoint cameraPoint = CGPointMake(point.x/width, point.y/height);
    
    // 设置聚焦点光标位置
    [self setFocusCursorWithPoint:point];
    
    if (self.cameraTapBlock) {
        self.cameraTapBlock(point,cameraPoint);
    }
}

- (UILabel *)photoIndexLable
{
    if (!_photoIndexLable) {
        _photoIndexLable = [[UILabel alloc] init];
        _photoIndexLable.textColor = [UIColor whiteColor];
        _photoIndexLable.textAlignment = NSTextAlignmentCenter;
        _photoIndexLable.font = [UIFont systemFontOfSize:14];
    }
    return _photoIndexLable;
}

- (UILabel *)photoTitleLable
{
    if (!_photoTitleLable) {
        _photoTitleLable = [[UILabel alloc] init];
        _photoTitleLable.textColor = [UIColor whiteColor];
        _photoTitleLable.layer.cornerRadius = 4.f;
        _photoTitleLable.layer.masksToBounds = YES;
        _photoTitleLable.backgroundColor = [UIColor blackColorWithAlpha:0.5];
        _photoTitleLable.textAlignment = NSTextAlignmentCenter;
    }
    return _photoTitleLable;
}

- (UIView *)tipsContentView
{
    if (!_tipsContentView) {
        _tipsContentView = [[UIView alloc] init];
        _tipsContentView.backgroundColor = [UIColor clearColor];
        [_tipsContentView addGestureRecognizer:self.cameraTapGR];
        
    }
    return _tipsContentView;
}

- (UIImageView *)tipsLineImgV
{
    if (!_tipsLineImgV) {
        _tipsLineImgV = [[UIImageView alloc] init];
    }
    return _tipsLineImgV;
}

- (UIButton *)backBtn
{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateNormal];
    }
    return _backBtn;
}

- (UIButton *)flashBtn
{
    if (!_flashBtn) {
        _flashBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_flashBtn setImage:[UIImage imageNamed:@"icon_flash_close"] forState:UIControlStateNormal];
    }
    return _flashBtn;
}

- (GinVerticalLayoutButton *)markBtn
{
    if (!_markBtn) {
        _markBtn = [[GinVerticalLayoutButton alloc] init];
        [_markBtn setTitle:@"标记" forState:UIControlStateNormal];
        [_markBtn setImage:[UIImage imageNamed:@"mark_photo_edit"] forState:UIControlStateNormal];
    }
    return _markBtn;
}

- (GinVerticalLayoutButton *)mosaicsBtn
{
    if (!_mosaicsBtn) {
        _mosaicsBtn = [[GinVerticalLayoutButton alloc] init];
        [_mosaicsBtn setTitle:@"涂抹" forState:UIControlStateNormal];
        [_mosaicsBtn setImage:[UIImage imageNamed:@"mosaics_photo_edit"] forState:UIControlStateNormal];
    }
    return _mosaicsBtn;
}

- (UIView *)leftControlView
{
    if (!_leftControlView) {
        _leftControlView = [[UIView alloc] init];
        _leftControlView.backgroundColor = [UIColor colorWithHex:0x343434];
    }
    return _leftControlView;
}

- (UIView *)rightControlView
{
    if (!_rightControlView) {
        _rightControlView = [[UIView alloc] init];
        _rightControlView.backgroundColor = [UIColor colorWithHex:0x343434];
    }
    return _rightControlView;
}

- (UIButton *)retryBtn
{
    if (!_retryBtn) {
        _retryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_retryBtn setTitle:@"重拍" forState:UIControlStateNormal];
    }
    return _retryBtn;
}

- (UIButton *)finishBtn
{
    if (!_finishBtn) {
        _finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_finishBtn setTitle:@"完成" forState:UIControlStateNormal];
    }
    return _finishBtn;
}

- (UIButton *)deletePhotoBtn
{
    if (!_deletePhotoBtn) {
        _deletePhotoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deletePhotoBtn setTitle:@"删除" forState:UIControlStateNormal];
    }
    return _deletePhotoBtn;
}

- (UIButton *)cameraBtn
{
    if (!_cameraBtn) {
        _cameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cameraBtn.showsTouchWhenHighlighted = YES;
        _cameraBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_cameraBtn setImage:[UIImage imageNamed:@"icon_shutter_active"] forState:UIControlStateNormal];
    }
    return _cameraBtn;
}

- (UIButton *)nextBtn
{
    if (!_nextBtn) {
        _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nextBtn setTitle:@"下一张" forState:UIControlStateNormal];
    }
    return _nextBtn;
}

- (UIImageView *)capturedImageView
{
    if (!_capturedImageView) {
        _capturedImageView = [[UIImageView alloc] init];
        _capturedImageView.contentMode = UIViewContentModeScaleAspectFit;
        _capturedImageView.backgroundColor = [UIColor colorWithHex:0x343434];
    }
    return _capturedImageView;
}

- (GinTitleSwitch *)switchView
{
    if (!_switchView) {
        _switchView = [[GinTitleSwitch alloc] init];
        _switchView.titleLabel.text = @"原图";
    }
    return _switchView;
}

- (UIImageView *)focusCursorImageView
{
    if (!_focusCursorImageView) {
        _focusCursorImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"focus_iccon"]];
        _focusCursorImageView.alpha = 0;
    }
    return _focusCursorImageView;
}

- (UIView *)infoContentView
{
    if (!_infoContentView) {
        _infoContentView = [[UIView alloc] init];
        _infoContentView.backgroundColor = [UIColor colorWithHex:0x343434];
    }
    return _infoContentView;
}

- (UIButton *)photoLibraryBtn
{
    if (!_photoLibraryBtn) {
        _photoLibraryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _photoLibraryBtn.backgroundColor = [UIColor clearColor];
        [_photoLibraryBtn setImage:[UIImage imageNamed:@"icon_photo_album"] forState:UIControlStateNormal];
    }
    return _photoLibraryBtn;
}

- (UILabel *)statusTitleLable
{
    if (!_statusTitleLable) {
        _statusTitleLable = [[UILabel alloc] init];
        _statusTitleLable.textColor = [UIColor whiteColor];
        _statusTitleLable.layer.cornerRadius = 4.f;
        _statusTitleLable.layer.masksToBounds = YES;
//        _statusTitleLable.backgroundColor = [UIColor blackColorWithAlpha:0.5];
        _statusTitleLable.textAlignment = NSTextAlignmentCenter;
    }
    return _statusTitleLable;
}

//- (UIView *)imageEditActionBar
//{
//    if (!_imageEditActionBar) {
//        _imageEditActionBar = [[UIView alloc] init];
//        _imageEditActionBar.layer.cornerRadius = 4.f;
//        _imageEditActionBar.layer.masksToBounds = YES;
//        _imageEditActionBar.backgroundColor = [UIColor blackColorWithAlpha:0.5];
//        
//    }
//    return _imageEditActionBar;
//}

- (UIButton *)nextEditionActionBtn
{
    if (!_nextEditionActionBtn) {
        _nextEditionActionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nextEditionActionBtn setImage:[UIImage imageNamed:@"edit_image_next_unselected"] forState:UIControlStateNormal];
    }
    return _nextEditionActionBtn;
}

- (UIButton *)previousEditionActionBtn
{
    if (!_previousEditionActionBtn) {
        _previousEditionActionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_previousEditionActionBtn setImage:[UIImage imageNamed:@"edit_image_previous_unselected"] forState:UIControlStateNormal];
    }
    return _previousEditionActionBtn;
}

- (UIButton *)cancelEditActionBtn
{
    if (!_cancelEditActionBtn) {
        _cancelEditActionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelEditActionBtn setTitle:@"取消" forState:UIControlStateNormal];
    }
    return _cancelEditActionBtn;
}

- (GinEditPhotoView *)editView
{
    if (!_editView) {
        _editView = [[GinEditPhotoView alloc] init];
    }
    return _editView;
}

- (GinCaptureHelpTipsView *)helpTipsView
{
    if (!_helpTipsView) {
        _helpTipsView = [[GinCaptureHelpTipsView alloc] init];
    }
    return _helpTipsView;
}

@end
