//
//  NSString+GinUnit.h
//  FrameworkDemo
//
//  Created by JunhuaShao on 15/9/7.
//  Copyright (c) 2015年 JunhuaShao. All rights reserved.
//

#import <Foundation/Foundation.h>

// 格式化字符串
#define ComboString(string, args...)[NSString stringWithFormat:string,args]
#define AppendString(str1,str2)     [NSString stringWithFormat:@"%@%@",str1,str2]

@interface NSString (GinUnit)

- (BOOL)isNotBlank;
- (BOOL)isImageType;
- (BOOL)isGif;

@end
