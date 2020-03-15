//
//  ContactAddTableViewController.m
//  RenrenTong
//
//  Created by jeffrey on 14-6-11.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "ContactAddTableViewController.h"
#import "ContactSendVerificationViewController.h"
#import "ContactDetailViewController.h"
#import "ViewControllerIdentifier.h"
#import "AddFriendViewController.h"
#import "ContactSendVerificationViewController.h"
#import "ContactTableViewController.h"

#import "MJRefresh.h"

@interface ContactAddTableViewController ()<ContactTableViewControllerDelegate>

@property (nonatomic, strong) NetWorkManager *netWorkManager;
@property (nonatomic, strong) NSArray *dataSource;//数据源
@property (nonatomic, strong) NSMutableArray *indexs;

@end

@implementation ContactAddTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"新的朋友";
    _netWorkManager = [[NetWorkManager alloc] init];
    [self requestNetWorkNewFriendData];
    
    //Add search button
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"添加"
                                                                  style:UIBarButtonItemStyleBordered
                                                                 target:self
                                                                 action:@selector(addFirend2)];
    
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.indexs = [NSMutableArray array];
    
    //上拉刷新和下拉加载更多
    [self setupRefresh];
}

- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.tableView addHeaderWithTarget:self action:@selector(headerReresh)];
}

/*****新的朋友请求*****/
- (void)requestNetWorkNewFriendData
{
    [self showWithStatus:@""];
    
    __weak ContactAddTableViewController *_self = self;
    [self.netWorkManager newFriends:[RRTManager manager].loginManager.loginInfo.tokenId typeId:@"0" pageIndex:1 pageSize:10 success:^(NSArray *newFriend) {
        [_self dismiss];//请求完，取消菊花
        
        if ([newFriend count] == 0) {
            [_self showWithTitle:@"暂时没有新的朋友哦！" defaultStr:nil];
        }
        [_self updateUI:newFriend];
    } failed:^(NSString *errorMSG) {
        [_self showErrorWithStatus:errorMSG];
    }];
}

- (void)updateUI:(NSArray *)data
{
    NSLog(@"%@",data);
    self.dataSource = [NSArray arrayWithArray:data];
    
    [self.tableView reloadData];
    
}

- (void)sendNewFriendObject:(NewFriends *)newFriend
{
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated
{
    self.hidesBottomBarWhenPushed = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self dismiss];
    
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
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContactAddCell"
                                                            forIndexPath:indexPath];
    UIImageView *headImage = (UIImageView *)[cell viewWithTag:1];
    UILabel *name = (UILabel *) [cell viewWithTag:2];
    UILabel *time = (UILabel *) [cell viewWithTag:3];
    UIButton *acceptBtn = (UIButton*)[cell viewWithTag:4];
    UILabel *label = (UILabel*)[cell viewWithTag:6];
    
    NewFriends *tmp = [self.dataSource objectAtIndex:indexPath.row];
    
    [headImage setImageWithURL:[NSURL URLWithString:tmp.SenderPictureUrl] placeholderImage:[UIImage imageNamed:@"default"]];
    
    name.text = tmp.SenderUserName;
    if (tmp.body.length != 0) {
        time.text = [NSString stringWithFormat:@"%@%@",@"验证信息:",tmp.body];
    }else{
        time.text = @"没有验证消息哦!";
    }
    
    acceptBtn.layer.cornerRadius = 2.0;
    [acceptBtn addTarget:self action:@selector(acceptFirend:)
        forControlEvents:UIControlEventTouchUpInside];
    acceptBtn.backgroundColor = appColor;
    
    
    /*判断是否是已添加or接受*/
    if ([tmp.IsFollows boolValue]) {
        [acceptBtn setHidden:YES];
        [label setHidden:NO];
    }else {
        [acceptBtn setHidden:NO];
        [label setHidden:YES];
    }
    
    
    return cell;
}

#pragma mark - tableview delegate
#pragma mark -
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NewFriends *tmp = [self.dataSource objectAtIndex:indexPath.row];

    [self.navigationController pushViewController:ContactDetailVCID
                                   withStoryBoard:ContactStoryBoardName
                                        withBlock:^(UIViewController *viewController) {
        ContactDetailViewController *vc = (ContactDetailViewController*)viewController;
        vc.OUserId = tmp.SenderUserId;
    }];
    
    
}

#pragma mark - 接受
#pragma mark -
- (void)acceptFirend:(UIButton*)button
{
    //获取NSIndexPath和cell上面的每个button
    CGPoint hitPoint = [button convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:hitPoint];
    
    __block NewFriends *tmp = (NewFriends*)[self.dataSource objectAtIndex:indexPath.row];
    NSLog(@"%@",tmp.Id);
    
    //好友添加接受
    
    NSString *type = [NSString stringWithFormat:@"%@", tmp.Type];
    if ([type isEqualToString:@"-99"]) {
        [self showWithStatus:@""];
        [self.netWorkManager acceptNewFriend:tmp.Id success:^(NSDictionary *data) {
            tmp.IsFollows = [NSString stringWithFormat:@"%d", ![tmp.IsFollows boolValue]];
            [self.tableView reloadData];
            [self dismiss];//请求完，取消菊花
            [self gotoMainUI];
        } failed:^(NSString *errorMSG) {
            [self showErrorWithStatus:errorMSG];
        }];
    //家长绑定接受
    }else if ([type isEqualToString:@"1"]){
        [self showWithStatus:@""];
        [self.netWorkManager acceptNewFamily:[RRTManager manager].loginManager.loginInfo.tokenId
                                        Type:@"1"
                              ChildrenUserId:[RRTManager manager].loginManager.loginInfo.userId
                                     success:^(NSDictionary *data) {
            
         tmp.IsFollows = [NSString stringWithFormat:@"%d", ![tmp.IsFollows boolValue]];
         [self.tableView reloadData];
         [self dismiss];
         [self gotoMainUI];
        } failed:^(NSString *errorMSG) {
            [self showErrorWithStatus:errorMSG];
        }];
    }
}

- (void)gotoMainUI
{
//    [self performSelector:@selector(back) withObject:nil afterDelay:0.5f];
//    self.block();
    //注册通知
    [[NSNotificationCenter defaultCenter] postNotificationName:kContactAdded
                                                        object:nil
                                                      userInfo:nil];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

//添加好友
- (void)addFirend:(UIButton*)button
{
    [self.navigationController pushViewController:ContactSendVerVCID
                                   withStoryBoard:ContactStoryBoardName
                                        withBlock:nil];
}

- (void)addFirend2
{
    [self.navigationController pushViewController:AddFriendVCID
                                   withStoryBoard:ContactStoryBoardName
                                        withBlock:nil];
}

#pragma mark - 下拉刷新
#pragma mark -
- (void)headerReresh
{
    __weak ContactAddTableViewController *_self = self;
    [_self showWithStatus:@""];
    [_self.netWorkManager newFriends:[RRTManager manager].loginManager.loginInfo.tokenId typeId:@"0" pageIndex:1 pageSize:10 success:^(NSArray *newFriend) {
        [_self dismiss];//请求完，取消菊花
        
        if ([newFriend count] == 0) {
            [_self showWithTitle:@"暂时没有新的朋友哦！" defaultStr:nil];
        }
        [_self updateUI:newFriend];
        [_self.tableView headerEndRefreshing];
    } failed:^(NSString *errorMSG) {
        [_self showErrorWithStatus:errorMSG];
        [_self.tableView headerEndRefreshing];
    }];
}

@end
