//
//  TheMessageRecordViewController.m
//  RenrenTong
//
//  Created by 符其彬 on 15/3/6.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "TheMessageRecordViewController.h"
#import "TheMessageRecordCell.h"
#import "MJRefresh.h"
#import "NetWorkManager+SchoolAndHouse.h"


@interface TheMessageRecordViewController ()<UITableViewDelegate,UITableViewDataSource,MLEmojiLabelDelegate>
{
    int recpageIndex;
    int recpageSize;
}
@property (nonatomic, strong) NetWorkManager *netWorkManager;
@property (nonatomic, strong) NSMutableArray *emjoalablearray;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation TheMessageRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mainTableView.dataSource = self;
    self.mainTableView.delegate = self;
    self.title = @"短信记录";
    self.netWorkManager = [[NetWorkManager alloc] init];
    self.emjoalablearray = [[NSMutableArray alloc] init];
    self.dataSource = [[NSMutableArray alloc] init];
    recpageIndex = 1;
    recpageSize = 10;
    
    //上拉刷新和下拉加载更多
    [self setupRefresh];
    [self requestData];
    
    if ([self.mainTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.mainTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.mainTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.mainTableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark -- 数据请求

- (void)requestData
{
    [MBProgressHUD showMessage:@"数据加载中..."];
    [self.dataSource removeAllObjects];
    [self.emjoalablearray removeAllObjects];
    [self.netWorkManager getMessageCounts:[RRTManager manager].loginManager.loginInfo.tokenId
                                   userId:[RRTManager manager].loginManager.loginInfo.userId
                                 userRole:[RRTManager manager].loginManager.loginInfo.userRole
                              messageType:self.theMsgType
                                 pageSize:recpageSize
                                pageIndex:recpageIndex
                                  success:^(NSMutableArray *data) {
                                      [MBProgressHUD hideHUD];
                                      [self gotoUpdataUI:data];
                                  } failed:^(NSString *errorMSG) {
                                      [self showErrorWithStatus:@""];
                                      [MBProgressHUD hideHUD];
                                  }];
}

#pragma mark -- 刷新界面
#pragma mark --

- (void)gotoUpdataUI:(NSMutableArray *)data
{
    if (data) {
            for(int i = 0; i < [data count]; i ++) {
                
                GetMessage *GMObjects = (GetMessage *)[data objectAtIndex:i];
                [self.emjoalablearray addObject:[self createLableWithText:GMObjects.MsgContent
                                                                     font:[UIFont systemFontOfSize:16]
                                                                    width:SCREENWIDTH - 20]];
                [self.dataSource addObject:GMObjects];
            }
            [self.mainTableView reloadData];
    }
    [MBProgressHUD hideHUD];
}

#pragma mark emjolable

-(MLEmojiLabel*)createLableWithText:(NSString*)text font:(UIFont*)font  width:(int)width{
    MLEmojiLabel*_emojiLabel= [[MLEmojiLabel alloc]init];
    _emojiLabel.numberOfLines = 0;
    _emojiLabel.font = font;
    _emojiLabel.emojiDelegate = self;
    _emojiLabel.backgroundColor = [UIColor clearColor];
    _emojiLabel.lineBreakMode = NSLineBreakByCharWrapping;
    _emojiLabel.isNeedAtAndPoundSign = YES;
    [_emojiLabel setEmojiText:text];
    _emojiLabel.frame = CGRectMake(0, 0, width, 0);
    [_emojiLabel sizeToFit];
    return _emojiLabel;
}

#pragma mark -- 刷新
#pragma mark --
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.mainTableView addHeaderWithTarget:self action:@selector(headerReresh)];
    [self.mainTableView addFooterWithTarget:self action:@selector(footerReresh)];
}

#pragma mark - 上拉刷新和下拉加载
#pragma mark -
- (void)headerReresh
{
    __weak TheMessageRecordViewController *_self = self;
    [MBProgressHUD showMessage:@"数据加载中..."];
    [self.dataSource removeAllObjects];
    [self.emjoalablearray removeAllObjects];
    recpageIndex = 1;
    [self.netWorkManager getMessageCounts:[RRTManager manager].loginManager.loginInfo.tokenId
                                   userId:[RRTManager manager].loginManager.loginInfo.userId
                                 userRole:[RRTManager manager].loginManager.loginInfo.userRole
                              messageType:self.theMsgType
                                 pageSize:recpageSize
                                pageIndex:recpageIndex
                                  success:^(NSMutableArray *data) {
                                      [MBProgressHUD hideHUD];
                                      [self gotoUpdataUI:data];
                                      [_self.mainTableView headerEndRefreshing];
                                  } failed:^(NSString *errorMSG) {
                                      [MBProgressHUD hideHUD];
                                      [_self.mainTableView headerEndRefreshing];
                                  }];
}

- (void)footerReresh
{
    __weak TheMessageRecordViewController *_self = self;
    [MBProgressHUD showMessage:@"数据加载中..."];
    recpageIndex++;
    [self.netWorkManager getMessageCounts:[RRTManager manager].loginManager.loginInfo.tokenId
                                   userId:[RRTManager manager].loginManager.loginInfo.userId
                                 userRole:[RRTManager manager].loginManager.loginInfo.userRole
                              messageType:self.theMsgType
                                 pageSize:recpageSize
                                pageIndex:recpageIndex
                                  success:^(NSMutableArray *data) {
                                      
                                      [MBProgressHUD hideHUD];
                                      [self gotoUpdataUI:data];
                                      [_self.mainTableView footerEndRefreshing];
                                      
                                  } failed:^(NSString *errorMSG) {
                                      [MBProgressHUD hideHUD];
                                      [_self.mainTableView footerEndRefreshing];
                                  }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.emjoalablearray && [self.emjoalablearray count] > 0) {
        return [self.emjoalablearray count];
    } else{
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;

    if (self.emjoalablearray && [self.emjoalablearray count] > 0) {
        height = 30;
        height += ((MLEmojiLabel*)[self.emjoalablearray objectAtIndex:indexPath.row]).height;
        height += 10;
    }
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"TheMessageRecordCell";
    TheMessageRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TheMessageRecordCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    //防止重用问题
    UIView *emjoView = (UIView *)[cell viewWithTag:103];
    if (emjoView) {
        [emjoView removeFromSuperview];
    }
    if (self.emjoalablearray && [self.emjoalablearray count] > 0) {
        cell.content = [self.emjoalablearray objectAtIndex:indexPath.row];
        cell.content.top = 10;
        cell.content.left = 10;
        cell.content.tag = 103;
        [cell addSubview:[self.emjoalablearray objectAtIndex:indexPath.row]];
    }
    if (self.dataSource && [self.dataSource count] > 0) {
        GetMessage *GMObjects = [self.dataSource objectAtIndex:indexPath.row];
        cell.fromOrderLabel.text = [NSString stringWithFormat:@"发信人:%@",GMObjects.PubUserName];
        cell.timeLabel.text = GMObjects.CreateTime;
        cell.fromOrderLabel.top = cell.content.bottom + 5;
        cell.timeLabel.top = cell.content.bottom + 5;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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

@end
