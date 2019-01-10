//
//  Created by Ginhoor on 13-11-29.
//  Copyright (c) 2013年 Ginhoor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface GinQRCodePickerBaseController : UIViewController

@property (copy, nonatomic) void(^resultDidReceivedBlock)(NSString *resultString);

@end
