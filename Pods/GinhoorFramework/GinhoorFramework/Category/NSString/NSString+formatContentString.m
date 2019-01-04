//
//  NSString+formatContentString.m
//  LOLBox
//
//  Created by Ginhoor on 14-3-14.
//  Copyright (c) 2014年 Ginhoor. All rights reserved.
//

#import "NSString+formatContentString.h"

@implementation NSString (formatContentString)

- (NSString *)formatContentWithTag:(NSString*)tag
{
    if (self.length > 0) {
        return [NSString stringWithFormat:@"%@：%@",tag,self];
    } else {
        return [NSString stringWithFormat:@"%@：无",tag];
    }
}

- (NSString *)formatWebString
{
    NSString *value = [self stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\""]];
    value = [value stringByReplacingOccurrencesOfString:@"\\\\" withString:@"\\"];
    value = [value stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"];
    value = [value stringByReplacingOccurrencesOfString:@"\\\"" withString:@"\""];
    value = [value stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
    value = [value stringByReplacingOccurrencesOfString:@"\\r" withString:@"\r"];
    value = [value stringByReplacingOccurrencesOfString:@"\\t" withString:@"\t"];
    value = [value stringByReplacingOccurrencesOfString:@"\\f" withString:@"\f"];
    value = [value stringByReplacingOccurrencesOfString:@"\\b" withString:@"\f"];
    
    return value;
}

- (NSString *)formatUrlString
{
    NSString *charactersToEscape = @"?!@#$^&%*+,:;='\"`<>()[]{}/\\| ";
    NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:charactersToEscape] invertedSet];
    
    NSString *encodedUrl = [self stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
    return encodedUrl;
}

+ (NSString *)formatFloatNumber:(NSNumber*)number
{
    NSMutableString *value = [NSMutableString stringWithFormat:@"%.2f",number.doubleValue];
    NSString *regExStr =@"0$|.00$";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regExStr options:NSRegularExpressionCaseInsensitive error:nil];
    
    NSArray *results = [regex matchesInString:value options:NSMatchingReportCompletion range:NSMakeRange(0, value.length)];
    
    for (NSTextCheckingResult *check in results) {
        [value deleteCharactersInRange:check.range];
    }
    return value;
}

@end
