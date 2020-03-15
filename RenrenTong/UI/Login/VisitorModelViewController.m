//
//  VisitorModelViewController.m
//  RenrenTong
//
//  Created by 符其彬 on 15/3/18.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "VisitorModelViewController.h"
#import "WebViewController.h"
#import "NoNavViewController.h"
#import "AdverView.h"
#import "CurrentFooterCell.h"
#import "MJRefresh.h"

#import "DynamicCell.h"
#import "PublishCommentView.h"
#import "PublishListAndPraiseView.h"
#import "PersonModel.h"
#import "AlbumList.h"

@interface VisitorModelViewController ()<UIScrollViewDelegate,UIActionSheetDelegate,UITableViewDelegate,UITableViewDataSource,AdverViewDelegate,UIAlertViewDelegate,DynamicCellDelegate>

@property (nonatomic, strong) NetWorkManager *netWorkManager;
@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UIAlertView *alertView;
@property (nonatomic, strong) NSMutableArray *webArray;
@property (nonatomic, strong) NSMutableArray *imageNameArray;
@property (nonatomic, strong) NSMutableArray *educationArray;
@property (nonatomic, strong) AdverView *adView;
@property (nonatomic, assign) int pageIndex;
@property (nonatomic, assign) int pageSize;

@end

@implementation VisitorModelViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"访客模式";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    //Add search button
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"登录"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(clickRightButton)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    //Add search button
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"注册"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(clickLeftButton)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    _imageArray = [[NSMutableArray alloc] init];
    _imageNameArray = [[NSMutableArray alloc] init];
    _webArray = [[NSMutableArray alloc] init];
    
    //上拉刷新和下拉加载更多
    [self setupRefresh];
    self.dataSource = [[NSMutableArray alloc] init];
    _educationArray = [[NSMutableArray alloc] init];
    self.netWorkManager = [[NetWorkManager alloc] init];
    self.pageIndex = 1;
    self.pageSize = 10;
    
    self.mainTableView.dataSource = self;
    self.mainTableView.delegate = self;
    
    if ([self.mainTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.mainTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.mainTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.mainTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    [self requestData];
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
    self.pageIndex = 1;
    
    NSString *url1 = [NSString stringWithFormat:@"http://home.%@/api/GetActivity",aedudomain];
    NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:@"",@"typeId",[RRTManager manager].loginManager.loginInfo.userId,@"userId",[NSString stringWithFormat:@"%d",self.pageSize],@"pageSize",[NSString stringWithFormat:@"%d",self.pageIndex],@"pageIndex",nil];
    [HttpUtil GetWithUrl:url1 parameters:dic1 success:^(id json) {
        TheMyTendency *theGoodFriendTendency = [[TheMyTendency alloc] initWithString:json error:nil];
        if (theGoodFriendTendency.st == 0) {
            [MBProgressHUD hideHUD];
            [self.dataSource removeAllObjects];
            [self updateView:[theGoodFriendTendency.msg.list mutableCopy]];
            self.pageIndex = 1;
            [self.mainTableView headerEndRefreshing];
        }else{
            ErrorModel *erromodel = [[ErrorModel alloc] initWithString:json error:nil];
            [MBProgressHUD hideHUD];
            [self showUploadView:erromodel.msg];
            [self.mainTableView headerEndRefreshing];
        }
    } fail:^(id errors) {
        [MBProgressHUD hideHUD];
        [self showUploadView:errors];
        [self.mainTableView headerEndRefreshing];
    } cache:^(id cache) {
        TheMyTendency *theGoodFriendTendency = [[TheMyTendency alloc] initWithString:cache error:nil];
        if (theGoodFriendTendency.st == 0) {
            [self updateView:[theGoodFriendTendency.msg.list mutableCopy]];
            [self.mainTableView headerEndRefreshing];
        }
        [MBProgressHUD hideHUD];
    }];
}

- (void)footerReresh
{
    NSString *url1 = [NSString stringWithFormat:@"http://home.%@/api/GetActivity",aedudomain];
    NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:@"",@"typeId",[RRTManager manager].loginManager.loginInfo.userId,@"userId",[NSString stringWithFormat:@"%d",self.pageSize],@"pageSize",[NSString stringWithFormat:@"%d",self.pageIndex],@"pageIndex",nil];
    [HttpUtil GetWithUrl:url1 parameters:dic1 success:^(id json) {
        TheMyTendency *theGoodFriendTendency = [[TheMyTendency alloc] initWithString:json error:nil];
        if (theGoodFriendTendency.st == 0) {
            [MBProgressHUD hideHUD];
            [self updateView:[theGoodFriendTendency.msg.list mutableCopy]];
            [self.mainTableView footerEndRefreshing];
        }else{
            ErrorModel *erromodel = [[ErrorModel alloc] initWithString:json error:nil];
            [MBProgressHUD hideHUD];
            [self showUploadView:erromodel.msg];
            [self.mainTableView footerEndRefreshing];
        }
    } fail:^(id errors) {
        [MBProgressHUD hideHUD];
        [self showUploadView:errors];
        [self.mainTableView footerEndRefreshing];
    } cache:^(id cache) {
        TheMyTendency *theGoodFriendTendency = [[TheMyTendency alloc] initWithString:cache error:nil];
        if (theGoodFriendTendency.st == 0) {
            [self updateView:[theGoodFriendTendency.msg.list mutableCopy]];
            [self.mainTableView footerEndRefreshing];
        }
        [MBProgressHUD hideHUD];
    }];
}

#pragma mark -- 数据请求

- (void)requestData
{
    [MBProgressHUD showMessage:@"数据加载中,请稍后哒..."];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUD];
    });
    // 社区动态
    
    NSString *url1 = [NSString stringWithFormat:@"http://home.%@/api/GetActivity",aedudomain];
    NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:@"",@"typeId",[RRTManager manager].loginManager.loginInfo.userId,@"userId",[NSString stringWithFormat:@"%d",self.pageSize],@"pageSize",[NSString stringWithFormat:@"%d",self.pageIndex],@"pageIndex",nil];
    [HttpUtil GetWithUrl:url1 parameters:dic1 success:^(id json) {
        TheMyTendency *theGoodFriendTendency = [[TheMyTendency alloc] initWithString:json error:nil];
        if (theGoodFriendTendency.st == 0) {
            [MBProgressHUD hideHUD];
            [self updateView:[theGoodFriendTendency.msg.list mutableCopy]];
            [self.mainTableView headerEndRefreshing];
        }else{
            ErrorModel *erromodel = [[ErrorModel alloc] initWithString:json error:nil];
            [MBProgressHUD hideHUD];
            [self showUploadView:erromodel.msg];
            [self.mainTableView headerEndRefreshing];
        }
    } fail:^(id errors) {
        [MBProgressHUD hideHUD];
        [self showUploadView:errors];
    } cache:^(id cache) {
        TheMyTendency *theGoodFriendTendency = [[TheMyTendency alloc] initWithString:cache error:nil];
        if (theGoodFriendTendency.st == 0) {
            [self updateView:[theGoodFriendTendency.msg.list mutableCopy]];
            [self.mainTableView headerEndRefreshing];
        }
        [MBProgressHUD hideHUD];
    }];
    
    // 获取教育资讯
    NSString *url = [NSString stringWithFormat:@"http://nmapi.%@/home/GetNewsList",aedudomain];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"1",@"count",nil];
    [HttpUtil GetWithUrl:url parameters:dic success:^(id json) {
        AeduNewModel *aeduNewModel = [[AeduNewModel alloc] initWithString:json error:nil];
        if (aeduNewModel.result == 1) {
            _educationArray = (NSMutableArray*)aeduNewModel.items;
            [self.mainTableView reloadData];
        }else{
            ErrorModel *erromodel = [[ErrorModel alloc] initWithString:json error:nil];
            [self showUploadView:erromodel.msg];
        }
    } fail:^(id errors) {
        [self showUploadView:errors];
    } cache:^(id cache) {
        AeduNewModel *aeduNewModel = [[AeduNewModel alloc] initWithString:cache error:nil];
        if (aeduNewModel.result == 1) {
            _educationArray = (NSMutableArray*)aeduNewModel.items;
            [self.mainTableView reloadData];
        }
    }];
        
    // 广告请求
    url = [NSString stringWithFormat:@"http://dsjtj.%@/Api/GetAdvert",aedudomain];
    dic = [NSDictionary dictionaryWithObjectsAndKeys:@"4",@"advertType",[RRTManager manager].loginManager.loginInfo.tokenId,@"toKen",nil];
    [HttpUtil GetWithUrl:url parameters:dic success:^(id json) {
        Adver *result = [[Adver alloc] initWithString:json error:nil];
        if (result.Status == 1 && result.Data.count > 0) {
            NSMutableArray *array = [[NSMutableArray alloc] init];
            NSMutableArray *adNameArray = [[NSMutableArray alloc] init];
            NSMutableArray *linkUrlArray = [[NSMutableArray alloc] init];
            for (AdverData *data in result.Data) {
                [array addObject:data.ImageURL];
                [adNameArray addObject:data.AdName];
                [linkUrlArray addObject:data.LinkUrl];
            }
            // 初始化广告页（AdverType 不要）
            self.adView = [[AdverView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 90) AdverType:HomePageTopAdver];
            self.mainTableView.frame = CGRectMake(0, 90, SCREENWIDTH, SCREENHEIGHT - 90);
            self.adView.delegate = self;
            [self.adView setPicArray:array];
            [self.adView setLinkUrlArray:linkUrlArray];
            [self.adView setAdNameArray:adNameArray];
            [self.view addSubview:self.adView];
        }else{
            [self removeAdverView];
        }
    } fail:^(id errors) {
        [self removeAdverView];
    } cache:^(id cache) {
        
    }];

    }

-(void)removeAdverView
{
    [self.adView removeFromSuperview];
    self.mainTableView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - 64);
}

- (void)updateView:(NSMutableArray *)data
{
    if (data && [data count] > 0) {
        if (self.pageIndex > 1) {
            [self.dataSource addObjectsFromArray:data];
        }else{
            self.dataSource = data;
        }
        self.pageIndex ++;
        [self.mainTableView reloadData];
    }
}

#pragma mark -- AdverViewDelegate

-(void)clickTheImages:(int)tag andWithAdNameArray:(NSMutableArray *)adNameArray andWithLinkUrlArray:(NSMutableArray *)linkUrlArry
{
    WebViewController *VC = [[WebViewController alloc] init];
    NSString *URL0 = [linkUrlArry objectAtIndex:tag];
    VC.URL = URL0;
    VC.title = [adNameArray objectAtIndex:tag];
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 30;
    } else{
        return 20;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return [_educationArray count];
        case 1:
            if (self.dataSource && [self.dataSource count] > 0) {
                return [self.dataSource count];
            }
        default:
            return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(10.0, 0.0, 300.0, 44.0)];
    UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.opaque = NO;
    headerLabel.textColor = [UIColor blackColor];
    headerLabel.highlightedTextColor = [UIColor whiteColor];
    headerLabel.font = [UIFont boldSystemFontOfSize:18];
    headerLabel.frame = CGRectMake(10.0, -5, 300.0, 20.0);
    if (section == 0){
        headerLabel.frame = CGRectMake(10, 5, 300, 20);
        headerLabel.text = @"教育资讯";
    }else if (section == 1){
        headerLabel.text = @"社区动态";
    }
    [customView addSubview:headerLabel];
    return customView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 64;
    } else{
        DynamicCell *cell = [[DynamicCell alloc] init];
        if (self.dataSource && [self.dataSource count] > 0) {
            cell.model = [self.dataSource objectAtIndex:indexPath.row];
        }
        return cell.height;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *cellIdentifier = @"CurrentFooterCell";
        CurrentFooterCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"CurrentFooterCell" owner:self options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.userHeaderImageView.hidden = YES;
        cell.userHeaderImageView2.hidden = YES;
        cell.userHeaderImageView3.hidden = NO;
        cell.userHeaderImageView4.hidden = YES;
        cell.titleLabel.hidden = YES;
        cell.titleLabel1.hidden = NO;
        cell.titleLabel2.hidden = YES;
        cell.titleLabel3.hidden = YES;

        if (_educationArray && [_educationArray count] > 0) {
            AeduNewModelItems *EI = (AeduNewModelItems *)[_educationArray objectAtIndex:0];
            cell.conmmentLabel.text = EI.Detail;
            cell.timeLabel.text = EI.PublishDate;
        } else{
            cell.conmmentLabel.text = @"暂无教育资讯";
        }
        return cell;
        
    } else{
        static NSString *cellIdentifier = @"DynamicCell";
        //自定义cell类
        DynamicCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[DynamicCell alloc] init];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if (self.dataSource && [self.dataSource count] > 0) {
            cell.model = [self.dataSource objectAtIndex:indexPath.row];
            cell.delegate = self;
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            NoNavViewController *VC = [[NoNavViewController alloc] init];
            NSString *URL0 = [NSString stringWithFormat:@"http://www.%@/MoblieNews",aedudomain];
            VC.URL = URL0;
            VC.title = @"教育资讯";
            [self.navigationController pushViewController:VC animated:YES];
        }
    } else{
        [self exitMethod];
    }
}

#pragma mark -- DynamicCellDelegete
#pragma mark --

-(void)DynamicPraise:(DynamicCell*)cell
{
    [self exitMethod];
}

-(void)DynamicComment:(DynamicCell *)cell
{
    [self exitMethod];
}

-(void)DynamicReplayComment:(DynamicCell *)cell ReplayID:(NSString*)toUserID
{
    [self exitMethod];
}

-(void)DynamicMoreComment:(DynamicCell *)cell
{
    [self exitMethod];
}

-(void)hidenNavigationBar:(BOOL)isEnd
{
    if (isEnd) {
        self.navigationController.navigationBar.hidden = NO;
        
    } else{
        self.navigationController.navigationBar.hidden = YES;
        
    }
}

- (void)exitMethod
{
    _alertView = [[UIAlertView alloc] initWithTitle:@""
                                            message:@"请登陆后进行操作 ~(>_<)~ "
                                           delegate:self
                                  cancelButtonTitle:@"取消"
                                  otherButtonTitles:@"好的", nil];
    [_alertView show];
}

#pragma mark -- UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self.navigationController popViewControllerAnimated:YES];

    }
}
#pragma mark -- 登录

- (void)clickRightButton
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -- 注册

- (void)clickLeftButton
{
    [self.navigationController pushViewController:NewRegisterVCID
                                                          withStoryBoard:LoginStoryBoardName
                                                               withBlock:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [self dismiss];
}
@end
