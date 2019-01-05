//
//  GinMediaManager.m
//  GinCameraCaptureManager
//
//  Created by JunhuaShao on 2019/1/4.
//  Copyright © 2019 JunhuaShao. All rights reserved.
//

#import <NSString+GinUnit.h>
#import "GinMediaManager.h"

@implementation GinMediaManager

+ (NSString *)getVideoFileName
{
    [self createFolder];
    
    NSString *name = [self createFilename];
    
    return [NSString stringWithFormat:@"/%@.mp4",name];
}

+ (BOOL)deleteVideoFile:(NSString *)filePath
{
    if (![filePath isNotBlank]) {
        return NO;
    }
    BOOL flag = NO;
    NSError *__autoreleasing error = nil;
    
    NSFileManager *manager = [NSFileManager defaultManager];
    flag = [manager removeItemAtPath:filePath error:&error];
    
    if (flag == NO && error) {
        NSLog(@"file delete failed!!! error --> %@",error);
    } else {
        NSLog(@"file in path:%@ deleted!",filePath);
    }
    return flag;
}

+ (NSDictionary *)saveImage:(UIImage *)image
{
    NSString *name = [self createFilename];
    BOOL flag = [self writeToFile:image path:[self filePath:name]];
    
    return @{@"name":name, @"success":@(flag)};
}

+ (UIImage *)getImageByName:(NSString *)name
{
    if (!name.isNotBlank) {
        return nil;
    }
    UIImage *image = [UIImage imageWithContentsOfFile:[self filePath:name]];
    return image;
}

+ (BOOL)deleteImageByName:(NSString *)name
{
    if (![name isNotBlank]) {
        return NO;
    }
    BOOL flag = NO;
    NSError *__autoreleasing error = nil;
    
    NSFileManager *manager = [NSFileManager defaultManager];
    flag = [manager removeItemAtPath:[self filePath:name] error:&error];
    
    if (flag == NO && error) {
        NSLog(@"file delete failed!!! error --> %@",error);
    } else {
        NSLog(@"file in path:%@ deleted!",name);
    }
    return flag;
}

+ (NSString *)filePath:(NSString *)name
{
    NSString *tempPath;
    if (name) {
        tempPath = [NSString stringWithFormat:@"GinCache/%@",name];
    } else {
        tempPath = @"GinCache";
    }
    
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [rootPath stringByAppendingPathComponent:tempPath];
    return filePath;
}

+ (BOOL)createFolder
{
    NSFileManager *manager = [NSFileManager defaultManager];
    
    BOOL flag = [manager fileExistsAtPath:[self filePath:nil] isDirectory:nil];
    
    if (!flag) {
        NSError *__autoreleasing error = nil;
        [manager createDirectoryAtPath:[self filePath:nil] withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            NSLog(@"error--->%@",error);
        }
    }
    
    return flag;
}

+ (NSString *)createFilename
{
    return [[NSUUID UUID] UUIDString];
}

#pragma - Private Method
+ (BOOL)writeToFile:(UIImage *)image path:(NSString *)path
{
    BOOL flag = NO;
    [self createFolder];
    NSData *data = UIImageJPEGRepresentation(image, 0.3);
    flag = [data writeToFile:path atomically:YES];
    
    if (flag) {
        NSLog(@"file save in path:%@",path);
    } else {
        NSLog(@"file save failed!!!");
    }
    return flag;
}

@end
