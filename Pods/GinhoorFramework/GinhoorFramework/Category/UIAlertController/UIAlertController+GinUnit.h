//
//  UIAlertController+GinUnit.h
//  FrameworkDemo
//
//  Created by JunhuaShao on 2017/2/6.
//  Copyright © 2017年 JunhuaShao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertController (GinUnit)

+ (void)alert:(NSString *)title
      message:(NSString *)message
  cancelTitle:(NSString *)cancelTitle
  cancelBlock:(void (^)(UIAlertAction *action))cancelBlock
completionBlock:(void(^)(void))completionBlock;

+ (void)alert:(NSString *)title
      message:(NSString *)message
  submitTitle:(NSString *)submitTitle
  submitBlock:(void (^)(UIAlertAction *action))submitBlock
  cancelTitle:(NSString *)cancelTitle
  cancelBlock:(void (^)(UIAlertAction *action))cancelBlock
completionBlock:(void(^)(void))completionBlock;

+ (void)alertOnWindow:(UIWindow *)window
                title:(NSString *)title
              message:(NSString *)message
          cancelTitle:(NSString *)cancelTitle
       cancleBtnStyle:(UIAlertActionStyle)cancelBtnStyle
          cancelBlock:(void (^)(UIAlertAction *action))cancelBlock
      completionBlock:(void(^)(void))completionBlock;

+ (void)alertOnWindow:(UIWindow *)window
                title:(NSString *)title
              message:(NSString *)message
          submitTitle:(NSString *)submitTitle
       submitBtnStyle:(UIAlertActionStyle)submitBtnStyle
          submitBlock:(void (^)(UIAlertAction *action))submitBlock
          cancelTitle:(NSString *)cancelTitle
       cancleBtnStyle:(UIAlertActionStyle)cancelBtnStyle
          cancelBlock:(void (^)(UIAlertAction *action))cancelBlock
      completionBlock:(void(^)(void))completionBlock;

@end

