//
//  GinMediaManager.h
//  GinCameraCaptureManager
//
//  Created by JunhuaShao on 2019/1/4.
//  Copyright © 2019 JunhuaShao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GinMediaManager : NSObject

+ (NSString *)getVideoFileName;
+ (BOOL)deleteVideoFile:(NSString *)filePath;
+ (NSString *)filePath:(NSString *)name;
+ (BOOL)createFolder;
+ (NSString *)createFilename;

@end
