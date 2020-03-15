//
//  TheNoticeViewController.m
//  RenrenTong
//
//  Created by 符其彬 on 14/12/12.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "TheNoticeViewController.h"
#import "WebViewController.h"
#import "MLEmojiLabel.h"
#import "MJRefresh.h"
#import "TheNoticeCell.h"


@interface TheNoticeViewController ()<UITableViewDataSource,UITableViewDelegate,MLEmojiLabelDelegate>
{
    int recpageIndex;
    int recpageSize;
    
    NSString *theUserRole;
}
@property (nonatomic, strong) NetWorkManager *netWorkManager;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *emjoalablearray;

@end

@implementation TheNoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.theTitle;
    
    recpageIndex = 1;
    recpageSize = 10;
    
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    
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
    
    NSString *role = [NSString stringWithFormat:@"%@",[RRTManager manager].loginManager.loginInfo.userRole];
    if ([role isEqualToString:@"2"]) {
        theUserRole = @"2";
    } else if ([role isEqualToString:@"3"] || [role isEqualToString:@"4"] || [role isEqualToString:@"5"] || [role isEqualToString:@"6"]){
        theUserRole = @"3";
    } else if ([role isEqualToString:@"1"]){
        theUserRole = @"1";
    }
    
    self.dataSource = [[NSMutableArray alloc] init];
    self.emjoalablearray = [[NSMutableArray alloc] init];
    _netWorkManager = [[NetWorkManager alloc] init];
    
    [self setupRefresh];
    [self requestData];
}

#pragma mark -- 查看成绩系统

- (void)lookCJ
{
    WebViewController *VC = [[WebViewController alloc] init];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                 style:UIBarButtonItemStylePlain
                                                                target:nil
                                                                action:nil];
    [self.navigationItem setBackBarButtonItem:backItem];
    NSString *URL01 = [NSString stringWithFormat:@"http://pa3.%@/teacher/examlist?pc=true",aedudomain];
    VC.URL = URL01;
    VC.title = @"成绩系统";
    
    [self.navigationController pushViewController:VC animated:YES];
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
    __weak TheNoticeViewController *_self = self;
    [self show];
    recpageIndex=1;
    [self.netWorkManager getMessageRecords:[RRTManager manager].loginManager.loginInfo.userId
                                  userrole:theUserRole
                               messageType:self.messageType
                                  pageSize:recpageSize
                                 pageIndex:recpageIndex
                                   success:^(NSMutableArray *data) {
                                       
                                       [_self dismiss];
                                       [_self.emjoalablearray removeAllObjects];
                                       [_self.dataSource removeAllObjects];
                                       [_self gotoUI:data];
                                       [_self.mainTableView headerEndRefreshing];
                                   } failed:^(NSString *errorMSG) {
                                       [_self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:errorMSG];
                                       [_self.mainTableView headerEndRefreshing];
                                       
                                   }];

}
- (void)footerReresh
{
    __weak TheNoticeViewController *_self = self;
    [self show];
    [self.netWorkManager getMessageRecords:[RRTManager manager].loginManager.loginInfo.userId
                                  userrole:theUserRole
                               messageType:self.messageType
                                  pageSize:recpageSize
                                 pageIndex:recpageIndex
                                   success:^(NSMutableArray *data) {
                                       [_self dismiss];
                                       [_self gotoUI:data];
                                       [_self.mainTableView footerEndRefreshing];
                                       
                                   } failed:^(NSString *errorMSG) {
                                       [_self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:errorMSG];
                                       [_self.mainTableView footerEndRefreshing];
                                       
                                   }];
}

#pragma mark -- 请求短信
- (void)requestData
{
    [self showWithStatus:@"加载数据中"];
    [self.netWorkManager getMessageRecords:[RRTManager manager].loginManager.loginInfo.userId
                                  userrole:theUserRole
                               messageType:self.messageType
                                  pageSize:recpageSize
                                 pageIndex:recpageIndex
                                   success:^(NSMutableArray *data) {
                                       
                                       [self dismiss];
                                       self.mainTableView.hidden = NO;

                                       [self gotoUI:data];
                                       
                                   } failed:^(NSString *errorMSG) {
                                       [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:errorMSG];
                                       
                                       // 无数据时候处理：
                                       self.mainTableView.hidden = YES;
                                       UIImageView *noMessageIMG = [[UIImageView alloc] init];
                                       UIImage *image = [UIImage imageNamed:@"withOutNoMessege"];
                                       noMessageIMG.frame = CGRectMake(self.view.bounds.size.width / 2 - image.size.width / 2, self.view.bounds.size.height / 2 - image.size.height / 2, 133, 118);
                                       [noMessageIMG setImage:image];
                                       [self.view addSubview:noMessageIMG];

                                   }];
}

#pragma mark -- 刷新短信界面

- (void)gotoUI:(NSMutableArray *)data
{
    if (data && [data count] > 0) {
        for (int i = 0; i < [data count]; i ++) {
            TheNotice *TNObjects = (TheNotice *)[data objectAtIndex:i];
            [self.emjoalablearray addObject:[self createLableWithText:TNObjects.MsgContent
                                                                 font:[UIFont systemFontOfSize:15]
                                                                width:SCREENWIDTH - 20]];
            [self.dataSource addObject:TNObjects];
        }
    }
    [self.mainTableView reloadData];
    recpageIndex++;

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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    height = 30;
    height += ((MLEmojiLabel*)[self.emjoalablearray objectAtIndex:indexPath.row]).height;
    height += 10;
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"TheNoticeCell";
    TheNoticeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TheNoticeCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    //防止重用问题
    UIView *emjoView = (UIView *)[cell viewWithTag:103];
    if (emjoView) {
        [emjoView removeFromSuperview];
    }
    
    cell.content = [self.emjoalablearray objectAtIndex:indexPath.row];
    cell.content.top = 10;
    cell.content.left = 10;
    cell.content.tag = 103;
    
    [cell addSubview:[self.emjoalablearray objectAtIndex:indexPath.row]];
    
    TheNotice *TNObjects = [self.dataSource objectAtIndex:indexPath.row];
    cell.timeLabel.text = TNObjects.CatchTime;
    cell.nameLabel.text = [NSString stringWithFormat:@"来自：%@",TNObjects.CreateBy];
    cell.timeLabel.top = cell.content.bottom + 5;
    cell.nameLabel.top = cell.content.bottom + 5;
    
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
