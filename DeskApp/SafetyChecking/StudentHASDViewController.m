//
//  StudentHASDViewController.m
//  RenrenTong
//
//  Created by 唐彬 on 15-4-28.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "StudentHASDViewController.h"
#import "MessageCell.h"
#import "MJRefresh.h"
#import "MJExtension.h"
#import "ReceiveMessage.h"

@interface StudentHASDViewController ()

@end

@implementation StudentHASDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"家校消息";
    pageindex=1;
    pagesize=20;
    self.tableview.delegate=self;
    self.tableview.dataSource=self;
    self.messageData = [NSMutableArray array];
    self.netWorkManager = [[NetWorkManager alloc] init];
    [self getMessageData];
    [self setupRefresh];
}


- (void)getMessageData
{
    [self show];
    [self.netWorkManager getStudentHomeAndSchoolMessage:[RRTManager manager].loginManager.loginInfo.userId pageSize:pagesize pageIndex:pageindex success:^(NSDictionary *data) {
        pageindex=1;
        NSLog(@"%@",data);
        [self processData:data];
        [self dismiss];
    } failed:^(NSString *errorMSG) {
        [self dismiss];
    }];
}
#pragma mark -- 刷新
#pragma mark --
- (void)setupRefresh
{
    [self.tableview addHeaderWithTarget:self action:@selector(headerReresh)];
    [self.tableview addFooterWithTarget:self action:@selector(footerReresh)];
}

#pragma mark - 上拉刷新和下拉加载
#pragma mark -
- (void)headerReresh
{
    [self.messageData removeAllObjects];
    [self getMessageData];
    [self.tableview headerEndRefreshing];
    
}
- (void)footerReresh
{
    [self show];
    [self.netWorkManager getStudentHomeAndSchoolMessage:[RRTManager manager].loginManager.loginInfo.userId pageSize:pagesize pageIndex:pageindex+1 success:^(NSDictionary *data) {
        pageindex++;
        NSLog(@"%@",data);
        [self processData:data];
        [self dismiss];
    } failed:^(NSString *errorMSG) {
        [self dismiss];
    }];
    [self.tableview footerEndRefreshing];
    
}

-(void)processData:(NSDictionary *)data{
    @try {
        if ([[data objectForKey:@"st"] intValue]==0) {
            if ([[data objectForKey:@"msg"] objectForKey:@"count"]>0) {
                NSArray* list=[[data objectForKey:@"msg"] objectForKey:@"list"];
                for (NSDictionary *dic in list) {
                    [self.messageData addObject:dic];
                }
                [self.tableview reloadData];
            }
        }
    }
    @catch (NSException *exception) {
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [self.messageData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CommunicationGuardianCell";
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[MessageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if ([self.messageData count] > 0) {
        NSDictionary *msg = self.messageData[indexPath.row];
        if ([[msg objectForKey:@"MsgType"] intValue] == 2) {
            cell.msgIcon.image = [UIImage imageNamed:@"tz"];
            cell.msgLabel.text = @"通知";
        }else if ([[msg objectForKey:@"MsgType"] intValue] == 8)
        {
            cell.msgIcon.image = [UIImage imageNamed:@"zy"];
            cell.msgLabel.text = @"作业";
        }else
        {
            cell.msgIcon.image = [UIImage imageNamed:@"tz"];
            cell.msgLabel.text = @"通知";
        }
        cell.timeLabel.text = [msg objectForKey:@"MsgContent"];
        cell.theTimeLabel.text = [msg objectForKey:@"PubTime"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GuardianDetailsViewController *deVC = [[GuardianDetailsViewController alloc]init];
    ReceiveMessage* rm=[[ReceiveMessage alloc] init];
    NSDictionary* dic=self.messageData[indexPath.row];
    rm.MessageContent=[dic objectForKey:@"MsgContent"];
    deVC.PubUser=[dic objectForKey:@"PubUserName"];
    deVC.PubUserID=[dic objectForKey:@"PubUserId"];
    rm.RecieveUser=[dic objectForKey:@"UserName"];
    rm.PubTime=[dic objectForKey:@"PubTime"];
    rm.Audio=[[NSArray alloc] init];
    rm.MessageId=@"";
    rm.HeadType=[[dic objectForKey:@"MsgType"] intValue];
    rm.BodyType=0;
    rm.Audio=nil;
    rm.Pic=nil;

    deVC.message = rm;
    NSLog(@"%@",deVC.message);
    [self.navigationController pushViewController:deVC animated:NO];
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
