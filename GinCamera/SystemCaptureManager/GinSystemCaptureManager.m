//
//  GinSystemCaptureManager.m
//  CommercialVehiclePlatform
//
//  Created by JunhuaShao on 2018/1/29.
//  Copyright © 2018年 JunhuaShao. All rights reserved.
//

#import <UIImage+GinUnit.h>
#import <UIAlertController+GinUnit.h>
#import <TOCropViewController.h>
#import "GinSystemCaptureManager.h"

@interface GinSystemCaptureManager() <UINavigationControllerDelegate, UIImagePickerControllerDelegate, TOCropViewControllerDelegate>

@property (weak, nonatomic) UIViewController *presentedViewController;
@property (strong, nonatomic) UIImagePickerController *picker;

@property (assign, nonatomic) BOOL imageEditable;

@end

@implementation GinSystemCaptureManager

+ (void)toSystemCapture:(UIViewController *)presentedViewController
   compressImageMaxSize:(CGSize)compressImageMaxSize
  didImageCapturedBlock:(void(^)(UIImage *image))didImageCapturedBlock
{
    [self toSystemCapture:presentedViewController
            imageEditable:YES
     imageEditAspectRatio:CGSizeZero
                 compress:YES
        compressImageMaxSize:compressImageMaxSize
       compressMaxQuality:0.3
      compressMaxDataSize:500
    didImageCapturedBlock:didImageCapturedBlock];
}

+ (void)toEditableSystemCapture:(UIViewController *)presentedViewController
           imageEditAspectRatio:(CGSize)imageEditAspectRatio
           compressImageMaxSize:(CGSize)compressImageMaxSize
          didImageCapturedBlock:(void(^)(UIImage *image))didImageCapturedBlock
{
    [self toSystemCapture:presentedViewController
            imageEditable:YES
     imageEditAspectRatio:imageEditAspectRatio
                 compress:YES
        compressImageMaxSize:compressImageMaxSize
       compressMaxQuality:0.3
      compressMaxDataSize:500
    didImageCapturedBlock:didImageCapturedBlock];
}

+ (void)toSystemCapture:(UIViewController *)presentedViewController
          imageEditable:(BOOL)imageEditable
   imageEditAspectRatio:(CGSize)imageEditAspectRatio
               compress:(BOOL)compress
   compressImageMaxSize:(CGSize)compressImageMaxSize
     compressMaxQuality:(CGFloat)compressMaxQuality
    compressMaxDataSize:(CGFloat)compressMaxDataSize
  didImageCapturedBlock:(void(^)(UIImage *image))didImageCapturedBlock
{
    GinSystemCaptureManager *manager = [GinSystemCaptureManager sharedInstance];
    manager.presentedViewController = presentedViewController;
    manager.didImageCapturedBlock = didImageCapturedBlock;

    manager.imageEditable = imageEditable;
    if (imageEditable) {
        manager.imageEditAspectRatio = imageEditAspectRatio;
    }
    
    manager.compress = compress;
    if (compress) {
        manager.compressImageMaxSize = compressImageMaxSize;
        manager.compressMaxQuality = compressMaxQuality;
        manager.compressMaxDataSize = compressMaxDataSize;
    }
    [manager chooseAction];
}

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static id sharedInstance = nil;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)chooseAction
{
    UIAlertController *sheet = [UIAlertController alertControllerWithTitle:nil message:nil  preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
    }];
    [sheet addAction:cancelAction];
    
    UIAlertAction *captureAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self takePhoto];
    }];
    [sheet addAction:captureAction];

    UIAlertAction *libraryAction = [UIAlertAction actionWithTitle:@"相册上传" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self localPhoto];

    }];
    
    [sheet addAction:libraryAction];
    
    [self.presentedViewController presentViewController:sheet animated:YES completion:nil];
}

// 开始拍照
- (void)takePhoto
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        if ([GinSystemCaptureManager checkVideoAuthorization]) {
            self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            self.picker.delegate = self;
            self.picker.allowsEditing = NO;
            [self.presentedViewController presentViewController:self.picker animated:YES completion:nil];
        } else {
            [UIAlertController alert:@"提示" message:@"请前往系统设置中开启相机功能" submitTitle:@"前往" submitBlock:^(UIAlertAction *action) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{UIApplicationOpenURLOptionUniversalLinksOnly : @NO} completionHandler:nil];
            } cancelTitle:@"取消" cancelBlock:nil completionBlock:nil];
        }
    }
}

// 打开本地相册
- (void)localPhoto
{
    self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.picker.delegate = self;
    //设置选择后的图片可被编辑
    self.picker.allowsEditing = NO;
    [self.presentedViewController presentViewController:self.picker animated:YES completion:nil];
}

#pragma mark- Delegate & DataSource

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *editedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    if(!editedImage) {
        editedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    UIImage *savedImage = editedImage;
    if (self.compress) {
        if (!CGSizeEqualToSize(self.compressImageMaxSize, CGSizeZero)) {
            CGSize scaleSize = CGSizeZero;
            if (savedImage.size.width > savedImage.size.height) {
                if (savedImage.size.width > self.compressImageMaxSize.width) {
                    scaleSize = CGSizeMake(self.compressImageMaxSize.width, self.compressImageMaxSize.width / savedImage.size.width * savedImage.size.height);
                }
            } else {
                if (savedImage.size.height > self.compressImageMaxSize.height) {
                    scaleSize = CGSizeMake(self.compressImageMaxSize.height / savedImage.size.height * savedImage.size.width, self.compressImageMaxSize.height);
                }
            }
            if (!CGSizeEqualToSize(scaleSize, CGSizeZero)) {
                savedImage = [savedImage scaleToSize:scaleSize];
            }
        }
        savedImage = [UIImage imageWithData:[editedImage compressToMaxDataSizeKBytes:self.compressMaxDataSize maxQuality:self.compressMaxQuality]];
    }
    
    if (self.imageEditable) {
        TOCropViewController *cropViewController = [[TOCropViewController alloc] initWithImage:savedImage];
        
        cropViewController.delegate = self;
        cropViewController.cropView.cropBoxResizeEnabled = NO;
        cropViewController.aspectRatioPickerButtonHidden = YES;
        cropViewController.aspectRatioPreset = TOCropViewControllerAspectRatioPresetCustom;
        cropViewController.customAspectRatio = self.imageEditAspectRatio;
        cropViewController.aspectRatioLockEnabled = YES;
        
        [picker presentViewController:cropViewController animated:YES completion:nil];
    } else {
        if (self.didImageCapturedBlock) {
            self.didImageCapturedBlock(savedImage);
        }
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark- TOCropViewController delegate
- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(nonnull UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle
{
    if (self.didImageCapturedBlock) {
        self.didImageCapturedBlock(image);
    }
    [cropViewController dismissViewControllerAnimated:YES completion:nil];
    [self.picker dismissViewControllerAnimated:NO completion:nil];
}

- (void)cropViewController:(TOCropViewController *)cropViewController didFinishCancelled:(BOOL)cancelled
{
    [cropViewController dismissViewControllerAnimated:YES completion:nil];
    [self.picker dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark- Getter & Setter

- (UIImagePickerController *)picker
{
    if (!_picker) {
        _picker = [[UIImagePickerController alloc] init];
    }
    return _picker;
}

@end
