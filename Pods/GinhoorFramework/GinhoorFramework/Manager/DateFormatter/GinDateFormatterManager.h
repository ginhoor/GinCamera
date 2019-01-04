//
//  GinDateFormatterManager.h
//  FrameworkDemo
//
//  Created by JunhuaShao on 2018/12/24.
//  Copyright © 2018 JunhuaShao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GinDateFormatterManager : NSObject

/**
 根据秒数显示格式化字符串（1'01''）
 
 @param second 秒数
 @return 格式化字符串
 */
+ (NSString *)getStringOfSecond:(NSUInteger)second;
/**
 yyyy
 */
+ (NSString *)getYear:(NSDate *)date;
/**
 MM
 */
+ (NSString *)getMonth:(NSDate *)date;
/**
 @{@"year":@2017, @"month":@5}
 */
+ (NSDictionary *)yearAndMonthFromString:(NSString *)dateString;
/**
 yyyy年MM月
 */
+ (NSString *)stringCNFromDate:(NSDate *)date;

/**
 yyyy-MM
 */
+ (NSDate *)dateFromYMString:(NSString *)dateString;

/**
 yyyy-MM-dd
 */
+ (NSString *)stringFromDate:(NSDate *)date;
+ (NSDate *)dateFromString:(NSString *)dateString;
/**
 yyyy-MM-dd HH:mm
 */
+ (NSString *)detailStringWithoutSecondsFromDate:(NSDate *)date;
/**
 yyyy-MM-dd HH:mm:ss
 */
+ (NSString *)detailStringFromDate:(NSDate *)date;
+ (NSDate *)dateFromDetailString:(NSString *)dateString;
/**
 @param numString yyyyMMdd
 @return yyyy-MM-dd
 */
+ (NSString *)formatDateFromNumString:(NSString *)numString;

/**
 获得从开始年份至今的年份列表
 
 @param beginYear yyyy
 @return @[@"yyyy"]
 */
+ (NSArray *)getYearListUntilNow:(NSString *)beginYear;

/**
 格式化时间字符串
 
 @param dateString yyyy-MM-dd HH:mm:ss
 @return 1.时间为当日，则显示为“12:00”
 2.时间为昨天，显示为“昨天”
 3.时间为前天，显示为“前天”
 4.更早的时间，统一显示日期为“6-12”
 */
+ (NSString *)formatDateForShortString:(NSString *)dateString;
+ (NSString *)formatDateForShortString:(NSString *)dateString detailDateFormat:(NSString *)detailDateFormat;

@end

NS_ASSUME_NONNULL_END
