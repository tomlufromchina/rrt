//
//  ParentsAttendanceStatisticsViewController.m
//  RenrenTong
//
//  Created by 符其彬 on 14-10-11.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "ParentsAttendanceStatisticsViewController.h"
#import "ParentAllATTStatisticsViewController.h"
#import "NetWorkManager+Attend.h"

@interface ParentsAttendanceStatisticsViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong)NetWorkManager *netWorkManager;
@property (nonatomic, assign) long long infoClassId;


@end

@implementation ParentsAttendanceStatisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.childinfo) {
        self.title = [NSString stringWithFormat:@"%@-考勤统计",[_childinfo objectForKey:@"UserName"]];
    }
    self.mainTableView.dataSource = self;
    self.mainTableView.delegate = self;
    
    //Add search button
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"查询"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(clickTrueButton)];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.netWorkManager = [[NetWorkManager alloc] init];
}

#pragma mark -- 获取学生所在的班级信息
#pragma mark --

- (void)requestData
{
    [self show];
    [self.netWorkManager GetStudentClassDetails:[[self.childinfo objectForKey:@"UserId"] intValue]
                                       success:^(NSMutableArray *data) {
                                           [self dismiss];
                                           [self gotoUpdataUI:data];
                                       } failed:^(NSString *errorMSG) {
                                           [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:errorMSG];
                                       }];
    
}

#pragma mark -- 获取学生班级Id
#pragma mark --
- (void)gotoUpdataUI:(NSMutableArray *)array
{
    self.infoClassId = [[array[0] objectForKey:@"ClassId"] longLongValue];

}

#pragma mark - Table view data source And Delegete

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"开始时间";
    } else{
        return @"截止时间";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ParentsAttendanceStatisticsCell"
                                                            forIndexPath:indexPath];

    UILabel *label = (UILabel*)[cell viewWithTag:3];
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd"];
    NSString *locationString = [dateformatter stringFromDate:[NSDate date]];
    label.text = locationString;

    UIButton *calendarBtn = (UIButton *)[cell viewWithTag:2];
    calendarBtn.tag=[indexPath section];
    [calendarBtn addTarget:self action:@selector(clickCalendarBtn:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}


- (void)showDateAlertWithTag:(int)tag {
    UIDatePicker* datepicker=[[UIDatePicker alloc] init];
    datepicker.width=SCREENWIDTH-40;
    datepicker.datePickerMode=UIDatePickerModeDate;
    datepicker.tag=2013;
    AttendAlertView* alertView=[[AttendAlertView alloc] init];
    alertView.delegate=self;
    alertView.tag=tag;
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"取消",@"确定", nil]];//添加按钮
    [alertView setContainerView:datepicker];
    [alertView show];
    
}

// Default button behaviour
- (void)customAttendAlertViewButtonTouchUpInside: (AttendAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        int tag=(int)[alertView tag];
        UIDatePicker* datepicker =(UIDatePicker*)[alertView viewWithTag:2013];
        NSDate* date=[datepicker date];
        UITableViewCell *cell=nil;
        if (tag==888) {
            //获取cell上的label
            NSIndexPath *cellPath = [NSIndexPath indexPathForItem:0 inSection:0];
            cell = (UITableViewCell*)[self.mainTableView cellForRowAtIndexPath:cellPath];
            
        }else if(tag==8888){
            //获取cell上的label
            NSIndexPath *cellPath = [NSIndexPath indexPathForItem:0 inSection:1];
            cell = (UITableViewCell*)[self.mainTableView cellForRowAtIndexPath:cellPath];
            
        }
        if (cell) {
            NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
            [dateformatter setDateFormat:@"yyyy-MM-dd"];
            NSString *locationString = [dateformatter stringFromDate:date];
            UILabel* lable=(UILabel*)[cell viewWithTag:3];
            lable.text = locationString;
        }
    }
    [alertView close];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==0) {
        [self showDateAlertWithTag:888];
    }
    if (indexPath.section==1) {
        [self showDateAlertWithTag:8888];
    }
}

#pragma mark -- 日历按钮响应
#pragma mark --

- (void)clickCalendarBtn:(UIButton *)sender
{
    if (sender.tag==0) {
        [self showDateAlertWithTag:888];
    }
    if (sender.tag==1) {
        [self showDateAlertWithTag:8888];
    }
}

#pragma mark -- 查询按钮响应
#pragma mark -- 

- (void)clickTrueButton
{
    UITableViewCell *cell=nil;
    //获取cell上的label
    NSIndexPath *cellPath = [NSIndexPath indexPathForItem:0 inSection:0];
    cell = (UITableViewCell*)[self.mainTableView cellForRowAtIndexPath:cellPath];
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd"];
    
    UILabel* lable=(UILabel*)[cell viewWithTag:3];
    NSDate* begindate=[dateformatter dateFromString:lable.text];
    //获取cell上的label
    cellPath = [NSIndexPath indexPathForItem:0 inSection:1];
    cell = (UITableViewCell*)[self.mainTableView cellForRowAtIndexPath:cellPath];
    lable=(UILabel*)[cell viewWithTag:3];
    
    NSDate* enddate=[dateformatter dateFromString:lable.text];
    
    
    NSTimeInterval secondsInterval= [enddate timeIntervalSinceDate:begindate];
    if (secondsInterval>=0) {
        [self.navigationController pushViewController:ParentATTStatisticsVCID withStoryBoard:DeskStoryBoardName withBlock:^(UIViewController *viewController){
            ParentATTStatisticsViewController *  pavc = (ParentATTStatisticsViewController *)viewController;
            pavc.begindate=begindate;
            pavc.enddate=enddate;
            pavc.childinfo=_childinfo;
        }];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"开始时间早于结束时间" message:@"你确定查询吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
        [alert addButtonWithTitle:@"确定"];
        [alert show];
    }

}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        UITableViewCell *cell=nil;
        //获取cell上的label
        NSIndexPath *cellPath = [NSIndexPath indexPathForItem:0 inSection:0];
        cell = (UITableViewCell*)[self.mainTableView cellForRowAtIndexPath:cellPath];
        NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"yyyy-MM-dd"];
        
        UILabel* lable=(UILabel*)[cell viewWithTag:3];
        NSDate* begindate=[dateformatter dateFromString:lable.text];
        //获取cell上的label
        cellPath = [NSIndexPath indexPathForItem:0 inSection:1];
        cell = (UITableViewCell*)[self.mainTableView cellForRowAtIndexPath:cellPath];
        lable=(UILabel*)[cell viewWithTag:3];
        
        NSDate* enddate=[dateformatter dateFromString:lable.text];
        [self.navigationController pushViewController:ParentATTStatisticsVCID withStoryBoard:DeskStoryBoardName withBlock:^(UIViewController *viewController){
            ParentATTStatisticsViewController *  pavc = (ParentATTStatisticsViewController *)viewController;
            pavc.begindate=begindate;
            pavc.enddate=enddate;
            pavc.childinfo=_childinfo;
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
