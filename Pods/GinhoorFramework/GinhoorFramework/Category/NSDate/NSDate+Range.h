//
//  NSDate+Range.h
//  FrameworkDemo
//
//  Created by JunhuaShao on 15/5/27.
//  Copyright (c) 2015年 JunhuaShao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Range)

/**
 *  通过 HH:mm 来创建NSDate
 *
 *  @param time HH:mm
 *
 *  @return NSDate
 */
+ (NSDate *)dateInToday:(NSString *)time;

/**
 *  计算时间列表（不考虑当前时间因素）
 *
 *  @param startDate    开始时间
 *  @param endDate      结束时间
 *  @param timeInterval 时间间隔（秒）
 *  @param numOfDays    天数
 *
 *  @return 时间列表
 */
+ (NSArray *)dateList:(NSDate *)startDate
              endDate:(NSDate *)endDate
         timeInterval:(NSTimeInterval)timeInterval
            numOfDays:(NSUInteger)numOfDays;

/**
 *  根据当前时间计算时间列表
 *
 *  @param startDate    开始时间
 *  @param endDate      结束时间
 *  @param timeInterval 时间间隔（秒）
 *  @param numOfDays    天数
 *
 *  @return 时间列表
 */
+ (NSArray *)realtimeDateList:(NSDate *)startDate
                      endDate:(NSDate *)endDate
                 timeInterval:(NSTimeInterval)timeInterval
                    numOfDays:(NSUInteger)numOfDays;

/**
 *  计算一天中时间列表（不考虑当前时间因素）
 *
 *  @param startDate    开始时间
 *  @param endDate      结束时间
 *  @param timeInterval 时间间隔
 *
 *  @return 时间列表
 */
+ (NSArray *)timeInOneDay:(NSDate *)startDate
                  endDate:(NSDate *)endDate
             timeInterval:(NSTimeInterval)timeInterval;

/**
 *  根据当前时间计算一天中时间列表
 *
 *  @param startDate    开始时间
 *  @param endDate      结束时间
 *  @param timeInterval 时间间隔
 *
 *  @return 时间列表
 */
+ (NSArray *)realtimeInOneDay:(NSDate *)startDate
                      endDate:(NSDate *)endDate
                 timeInterval:(NSTimeInterval)timeInterval;


@end
