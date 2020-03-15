//
//  TodayAttendanceViewController.m
//  RenrenTong
//
//  Created by 符其彬 on 14-9-26.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "TodayAttendanceViewController.h"
#import "AttendanceRecordViewController.h"
#import "NetWorkManager+Attend.h"

@interface TodayAttendanceViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NetWorkManager *netWorkManager;
@property (nonatomic, strong) TodayAttendance *TA;

@end

@implementation TodayAttendanceViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"今日考勤";
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.backgroundColor = [UIColor whiteColor];
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.dataSource = [[NSMutableArray alloc] init];
    self.netWorkManager = [[NetWorkManager alloc] init];
    [self requestData];

}

#pragma mark -- 网络请求数据
#pragma mark -- 

- (void)requestData
{
    //获取当前时间
    NSDate *senddate=[NSDate date];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd"];
    NSString *locationString=[dateformatter stringFromDate:senddate];
    [self show];
    [self.netWorkManager todayAttendance:[RRTManager manager].loginManager.loginInfo.userId
                                  mydate:locationString
                                 success:^(NSMutableArray *data) {
                                     [self dismiss];
                                     [self gotoUpdataUI:data];
    } failed:^(NSString *errorMSG) {
        [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:errorMSG];
    }];
}

- (void)gotoUpdataUI:(NSMutableArray *)array
{
    if (array) {
        for (int i = 0; i < [array count]; i ++) {
            self.TA = array[i];
            [self.dataSource addObject:self.TA];
        }
    } else {
        [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"加载失败..."];

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
    return [self.dataSource count];
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TodayAttendanceCell"
                                                            forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;//小箭头
    
    if (indexPath.row % 2 == 0) {
        cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
    } else {
        cell.backgroundColor = [UIColor whiteColor];
    }
    self.TA = [self.dataSource objectAtIndex:indexPath.row];
    UILabel *className = (UILabel *)[cell viewWithTag:1];
    UILabel *bossName = (UILabel *)[cell viewWithTag:2];
    UILabel *lateNumber = (UILabel *)[cell viewWithTag:3];
    UILabel *earlyNumber = (UILabel *)[cell viewWithTag:4];
    UILabel *noRecordNumber = (UILabel *)[cell viewWithTag:5];
    
    className.text = self.TA.ClassName;
    bossName.text = self.TA.MasterName;
    lateNumber.text = [NSString stringWithFormat:@"%d人",self.TA.cidaoNum];
    earlyNumber.text = [NSString stringWithFormat:@"%d人",self.TA.zaotuiNum];
    noRecordNumber.text = [NSString stringWithFormat:@"%d人",self.TA.noRecordNum];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.TA = [self.dataSource objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:AttendanceRecordVCID withStoryBoard:DeskStoryBoardName withBlock:^(UIViewController *viewController) {
        AttendanceRecordViewController *VC = (AttendanceRecordViewController *)viewController;
        VC.titleName = self.TA.ClassName;
        VC.todayData = self.TA.mydate;
        VC.lassId = self.TA.ClassId;
    }];
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
