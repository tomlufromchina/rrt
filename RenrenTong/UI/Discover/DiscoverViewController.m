//
//  DiscoverViewController.m
//  RenrenTong
//
//  Created by aedu on 15/3/26.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "DiscoverViewController.h"
#import "ViewControllerIdentifier.h"
#import "FriendTendencyViewController.h"
#import "MyTendencyViewController.h"
#import "MyZBPhotoViewController.h"
#import "ContactDetailViewController.h"
#import "RootViewController.h"
#import "NoNavViewController.h"
#import "WebViewController.h"
#import "AdverView.h"
#import "HotTopic.h"
#import "MJExtension.h"
#import "TheHotTopicDetailsViewController.h"

#import "AlbumList.h"

@interface DiscoverViewController ()<RootViewControllerDelegate,AdverViewDelegate>

@property (nonatomic, strong) NSString *ZBurl;
@property (nonatomic, strong) AdverView *adView;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSArray *details;
@property (nonatomic, strong) NSMutableArray *myClassListArray;//班级名

@property (nonatomic, strong) NetWorkManager *netWorkManager;
@property(nonatomic, strong)NSArray *hotTopicArray;

@end

@implementation DiscoverViewController
- (NSArray *)hotTopicArray
{
    if (!_hotTopicArray) {
        _hotTopicArray = [NSArray array];
    }
    return _hotTopicArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavigation];
    self.titleLabel.text = @"发现";
    
    [self.navigationRightButton setBackgroundImage:[UIImage imageNamed:@"发现_03"] forState:UIControlStateNormal];
    
    // 广告请求
    
    NSString *url = [NSString stringWithFormat:@"http://dsjtj.%@/Api/GetAdvert",aedudomain];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"5",@"advertType",[RRTManager manager].loginManager.loginInfo.tokenId,@"toKen",nil];
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
            self.adView.delegate = self;
            [self.adView setPicArray:array];
            [self.adView setLinkUrlArray:linkUrlArray];
            [self.adView setAdNameArray:adNameArray];
        }else{
            [self removeAdverView];
        }
    } fail:^(id errors) {
        [self removeAdverView];
    } cache:^(id cache) {
        Adver *result = [[Adver alloc] initWithString:cache error:nil];
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
                self.adView.delegate = self;
                [self.adView setPicArray:array];
                [self.adView setLinkUrlArray:linkUrlArray];
                [self.adView setAdNameArray:adNameArray];
            }
    }];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT - 64 -49)];
    self.mainView = tableView;
    self.mainView.delegate = self;
    self.mainView.dataSource = self;
    self.mainView.tableHeaderView = self.adView;
    [self.view addSubview:tableView];
    
    self.titles = [NSArray arrayWithObjects:@"社区动态 (好友圈)",
                   @"我的班级",@"商城",@"活动",nil];
    
    self.images = [NSArray arrayWithObjects:@"hy-",
                   @"bj-",@"gw-",
                   @"hd-",nil];
    self.details = [NSArray arrayWithObjects:@"看看大家都在聊什么",@"关注我感兴趣的资讯",@"班级内的最新消息", nil];
    
    self.netWorkManager = [[NetWorkManager alloc]init];
    self.myClassListArray = [NSMutableArray array];
    [self getRecommendTags];
}

#pragma mark -- AdverViewDelegete
#pragma mark --

-(void)clickTheImages:(int)tag andWithAdNameArray:(NSMutableArray *)adNameArray andWithLinkUrlArray:(NSMutableArray *)linkUrlArry
{
    WebViewController *VC = [[WebViewController alloc] init];
    NSString *URL0 = [linkUrlArry objectAtIndex:tag];
    VC.URL = URL0;
    VC.title = [adNameArray objectAtIndex:tag];
    [self.navigationController pushViewController:VC animated:YES];
}

-(void)removeAdverView
{
    [self.adView removeFromSuperview];
    self.mainView.tableHeaderView = nil;
}

-(void)navigationRightButtonClick:(UIButton*)sender
{
    if(is_IOS_7)
    {
        RootViewController * rt = [[RootViewController alloc]init];
        rt.delegate = self;
        [self presentViewController:rt animated:YES completion:^{
        }];
    }
    else
    {
        [self showImage:[UIImage imageNamed:@"confirm-err72"] status:@"该功能只支持IOS7以上设备!"];
    }
}
- (void)getRecommendTags
{
    NSString *url = [NSString stringWithFormat:@"http://home.%@/api/GetRecommendTags",aedudomain];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"10",@"topNum",nil];
    [HttpUtil GetWithUrl:url
              parameters:dic
                 success:^(id json) {
                     TheHotTopicModel *theHotTopicModel = [[TheHotTopicModel alloc] initWithString:json error:nil];
                     if (theHotTopicModel.st == 0) {
                         self.hotTopicArray = theHotTopicModel.msg.list;
                         [self.mainView reloadData];
                     }else{
                         ErrorModel *erromodel = [[ErrorModel alloc] initWithString:json error:nil];
                         [self showUploadView:erromodel.msg];
                     }
                 } fail:^(id errors) {
                     [self showUploadView:errors];
                 } cache:^(id cache) {
                     
                 }];
    
    
    // 获取班级列表
    url = [NSString stringWithFormat:@"http://nmapi.%@/class/GetClassList",aedudomain];
    dic = [NSDictionary dictionaryWithObjectsAndKeys:[RRTManager manager].loginManager.loginInfo.userId,@"userId",[RRTManager manager].loginManager.loginInfo.userRole,@"UserRole",nil];
    [HttpUtil GetWithUrl:url parameters:dic success:^(id json) {
        MyCurrentClassListModel *list = [[MyCurrentClassListModel alloc] initWithString:json error:nil];
        if (list.result == 1) {
            self.myClassListArray = (NSMutableArray*)list.items;
        }
    } fail:^(id errors) {
    } cache:^(id cache) {
        MyCurrentClassListModel *list = [[MyCurrentClassListModel alloc] initWithString:cache error:nil];
        if (list.result == 1) {
            self.myClassListArray = (NSMutableArray*)list.items;
        }
    }];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
        case 1:
            return 2;
        case 2:
            return 2;
        default:
            return 0;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *string = [NSString stringWithFormat:@"Cell%d",indexPath.section];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:string];
    if (indexPath.section == 0) {
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:string];
        }
        TheHotTopicModelList *hotTopic = [self.hotTopicArray firstObject];
        cell.imageView.image = [UIImage imageNamed:@"ht-"];
        
        if (hotTopic.TagName.length != 0) {
            cell.textLabel.text = hotTopic.TagName;
        }
        else
        {
            cell.textLabel.text = @"暂无热门话题";
        }
        if (hotTopic.ItemCount) {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"讨论 %@",hotTopic.ItemCount];
        }
    }else if (indexPath.section == 1)
    {
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:string];
        }
        cell.imageView.image = [UIImage imageNamed:(NSString*)[self.images objectAtIndex:indexPath.row]];
        cell.textLabel.text = (NSString*)[self.titles objectAtIndex:indexPath.row];
        cell.detailTextLabel.text = (NSString*)[self.details objectAtIndex:indexPath.row];
        cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    }else if (indexPath.section == 2)
    {
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:string];
        }
        int index = indexPath.row + 2;
        cell.imageView.image = [UIImage imageNamed:(NSString*)[self.images objectAtIndex:index]];
        cell.textLabel.text = (NSString*)[self.titles objectAtIndex:index];
    }
     cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        [self.navigationController pushViewController:HotTicopDetailsVCID
                                       withStoryBoard:DiscoverStoryBoardName withBlock:^(UIViewController *viewController) {
                                           TheHotTopicDetailsViewController *VC = (TheHotTopicDetailsViewController *)viewController;
                                           VC.hotTopic = [self.hotTopicArray firstObject];
                                       }];
        if ([[NSString stringWithFormat:@"%@",[RRTManager manager].loginManager.loginInfo.userRole] isEqualToString:@"1"]) {
            [self bigData:S_Topic];
        } else if ([[NSString stringWithFormat:@"%@",[RRTManager manager].loginManager.loginInfo.userRole] isEqualToString:@"2"]){
            [self bigData:P_Topic];
        } else{
            [self bigData:T_Topic];
        }
    }else if (indexPath.section == 1)
    {
        if (indexPath.row == 0) {
            
            [self.navigationController pushViewController:GoodFriendCircleVCID
                                           withStoryBoard:ActivityStoryBoardName
                                                withBlock:nil];
            
            if ([[NSString stringWithFormat:@"%@",[RRTManager manager].loginManager.loginInfo.userRole] isEqualToString:@"1"]) {
                [self bigData:S_FriendsCircle];
            } else if ([[NSString stringWithFormat:@"%@",[RRTManager manager].loginManager.loginInfo.userRole] isEqualToString:@"2"]){
                [self bigData:P_FriendsCircle];
            } else{
                [self bigData:T_FriendsCircle];
            }
            
        } else if (indexPath.row == 1){
            if ([self.myClassListArray count] > 0) {
                [self.navigationController pushViewController:MyClassVCID
                                               withStoryBoard:DiscoverStoryBoardName withBlock:nil];
            } else{
                [self showUploadView:@"你还没加入任何班级哦"];
            }
            
            if ([[NSString stringWithFormat:@"%@",[RRTManager manager].loginManager.loginInfo.userRole] isEqualToString:@"1"]) {
                [self bigData:S_MyClass];
            } else if ([[NSString stringWithFormat:@"%@",[RRTManager manager].loginManager.loginInfo.userRole] isEqualToString:@"2"]){
                [self bigData:P_MyClass];
            } else{
                [self bigData:T_MyClass];
            }
        }
    } else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            NoNavViewController *VC = [[NoNavViewController alloc] init];
            NSString *URL0 = [NSString stringWithFormat:@"http://www.%@/gift/pointsmall?token=%@",aedudomain,[RRTManager manager].loginManager.loginInfo.tokenId];
            VC.URL = URL0;
            VC.title = @"商城";
            [self.navigationController pushViewController:VC animated:YES];
            
            if ([[NSString stringWithFormat:@"%@",[RRTManager manager].loginManager.loginInfo.userRole] isEqualToString:@"1"]) {
                [self bigData:S_ShoppingMall];
            } else if ([[NSString stringWithFormat:@"%@",[RRTManager manager].loginManager.loginInfo.userRole] isEqualToString:@"2"]){
                [self bigData:P_ShoppingMall];
            } else{
                [self bigData:T_ShoppingMall];
            }
            
        } else if (indexPath.row == 1){
            WebViewController *wvc = [[WebViewController alloc] init];
            NSString *str = [NSString stringWithFormat:@"http://www.%@/gift/myspace.html?token=%@",aedudomain,[RRTManager manager].loginManager.loginInfo.tokenId];
            NSString *URL2 = str;
            wvc.URL = URL2;
            wvc.title = @"活动";
            [self.navigationController pushViewController:wvc animated:YES];
            
            if ([[NSString stringWithFormat:@"%@",[RRTManager manager].loginManager.loginInfo.userRole] isEqualToString:@"1"]) {
                [self bigData:S_Activity];
            } else if ([[NSString stringWithFormat:@"%@",[RRTManager manager].loginManager.loginInfo.userRole] isEqualToString:@"2"]){
                [self bigData:P_Activity];
            } else{
                [self bigData:T_Activity];
            }
        }
    }
}

- (void)stringData:(NSString *)string
{
    //用户userID匹配
    NSString *ZBRegex = @"^\\d{5,9}$";
    NSPredicate *ZBTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",ZBRegex];
    
    //网址匹配
    NSString *regex = @"http+:[^\\s]*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    
    if([ZBTest evaluateWithObject:string])
    {
        [self.navigationController pushViewController:ContactDetailVCID
                                       withStoryBoard:ContactStoryBoardName
                                            withBlock:^(UIViewController *viewController) {
                                                ContactDetailViewController *vc = (ContactDetailViewController*)viewController;
                                                vc.OUserId = string;
                                                
                                            }];
    }
    else if([predicate evaluateWithObject:string])
    {
        self.ZBurl = string;
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil
                                                        message:@"你将打开这个网址!"
                                                       delegate:nil
                                              cancelButtonTitle:@"关闭"
                                              otherButtonTitles:@"好", nil];
        alert.tag = 10000;
        alert.delegate = self;
        [alert show];
    }else
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil
                                                        message:@"扫描结果无效"
                                                       delegate:nil
                                              cancelButtonTitle:@"关闭"
                                              otherButtonTitles:nil];
        alert.tag = 10001;
        alert.delegate = self;
        [alert show];
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==10000) {
        if (buttonIndex==1) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.ZBurl]];
        }
    }
}
/**
 *  大数据统计
 *
 *  @param key BigData
 */
- (void)bigData:(BigData)key
{
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    CFShow((__bridge CFTypeRef)(infoDic));
    NSString *appVersion = [infoDic objectForKey:@"CFBundleVersion"];
    NSString *theAppVersion = [NSString stringWithFormat:@"v%@",appVersion];
    [self.netWorkManager getBrowseNumber:[RRTManager manager].loginManager.loginInfo.userId
                         ppId:key
                    productId:@"5"
                      version:theAppVersion
                      success:^(NSString *data) {
                          
                      } failed:^(NSString *errorMSG) {
                          
                      }];
}

- (void)viewDidAppear:(BOOL)animated
{
    self.hidesBottomBarWhenPushed = YES;
}
- (void)viewWillDisappear:(BOOL)animated
{
    self.hidesBottomBarWhenPushed = NO;
}

@end
