//
//  ParentATTStatisticsViewController.m
//  RenrenTong
//
//  Created by 符其彬 on 14-10-11.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "ParentATTStatisticsViewController.h"
#import "NetWorkManager+Attend.h"

@interface ParentATTStatisticsViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NetWorkManager *netWorkManager;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSArray *unusualStudentCount;

@end

@implementation ParentATTStatisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.mainTableView.dataSource = self;
    self.mainTableView.delegate = self;
    if (self.childinfo) {
        self.title = [NSString stringWithFormat:@"%@-考勤统计",[_childinfo objectForKey:@"UserName"]];
    }
    self.netWorkManager = [[NetWorkManager alloc] init];
    self.dataSource = [[NSMutableArray alloc] init];
    self.unusualStudentCount = [[NSArray alloc] init];
    [self requestData];

}

#pragma mark -- 数据解析
#pragma mark -- 

- (void)requestData
{
    [self show];
   
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *beginStr = [dateFormatter stringFromDate:self.begindate];
    NSString *endStr = [dateFormatter stringFromDate:self.enddate];
    
    [self.netWorkManager CertainTimeAttendanceDetails:[[self.childinfo objectForKey:@"UserId"] intValue]
                                          mybegindate:beginStr
                                            myenddate:endStr
                                              success:^(NSMutableArray *data) {
        [self dismiss];
        [self gotoUpateUI:data];
        
    } failed:^(NSString *errorMSG) {
        [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:errorMSG];
    }];
}

#pragma mark -- 刷新界面
#pragma mark -- 

- (void)gotoUpateUI:(NSMutableArray *)array
{
    NSLog(@"%@",array);
    self.dataSource=array;
    int zc=0;
    int cd=0;
    int zt=0;
    int no=0;
    if (array && [array count] > 0) {
        for (int i = 0 ; i < [array count]; i ++) {
            ChildATTRecord * CAR=[array objectAtIndex:i];
            for (int j = 0 ; j < [CAR.myAttendanceList count]; j ++) {
                StudentAttDetails *SAD =[CAR.myAttendanceList objectAtIndex:j];
                if (SAD.dtype == 0) {
                    zc = SAD.count;
                } else if (SAD.dtype == 1){
                    cd= SAD.count;
                } else if (SAD.dtype == 2){
                    zt= SAD.count;
                } else{
                    no= SAD.count;
                }
                
                self.unusualStudentCount = [SAD.Memo componentsSeparatedByString:@","];
            }
        }
    }
    
    UILabel *zcLabel = (UILabel *)[self.view viewWithTag:7];
    zcLabel.text = [NSString stringWithFormat:@"%d次",zc];
    UILabel *cdLabel = (UILabel *)[self.view viewWithTag:8];
    cdLabel.text = [NSString stringWithFormat:@"%d次",cd];
    UILabel *ztLabel = (UILabel *)[self.view viewWithTag:9];
    ztLabel.text = [NSString stringWithFormat:@"%d次",zt];
    UILabel *noCard = (UILabel *)[self.view viewWithTag:10];
    noCard.text = [NSString stringWithFormat:@"%d次",no];
    [self.mainTableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.unusualStudentCount count];
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ParentATTStatisticsCell"
                                                            forIndexPath:indexPath];
    UIImageView *imageView1 = (UIImageView *)[cell viewWithTag:1];//正常
    UIImageView *imageView2 = (UIImageView *)[cell viewWithTag:2];//迟到
    UIImageView *imageView3 = (UIImageView *)[cell viewWithTag:3];//早退
    UIImageView *imageView4 = (UIImageView *)[cell viewWithTag:4];//未刷卡
    UILabel *label = (UILabel *)[cell viewWithTag:5];
    if (self.dataSource && [self.dataSource count] > 0) {
        ChildATTRecord * CAR=[self.dataSource objectAtIndex:0];
        StudentAttDetails *SAD =[CAR.myAttendanceList objectAtIndex:0];
        if (SAD.dtype == 0) {
            imageView1.hidden = NO;
            imageView2.hidden = YES;
            imageView3.hidden = YES;
            imageView4.hidden = YES;
            label.text = [self.unusualStudentCount objectAtIndex:indexPath.row];
        } else if (SAD.dtype == 1){
            imageView1.hidden = YES;
            imageView2.hidden = NO;
            imageView3.hidden = YES;
            imageView4.hidden = YES;
            label.text = [self.unusualStudentCount objectAtIndex:indexPath.row];
        } else if (SAD.dtype == 2){
            imageView1.hidden = YES;
            imageView2.hidden = YES;
            imageView3.hidden = NO;
            imageView4.hidden = YES;
            label.text = [self.unusualStudentCount objectAtIndex:indexPath.row];
        } else if (SAD.dtype == 3){
            imageView1.hidden = YES;
            imageView2.hidden = YES;
            imageView3.hidden = YES;
            imageView4.hidden = NO;
            label.text = [self.unusualStudentCount objectAtIndex:indexPath.row];
        }
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self dismiss];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
