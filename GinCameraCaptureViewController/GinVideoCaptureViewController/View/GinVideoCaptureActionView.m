//
//  GinVideoCaptureActionView.m
//  demo4CaptureVideo
//
//  Created by JunhuaShao on 2018/2/23.
//  Copyright © 2018年 JunhuaShao. All rights reserved.
//

#import <Masonry.h>
#import "GinVideoCaptureActionView.h"

@implementation GinVideoCaptureActionView

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
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.videoProgressView];
    
    [self addSubview:self.videoDurationView];
    [self.videoDurationView addSubview:self.durationDotView];
    [self.videoDurationView addSubview:self.durationLabel];
    
    [self addSubview:self.doneBtn];
    [self addSubview:self.undoBtn];
    [self addSubview:self.captureBtn];
    [self addSubview:self.deleteBtn];
    
    self.status = CEVehicleVideoCaptureStatusReady;
}

- (void)updateConstraints
{
    [super updateConstraints];
    
    [self.videoProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.offset(0);
        make.right.offset(0);
        make.height.offset([GinVideoCaptureProgressView viewHeight]);
    }];
    
    [self.captureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.offset(0);
        make.size.sizeOffset(CGSizeMake(72, 72));
    }];
    
    [self.undoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(40);
        make.centerY.equalTo(self.captureBtn);
        make.size.sizeOffset(CGSizeMake(48, 48));
    }];
    
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.undoBtn);
    }];
    
    [self.doneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-40);
        make.centerY.equalTo(self.captureBtn);
        make.size.sizeOffset(CGSizeMake(48, 48));
    }];
    
    [self.videoDurationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.captureBtn);
        make.top.equalTo(self.videoProgressView.mas_bottom).offset(10);
        make.size.sizeOffset(CGSizeMake(4+8+40, 20));
    }];
    
    [self.durationDotView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset(0);
        make.left.offset(0);
        make.size.sizeOffset(CGSizeMake(4, 4));
    }];
    
    [self.durationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset(0);
        make.left.equalTo(self.durationDotView).offset(8);
        make.size.sizeOffset(CGSizeMake(40, 20));
    }];
}

#pragma mark- Getter & Setter

- (void)setStatus:(CEVehicleVideoCaptureStatus)status
{
    _status = status;
    
    switch (status) {
        case CEVehicleVideoCaptureStatusReady: {
            self.videoDurationView.hidden = YES;
            self.doneBtn.hidden = YES;
            self.undoBtn.hidden = YES;
            self.deleteBtn.hidden = YES;
            
            self.captureBtn.enabled = YES;
            [self.videoProgressView flashDotView:YES];
            [self.videoProgressView unSelectedProgress];
        }
            break;
        
        case CEVehicleVideoCaptureStatusCapturing: {
            self.videoDurationView.hidden = NO;
            
            [self startDurationLabelAnimation];
            
            self.doneBtn.hidden = YES;
            self.undoBtn.hidden = YES;
            self.deleteBtn.hidden = YES;
            [self.videoProgressView flashDotView:NO];
            [self.videoProgressView unSelectedProgress];

        }
            break;
            
        case CEVehicleVideoCaptureStatusCaptured: {
            self.videoDurationView.hidden = YES;
            
            [self stopDurationLabelAnimation];

            self.doneBtn.hidden = NO;
            self.undoBtn.hidden = NO;
            self.deleteBtn.hidden = YES;

            self.captureBtn.enabled = YES;
            [self.videoProgressView flashDotView:YES];
            [self.videoProgressView unSelectedProgress];

        }
            break;
            
        case CEVehicleVideoCaptureStatusUndo: {
            self.videoDurationView.hidden = YES;
            self.doneBtn.hidden = NO;
            self.undoBtn.hidden = YES;
            self.deleteBtn.hidden = NO;
            [self.videoProgressView flashDotView:NO];
        }
            break;

        case CEVehicleVideoCaptureStatusFinished: {
            self.videoDurationView.hidden = YES;
            
            [self stopDurationLabelAnimation];

            self.captureBtn.enabled = NO;
            self.doneBtn.hidden = NO;
            self.undoBtn.hidden = NO;
            self.deleteBtn.hidden = YES;
            [self.videoProgressView flashDotView:NO];
            [self.videoProgressView unSelectedProgress];

        }
            break;

        default:
            break;
    }
    
}

- (void)updateDurationLabel:(NSTimeInterval)duration
{
    if (duration < 10) {
        self.durationLabel.text = [NSString stringWithFormat:@"00:0%ld",(long)duration];
    } else if (duration < 60) {
        self.durationLabel.text = [NSString stringWithFormat:@"00:%ld",(long)duration];
    } else {
        self.durationLabel.text = @"01:00";
    }
}

- (void)startDurationLabelAnimation
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = @1;
    animation.toValue = @0;
    animation.duration = 1;
    animation.repeatCount = CGFLOAT_MAX;
    animation.autoreverses = YES;
    
    [self.durationDotView.layer addAnimation:animation forKey:@"durationLabelAnimation"];
}

- (void)stopDurationLabelAnimation
{
    [self.durationDotView.layer removeAnimationForKey:@"durationLabelAnimation"];
}

- (GinVideoCaptureProgressView *)videoProgressView
{
    if (!_videoProgressView) {
        _videoProgressView = [[GinVideoCaptureProgressView alloc] init];
    }
    return _videoProgressView;
}

- (UIView *)videoDurationView
{
    if (!_videoDurationView) {
        _videoDurationView = [[UIView alloc] init];
    }
    return _videoDurationView;
}

- (UIView *)durationDotView
{
    if (!_durationDotView) {
        _durationDotView = [[UIView alloc] init];
        _durationDotView.backgroundColor = [UIColor orangeColor];
        _durationDotView.layer.cornerRadius = 2;
        _durationDotView.layer.masksToBounds = YES;
    }
    return _durationDotView;
}

- (UILabel *)durationLabel
{
    if (!_durationLabel) {
        _durationLabel = [[UILabel alloc] init];
        _durationLabel.font = [UIFont systemFontOfSize:14];
        _durationLabel.textColor = [UIColor darkGrayColor];
    }
    return _durationLabel;
}

- (UIButton *)undoBtn
{
    if (!_undoBtn) {
        _undoBtn = [[UIButton alloc] init];
        [_undoBtn setImage:[UIImage imageNamed:@"undo_btn"] forState:UIControlStateNormal];
    }
    return _undoBtn;
}

- (UIButton *)captureBtn
{
    if (!_captureBtn) {
        _captureBtn = [[UIButton alloc] init];

        [_captureBtn setImage:[UIImage imageNamed:@"capture_btn_normal"] forState:UIControlStateNormal];
        [_captureBtn setImage:[UIImage imageNamed:@"capture_btn_capturing"] forState:UIControlStateHighlighted];
        [_captureBtn setImage:[UIImage imageNamed:@"capture_btn_disable"] forState:UIControlStateDisabled];
    }
    
    return _captureBtn;
}

- (UIButton *)doneBtn
{
    if (!_doneBtn) {
        _doneBtn = [[UIButton alloc] init];
        [_doneBtn setImage:[UIImage imageNamed:@"done_btn"] forState:UIControlStateNormal];
    }
    return _doneBtn;
}

- (UIButton *)deleteBtn
{
    if (!_deleteBtn) {
        _deleteBtn = [[UIButton alloc] init];
        [_deleteBtn setImage:[UIImage imageNamed:@"delete_btn"] forState:UIControlStateNormal];
    }
    return _deleteBtn;
}


@end
