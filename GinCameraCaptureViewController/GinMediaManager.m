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

@end
