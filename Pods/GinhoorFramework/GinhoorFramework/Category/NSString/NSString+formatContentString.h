//
//  NSString+formatContentString.h
//  LOLBox
//
//  Created by Ginhoor on 14-3-14.
//  Copyright (c) 2014年 Ginhoor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (formatContentString)

- (NSString *)formatContentWithTag:(NSString*)tag;
- (NSString *)formatWebString;
- (NSString *)formatUrlString;
/**
 *  将0.10，2.00 统一成0.1，2
 *
 *  @param number 浮点数
 *
 *  @return 处理后的字符串
 */
+ (NSString *)formatFloatNumber:(NSNumber*)number;


@end
