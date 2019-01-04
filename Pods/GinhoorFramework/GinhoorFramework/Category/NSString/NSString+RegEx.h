//
//  NSString+RegEx.h
//  FrameworkDemo
//
//  Created by JunhuaShao on 15/8/28.
//  Copyright (c) 2015年 JunhuaShao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (RegEx)

/**
 *  匹配正则
 *
 *  @param regex 规则
 *
 *  @return 是否匹配
 */
- (BOOL)match:(NSString *)regex;

- (BOOL)validateMobile;
- (BOOL)validateMobileSpecial;
- (BOOL)validateID;
- (BOOL)validateEmail;

- (NSString *)replaceWhiteSpace;
- (NSString *)replaceWhiteSpaceWithStr:(NSString *)str;



@end
