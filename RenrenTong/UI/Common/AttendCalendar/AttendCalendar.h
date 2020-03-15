//
//  AttendCalendar.h
//  RenrenTong
//
//  Created by 唐彬 on 14-9-24.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol AttendCalendarDelegate
@optional
- (void)selectedDate:(NSDate *)date;// 点击日期
- (void)directBegin:(NSDate *)begindate End:(NSDate *)enddate;// 点击更换月份
@end
@interface AttendCalendar : UIView{
    NSDate* today;
    NSDate* currentdate;
    UIButton* prebtn;
    UIButton* nextbtn;
    UILabel* title;
    UIView* line1;
    UIView* line2;
    UIView* line3;
    BOOL loadweek;
    NSMutableArray* dates;
    NSMutableArray* datebtns;
}
@property(nonatomic,assign) id delegate;
- (id)initCalendar;// 初始化日历
-(void)setErrorDateState:(NSDate*)date;// 处理异常日期
@end
