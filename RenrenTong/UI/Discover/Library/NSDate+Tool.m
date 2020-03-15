//
//  NSDate+Tool.m
//  ToucanHealthPlatform
//
//  Created by Yiyi on 9/25/14.
//  Copyright (c) 2014 KSCloud.Co.,Ltd. All rights reserved.
//

#import "NSDate+Tool.h"
#define DEFAULT_DATA_FORMMATER  @"yyyy-MM-dd HH:mm:ss"
@implementation NSDate(Tool)


+(NSUInteger)getNumberOfMonth:(NSDate *)date
{
    NSCalendar *calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    
    return range.length;
}


+(NSDate *)getDateByFormatterString:(NSString *) date Formate:(NSString *)formateStr
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:formateStr];

   
    return [formatter dateFromString:date];
}

+(NSString *)getDateStringByFormatterString:(NSDate *) date Formate:(NSString *)formateStr
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:formateStr];
    
    return [formatter  stringFromDate:date];
}


+(NSDate *)getDateByDefaultFormatterString:(NSString *) date
{
    return [NSDate getDateByFormatterString:date Formate:DEFAULT_DATA_FORMMATER];
}


+(NSString *)getDateStringByDefaultFormatterString:(NSDate *) date
{
    return [NSDate getDateStringByFormatterString:date Formate:DEFAULT_DATA_FORMMATER];
}

+(NSDate*)getDateWithCurrentDayBefor:(NSDate*)currentDate Num:(int)num
{
//    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//    NSDateComponents *components = [gregorian components:(NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:currentDate];
//    for (NSInteger i = num; i > 0; i--) {
//        if (components.day == 0) {
//            if (components.month == 1) {
//                components.month = 12;
//                components.year--;
//            }else{
//                components.month--;
//            }
//            components.day++;
//            currentDate = [gregorian dateFromComponents:components];
//            
//            NSRange days = [gregorian rangeOfUnit:NSDayCalendarUnit
//                                           inUnit:NSMonthCalendarUnit
//                                          forDate:currentDate];
//            components.day =days.length;
//        }
//        NSString *string = [NSString stringWithFormat:@"%d-%d-%d",(int)components.year,(int)components.month,(int)components.day--];
//        if (i == 1) {
//            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
//            [formatter setDateFormat:@"yyyy-MM-dd"];
//            NSDate *date = [formatter dateFromString:string];
//            return date;
//        }
//       
//    }
    
    const NSTimeInterval currentDateSec = [currentDate timeIntervalSince1970];
    NSTimeInterval  beforeDateSec = currentDateSec  - (num * 3600 *24);
    return [NSDate dateWithTimeIntervalSince1970:beforeDateSec];

}

+(NSDate *)getDayForStartTime:(NSDate *)date
{

    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth| NSCalendarUnitDay fromDate:date];
    
    return [calendar dateFromComponents:components];
}


+(NSDate *)getHourForStartTime:(NSDate *) date
{
    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth| NSCalendarUnitDay|NSCalendarUnitHour fromDate:date];
    
    return [calendar dateFromComponents:components];
}


+(int)getDayIntervalFormDayToDay:(NSDate *)fromDay ToDay:(NSDate *)toDay
{
   NSTimeInterval intervalSecond = [toDay timeIntervalSinceDate:fromDay];
   return intervalSecond / (3600 * 24);
}
@end
