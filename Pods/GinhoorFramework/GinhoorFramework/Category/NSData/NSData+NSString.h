//
//  NSData+NSString.h
//  LOLBox
//
//  Created by Ginhoor on 14-8-30.
//  Copyright (c) 2014年 Ginhoor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (NSString)

+ (NSData *)stringToData:(NSString *)string;

- (NSString *)dataToString;

@end
