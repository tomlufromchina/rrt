//
//  StudentSchoolAndHouseViewController.m
//  RenrenTong
//
//  Created by 符其彬 on 14-10-30.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "StudentSchoolAndHouseViewController.h"
#import "StudentSchoollAndHouseCell.h"
#import "MLEmojiLabel.h"
#import "MJRefresh.h"

#import "NetWorkManager+SchoolAndHouse.h"

@interface StudentSchoolAndHouseViewController ()<UITableViewDataSource,UITableViewDelegate,MLEmojiLabelDelegate>
{
    int recpageIndex;
    int recpageSize;
}
@property (nonatomic, strong) NetWorkManager *netWorkManager;
@property (nonatomic, strong) NSMutableArray *emjoalablearray;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation StudentSchoolAndHouseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"收到的短信";
    recpageIndex = 1;
    recpageSize = 10;
    self.mainTableView.dataSource = self;
    self.mainTableView.delegate = self;
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.netWorkManager = [[NetWorkManager alloc] init];
    self.emjoalablearray = [[NSMutableArray alloc] init];
    self.dataSource = [[NSMutableArray alloc] init];
    
    //上拉刷新和下拉加载更多
    [self setupRefresh];
    [self requestData];

}

#pragma mark --数据解析
#pragma mark --

- (void)requestData
{
    [self show];
    [self.netWorkManager getMyselfMessageCounts:[RRTManager manager].loginManager.loginInfo.tokenId
                                         userId:[RRTManager manager].loginManager.loginInfo.userId
                                       pageSize:recpageSize
                                      pageIndex:recpageIndex
                                        success:^(NSMutableArray *data) {
                                            [self dismiss];
                                            [self gotoUpdataUI:data];
                                        } failed:^(NSString *errorMSG) {
                                            [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:errorMSG];
                                        }];
}

- (void)gotoUpdataUI:(NSMutableArray *)data
{
        if (data) {
        for (int i = 0; i < [data count]; i ++) {
            
            SendMessage *GMObjects = (SendMessage *)[data objectAtIndex:i];
            
            [self.emjoalablearray addObject:[self createLableWithText:GMObjects.MsgContent
                                                                  font:[UIFont systemFontOfSize:15]
                                                                 width:SCREENWIDTH - 20]];
            [self.dataSource addObject:GMObjects];
        }
        [self.mainTableView reloadData];
        recpageIndex++;
    }
}

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
    static NSString *cellIdentifier = @"StudentSchoollAndHouseCell";
    StudentSchoollAndHouseCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"StudentSchoollAndHouseCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.row % 2 == 0) {
        cell.backgroundColor = [UIColor whiteColor];
    } else {
        cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
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
    
    SendMessage *GMObjects = [self.dataSource objectAtIndex:indexPath.row];
    
    UILabel *author = (UILabel *)[cell viewWithTag:101];
    UILabel *creatTime = (UILabel *)[cell viewWithTag:102];
    author.text = [NSString stringWithFormat:@"发信人：%@",GMObjects.CreateBy];
    creatTime.text = GMObjects.CreateTime;
    //        creatTime.text = [NSString stringWithFormat:@"时间：%@",@"暂无"];
    
    author.top = cell.content.bottom + 5;
    creatTime.top = cell.content.bottom + 5;
    
    return cell;
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
    __weak StudentSchoolAndHouseViewController *_self = self;
    [self show];
    recpageIndex=1;
    
    [self.netWorkManager getMyselfMessageCounts:[RRTManager manager].loginManager.loginInfo.tokenId
                                         userId:[RRTManager manager].loginManager.loginInfo.userId
                                       pageSize:recpageSize
                                      pageIndex:recpageIndex
                                        success:^(NSMutableArray *data) {
                                            [_self dismiss];
                                            [_self.emjoalablearray removeAllObjects];
                                            [_self.dataSource removeAllObjects];
                                            [_self gotoUpdataUI:data];
                                            [_self.mainTableView headerEndRefreshing];
                                        } failed:^(NSString *errorMSG) {
                                            [_self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:errorMSG];
                                            [_self.mainTableView headerEndRefreshing];
                                        }];
    
}

- (void)footerReresh
{
    __weak StudentSchoolAndHouseViewController *_self = self;
    
    [self show];
    
    [self.netWorkManager getMyselfMessageCounts:[RRTManager manager].loginManager.loginInfo.tokenId
                                         userId:[RRTManager manager].loginManager.loginInfo.userId
                                       pageSize:recpageSize
                                      pageIndex:recpageIndex
                                        success:^(NSMutableArray *data) {
                                            [_self dismiss];
                                            [_self gotoUpdataUI:data];
                                            [_self.mainTableView footerEndRefreshing];
                                        } failed:^(NSString *errorMSG) {
                                            [_self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:errorMSG];
                                            [_self.mainTableView footerEndRefreshing];
                                        }];
    
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
