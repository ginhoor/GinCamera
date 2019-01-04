//
//  GinSysInfo.m
//  demo4UserSpace
//
//  Created by Ginhoor on 14-8-20.
//  Copyright (c) 2014年 Ginhoor. All rights reserved.
//

#import "GinSysInfo.h"

@implementation GinSysInfo

+ (NSString *)iOSSystemVersion
{
    return [[UIDevice currentDevice] systemVersion];
}

+ (NSString *)appVersion
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

+ (NSString *)appBundleName
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
}

+ (NSString *)buildVersion
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}

+ (NSString *)bundleSeedID {
    NSDictionary *query = [NSDictionary dictionaryWithObjectsAndKeys:
                           (__bridge id)(kSecClassGenericPassword), kSecClass,
                           @"bundleSeedID", kSecAttrAccount,
                           @"", kSecAttrService,
                           (id)kCFBooleanTrue, kSecReturnAttributes,
                           nil];
    CFDictionaryRef result = nil;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query, (CFTypeRef *)&result);
    if (status == errSecItemNotFound)
        status = SecItemAdd((__bridge CFDictionaryRef)query, (CFTypeRef *)&result);
    if (status != errSecSuccess)
        return nil;
    NSString *accessGroup = [(__bridge NSDictionary *)result objectForKey:(__bridge id)(kSecAttrAccessGroup)];
    NSArray *components = [accessGroup componentsSeparatedByString:@"."];
    NSString *bundleSeedID = [[components objectEnumerator] nextObject];
    CFRelease(result);
    return bundleSeedID;
}

+ (BOOL)iOSVersion:(CGFloat)version
{
    return [self iOSSystemVersion].floatValue >= version && [self iOSSystemVersion].floatValue < version+1;
}

+ (BOOL)laterThanVersion:(CGFloat)version;
{
    return [self iOSSystemVersion].floatValue >= version;
}

+ (BOOL)isJailbrokenUser
{
    /* Cydia.app */
    NSString *cydiaPath = @"/Applications/Cydia.app";
    if ([[NSFileManager defaultManager] fileExistsAtPath:cydiaPath]) {
        return YES;
    }
    
    /* apt */
    NSString *aptPath = @"/private/var/lib/apt/";
    if ([[NSFileManager defaultManager] fileExistsAtPath:aptPath]) {
        return YES;
    }
    return NO;
}

+ (BOOL)isPiratedUser
{
    NSString *path = [NSHomeDirectory() stringByAppendingString:@"/iTunesMetadata.plist"];
    NSDictionary *infoDic = [[NSDictionary alloc] initWithContentsOfFile:path];
    
    if (infoDic[@"com.apple.iTunesStore.downloadInfo"][@"accountInfo"][@"AppleID"]) {
        return NO;
    } else if (infoDic[@"appleId"])
    {
        return NO;
    } else {
        return YES;
    }
}

@end
