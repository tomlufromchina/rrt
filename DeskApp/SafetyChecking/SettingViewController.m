//
//  SettingViewController.m
//  RenrenTong
//
//  Created by 符其彬 on 14-9-25.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "SettingViewController.h"
#import "NetWorkManager+Attend.h"


@interface SettingViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>
@property (nonatomic, strong) NetWorkManager *netWorkManger;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *exceptionallyArray;
@property (nonatomic, strong) CheckingForTeachers *CFT;
@property (nonatomic, strong) TodayAttendance *TA;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    
    self.mainTableView.dataSource = self;
    self.mainTableView.delegate = self;
    [self.mainTableView setSeparatorColor:appColor];
    self.netWorkManger = [[NetWorkManager alloc] init];
    self.dataSource = [[NSMutableArray alloc] init];
    self.exceptionallyArray = [[NSMutableArray alloc] init];
    //Add search button
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"保存"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(clickTrueButton)];
    self.navigationItem.rightBarButtonItem = rightItem;
    [self requestData];
}

- (void)requestData
{
    [self show];
    
    [self.netWorkManger getCheckingOfTearchs:[RRTManager manager].loginManager.loginInfo.tokenId
                                   teacherId:[RRTManager manager].loginManager.loginInfo.userId
                                     success:^(NSMutableArray *data) {
                                         [self dismiss];
                                         [self gotoUpdataUI:data];
        
    } failed:^(NSString *errorMSG) {
        [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:errorMSG];
        
    }];
    
    //获取当前时间
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    NSString *locationString=[dateformatter stringFromDate:[NSDate date]];
    
    [self.netWorkManger todayAttendance:[RRTManager manager].loginManager.loginInfo.userId
                                 mydate:locationString
                                success:^(NSMutableArray *data) {
                                    [self dismiss];
                                    [self UpdataUI:data];
                                } failed:^(NSString *errorMSG) {
                                    [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:errorMSG];
                                }];
}

- (void)gotoUpdataUI:(NSMutableArray *)array
{
    if (array) {
        for (int i = 0; i < [array count]; i ++) {
            self.CFT = array[i];
            [self.dataSource addObject:self.CFT];
        }
        [self.mainTableView reloadData];
    }
}

- (void)UpdataUI:(NSMutableArray *)array
{
    if (array) {
        for (int i = 0; i < [array count]; i ++) {
            self.TA = array[i];
            [self.exceptionallyArray addObject:self.TA];
        }
        
    }
}

#pragma mark -- 确定按钮点击响应
#pragma mark -- （将数据存储到本地）

- (void)clickTrueButton
{
    
    if (cft && ta) {
        NSUserDefaults* nud=[NSUserDefaults standardUserDefaults];
        
        [nud setBool:YES forKey:[NSString stringWithFormat:@"%@issettingid",[RRTManager manager].loginManager.loginInfo.userId]];
        NSMutableDictionary* dic=[[NSMutableDictionary alloc] init];
        int WSKInteger = ta.noRecordNum;
        int CDInteger = ta.cidaoNum;
        int ZTInteger = ta.zaotuiNum;
        // 将考勤首页的数据结构存储到本地
        [dic setObject:[NSNumber numberWithLongLong:cft.ClassId] forKey:@"ClassId"];
        [dic setObject:[NSNumber numberWithInt:cft.gradeId] forKey:@"gradeId"];
        [dic setObject:[NSNumber numberWithInt:cft.schoolId] forKey:@"schoolId"];
        [dic setObject:[NSNumber numberWithInt:cft.studentCount] forKey:@"studentCount"];
        [dic setObject:[NSNumber numberWithInt:cft.memberCount] forKey:@"memberCount"];
        [dic setObject:[NSNumber numberWithInt:cft.classType] forKey:@"classType"];
        [dic setObject:[NSNumber numberWithInt:cft.masterAccount] forKey:@"masterAccount"];
        [dic setObject:[NSNumber numberWithInt:cft.classSubjectType] forKey:@"classSubjectType"];
        [dic setObject:[NSNumber numberWithInt:cft.statusId] forKey:@"statusId"];
        [dic setObject:[NSNumber numberWithInt:cft.masterId] forKey:@"masterId"];
        [dic setObject:cft.classAlias forKey:@"classAlias"];
        //存储数据
        [nud setObject:dic forKey:[NSString stringWithFormat:@"%@issettingclassinfo",[RRTManager manager].loginManager.loginInfo.userId]];
        
        [nud setInteger:WSKInteger forKey:@"WSKInteger"];
        [nud setInteger:CDInteger forKey:@"CDInteger"];
        [nud setInteger:ZTInteger forKey:@"ZTInteger"];
        if (self.delegate) {
            if ([self.delegate respondsToSelector:@selector(issettinged)]) {
                [self.delegate performSelector:@selector(issettinged)];
            }
        }
        [nud synchronize];
        [self performSelector:@selector(back) withObject:nil afterDelay:0.7f];
    } else {
        //cft为nil的情况，没有给其赋值
        [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"请选择默认班级"];

    }
    
}

- (void)back
{
    [self showImage:[UIImage imageNamed:@"confirm-ok72.png"] status:@"设置成功"];

    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source And Delegete

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
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
    return @"设置默认班级考勤";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingCell"
                                                            forIndexPath:indexPath];
//    UILabel *label = (UILabel*)[cell viewWithTag:1];
//    self.CFT = [self.dataSource objectAtIndex:indexPath.row];
//    label.text = self.CFT.classAlias;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (!self.dataSource) {
        [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"未加入任何班级"];

        return;
    }
    UIActionSheet* sheet=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    for(int i=0;i<[self.dataSource count];i++)
    {
        CheckingForTeachers* temp = [self.dataSource objectAtIndex:i];
        NSString *str = temp.classAlias;
        [sheet addButtonWithTitle:str];
    }
    [sheet addButtonWithTitle:@"取消"];
    sheet.cancelButtonIndex = [self.dataSource count];
    [sheet showInView:self.view];
    
}

#pragma mark -- UIActionSheetDelegate
#pragma mark --

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex<[self.dataSource count]) {
        //获取cell上的label
        NSIndexPath *cellPath = [NSIndexPath indexPathForItem:0 inSection:0];
        UITableViewCell *cell = [self.mainTableView cellForRowAtIndexPath:cellPath];
        if (cell) {
            UILabel *label = (UILabel*)[cell viewWithTag:1];
            //给cft赋值
            cft = [self.dataSource objectAtIndex:buttonIndex];
            if (self.exceptionallyArray && [self.exceptionallyArray count] >0) {
                int tempindex=[self.exceptionallyArray count]-1-buttonIndex;
                
                ta = [self.exceptionallyArray objectAtIndex:tempindex];
                label.text = cft.classAlias;
                label.tag = 1;
            } else{
                [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"设置失败！"];
            }
        }
    }
    NSLog(@"buttonIndex:%d",buttonIndex);
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self dismiss];
}

@end
