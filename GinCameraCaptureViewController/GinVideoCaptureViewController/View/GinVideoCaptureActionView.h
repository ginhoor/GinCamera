//
//  GinVideoCaptureActionView.h
//  demo4CaptureVideo
//
//  Created by JunhuaShao on 2018/2/23.
//  Copyright © 2018年 JunhuaShao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GinVideoCaptureProgressView.h"

typedef NS_ENUM(NSUInteger, CEVehicleVideoCaptureStatus) {
    CEVehicleVideoCaptureStatusReady,
    CEVehicleVideoCaptureStatusCapturing,
    CEVehicleVideoCaptureStatusCaptured,
    CEVehicleVideoCaptureStatusUndo,
    CEVehicleVideoCaptureStatusFinished,
};

@interface GinVideoCaptureActionView : UIView

@property (assign, nonatomic) CEVehicleVideoCaptureStatus status;

@property (strong, nonatomic) GinVideoCaptureProgressView *videoProgressView;

@property (strong, nonatomic) UIView *videoDurationView;
@property (strong, nonatomic) UIView *durationDotView;
@property (strong, nonatomic) UILabel *durationLabel;

@property (strong, nonatomic) UIButton *undoBtn;
@property (strong, nonatomic) UIButton *deleteBtn;
@property (strong, nonatomic) UIButton *captureBtn;
@property (strong, nonatomic) UIButton *doneBtn;

- (void)updateDurationLabel:(NSTimeInterval)duration;

@end
