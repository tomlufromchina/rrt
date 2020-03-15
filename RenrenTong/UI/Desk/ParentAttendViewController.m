//
//  ParentAttendViewController.m
//  RenrenTong
//
//  Created by 唐彬 on 14-9-24.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "ParentAttendViewController.h"

@interface ParentAttendViewController ()

@end

@implementation ParentAttendViewController
AttendCalendar* ac;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *actionItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(actionClick)];
    [self.navigationItem setRightBarButtonItem:actionItem];
    self.title=@"xxx";
    ac=[[AttendCalendar alloc] initCalendar];//初始化日历
    ac.top=64;
    NSDate* date=[NSDate date];
    [ac setErrorDateState:date];//异常日期
    ac.delegate=self;
    [self.view addSubview:ac];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)selectedDate:(NSDate *)date{
    NSLog(@"%@",date);
}

- (void)directBegin:(NSDate *)begindate End:(NSDate *)enddate{
    NSLog(@"begindate%@",begindate);
    NSLog(@"enddate%@",enddate);
}

-(void)actionClick{
    NSLog(@"家长");
}



@end
