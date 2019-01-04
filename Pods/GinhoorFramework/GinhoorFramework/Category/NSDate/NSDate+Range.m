//
//  NSDate+Range.m
//  FrameworkDemo
//
//  Created by JunhuaShao on 15/5/27.
//  Copyright (c) 2015年 JunhuaShao. All rights reserved.
//

#import "NSDate+Range.h"
#import "NSDate+RCUtility.h"

const static NSTimeInterval oneDayInterval = 24*60*60;

@implementation NSDate (Range)

+ (NSDate *)dateInToday:(NSString *)time
{
    NSDateFormatter *totalFormatter = [[NSDateFormatter alloc] init];
    [totalFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [totalFormatter setLocale:[NSLocale currentLocale]];
    NSDate *date = [totalFormatter dateFromString:[NSString stringWithFormat:@"%@ %@:00",[[NSDate date] detailDateString],time]];
    
    return date;
}

+ (NSArray *)dateList:(NSDate *)startDate
              endDate:(NSDate *)endDate
         timeInterval:(NSTimeInterval)timeInterval
            numOfDays:(NSUInteger)numOfDays
{
    
    NSMutableArray *days = [NSMutableArray array];
    for (NSUInteger i = 0; i < numOfDays; i++){
        
        [days addObject:[NSDate timeInOneDay:[NSDate dateWithTimeInterval:oneDayInterval*i sinceDate:startDate] endDate:[NSDate dateWithTimeInterval:oneDayInterval*i sinceDate:endDate] timeInterval:timeInterval]];
    }
    
    return days;
}

+ (NSArray *)realtimeDateList:(NSDate *)startDate
                      endDate:(NSDate *)endDate
                 timeInterval:(NSTimeInterval)timeInterval
                    numOfDays:(NSUInteger)numOfDays;
{
    startDate = [self dateInToday:[startDate timeString]];
    endDate = [self dateInToday:[endDate timeString]];
    
    if ([endDate compare:startDate] == NSOrderedAscending ) {
        endDate = [NSDate dateWithTimeInterval:oneDayInterval sinceDate:endDate];
    }
    
    NSMutableArray *days = [NSMutableArray array];
    
    [days addObject:[NSDate realtimeInOneDay:startDate endDate:endDate timeInterval:timeInterval]];
    
    [days addObjectsFromArray:
     [NSDate dateList:[NSDate dateWithTimeInterval:oneDayInterval sinceDate:startDate]
              endDate:[NSDate dateWithTimeInterval:oneDayInterval sinceDate:endDate]
         timeInterval:timeInterval
            numOfDays:numOfDays-1]];
    
    return days;
}

+ (NSArray *)timeInOneDay:(NSDate *)startDate
                  endDate:(NSDate *)endDate
             timeInterval:(NSTimeInterval)timeInterval
{
    if ([endDate compare:startDate] == NSOrderedAscending ) {
        endDate = [NSDate dateWithTimeInterval:oneDayInterval sinceDate:endDate];
    }
    
    NSMutableArray *timeInOneDay = [NSMutableArray array];
    
    for (NSTimeInterval  i = startDate.timeIntervalSince1970; i <= endDate.timeIntervalSince1970; i+=timeInterval) {
        NSDate *tempDate = [NSDate dateWithTimeIntervalSince1970:i];
        [timeInOneDay addObject:tempDate];
    }
    return timeInOneDay;
}


+ (NSArray *)realtimeInOneDay:(NSDate *)startDate
                      endDate:(NSDate *)endDate
                 timeInterval:(NSTimeInterval)timeInterval
{
    NSMutableArray *timeInDayWithRealtimeConstraint = [NSMutableArray array];
    
    NSTimeInterval startTimeInterval = 0;
    
    if ([startDate compare:[NSDate date]] == NSOrderedAscending) {
        startTimeInterval = [NSDate dateWithTimeInterval:(ceil(ABS(startDate.timeIntervalSinceNow)/timeInterval))*timeInterval sinceDate:startDate].timeIntervalSince1970;
    } else {
        startTimeInterval = startDate.timeIntervalSince1970;
    }
    
    for (NSTimeInterval  i = startTimeInterval; i <= endDate.timeIntervalSince1970; i+=timeInterval) {
        
        NSDate *tempDate = [NSDate dateWithTimeIntervalSince1970:i];
        [timeInDayWithRealtimeConstraint addObject:tempDate];
    }
    return timeInDayWithRealtimeConstraint;
}

@end
