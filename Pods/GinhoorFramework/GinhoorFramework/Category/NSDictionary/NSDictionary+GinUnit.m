//
//  NSDictionary+GinUnit.m
//  FrameworkDemo
//
//  Created by JunhuaShao on 15/6/18.
//  Copyright (c) 2015年 JunhuaShao. All rights reserved.
//

#import "NSDictionary+GinUnit.h"
#import "NSArray+GinUnit.h"

@implementation NSDictionary (GinUnit)

- (BOOL)containKey:(NSString *)key
{
    if (![self.allKeys containAnyElements]) {
        return NO;
    }
    return [self.allKeys containsObject:key];
}

@end
