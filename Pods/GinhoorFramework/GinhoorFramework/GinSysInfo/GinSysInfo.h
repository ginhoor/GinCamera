//
//  GinSysInfo.h
//  demo4UserSpace
//
//  Created by Ginhoor on 14-8-20.
//  Copyright (c) 2014年 Ginhoor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface GinSysInfo : NSObject

+ (NSString *)iOSSystemVersion;
+ (NSString *)appVersion;
+ (NSString *)appBundleName;
+ (NSString *)buildVersion;
+ (NSString *)bundleSeedID;

+ (BOOL)isJailbrokenUser;
+ (BOOL)isPiratedUser;

+ (BOOL)iOSVersion:(CGFloat)version;
+ (BOOL)laterThanVersion:(CGFloat)version;

@end
