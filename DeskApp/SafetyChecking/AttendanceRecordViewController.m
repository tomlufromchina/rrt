//
//  AttendanceRecordViewController.m
//  RenrenTong
//
//  Created by 符其彬 on 14-9-26.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "AttendanceRecordViewController.h"
#import "AttendanceRecordDetailsViewController.h"
#import "NetWorkManager+Attend.h"

@interface AttendanceRecordViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NetWorkManager *netWorkManager;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *studentDataSource;// 学生列表基本信息
@property (nonatomic, strong) NSMutableArray *studentATTDetails;// 学生考勤情况

@property (nonatomic, strong) ClassAttendance *CA;
@property (nonatomic, strong) StudentAttList *SAL;// 学生列表基本信息
@property (nonatomic, strong) StudentAttDetails *SAD;// 学生考勤情况

@end

@implementation AttendanceRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.title = self.titleName;
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    [self.mainTableView setSeparatorColor:appColor];
    
    self.netWorkManager = [[NetWorkManager alloc] init];
    self.dataSource = [[NSMutableArray alloc] init];
    self.studentDataSource = [[NSMutableArray alloc]
                              init];
    self.studentATTDetails = [[NSMutableArray alloc] init];
    
    //获取当前时间
    NSDate *senddate=[NSDate date];
    NSDateFormatter *dateformatter= [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd"];
    NSString *locationString = [dateformatter stringFromDate:senddate];
    self.currentData.text = locationString;
    
    [self requestData:self.currentData.text];
}


#pragma mark -- 数据请求
#pragma mark --
- (void)requestData:(NSString *)date
{
    
    [self show];
    [self.netWorkManager classAttendanceDetails:self.lassId
                                         mydate:self.currentData.text
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
    [self.studentDataSource removeAllObjects];
    [self.dataSource removeAllObjects];
    [self.studentATTDetails removeAllObjects];
    self.CA = array[0];
    [self.dataSource addObject:self.CA];
    [self.studentDataSource addObject:self.CA.UserAttListArray];
    NSLog(@"%@",self.CA.UserAttListArray);
    [self.studentATTDetails addObject:self.CA.myAttendanceListArray];
    UILabel *lateNumber = (UILabel *)[self.view viewWithTag:2];
    UILabel *earlyNumber = (UILabel *)[self.view viewWithTag:3];
    UILabel *leaveSCNumber = (UILabel *)[self.view viewWithTag:4];
    UILabel *zhengChang = (UILabel *)[self.view viewWithTag:5];
    lateNumber.text = [NSString stringWithFormat:@"%d人",self.CA.cidaoNum];
    earlyNumber.text = [NSString stringWithFormat:@"%d人",self.CA.zaotuiNum];
    leaveSCNumber.text = [NSString stringWithFormat:@"%d人",self.CA.noRecordNum];
    if (!self.CA.zhengchangNum) {
        
        zhengChang.text = [NSString stringWithFormat:@"%d人",self.CA.zhengchangNum];
    }else{
        zhengChang.text = @"0";
    }
    
    [self.mainTableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.CA.UserAttListArray count];
    
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AttendanceRecordCell"
                                                            forIndexPath:indexPath];
    
    UILabel *studentName = (UILabel *)[cell viewWithTag:3];
    UIImageView *unusualImageView = (UIImageView *)[cell viewWithTag:1];
    UIImageView *usualImageView = (UIImageView *)[cell viewWithTag:2];
    UIImageView *lateImageView = (UIImageView *)[cell viewWithTag:4];
    UIImageView *leaveImageView = (UIImageView *)[cell viewWithTag:5];
    UIImageView *notImageView = (UIImageView *)[cell viewWithTag:6];
    UIImageView *vacateImageView = (UIImageView *)[cell viewWithTag:7];

    self.SAL = [self.studentDataSource[0] objectAtIndex:indexPath.row];
    self.SAD = [self.studentATTDetails[0] objectAtIndex:indexPath.row];
    studentName.text = self.SAL.UserName;
    
    if (self.SAD.dtype != 0) {
        
        unusualImageView.hidden = NO;
        usualImageView.hidden = YES;
        if (self.SAD.dtype == 1){
            // 迟到
            lateImageView.hidden = NO;
            leaveImageView.hidden = YES;
            notImageView.hidden = YES;
            vacateImageView.hidden = YES;
        } else if (self.SAD.dtype == 2){
            // 早退
            lateImageView.hidden = YES;
            leaveImageView.hidden = NO;
            notImageView.hidden = YES;
            vacateImageView.hidden = YES;
            
            
        } else if (self.SAD.dtype == 3){
            // 未打卡
            lateImageView.hidden = YES;
            leaveImageView.hidden = YES;
            notImageView.hidden = NO;
            vacateImageView.hidden = YES;
            
        } else{
            // 请假
            lateImageView.hidden = YES;
            leaveImageView.hidden = YES;
            notImageView.hidden = YES;
            vacateImageView.hidden = YES;
        }
    } else {
        unusualImageView.hidden = YES;
        usualImageView.hidden = NO;
        lateImageView.hidden = YES;
        leaveImageView.hidden = YES;
        notImageView.hidden = YES;
        vacateImageView.hidden = YES;
    }
        return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController pushViewController:AttendanceRecordDetailsVCID
                                   withStoryBoard:DeskStoryBoardName
                                        withBlock:^(UIViewController *viewController) {
        AttendanceRecordDetailsViewController *VC = (AttendanceRecordDetailsViewController *)viewController;
        self.SAL = [self.studentDataSource[0] objectAtIndex:indexPath.row];
        self.SAD = [self.studentATTDetails[0] objectAtIndex:indexPath.row];
        VC.classId = self.SAL.ClassId;
        VC.subTitle = self.SAL.UserName;
        VC.userId = self.SAL.UserId;
    }];
    
}
#pragma mark -- 点击日历按钮响应事件
#pragma mark --
- (IBAction)clickCalendarButton:(UIButton *)sender {
    
    [self showDateAlertView:103];
}

#pragma mark -- ShowAlertView
#pragma mark --
- (void)showDateAlertView:(int)tag
{
    UIDatePicker* myDatePicker= [[UIDatePicker alloc] init];
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
    if ([alertView tag]==103) {
        if (buttonIndex==1) {
            UIDatePicker* datepicker =(UIDatePicker*)[alertView viewWithTag:102];
            NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            NSString * dateString = [formatter stringFromDate:datepicker.date];
            self.currentData.text = dateString;
            [self.studentDataSource removeAllObjects];
            [self.dataSource removeAllObjects];
            [self.studentATTDetails removeAllObjects];
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
