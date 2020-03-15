//
//  HighlLevelSettingViewController.m
//  RenrenTong
//
//  Created by 符其彬 on 15/2/2.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "HighlLevelSettingViewController.h"
#import "CommunicationRecordDetailsViewController.h"
#import "HighLevelSrettingCell.h"
#import "MJRefresh.h"

@interface HighlLevelSettingViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    int recpageIndex;
    int recpageSize;
    TheTeacherSendRecords *theTeacherSendRecords;

}
@property (nonatomic, strong) NetWorkManager *netWorkManager;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation HighlLevelSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    recpageIndex = 1;
    recpageSize = 10;
    
    self.netWorkManager = [[NetWorkManager alloc] init];
    self.dataSource = [[NSMutableArray alloc] init];
    self.title = @"发送记录";
    
    self.mainTableView.dataSource = self;
    self.mainTableView.delegate = self;
    
    if ([self.mainTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.mainTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.mainTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.mainTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    [self setupRefresh];
    
    // 数据请求
    [self requestData];
}

#pragma mark -- 数据请求

- (void)requestData
{
    [MBProgressHUD showMessage:@"数据加载中..."];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUD];
    });
    [self.netWorkManager theTeacherSendRecords:[RRTManager manager].loginManager.loginInfo.userId
                                         Token:[RRTManager manager].loginManager.loginInfo.tokenId
                                      pageSize:recpageSize
                                     pageIndex:recpageIndex
                                       success:^(NSMutableArray *data) {
                                           [MBProgressHUD hideHUD];
                                           [self updateUI:data];
                                           
                                       } failed:^(NSString *errorMSG) {
                                           [self showImage:[UIImage imageNamed:@""] status:errorMSG];
                                       }];
}

#pragma mark -- 刷新界面

- (void)updateUI:(NSMutableArray *)array
{
    if (array && [array count] > 0) {
        for (int i = 0; i < [array count]; i ++) {
           TheTeacherSendRecords *obj=[array objectAtIndex:i];
            [_dataSource addObject:obj];

        }
        [self.mainTableView reloadData];
        
    } else{
        [self showImage:[UIImage imageNamed:@""] status:@"没获取到响应数据！"];
    }
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
    recpageIndex = 1;
    [self show];
    [self.netWorkManager theTeacherSendRecords:[RRTManager manager].loginManager.loginInfo.userId
                                         Token:[RRTManager manager].loginManager.loginInfo.tokenId
                                      pageSize:recpageSize
                                     pageIndex:recpageIndex
                                       success:^(NSMutableArray *data) {
                                           [self dismiss];
                                           [_dataSource removeAllObjects];
                                           [self updateUI:data];
                                           [self.mainTableView headerEndRefreshing];

                                       } failed:^(NSString *errorMSG) {
                                           [self showImage:[UIImage imageNamed:@""] status:errorMSG];
                                           [self.mainTableView headerEndRefreshing];

                                       }];
    
}
- (void)footerReresh
{
    [self show];
    recpageIndex ++;
    [self.netWorkManager theTeacherSendRecords:[RRTManager manager].loginManager.loginInfo.userId
                                         Token:[RRTManager manager].loginManager.loginInfo.tokenId
                                      pageSize:recpageSize
                                     pageIndex:recpageIndex
                                       success:^(NSMutableArray *data) {
                                           [self dismiss];
                                           [self updateUI:data];
                                           [self.mainTableView footerEndRefreshing];
                                           
                                       } failed:^(NSString *errorMSG) {
                                           [self showImage:[UIImage imageNamed:@""] status:errorMSG];
                                           [self.mainTableView footerEndRefreshing];
                                           
                                       }];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataSource count];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"HighLevelSrettingCell";
    HighLevelSrettingCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
     
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HighLevelSrettingCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    TheTeacherSendRecords *obj = [_dataSource objectAtIndex:indexPath.row];
    cell.conmentLabel.text = obj.MsgContent;
    cell.timeLabel.text = obj.CreateTimeFormat;
    if ([obj.MsgType isEqualToString:@"8"]) {
        cell.zuoYeImageView.hidden = NO;
        cell.tongZhiImageView.hidden = YES;
        cell.chengJiImageView.hidden = YES;
    } else if ([obj.MsgType isEqualToString:@"11"]){
        cell.zuoYeImageView.hidden = YES;
        cell.tongZhiImageView.hidden = NO;
        cell.chengJiImageView.hidden = YES;
    } else if ([obj.MsgType isEqualToString:@"2"]){
        cell.zuoYeImageView.hidden = YES;
        cell.tongZhiImageView.hidden = YES;
        cell.chengJiImageView.hidden = NO;
    }
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    HighLevelSrettingCell *cell = (HighLevelSrettingCell *)[self.mainTableView cellForRowAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    
    [self.navigationController pushViewController:TheRecordDetailsVCID
                                   withStoryBoard:DeskStoryBoardName
                                        withBlock:^(UIViewController *viewController) {
                                            CommunicationRecordDetailsViewController *vc = (CommunicationRecordDetailsViewController*)viewController;
                                            vc.theTeacherSendRecordObj = (TheTeacherSendRecords *)[_dataSource objectAtIndex:indexPath.row];
                                        }];
    
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

- (void)viewWillDisappear:(BOOL)animated
{
    [self dismiss];
    [MBProgressHUD hideHUD];
}


@end
