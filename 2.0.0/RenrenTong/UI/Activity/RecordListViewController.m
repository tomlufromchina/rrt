//
//  RecordListViewController.m
//  RenrenTong
//
//  Created by jeffrey on 14-7-8.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "RecordListViewController.h"
#import "ViewControllerIdentifier.h"
#import "RecordDetailsController.h"

@interface RecordListViewController ()

@property (nonatomic, strong) NetWorkManager *netWorkManager;
@property (nonatomic, strong) NSMutableArray *dataSuorce;//数据源
@property (nonatomic, assign) int PageSize;
@property (nonatomic, assign) int PageIndex;

@end

@implementation RecordListViewController

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
    
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
    [self.tableView setSeparatorColor:appColor];
    self.netWorkManager = [[NetWorkManager alloc] init];
    self.title = @"日志";
    
    //上拉刷新和下拉加载更多
    [self setupRefresh];
    [self requestLinkmanData];
    
    self.PageIndex = 1;
    self.PageSize = 10;
}

- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self enableRefresh:YES action:@selector(headerReresh)];
    [self enableLoadMore:YES action:@selector(footerReresh)];
}

- (void)requestLinkmanData
{
    self.PageIndex = 1;
    self.PageSize = 10;
    
    [self showWithStatus:@""];
    [self.netWorkManager blogListDetail:[RRTManager manager].loginManager.loginInfo.tokenId UsedId:[RRTManager manager].loginManager.loginInfo.userId PageIndex:1 PageSize:10 success:^(NSArray *blog) {
        [self dismiss];
        [self updateView:blog];
    } failed:^(NSString *errorMSG) {
        [self showErrorWithStatus:errorMSG];
    }];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self dismiss];
    
}

//刷新界面
- (void)updateView:(NSArray *)datum
{
    self.dataSuorce = [NSMutableArray arrayWithArray:datum];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSuorce count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecordCommentCell" forIndexPath:indexPath];
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    UIView *firstView = (UIView *)[cell viewWithTag:6];
    UIView *sendView = (UIView *)[cell viewWithTag:7];
    UILabel *title = (UILabel *)[cell viewWithTag:1];
    UILabel *discuss = (UILabel *)[cell viewWithTag:8];
    UILabel *reading = (UILabel *)[cell viewWithTag:9];
    UILabel *time = (UILabel *)[cell viewWithTag:4];
    firstView.layer.cornerRadius = 2.0f;
    sendView.layer.cornerRadius = 2.0f;
    NSLog(@"The index is:%d", indexPath.row);
    BlogList *blogList = [self.dataSuorce objectAtIndex:indexPath.row];
    title.text = [NSString stringWithFormat:@"%@",blogList.title];
    discuss.text = [NSString stringWithFormat:@"(%@)",blogList.commentCount];
    reading.text = [NSString stringWithFormat:@"(%@)",blogList.hitCount];
    time.text = [NSString stringWithFormat:@"%@",blogList.dateTime];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    RecordDetailsController *VC = [[RecordDetailsController alloc] init];
    BlogList *blogList = [self.dataSuorce objectAtIndex:indexPath.row];
    VC.rid = blogList.blogThreadId;
    NSLog(@"%@",VC.rid);
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                 style:UIBarButtonItemStyleBordered
                                                                target:nil
                                                                action:nil];
    [self.navigationItem setBackBarButtonItem:backItem];
    
    [self.navigationController pushViewController:VC animated:YES];
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

#pragma mark - 上拉刷新和下拉加载
#pragma mark -
- (void)headerReresh
{
    __weak RecordListViewController *_self = self;
    [self showWithStatus:@""];
    [self.netWorkManager blogListDetail:[RRTManager manager].loginManager.loginInfo.tokenId UsedId:[RRTManager manager].loginManager.loginInfo.userId PageIndex:1 PageSize:_self.PageSize success:^(NSArray *blog) {
        [self dismiss];
        _self.PageIndex = 1;
        [_self endRefresh];
        [self updateView:blog];
    } failed:^(NSString *errorMSG) {
        [self showErrorWithStatus:@"刷新失败..."];
        [_self endRefresh];
    }];
}

- (void)footerReresh
{
    __weak RecordListViewController *_self = self;
    [self showWithStatus:@""];
    [self.netWorkManager blogListDetail:[RRTManager manager].loginManager.loginInfo.tokenId
                                 UsedId:[RRTManager manager].loginManager.loginInfo.userId
                              PageIndex:_self.PageIndex + _self.PageSize
                               PageSize:_self.PageSize
                                success:^(NSArray *blog) {
        [self dismiss];
        self.PageIndex += self.PageSize;
        [self updateView:blog];
        [_self endLoadMore];
    } failed:^(NSString *errorMSG) {
        [self showErrorWithStatus:errorMSG];

        [_self endLoadMore];
    }];
    
    
}


@end
