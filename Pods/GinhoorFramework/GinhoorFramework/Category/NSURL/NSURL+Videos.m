//
//  NSURL+Videos.m
//  LOLBox
//
//  Created by Ginhoor on 14-1-18.
//  Copyright (c) 2014年 Ginhoor. All rights reserved.
//

#import "NSURL+Videos.h"

@implementation NSURL (Videos)

+ (NSURL *)makeYouKuM3U8:(NSString *)idStr
{
    NSArray *pathComponents = [idStr pathComponents];
    
    NSString *prefix = @"http://v.youku.com/player/getRealM3U8/vid/";
    NSString *suffix = @"/type//video.m3u8";
    NSString *result;
    
    if (pathComponents.count > 4) {
        result = [NSString stringWithFormat:@"%@%@%@",prefix,[pathComponents objectAtIndex:pathComponents.count-2],suffix];
    } else {
        NSString *tmpID = [pathComponents lastObject];
        tmpID = [tmpID substringFromIndex:3];
        tmpID = [tmpID substringToIndex:tmpID.length - 5];
        result = [NSString stringWithFormat:@"%@%@%@",prefix,tmpID,suffix];
    }
    
    return [NSURL URLWithString:result];
}

@end

