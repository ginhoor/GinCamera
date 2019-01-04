//
//  NSData+NSString.m
//  LOLBox
//
//  Created by Ginhoor on 14-8-30.
//  Copyright (c) 2014年 Ginhoor. All rights reserved.
//

#import "NSData+NSString.h"

@implementation NSData (NSString)

+ (NSData *)stringToData:(NSString *)string
{
    return [string dataUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)dataToString
{
    return [[NSString alloc]initWithData:self encoding:NSUTF8StringEncoding];
}

@end
