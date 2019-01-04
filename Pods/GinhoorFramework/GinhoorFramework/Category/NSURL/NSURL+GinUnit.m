//
//  NSURL+GinUnit.m
//  hmeIosCn
//
//  Created by JunhuaShao on 15/4/10.
//  Copyright (c) 2015年 Byhere. All rights reserved.
//

#import "NSURL+GinUnit.h"

@implementation NSURL (GinUnit)

- (NSDictionary *)queryDictionary
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    NSString *urlString = [self query];
    for (NSString *param in [urlString componentsSeparatedByString:@"&"]) {
        NSArray *elts = [param componentsSeparatedByString:@"="];
        if([elts count] < 2) continue;
        [params setObject:[elts lastObject] forKey:[elts firstObject]];
    }
    
    return params;

}

@end
