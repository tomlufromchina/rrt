
//  AttendanceRecordDetailsViewController.m
//  RenrenTong
//
//  Created by 符其彬 on 14-9-26.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "AttendanceRecordDetailsViewController.h"
#import "NetWorkManager+Attend.h"

@interface AttendanceRecordDetailsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NetWorkManager *netWorkManager;
@property (nonatomic, strong) NSMutableArray *studentATTDetailsDataSource;
@property (nonatomic, strong) StudentAttDetails *SAD;
@property (nonatomic, strong) NSArray *unusualArray;

@end

@implementation AttendanceRecordDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.title = [NSString stringWithFormat:@"%@的考勤记录",self.subTitle];
    
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    [self.mainTableView setSeparatorColor:appColor];
    
    self.studentATTDetailsDataSource = [[NSMutableArray alloc] init];
    self.netWorkManager = [[NetWorkManager alloc] init];
    self.unusualArray = [[NSArray alloc] init];
    
    //获取当前时间
    NSDate *senddate=[NSDate date];
    NSDateFormatter *dateformatter= [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd"];
    NSString *locationString = [dateformatter stringFromDate:senddate];
    self.currentData.text = locationString;
    
    [self requestData:self.currentData.text];
    

}

#pragma mark -- 网络请求数据
#pragma mark --
- (void)requestData:(NSString *)date
{
    [self show];
    [self.netWorkManager otherStudentsAttenanceDetails:self.classId
                                                mydate:date
                                                userid:[NSString stringWithFormat:@"%d",self.userId]
                                              username:self.subTitle
                                               success:^(NSMutableArray *data) {
        [self dismiss];
        [self gotoUpdataUI:data];
    } failed:^(NSString *errorMSG) {
        [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:errorMSG];
    }];
}

#pragma mark -- 刷新界面
#pragma mark -- 

- (void)gotoUpdataUI:(NSMutableArray *)array
{
    if (array) {
        for (int i =0; i < [array count]; i ++) {
            self.SAD = array[i];
            if (self.SAD.dtype == 0) {
                UILabel *zcLabel = (UILabel *)[self.view viewWithTag:7];
                zcLabel.text = [NSString stringWithFormat:@"%d",self.SAD.count];
            } else if (self.SAD.dtype == 1){
                UILabel *cdLabel = (UILabel *)[self.view viewWithTag:8];
                cdLabel.text = [NSString stringWithFormat:@"%d",self.SAD.count];
            } else if (self.SAD.dtype == 2){
                UILabel *ztLabel = (UILabel *)[self.view viewWithTag:9];
                ztLabel.text = [NSString stringWithFormat:@"%d",self.SAD.count];
            } else{
                UILabel *noCard = (UILabel *)[self.view viewWithTag:10];
                noCard.text = [NSString stringWithFormat:@"%d",self.SAD.count];
            }
            [self.studentATTDetailsDataSource addObject:self.SAD];
            self.unusualArray = [_SAD.Memo componentsSeparatedByString:@","];
        }
        [self.mainTableView reloadData];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.unusualArray count];
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AttendanceRecordDetailsCell"
                                                            forIndexPath:indexPath];
    
    UIImageView *imageView1 = (UIImageView *)[cell viewWithTag:1];// 正常
    UIImageView *imageView2 = (UIImageView *)[cell viewWithTag:2];// 迟到
    UIImageView *imageView3 = (UIImageView *)[cell viewWithTag:3];// 早退
    UIImageView *imageView4 = (UIImageView *)[cell viewWithTag:4];// 未到校
    UILabel *label1 = (UILabel *)[cell viewWithTag:5];
    self.SAD = [self.studentATTDetailsDataSource objectAtIndex:0];
    if (self.SAD.dtype == 0) {
        imageView1.hidden = NO;
        imageView2.hidden = YES;
        imageView3.hidden = YES;
        imageView4.hidden = YES;
        label1.text = [self.unusualArray objectAtIndex:indexPath.row];
    } else if (self.SAD.dtype == 1){
        imageView1.hidden = YES;
        imageView2.hidden = NO;
        imageView3.hidden = YES;
        imageView4.hidden = YES;
        label1.text = [self.unusualArray objectAtIndex:indexPath.row];
    } else if (self.SAD.dtype == 2){
        imageView1.hidden = YES;
        imageView2.hidden = YES;
        imageView3.hidden = NO;
        imageView4.hidden = YES;
        label1.text = [self.unusualArray objectAtIndex:indexPath.row];
    } else if (self.SAD.dtype == 3){
        imageView1.hidden = YES;
        imageView2.hidden = YES;
        imageView3.hidden = YES;
        imageView4.hidden = NO;
        label1.text = [self.unusualArray objectAtIndex:indexPath.row];
    }
    return cell;
 
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark -- 日历按钮点击响应
#pragma mark --
- (IBAction)clickCalendarButton:(UIButton *)sender
{
    [self showDateAlertView:103];
}

#pragma mark -- ShowAlertView
#pragma mark --
- (void)showDateAlertView:(int)tag
{
    UIDatePicker* myDatePicker = [[UIDatePicker alloc] init];
    myDatePicker.width = SCREENWIDTH - 40;
    myDatePicker.datePickerMode = UIDatePickerModeDate;
    myDatePicker.tag = 102;
    AttendAlertView *alertView = [[AttendAlertView alloc] init];
    alertView.delegate = self;
    alertView.tag = tag;
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"取消",@"确定", nil]];//添加按钮
    [alertView setContainerView:myDatePicker];
    
    [alertView show];
}

#pragma mark -- AttendAlertView_DelegeteMethods
#pragma mark --
- (void)customAttendAlertViewButtonTouchUpInside: (AttendAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView tag] == 103) {
        if (buttonIndex == 1) {
            UIDatePicker* datepicker = (UIDatePicker*)[alertView viewWithTag:102];
            NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            NSString * dateString = [formatter stringFromDate:datepicker.date];
            self.currentData.text = dateString;
            [self.studentATTDetailsDataSource removeAllObjects];
            [self requestData:self.currentData.text];
        }
    }
    [alertView close];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self dismiss];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
