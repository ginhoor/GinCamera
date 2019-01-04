//
//  NSAttributedString+GinUnit.m
//  FrameworkDemo
//
//  Created by JunhuaShao on 15/6/12.
//  Copyright (c) 2015年 JunhuaShao. All rights reserved.
//

#import "NSAttributedString+GinUnit.h"

@implementation NSAttributedString (GinUnit)

+ (instancetype)string:(NSString *)string attribute:(NSDictionary *)attributes
{
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:string attributes:attributes];
    
    return attrString;
}
@end
