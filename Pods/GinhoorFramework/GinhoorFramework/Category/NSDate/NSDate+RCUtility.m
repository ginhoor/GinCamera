//
//  NSDate+RCUtility.m
//  FrameworkDemo
//
//  Created by JunhuaShao on 15/5/27.
//  Copyright (c) 2015年 JunhuaShao. All rights reserved.
//

#import "NSDate+RCUtility.h"

@implementation NSDate (RCUtility)

+ (NSDate *)dateFromString:(NSString *)dateString formatString:(NSString *)formatString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatString];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    
    return [dateFormatter dateFromString:dateString];
}

- (NSString *)customDateString:(NSString *)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    return [dateFormatter stringFromDate:self];
}

- (NSString *)yearString
{
    return [self customDateString:@"yyyy"];
}

- (NSString *)dateString
{
    return [self customDateString:@"MM-dd"];
}

// EEE,（@"周日"至@"周一"）
- (NSString *)weekString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEE"];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setWeekdaySymbols:@[@"星期日", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六"]];
    [dateFormatter setShortWeekdaySymbols:@[@"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六"]];
    [dateFormatter setVeryShortWeekdaySymbols:@[@"日", @"一", @"二", @"三", @"四", @"五", @"六"]];
    return [dateFormatter stringFromDate:self];
}

- (NSString *)timeString
{
    return [self customDateString:@"HH:mm"];
}

- (NSString *)dateAndTimeString
{
    return [self customDateString:@"MM-dd HH:mm:ss"];
}

- (NSString *)detailDateString
{
    return [self customDateString:@"yyyy-MM-dd"];
}

- (NSString *)detailDateAndTimeString
{
    return [self customDateString:@"yyyy-MM-dd HH:mm:ss"];
}

- (NSString *)detailDateTimeWeekString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss EEE"];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setWeekdaySymbols:@[@"星期日", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六"]];
    [dateFormatter setShortWeekdaySymbols:@[@"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六"]];
    [dateFormatter setVeryShortWeekdaySymbols:@[@"日", @"一", @"二", @"三", @"四", @"五", @"六"]];
    
    return [dateFormatter stringFromDate:self];

}

- (BOOL)isSameDayAsOtherDate:(NSDate *)date
{
    NSDate *newDate = [[self class] normalizeDate:date];
    return [[[self class] normalizeDate:self] isEqualToDate:newDate];
}

- (BOOL)isSameMonthAsOtherDate:(NSDate *)date
{
    NSDate *newDate = [[self class] monthDate:date];
    return [[[self class] monthDate:self] isEqualToDate:newDate];
}

+ (NSDate *)normalizeDate:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday)
                                                   fromDate:date];
    NSDate* returnDate = [calendar dateFromComponents:dateComponents];
    return returnDate;
}

+ (NSDate *)monthDate:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth)
                                                   fromDate:date];
    NSDate* returnDate = [calendar dateFromComponents:dateComponents];
    return returnDate;
}


+ (NSDate *)yesterdayDate
{
    return [NSDate dateWithTimeIntervalSinceNow:-3600*24];
}

- (NSString *)compareWithAnDate:(NSDate *)anDate
{
    NSCalendar *chineseClendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSUInteger unitFlags =  NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond;
    
    // 当前系统时间 与 活动结束时间 比较
    NSDateComponents *cps = [ chineseClendar components:unitFlags fromDate:self  toDate:anDate  options:0];
    
    NSInteger diffHour = cps.hour;
    NSInteger diffMinute = cps.minute;
    NSInteger diffSecond = cps.second;
    
    NSString *diffHourStr;
    NSString *diffMinuteStr;
    NSString *diffSecondStr;
    
    if (diffHour < 10) {
        diffHourStr = [NSString stringWithFormat:@"0%@",@(diffHour).stringValue];
    } else {
        diffHourStr = @(diffHour).stringValue;
    }
    
    if (diffMinute < 10) {
        diffMinuteStr = [NSString stringWithFormat:@"0%@",@(diffMinute).stringValue];
    } else {
        diffMinuteStr = @(diffMinute).stringValue;
    }
    
    if (diffSecond < 10) {
        diffSecondStr = [NSString stringWithFormat:@"0%@",@(diffSecond).stringValue];
    } else {
        diffSecondStr = @(diffSecond).stringValue;
    }
    
    return [NSString stringWithFormat:@"%@:%@:%@",diffHourStr,diffMinuteStr,diffSecondStr];
}


- (NSTimeInterval)intervalBetweenDates:(NSDate *)date
{
    return self.timeIntervalSince1970 - date.timeIntervalSince1970;
}

@end
