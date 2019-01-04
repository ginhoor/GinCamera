//
//  NSObject_Gin_Prefix.h
//  LOLBook
//
//  Created by Ginhoor on 13-5-25.
//  Copyright (c) 2013年 ginhoor_home. All rights reserved.
//



///////////////////////////////////////////
// Device & OS
//////////////////////////////////////////
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)

#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define SCREEN_SCALE [UIScreen mainScreen].scale

#define ONE_PHYSICAL_PX 1.f/[UIScreen mainScreen].scale

#define CurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])
#define isRetina ([UIScreen mainScreen].scale > 1.0f)

#define iPhone6P ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

#define isPad     ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
#define isPhone   ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)

//tmp 目录
#define TMP_PATH [NSHomeDirectory() stringByAppendingPathComponent:@"tmp"]

///////////////////////////////////////////
// G C D
//////////////////////////////////////////

#define DO_IN_BACKGROUND(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)

#define DO_IN_MAIN(block) dispatch_async(dispatch_get_main_queue(),block)

#define DO_AFTER(delayInSeconds,block) dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), block);

///////////////////////////////////////////
// Object
//////////////////////////////////////////

//user defaults
#define USER_DEFAULTS ([NSUserDefaults standardUserDefaults])
//file manager
#define FILE_MANAGER ([NSFileManager defaultManager])
//notification center
#define NOTIFICATION_CENTER ([NSNotificationCenter defaultCenter])

///////////////////////////////////////////
// Category
///////////////////////////////////////////

#define PointValue(x,y) [NSValue valueWithCGPoint:CGPointMake(x, y)]
#define raiseException(name,message) [NSException raise:name format:message];
#define radom(from,to) (int)(from + (arc4random() % (to - from + 1)))

///////////////////////////////////////////
// degrees/radian
///////////////////////////////////////////

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)
#define RADIAN_TO_DEGREES(radian) (radian*180.0)/(M_PI)
