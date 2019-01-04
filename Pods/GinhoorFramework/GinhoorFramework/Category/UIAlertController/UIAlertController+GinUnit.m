//
//  UIAlertController+GinUnit.m
//  FrameworkDemo
//
//  Created by JunhuaShao on 2017/2/6.
//  Copyright © 2017年 JunhuaShao. All rights reserved.
//

#import "UIAlertController+GinUnit.h"
#import "UIViewController+GinBaseClass.h"

@implementation UIAlertController (GinUnit)

+ (void)alert:(NSString *)title
      message:(NSString *)message
  cancelTitle:(NSString *)cancelTitle
  cancelBlock:(void (^)(UIAlertAction *action))cancelBlock
completionBlock:(void(^)(void))completionBlock
{
    [self alertOnWindow:[UIApplication sharedApplication].windows.firstObject title:title message:message cancelTitle:cancelTitle cancleBtnStyle:UIAlertActionStyleCancel cancelBlock:cancelBlock completionBlock:completionBlock];
}

+ (void)alert:(NSString *)title
      message:(NSString *)message
  submitTitle:(NSString *)submitTitle
  submitBlock:(void (^)(UIAlertAction *action))submitBlock
  cancelTitle:(NSString *)cancelTitle
  cancelBlock:(void (^)(UIAlertAction *action))cancelBlock
completionBlock:(void(^)(void))completionBlock
{
    [self alertOnWindow:[UIApplication sharedApplication].windows.firstObject title:title message:message submitTitle:submitTitle submitBtnStyle:UIAlertActionStyleDefault submitBlock:submitBlock cancelTitle:cancelTitle cancleBtnStyle:UIAlertActionStyleCancel cancelBlock:cancelBlock completionBlock:completionBlock];
}

+ (void)alertOnWindow:(UIWindow *)window
                title:(NSString *)title
              message:(NSString *)message
          cancelTitle:(NSString *)cancelTitle
       cancleBtnStyle:(UIAlertActionStyle)cancelBtnStyle
          cancelBlock:(void (^)(UIAlertAction *action))cancelBlock
      completionBlock:(void(^)(void))completionBlock
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:cancelTitle style:cancelBtnStyle handler:cancelBlock];
    
    [alertController addAction:cancel];
    
    UIViewController *presentedViewController;
    if (window) {
        presentedViewController = [UIViewController lastPresentedViewControllerByWindow:window];
    } else {
        presentedViewController = [UIViewController lastPresentedViewController];
    }
    
    [presentedViewController presentViewController:alertController animated:YES completion:completionBlock];
}

+ (void)alertOnWindow:(UIWindow *)window
                title:(NSString *)title
              message:(NSString *)message
          submitTitle:(NSString *)submitTitle
       submitBtnStyle:(UIAlertActionStyle)submitBtnStyle
          submitBlock:(void (^)(UIAlertAction *action))submitBlock
          cancelTitle:(NSString *)cancelTitle
       cancleBtnStyle:(UIAlertActionStyle)cancelBtnStyle
          cancelBlock:(void (^)(UIAlertAction *action))cancelBlock
      completionBlock:(void(^)(void))completionBlock
{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:cancelTitle style:cancelBtnStyle handler:cancelBlock];
    
    UIAlertAction *submit = [UIAlertAction actionWithTitle:submitTitle style:submitBtnStyle handler:submitBlock];
    
    [alertController addAction:cancel];
    [alertController addAction:submit];
    
    UIViewController *presentedViewController;
    if (window) {
        presentedViewController = [UIViewController lastPresentedViewControllerByWindow:window];
    } else {
        presentedViewController = [UIViewController lastPresentedViewController];
    }

    dispatch_async(dispatch_get_main_queue(),^{
        [presentedViewController presentViewController:alertController animated:YES completion:completionBlock];
    });
}

- (BOOL)shouldAutorotate
{
    return NO;
}

@end
