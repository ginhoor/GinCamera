//
//  NSObject+JSON.m
//  FrameworkDemo
//
//  Created by JunhuaShao on 15/5/24.
//  Copyright (c) 2015年 JunhuaShao. All rights reserved.
//

#import "NSObject+GinJSON.h"

@implementation NSObject (GinJSON)

- (NSString *)JSONString
{
    if (![NSJSONSerialization isValidJSONObject:self]) {
        NSLog(@"不是有效的JSON Object");
        return nil;
    }
    
    NSError *__autoreleasing error = nil;
    id result = [NSJSONSerialization dataWithJSONObject:self
                                                options:kNilOptions error:&error];
    
    if (error != nil) return nil;
    return [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
}

@end
