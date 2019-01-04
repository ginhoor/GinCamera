//
//  NSString+Json.m
//  LOLBox
//
//  Created by Ginhoor on 14-8-19.
//  Copyright (c) 2014年 Ginhoor. All rights reserved.
//

#import "NSString+GinJSON.h"

@implementation NSString (GinJSON)

+ (NSString *)JSONString:(NSObject *)object
{
    NSError *__autoreleasing error = nil;
    if (!object) {
        return nil;
    }
    id result = [NSJSONSerialization dataWithJSONObject:object
                                                options:kNilOptions error:&error];
    if (error != nil) return nil;
    return [[NSString alloc] initWithData:result
                                 encoding:NSUTF8StringEncoding];
}

- (NSDictionary *)JSONDictionary
{
    return [self JSONValue];
}

- (NSArray *)JSONArray
{
    return [self JSONValue];
}

- (id)JSONValue
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSError *__autoreleasing error = nil;
    if (!data) {
        return nil;
    }
    id result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (error != nil) return nil;
    return result;
}


@end
