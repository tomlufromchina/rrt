//
//  AttendStatisticsRSViewController.m
//  RenrenTong
//
//  Created by 唐彬 on 14-9-26.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "AttendStatisticsRSViewController.h"

@interface AttendStatisticsRSViewController ()

@end

@implementation AttendStatisticsRSViewController


- (void)viewDidLoad {
    networkmanager=[[NetWorkManager alloc] init];
    [super viewDidLoad];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                 style:UIBarButtonItemStylePlain
                                                                target:nil
                                                                action:nil];
    [self.navigationItem setBackBarButtonItem:backItem];
    self.title=@"统计结果";
    self.wskdata=nil;//未刷卡
    self.ycdata=nil;//异常
     zcdata=0;//正常
    self.tabview.delegate = self;
    self.tabview.dataSource = self;
    [self.tabview setSeparatorColor:appColor];
    [self requestData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -- 数据请求
#pragma mark --
- (void)requestData
{
     wskflag=NO;
     ycflag=NO;
     zcflag=NO;
    [self show];
    [networkmanager noSwipingCardNumber:_classid
                            mybegindate:_begintime
                              myenddate:_endtime
                               UserType:_UserType
                                success:^(NSMutableArray *data) {
        self.wskdata=data;
        wskflag=YES;
        [self gotoUpdataUI];
    } failed:^(NSString *errorMSG) {
        wskflag=YES;
        [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"未刷卡"];
    }];
    
    [networkmanager YCAttendance:_classid
                     mybegindate:_begintime
                       myenddate:_endtime
                        UserType:_UserType
                         success:^(NSMutableArray *data) {
        self.ycdata=data;
        ycflag=YES;
        [self gotoUpdataUI];
    } failed:^(NSString *errorMSG) {
        ycflag=YES;
        [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"未刷卡"];
    }];
    
    [networkmanager ZCAttendance:_classid
                     mybegindate:_begintime
                       myenddate:_endtime
                        UserType:_UserType
                         success:^(int data) {
        zcdata=data;
        zcflag=YES;
        [self gotoUpdataUI];
    } failed:^(NSString *errorMSG) {
        zcflag=YES;
        [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"未刷卡"];
    }];
}

-(void)gotoUpdataUI{
    if (wskflag&&ycflag&&zcflag) {
        [self.tabview reloadData];
        [self dismiss];
    }

}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 50;
    }else{
        return 30;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 4;
            break;
        default:
            return 0;
            break;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"考勤正常统计";
            break;
        case 1:
            return @"考勤异常统计";
            break;
        default:
            return @"";
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //指定cellIdentifier为自定义的cell
    static NSString *CellIdentifier = @"attsvrsCell";
    //自定义cell类
    AttendsvrsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        //通过xib的名称加载自定义的cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"AttendsvrsTableViewCell" owner:self options:nil] lastObject];
    }
    if (indexPath.section==0) {
        cell.users.hidden=YES;
        cell.title.text=@"考勤正常";
        cell.times.text=[NSString stringWithFormat:@"%i次",zcdata];
    }else{
        cell.users.hidden=NO;
    }
    if (indexPath.section==1) {
        cell.times.text=[NSString stringWithFormat:@"%i次",0];
        if (indexPath.row==0) {
            cell.img.image=[UIImage imageNamed:@"考勤-异常"];
            cell.title.text=@"考勤异常";
            NSString* users=@"";
            if (self.ycdata) {
                for (ClassNoSwipingCardNumber *cnsc in self.ycdata) {
                    if ([users length]>0) {
                        users=[NSString stringWithFormat:@"%@、%@",users,cnsc.PopMemo];
                    }else{
                        users=cnsc.PopMemo;
                    }
                }
                cell.times.text=[NSString stringWithFormat:@"%i次",[self.ycdata count]];
                cell.users.text=[NSString stringWithFormat:@"%@等%i人",users,[self.ycdata count]];
            }
        }
        // dtype = 1：c迟到
        if (indexPath.row==1) {
            cell.img.image=[UIImage imageNamed:@"迟到"];
            cell.title.text=@"迟到";
            NSString* users=@"";
            if (self.ycdata) {
                int peps=0;
                int times=0;
                for (ClassNoSwipingCardNumber *cnsc in self.ycdata) {
                    if (cnsc.dType==1) {
                        if ([users length]>0) {
                            users=[NSString stringWithFormat:@"%@、%@",users,cnsc.PopMemo];
                        }else{
                            users=cnsc.PopMemo;
                        }
                        peps+=cnsc.PopNum;
                        times+=cnsc.Num;
                    }
                }
                cell.times.text=[NSString stringWithFormat:@"%i次",times];
                cell.users.text=[NSString stringWithFormat:@"%@等%i人",users,peps];
            }
        }
        // 早退
        if (indexPath.row==2) {
            cell.img.image=[UIImage imageNamed:@"早退"];
            cell.title.text=@"早退";
            NSString* users=@"";
            if (self.ycdata) {
                int times=0;
                int peps=0;
                for (ClassNoSwipingCardNumber *cnsc in self.ycdata) {
                    if (cnsc.dType==2) {
                        if ([users length]>0) {
                            users=[NSString stringWithFormat:@"%@、%@",users,cnsc.PopMemo];
                        }else{
                            users=cnsc.PopMemo;
                        }
                        peps+=cnsc.PopNum;
                        times+=cnsc.Num;
                    }
                }
                cell.times.text=[NSString stringWithFormat:@"%i次",times];
                cell.users.text=[NSString stringWithFormat:@"%@等%i人",users,peps];
            }
        }
        if (indexPath.row==3) {
            cell.img.image=[UIImage imageNamed:@"未到校"];
            cell.title.text=@"未刷卡";
            NSString* users=@"";
            if (self.wskdata) {
                int times=0;
                int peps=0;
                for (ClassNoSwipingCardNumber *cnsc in self.wskdata) {
                    if ([users length]>0) {
                        users=[NSString stringWithFormat:@"%@、%@",users,cnsc.PopMemo];
                    }else{
                        users=cnsc.PopMemo;
                    }
                    peps+=cnsc.PopNum;
                    times+=cnsc.Num;
                }
                cell.times.text=[NSString stringWithFormat:@"%i次",times];
                cell.users.text=[NSString stringWithFormat:@"%@等%i人",users,peps];
            }
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==1) {
        AttendStatisticsLSViewController* assc=[[AttendStatisticsLSViewController alloc] init];
        assc.type=indexPath.row;
        if (indexPath.row==0) {
            assc.data=self.ycdata;
        }
        if (indexPath.row==1) {
            assc.data=self.ycdata;
        }
        if (indexPath.row==2) {
            assc.data=self.ycdata;
        }
        if (indexPath.row==3) {
            assc.data=self.wskdata;
        }
        [self.navigationController pushViewController:assc animated:YES];
    }
}


- (void)viewDidAppear:(BOOL)animated
{
    self.hidesBottomBarWhenPushed = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.hidesBottomBarWhenPushed = YES;
    [self dismiss];
}

@end
