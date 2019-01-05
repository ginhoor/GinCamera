//
//  GinEditPhotoView.m
//  JunhuashaoInspector
//
//  Created by JunhuaShao on 2017/8/18.
//  Copyright © 2017年 Junhuashao. All rights reserved.
//

#import <Masonry.h>
#import <BlocksKit.h>
#import <ReactiveObjC/ReactiveObjC.h>

#import "GinEditPhotoView.h"
#import "GinEditPhotoMarkView.h"

@interface GinEditPhotoView()
@property (strong, nonatomic) UITapGestureRecognizer *tapRecognizer;
@property (strong, nonatomic) NSMutableArray<GinEditPhotoMarkView *> *markViewList;
@end

@implementation GinEditPhotoView

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
    [self addSubview:self.photoImgV];
    [self addSubview:self.canvasView];
    
    [self addGestureRecognizer:self.tapRecognizer];
    
    __weak typeof(self) _WeakSelf = self;
    
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:kCEEditPhotoPreviousOrNextActionNotification object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * _Nullable x) {
        [_WeakSelf updateCanvas];
    }];
    
    self.markViewList = [NSMutableArray array];
}

- (void)updateConstraints
{
    [super updateConstraints];

    [self.photoImgV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    
    [self.canvasView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
}

- (void)updateCanvas
{
    [self.canvasView setNeedsDisplay];
    
    NSArray<GinEditPhotoMarkAction *> *markActionList = [self.viewModel.actionList bk_select:^BOOL(GinEditPhotoAction *action) {
        return action.actionType == GinEditPhotoActionTypeMark;
    }];
    
    [self.markViewList enumerateObjectsUsingBlock:^(GinEditPhotoMarkView * _Nonnull view, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (![markActionList containsObject:view.markAction]) {
            [view removeFromSuperview];
            [self.markViewList removeObject:view];
        }
    }];
    
    [markActionList enumerateObjectsUsingBlock:^(GinEditPhotoMarkAction * _Nonnull action, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!action.markView) {
            [self createMarkView:action.center transform:action.transform action:action];
        }
    }];
}

- (void)setViewModel:(GinEditPhotoViewModel *)viewModel
{
    _viewModel = viewModel;
    self.canvasView.viewModel = _viewModel;
    
    __weak typeof(self) _WeakSelf = self;
    [RACObserve(self.viewModel, photoImage) subscribeNext:^(UIImage *image) {
        _WeakSelf.photoImgV.image = image;
    }];
}

- (UITapGestureRecognizer *)tapRecognizer
{
    if (!_tapRecognizer) {
        _tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    }
    return _tapRecognizer;
}

- (void)tapAction:(UITapGestureRecognizer *)recognizer
{
    if (self.viewModel.currentActionType == GinEditPhotoActionTypeMark) {
        
        CGPoint point = [recognizer locationInView:recognizer.view];
        GinEditPhotoMarkAction *action = [GinEditPhotoMarkAction action];
        [action setMarkCenter:point];
        [self createMarkView:point transform:CGAffineTransformIdentity action:action];
        [self.viewModel addAction:action];
    }
}

- (void)createMarkView:(CGPoint)center transform:(CGAffineTransform)transfrom action:(GinEditPhotoMarkAction *)action
{
    GinEditPhotoMarkView *markView = [[GinEditPhotoMarkView alloc] initWithFrame:CGRectMake(0,0, 100, 100)];
    markView.center = center;
    
    markView.transform = transfrom;
    markView.markAction = action;
    
    action.markView = markView;
    
    [self addSubview:markView];
    
    [self.markViewList addObject:markView];
}

- (UIImageView *)photoImgV
{
    if (!_photoImgV) {
        _photoImgV = [[UIImageView alloc] init];
        _photoImgV.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _photoImgV;
}

- (GinEditPhotoCanvasView *)canvasView
{
    if (!_canvasView) {
        _canvasView = [[GinEditPhotoCanvasView alloc] init];
        _canvasView.backgroundColor = [UIColor clearColor];
    }
    return _canvasView;
}

@end
