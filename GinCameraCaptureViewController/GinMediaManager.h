//
//  GinMediaManager.h
//  GinCameraCaptureManager
//
//  Created by JunhuaShao on 2019/1/4.
//  Copyright © 2019 JunhuaShao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, GinMediaEditType) {
    GinMediaEditTypeCreate,
    GinMediaEditTypeEdited,
    GinMediaEditTypeDelete,
};

@interface GinMediaManager : NSObject

+ (NSString *)getVideoFileName;
+ (BOOL)deleteVideoFile:(NSString *)filePath;

+ (NSDictionary *)saveImage:(UIImage *)image;
+ (UIImage *)getImageByName:(NSString *)name;
+ (BOOL)deleteImageByName:(NSString *)name;


+ (NSString *)filePath:(NSString *)name;

+ (BOOL)createFolder;
+ (NSString *)createFilename;

@end
