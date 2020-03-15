//
//  NSDate+Tool.h
//  ToucanHealthPlatform
//
//  Created by Yiyi on 9/25/14.
//  Copyright (c) 2014 KSCloud.Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface NSDate(Tool)

//获得月份有多少天
+(NSUInteger)getNumberOfMonth:(NSDate *)date;

//通过格式来获得日期
+(NSDate *)getDateByFormatterString:(NSString *) date Formate:(NSString *)formateStr;

//通过格式来获得日期获得日期字符串
+(NSString *)getDateStringByFormatterString:(NSDate *) date Formate:(NSString *)formateStr;

//通过默认格式来获得日期
+(NSDate *)getDateByDefaultFormatterString:(NSString *) date;

//通过默认格式来获得日期字符串
+(NSString *)getDateStringByDefaultFormatterString:(NSDate *) date ;
/**
 *  获取当前传入时间N天前日期
 *
 *  @param currentDate     当前时间
 *  @param num             几天前
 */
+(NSDate*)getDateWithCurrentDayBefor:(NSDate*)currentDate Num:(int)num;

/**
 *  获得被给的日期当天的开始时间00:00:00
 *
 *  @param date     当前时间
 *  @param NSDate   当天日期
 */
+(NSDate *)getDayForStartTime:(NSDate *) date;

/**
 *  获得被给的日期的小时开始时间00:00
 *
 *  @param date     当前时间
 *  @param NSDate   当天日期
 */
+(NSDate *)getHourForStartTime:(NSDate *) date;


//从某个日期到某日期的天数
+(int)getDayIntervalFormDayToDay:(NSDate *)fromDay ToDay:(NSDate *)toDay;



@end
