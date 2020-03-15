//
//  AttendCalendar.m
//  RenrenTong
//
//  Created by 唐彬 on 14-9-24.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "AttendCalendar.h"

@implementation AttendCalendar
@synthesize delegate;

- (id)initCalendar
{
    self = [super init];
    if (self) {
        self.frame=CGRectMake(0, 0, 320, 0);
        //获取当前时间
        today = [self getCurrentDate];
        currentdate=today;
        loadweek=NO;
        dates=[[NSMutableArray alloc] init];
        datebtns=[[NSMutableArray alloc] init];
        UISwipeGestureRecognizer *recognizer;
        recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
        [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
        [self addGestureRecognizer:recognizer];
        
        recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
        [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
        [self addGestureRecognizer:recognizer];
        
        [self initContr];
    }
    return self;
}

-(void)initContr{
    [dates removeAllObjects];
    for (UIButton *btn in datebtns) {
        [btn removeFromSuperview];
    }
    [datebtns removeAllObjects];
    if (!title) {
        title=[[UILabel alloc] initWithFrame:CGRectMake((SCREENWIDTH-180)*0.5, 20, 180, 40)];
        title.textAlignment=NSTextAlignmentCenter;
        title.font=[UIFont systemFontOfSize:30];
        [self addSubview:title];
    }
    title.text=[NSString stringWithFormat:@"%d年%d月",[self getYearByDate:currentdate],[self getMonthByDate:currentdate]];
    if (!prebtn) {
        prebtn=[UIButton buttonWithType:UIButtonTypeCustom];
        prebtn.frame=CGRectMake(title.left-40, title.top, 40, 40);
        [prebtn setBackgroundImage:[UIImage imageNamed:@"acbtnl.png"] forState:UIControlStateNormal];
        [prebtn addTarget:self action:@selector(preClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:prebtn];
    }
    
    if (!nextbtn) {
        nextbtn=[UIButton buttonWithType:UIButtonTypeCustom];
        nextbtn.frame=CGRectMake(title.right, title.top, 40, 40);
        [nextbtn setBackgroundImage:[UIImage imageNamed:@"acbtnr.png"] forState:UIControlStateNormal];
        [nextbtn addTarget:self action:@selector(nextClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:nextbtn];
    }
    
    line1=[self drawLine:line1 rect:CGRectMake(10, title.bottom+30, SCREENWIDTH-20, 1)];
    int width=(SCREENWIDTH-20)/7;
    int height=30;
    if (!loadweek) {
        NSArray* weektext=@[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
        for (int i=0; i<7; i++) {
            UILabel* week=[[UILabel alloc] initWithFrame:CGRectMake(line1.left+i*width, line1.bottom+5, width, height)];
            week.textAlignment=NSTextAlignmentCenter;
            week.text=[weektext objectAtIndex:i];
            week.textColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
            [self addSubview:week];
        }
        loadweek=YES;
    }
    line2=[self drawLine:line2 rect:CGRectMake(10, line1.bottom+10+height, SCREENWIDTH-20, 1)];
    NSDate* tempdate=currentdate;
    int day=[self getDayByDate:tempdate];
    if (day>1) {
        day=-(day-1);
    }else{
        day=0;
    }
    tempdate=[self setDate:tempdate withDay:day];
    int fweekday=[self getWeekByDate:tempdate];
    int days=[self getDaysForMonthWithDate:tempdate];
    day=[self getDayByDate:tempdate];
    day=days-day;
    tempdate=[self setDate:tempdate withDay:day];
    int lweekday=[self getWeekByDate:tempdate];
    int totalday = fweekday + days;
    int row = totalday / 7;
    if (totalday % 7 > 0) {
        row = row + 1;
    }
    UIButton* btn;
    int oldwidth=width;
    width=36;
    height=36;
    tempdate=[self setDate:tempdate withDay:-(totalday-1)];
    int tag=0;
    for (int i = 0; i < row; i++) {
        for (int j = 0; j < 7; j++) {
            btn=[UIButton buttonWithType:UIButtonTypeCustom];
            if ((i == 0 && j < fweekday) || (i == row - 1 && j > lweekday)) {
                btn.frame=CGRectMake(10+j*oldwidth+(oldwidth-width)*0.5, i*height+line2.bottom+10*(i+1), width, height);
                [btn setTitleColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4] forState:UIControlStateNormal];
            } else {
                btn.frame=CGRectMake(10+j*oldwidth+(oldwidth-width)*0.5, i*height+line2.bottom+10*(i+1), width, height);
                [btn setTitleColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1] forState:UIControlStateNormal];
            }
            [btn setTitle:[NSString stringWithFormat:@"%d",[self getDayByDate:tempdate]] forState:UIControlStateNormal];
            btn.tag=tag;
            [btn addTarget:self action:@selector(selectDate:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            [dates addObject:tempdate];
            tempdate=[self setDate:tempdate withDay:1];
            tag++;
            [datebtns addObject:btn];
        }
    }
    line3=[self drawLine:line3 rect:CGRectMake(10, line2.bottom+(height+10)*row+10, SCREENWIDTH-20, 1)];
    self.height=line3.bottom+10;
    [self setCurrentDateState:today];
}

-(void)preClick:(UIButton*)sender{
    [self directleft];
}

-(void)nextClick:(UIButton*)sender{
    [self directright];
}

-(void)selectDate:(UIButton*)sender{
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(selectedDate:)]) {
            [self.delegate performSelector:@selector(selectedDate:) withObject:[dates objectAtIndex:sender.tag]];
        }
    }
}

-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
    if(recognizer.direction==UISwipeGestureRecognizerDirectionLeft) {
        [self directright];
    }
    if(recognizer.direction==UISwipeGestureRecognizerDirectionRight) {
        [self directleft];
    }
}

- (void)directright {
    int days=[self getDaysForMonthWithDate:currentdate];
    int day=[self getDayByDate:currentdate];
    day=days-day;
    currentdate=[self setDate:currentdate withDay:day+1];
    [self initContr];
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(directBegin:End:)]) {
            NSDate* tempdate=currentdate;
            int day=[self getDayByDate:tempdate];
            if (day>1) {
                day=-(day-1);
            }else{
                day=0;
            }
            tempdate=[self setDate:tempdate withDay:day];
            NSDate* begindate=tempdate;
            int days=[self getDaysForMonthWithDate:tempdate];
            day=[self getDayByDate:tempdate];
            day=days-day;
            tempdate=[self setDate:tempdate withDay:day];
            NSDate* enddate=tempdate;
            [self.delegate performSelector:@selector(directBegin:End:) withObject:begindate withObject:enddate];
        }
    }
}

- (void)directleft {
    int day=[self getDayByDate:currentdate];
    currentdate=[self setDate:currentdate withDay:-day];
    [self initContr];
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(directBegin:End:)]) {
            NSDate* tempdate=currentdate;
            int day=[self getDayByDate:tempdate];
            if (day>1) {
                day=-(day-1);
            }else{
                day=0;
            }
            tempdate=[self setDate:tempdate withDay:day];
            NSDate* begindate=tempdate;
            int days=[self getDaysForMonthWithDate:tempdate];
            day=[self getDayByDate:tempdate];
            day=days-day;
            tempdate=[self setDate:tempdate withDay:day];
            NSDate* enddate=tempdate;
            [self.delegate performSelector:@selector(directBegin:End:) withObject:begindate withObject:enddate];
        }
    }
}

-(void)setCurrentDateState:(NSDate*)date{
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd"];
    NSString *  currentdatestr=[dateformatter stringFromDate:date];
    for (int i=0; i<[dates count]; i++) {
        NSDate *tempdate=[dates objectAtIndex:i];
        NSString* tempdatestr=[dateformatter stringFromDate:tempdate];
        if ([tempdatestr isEqualToString:currentdatestr]) {
            UIButton* btn=[datebtns objectAtIndex:i];
            [btn setTitleColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:@"acdaten.png"] forState:UIControlStateNormal];
        }
    }
}

-(void)setErrorDateState:(NSDate*)date{
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd"];
    NSString *  currentdatestr=[dateformatter stringFromDate:today];
    NSString *  errordatestr=[dateformatter stringFromDate:date];
    for (int i=0; i<[dates count]; i++) {
        NSDate *tempdate=[dates objectAtIndex:i];
        NSString* tempdatestr=[dateformatter stringFromDate:tempdate];
        if ([tempdatestr isEqualToString:errordatestr]) {
            if ([errordatestr isEqualToString:currentdatestr]) {
                UIButton* btn=[datebtns objectAtIndex:i];
                [btn setTitleColor:[UIColor colorWithRed:255 green:255 blue:255 alpha:1] forState:UIControlStateNormal];
                [btn setBackgroundImage:[UIImage imageNamed:@"acdatene.png"] forState:UIControlStateNormal];
            }else{
                UIButton* btn=[datebtns objectAtIndex:i];
                [btn setTitleColor:[UIColor colorWithRed:255 green:255 blue:255 alpha:1] forState:UIControlStateNormal];
                [btn setBackgroundImage:[UIImage imageNamed:@"acdatee.png"] forState:UIControlStateNormal];
            }
            return;
        }
    }
}


-(UIView*)drawLine:(UIView*)line rect:(CGRect)rect{
    if (line) {
        line.frame=rect;
        return line;
    }
    line=[[UIView alloc] initWithFrame:rect];
    line.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    [self addSubview:line];
    return line;
}

//获取当前本地时间，解决时间差
-(NSDate*)getCurrentDate{
    NSDate* date = [NSDate date];
//    NSTimeZone *zone = [NSTimeZone systemTimeZone];
//    NSInteger interval = [zone secondsFromGMTForDate: date];
//    date = [date  dateByAddingTimeInterval: interval];
    return date;
}


-(NSDate*)setDate:(NSDate*)date withSecond:(int)second{
    NSTimeInterval seconds=second;
    date = [date dateByAddingTimeInterval: seconds];
    return date;
}

-(NSDate*)setDate:(NSDate*)date withMinute:(int)minute{
    return [self setDate:date withSecond:minute*60];
}

-(NSDate*)setDate:(NSDate*)date withHour:(int)hour{
    return [self setDate:date withMinute:hour*60];
}

-(NSDate*)setDate:(NSDate*)date withDay:(int)day{
    return [self setDate:date withHour:day*24];
}

-(NSDateComponents*)getComponentsWithDate:(NSDate*)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:date];
    return dateComponent;
}

-(int)getYearByDate:(NSDate*)date{
    NSDateComponents *dateComponent=[self getComponentsWithDate:date];
    return [dateComponent year];
}

-(int)getMonthByDate:(NSDate*)date{
    NSDateComponents *dateComponent=[self getComponentsWithDate:date];
    return [dateComponent month];
}

-(int)getDayByDate:(NSDate*)date{
    NSDateComponents *dateComponent=[self getComponentsWithDate:date];
    return [dateComponent day];
}

-(int)getHourByDate:(NSDate*)date{
    NSDateComponents *dateComponent=[self getComponentsWithDate:date];
    return [dateComponent hour];
}

-(int)getMinuteByDate:(NSDate*)date{
    NSDateComponents *dateComponent=[self getComponentsWithDate:date];
    return [dateComponent minute];
}

-(int)getSecondByDate:(NSDate*)date{
    NSDateComponents *dateComponent=[self getComponentsWithDate:date];
    return [dateComponent second];
}

-(int)getWeekByDate:(NSDate*)date{
    NSDateComponents *dateComponent=[self getComponentsWithDate:date];
    return [dateComponent weekday]-1;
}

-(int)getDaysForMonthWithDate:(NSDate*)date{
    NSCalendar *c = [NSCalendar currentCalendar];
    NSRange days = [c rangeOfUnit:NSCalendarUnitDay
                           inUnit:NSCalendarUnitMonth
                          forDate:date];
    return days.length;
}


-(void)dealloc{

}

@end
