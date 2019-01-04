//
//  NSString+Json.h
//  LOLBox
//
//  Created by Ginhoor on 14-8-19.
//  Copyright (c) 2014年 Ginhoor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (GinJSON)

+ (NSString *)JSONString:(NSObject *)object;

- (NSDictionary *)JSONDictionary;
- (NSArray *)JSONArray;

@end
