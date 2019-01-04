//
//  NSString+RegEx.m
//  FrameworkDemo
//
//  Created by JunhuaShao on 15/8/28.
//  Copyright (c) 2015年 JunhuaShao. All rights reserved.
//

#import "NSString+RegEx.h"

@implementation NSString (RegEx)

- (BOOL)validateMobileSpecial
{
    NSString *phoneReg = @"^(0|86|17951)?(13[0-9]|15[012356789]|17[678]|18[0-9]|14[57])[0-9]{8}$";
    return [self match:phoneReg];
}

- (BOOL)validateMobile
{
    NSString *phoneReg = @"^\\d{11}$";
    return [self match:phoneReg];
}

- (BOOL)validateID
{
    return [self match:@"(^\\d{15}$)|(^\\d{17}([0-9]|X)$)"];
}

- (BOOL)validateEmail
{
    NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    return [self match:emailRegEx];
}

- (NSString *)replaceWhiteSpace
{
    NSString *str = [NSString stringWithString:self];
    
    str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
    str = [str stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    return str;
}

- (NSString *)replaceWhiteSpaceWithStr:(NSString *)str
{
    if (!str) {
        str = @"";
    }
    NSString *result;
    NSString *reg = @"\\s*";
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:reg options:NSRegularExpressionCaseInsensitive error:&error];
    if (!error) {
        result = [regex stringByReplacingMatchesInString:self options:0 range:NSMakeRange(0, self.length) withTemplate:str];
    }
    return result;
}

- (BOOL)match:(NSString *)regex
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [predicate evaluateWithObject:self];
}

@end
