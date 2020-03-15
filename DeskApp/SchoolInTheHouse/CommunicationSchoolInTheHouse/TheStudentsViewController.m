//
//  TheStudentsViewController.m
//  RenrenTong
//
//  Created by 符其彬 on 15/2/27.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "TheStudentsViewController.h"
#import "GuardianDetailsViewController.h"
#import "NoNavViewController.h"
#import "MessageCell.h"
#import "MJRefresh.h"

@interface TheStudentsViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    int recpageIndex;
    int recpageSize;
}
@end

@implementation TheStudentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.theTitle) {
        self.title = self.theTitle;
        
    } else{
        self.title = @"信息列表";
        
    }
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    [self.navigationItem setBackBarButtonItem:backItem];
    
    if ([self.theTitle isEqualToString:@"成绩"]) {
        //Add right button
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"成绩系统"
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(lookCJ)];
        self.navigationItem.rightBarButtonItem = rightItem;
    }
    
    if ([self.mainTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [self.mainTableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([self.mainTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [self.mainTableView setLayoutMargins:UIEdgeInsetsZero];
        
    }
    
    [self setupRefresh];
}

- (void)lookCJ
{
    NoNavViewController *VC = [[NoNavViewController alloc] init];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                 style:UIBarButtonItemStylePlain
                                                                target:nil
                                                                action:nil];
    [self.navigationItem setBackBarButtonItem:backItem];
    
    NSString *theRole = [NSString stringWithFormat:@"%@",[RRTManager manager].loginManager.loginInfo.userRole];
    if ([theRole isEqualToString:@"1"]) {
        NSString *URL0 = [NSString stringWithFormat:@"http://phoneweb.%@/parent/exam?isapp=true",aedudomain];
        VC.URL = URL0;
        VC.title = @"成绩系统";
    } else if ([theRole isEqualToString:@"2"]){
        NSString *URL0 = [NSString stringWithFormat:@"http://phoneweb.%@/parent/exam?isapp=true",aedudomain];
        VC.URL = URL0;
        VC.title = @"成绩系统";
    } else if ([theRole isEqualToString:@"3"] || [theRole isEqualToString:@"4"] || [theRole isEqualToString:@"5"] || [theRole isEqualToString:@"6"]){
        NSString *URL0 = [NSString stringWithFormat:@"http://phoneweb.%@/teacher/exam/index?isapp=true",aedudomain];
        VC.URL = URL0;
        VC.title = @"成绩系统";
        
    }
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark -- 刷新
#pragma mark --
- (void)setupRefresh
{
    [self.mainTableView addHeaderWithTarget:self action:@selector(headerReresh)];
    [self.mainTableView addFooterWithTarget:self action:@selector(footerReresh)];
}

#pragma mark - 上拉刷新和下拉加载
#pragma mark -
- (void)headerReresh
{
    [self.mainTableView headerEndRefreshing];
    
}
- (void)footerReresh
{
    [self.mainTableView footerEndRefreshing];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CommunicationGuardianCell";
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[MessageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GuardianDetailsViewController *deVC = [[GuardianDetailsViewController alloc]init];
    [self.navigationController pushViewController:deVC animated:NO];
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [cell setLayoutMargins:UIEdgeInsetsZero];
        
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
