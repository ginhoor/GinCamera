//
//  GinScanQRCoderController.h
//  LOLBox
//
//  Created by JunhuaShao on 15/4/2.
//  Copyright (c) 2015年 Ginhoor. All rights reserved.
//

#import "GinQRCodePickerBaseController.h"

@interface GinScanQRCoderController : GinQRCodePickerBaseController

@property (copy, nonatomic) void(^didDismissBlock)(void);

+ (void)startScanQRCorder:(UIViewController *)controller receivedBlock:(void(^)(NSString * resultString))resultDidReceivedBlock dismissBlock:(void(^)(void))dismissBlock;

@end
