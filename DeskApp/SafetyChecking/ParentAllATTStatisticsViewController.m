//
//  ParentAllATTStatisticsViewController.m
//  RenrenTong
//
//  Created by 符其彬 on 14-10-16.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "ParentAllATTStatisticsViewController.h"
#import "NetWorkManager+Attend.h"

@interface ParentAllATTStatisticsViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, assign) long long infoClassId;
@property (nonatomic, strong) NetWorkManager *netWorkManager;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *studentDataSource;

@property (nonatomic, strong) ChildATTRecord *CAR;
@property (nonatomic, strong) StudentAttDetails *SAD;

@end

@implementation ParentAllATTStatisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"考勤统计";
    self.navigationController.navigationBar.translucent = NO;
    self.mainTableView.dataSource = self;
    self.mainTableView.delegate = self;
    self.mainTableView.top = self.backIMGView.bottom;
    self.netWorkManager = [[NetWorkManager alloc] init];
    self.dataSource = [[NSMutableArray alloc] init];
    self.studentDataSource = [[NSMutableArray alloc] init];
}

#pragma mark -- 获取学生所在的班级信息
#pragma mark --

- (void)viewWillAppear:(BOOL)animated
{
    [self show];
    [self.netWorkManager GetStudentClassDetails:[[self.infoClass objectForKey:@"UserId"] intValue]
                                        success:^(NSMutableArray *data) {
                                            [self dismiss];
                                            [self gotoUpdataUI:data];
                                        } failed:^(NSString *errorMSG) {
                                            [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:errorMSG];
                                        }];
    
}


#pragma mark -- 考勤统计数据
#pragma mark -- 

- (void)requestData
{
    [self.netWorkManager GetStudentCheckingRecords:self.infoClassId
                                            mydate:[NSString stringWithFormat:@"%@",self.beginTime]
                                            userid:[[self.infoClass objectForKey:@"UserId"] intValue]
                                           success:^(NSMutableArray *data) {
                                               [self dismiss];
                                               [self updateUI:data];
                                               
        
    } failed:^(NSString *errorMSG) {
        [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:errorMSG];
        
    }];
    
}

#pragma mark -- 刷新界面
#pragma mark -- 

- (void)updateUI:(NSMutableArray *)array
{
    for (int i = 0; i < [array count]; i ++) {
        self.CAR = array[i];
        
        [self.dataSource addObject:self.CAR];
        [self.studentDataSource addObject:self.CAR.myAttendanceList];
        
        self.SAD = self.studentDataSource[0][i];// 二维数组
        if (self.SAD.dtype == 0) {
            UILabel *zcLabel = (UILabel *)[self.view viewWithTag:7];
            zcLabel.text = [NSString stringWithFormat:@"%d次",self.SAD.count];
        } else if (self.SAD.dtype == 1){
            UILabel *cdLabel = (UILabel *)[self.view viewWithTag:8];
            cdLabel.text = [NSString stringWithFormat:@"%d次",self.SAD.count];
        } else if (self.SAD.dtype == 2){
            UILabel *ztLabel = (UILabel *)[self.view viewWithTag:9];
            ztLabel.text = [NSString stringWithFormat:@"%d次",self.SAD.count];
        } else{
            UILabel *noCard = (UILabel *)[self.view viewWithTag:10];
            noCard.text = [NSString stringWithFormat:@"%d次",self.SAD.count];
        }
        
    }
    [self.mainTableView reloadData];
    
}

#pragma mark -- 获取学生班级Id
#pragma mark --
- (void)gotoUpdataUI:(NSMutableArray *)array
{
    self.infoClassId = [[array[0] objectForKey:@"ClassId"] longLongValue];
    [self requestData];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.studentDataSource count];
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ParentAllATTStatisticsCell"
                                                            forIndexPath:indexPath];
    UIImageView *imageView1 = (UIImageView *)[cell viewWithTag:1];//正常
    UIImageView *imageView2 = (UIImageView *)[cell viewWithTag:2];//迟到
    UIImageView *imageView3 = (UIImageView *)[cell viewWithTag:3];//早退
    UIImageView *imageView4 = (UIImageView *)[cell viewWithTag:4];//未刷卡
    UILabel *label = (UILabel *)[cell viewWithTag:5];
    
    self.SAD = [self.studentDataSource[0] objectAtIndex:indexPath.row];
    if (self.SAD.dtype == 0) {
        imageView1.hidden = NO;
        imageView2.hidden = YES;
        imageView3.hidden = YES;
        imageView4.hidden = YES;
        label.text = self.SAD.Memo;
    } else if (self.SAD.dtype == 1){
        imageView1.hidden = YES;
        imageView2.hidden = NO;
        imageView3.hidden = YES;
        imageView4.hidden = YES;
        label.text = self.SAD.Memo;
    } else if (self.SAD.dtype == 2){
        imageView1.hidden = YES;
        imageView2.hidden = YES;
        imageView3.hidden = NO;
        imageView4.hidden = YES;
        label.text = self.SAD.Memo;
    } else if (self.SAD.dtype == 3){
        imageView1.hidden = YES;
        imageView2.hidden = YES;
        imageView3.hidden = YES;
        imageView4.hidden = NO;
        label.text = self.SAD.Memo;
    }
    
    return cell;
}

- (void)viewWillDisappear:(BOOL)animated{
    [self dismiss];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
