//
//  NSArray+GinUnit.m
//  FrameworkDemo
//
//  Created by JunhuaShao on 15/6/15.
//  Copyright (c) 2015年 JunhuaShao. All rights reserved.
//

#import "NSArray+GinUnit.h"

@implementation NSArray (GinUnit)

- (BOOL)containAnyElements
{
    return self && self.count > 0;
}

@end
