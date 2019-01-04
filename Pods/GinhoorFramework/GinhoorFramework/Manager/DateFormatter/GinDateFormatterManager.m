//
//  GinDateFormatterManager.m
//  FrameworkDemo
//
//  Created by JunhuaShao on 2018/12/24.
//  Copyright © 2018 JunhuaShao. All rights reserved.
//

#import "GinDateFormatterManager.h"

@interface GinDateFormatterManager()

@property (strong, nonatomic) NSDateFormatter *formatter;
@property (strong, nonatomic) NSCalendar *calendar;

@end

@implementation GinDateFormatterManager

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static id sharedInstance = nil;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.formatter = [[NSDateFormatter alloc] init];
    [self.formatter setLocale:[NSLocale currentLocale]];
    self.calendar = [NSCalendar currentCalendar];
}

+ (NSDateFormatter *)formatter
{
    return [GinDateFormatterManager sharedInstance].formatter;
}

+ (NSCalendar *)calendar
{
    return [GinDateFormatterManager sharedInstance].calendar;
}

+ (NSString *)getStringOfSecond:(NSUInteger)second
{
    NSString *secondStr = @"";
    NSInteger mSecond = second % 60;
    if (mSecond < 10) {
        secondStr = [NSString stringWithFormat:@"0%ld",(long)mSecond];
    } else {
        secondStr = [NSString stringWithFormat:@"%ld", (long)mSecond];
    }
    
    return [NSString stringWithFormat:@"%@'%@\"",@(second/60),secondStr];
}

+ (NSString *)getYear:(NSDate *)date
{
    NSDateFormatter *formatter = [self formatter];
    
    [formatter setDateFormat:@"yyyy"];
    return [formatter stringFromDate:date];
}

+ (NSString *)getMonth:(NSDate *)date
{
    NSDateFormatter *formatter = [self formatter];
    [formatter setDateFormat:@"MM"];
    return [formatter stringFromDate:date];
}

+ (NSDictionary *)yearAndMonthFromString:(NSString *)dateString
{
    NSDateFormatter *formatter = [self formatter];
    [formatter setDateFormat:@"yyyy-MM"];
    
    NSDate *date;
    if (dateString.length > 7) {
        date = [formatter dateFromString:[dateString substringWithRange:NSMakeRange(0, 7)]];
    } else {
        date = [formatter dateFromString:dateString];
    }
    
    [formatter setDateFormat:@"yyyy"];
    NSString *year = [formatter stringFromDate:date];
    
    [formatter setDateFormat:@"MM"];
    NSString *month = [formatter stringFromDate:date];
    
    return @{@"year":year, @"month":month};
}

+ (NSString *)stringCNFromDate:(NSDate *)date
{
    NSDateFormatter *formatter = [self formatter];
    [formatter setDateFormat:@"yyyy年MM月"];
    
    return [formatter stringFromDate:date];
}

+ (NSString *)stringFromDate:(NSDate *)date
{
    NSDateFormatter *formatter = [self formatter];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    return [formatter stringFromDate:date];
}

+ (NSDate *)dateFromString:(NSString *)dateString
{
    NSDateFormatter *formatter = [self formatter];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    return [formatter dateFromString:dateString];
}

+ (NSDate *)dateFromYMString:(NSString *)dateString
{
    NSDateFormatter *formatter = [self formatter];
    [formatter setDateFormat:@"yyyy-MM"];
    return [formatter dateFromString:dateString];
}


+ (NSString *)detailStringWithoutSecondsFromDate:(NSDate *)date
{
    NSDateFormatter *formatter = [self formatter];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    return [formatter stringFromDate:date];
}

+ (NSString *)detailStringFromDate:(NSDate *)date
{
    NSDateFormatter *formatter = [self formatter];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [formatter stringFromDate:date];
}

+ (NSString *)formatDateFromNumString:(NSString *)numString
{
    NSDateFormatter *formatter = [self formatter];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSDate *date = [formatter dateFromString:numString];
    
    return [self stringFromDate:date];
}

+ (NSDate *)dateFromDetailString:(NSString *)dateString
{
    NSDateFormatter *formatter = [self formatter];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [formatter dateFromString:dateString];
}

+ (NSString *)formatDateForShortString:(NSString *)dateString
{
    return [self formatDateForShortString:dateString detailDateFormat:@"yyyy-MM-dd"];
}

+ (NSString *)formatDateForShortString:(NSString *)dateString detailDateFormat:(NSString *)detailDateFormat
{
    NSDateFormatter *formatter = [self formatter];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *date = [formatter dateFromString:dateString];
    
    NSDate *theDayAfter3Days = [self normalizeDate:[NSDate dateWithTimeIntervalSinceNow:3600*24*3]];
    
    NSDate *theDayAfterTomorrow = [self normalizeDate:[NSDate dateWithTimeIntervalSinceNow:3600*24*2]];
    NSDate *tomorrow = [self normalizeDate:[NSDate dateWithTimeIntervalSinceNow:3600*24]];
    
    NSDate *today = [self normalizeDate:[NSDate date]];
    
    NSDate *yesterday = [self normalizeDate:[NSDate dateWithTimeIntervalSinceNow:-3600*24]];
    NSDate *theDayBeforeYesterday = [self normalizeDate:[NSDate dateWithTimeIntervalSinceNow:-3600*24*2]];
    
    NSString *timeStr;
    
    if ([date compare:theDayAfterTomorrow] == NSOrderedDescending &&
        [date compare:theDayAfter3Days] == NSOrderedAscending) {
        [formatter setDateFormat:@"HH:mm"];
        timeStr = [NSString stringWithFormat:@"后天 %@",[formatter stringFromDate:date]];
    } else if ([date compare:tomorrow] == NSOrderedDescending &&
               [date compare:theDayAfterTomorrow] == NSOrderedAscending) {
        [formatter setDateFormat:@"HH:mm"];
        timeStr = [NSString stringWithFormat:@"明天 %@",[formatter stringFromDate:date]];
        
    } else if ([date compare:today] == NSOrderedDescending &&
               [date compare:tomorrow] == NSOrderedAscending) {
        [formatter setDateFormat:@"HH:mm"];
        timeStr = [NSString stringWithFormat:@"今天 %@",[formatter stringFromDate:date]];
    } else if ([date compare:yesterday] == NSOrderedDescending &&
               [date compare:today] == NSOrderedAscending) {
        [formatter setDateFormat:@"HH:mm"];
        timeStr = [NSString stringWithFormat:@"昨天 %@",[formatter stringFromDate:date]];
        
    } else if ([date compare:theDayBeforeYesterday] == NSOrderedDescending &&
               [date compare:yesterday] == NSOrderedAscending){
        [formatter setDateFormat:@"HH:mm"];
        timeStr = [NSString stringWithFormat:@"前天 %@",[formatter stringFromDate:date]];
    } else {
        [formatter setDateFormat:detailDateFormat];
        timeStr = [formatter stringFromDate:date];
    }
    
    return timeStr;
}

+ (NSArray *)getYearListUntilNow:(NSString *)beginYear
{
    NSMutableArray *yearList = [NSMutableArray array];
    
    NSDate *beginDate = [self dateFromString:[NSString stringWithFormat:@"%@-06-01", beginYear]];
    [yearList addObject:[self getYear:beginDate]];
    
    NSDate *nextDate = [self dateFromString:[NSString stringWithFormat:@"%@-06-01",[self getYear:[self normalizeDate:[beginDate dateByAddingTimeInterval:3600*24*365]]]]];
    
    while ([[self getYear:nextDate] compare:[self getYear:[NSDate date]]] != NSOrderedDescending) {
        [yearList addObject:[self getYear:nextDate]];
        nextDate = [self dateFromString:[NSString stringWithFormat:@"%@-06-01",[self getYear:[self normalizeDate:[nextDate dateByAddingTimeInterval:3600*24*365]]]]];
    };
    
    return yearList;
}

+ (NSDate *)normalizeDate:(NSDate *)date
{
    NSCalendar *calendar = [self calendar];
    NSDateComponents *dateComponents = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday)
                                                   fromDate:date];
    NSDate *returnDate = [calendar dateFromComponents:dateComponents];
    return returnDate;
}

@end
