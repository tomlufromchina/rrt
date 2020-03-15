//
//  CurrentGuarDianViewController.m
//  RenrenTong
//
//  Created by 符其彬 on 15/3/23.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "CurrentGuarDianViewController.h"
#import "MyZBPhotoViewController.h"
#import "ModificationViewController.h"
#import "CommunicationGuardianViewController.h"
#import "NoNavViewController.h"
#import "WebViewController.h"
#import "CurrentHeaderCell.h"
#import "CurrentAmong_GuardianCell.h"
#import "CurrentFooterCell.h"
#import "PushNoticeCell.h"
#import "AdverView.h"
#import "RecommentViewController.h"
#import "AlbumList.h"
#import "PersonModel.h"
#import "MJRefresh.h"
@interface CurrentGuarDianViewController ()<UITableViewDelegate,UITableViewDataSource,AdverViewDelegate,ModificationVCDelegate>
{
    int tmpNumber;
    Brage * brage;
    AdverView *adView;

}
@property (nonatomic, strong) NSMutableArray *imageArray;// 广告图片
@property (nonatomic, strong) NSMutableArray *communityArray;
@property (nonatomic, strong) NSMutableArray *educationArray;
@property (nonatomic, strong) NSMutableArray *myClassActivityArray;
@property (nonatomic, strong) NetWorkManager *netWorkManager;
@property (nonatomic, strong) NSMutableArray *myClassListArray;//班级名


@end

@implementation CurrentGuarDianViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavigation];
    self.navigationCenterView.hidden = YES;
    _netWorkManager = [[NetWorkManager alloc] init];
    _communityArray = [[NSMutableArray alloc] init];
    _educationArray = [[NSMutableArray alloc] init];
    _myClassActivityArray = [[NSMutableArray alloc] init];
    self.myClassListArray = [NSMutableArray array];
    
    self.mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - 49)];
    [self.view addSubview:self.mainTableView];
    self.mainTableView.dataSource = self;
    self.mainTableView.delegate = self;
    self.mainTableView.showsVerticalScrollIndicator = NO;
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self.mainTableView reloadData];
    
    [self initView];
    [self requestData];
    
    // 设置刷新
    [self setupRefresh];
}

- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.mainTableView addHeaderWithTarget:self action:@selector(headerReresh)];
}

- (void)headerReresh
{
    [self requestData];
}

#pragma mark -- 视图生命周期

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.tabBarController.tabBar.hidden = NO;
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
    [self dismiss];

}

- (void)initView
{
    // 判断是否安装点点微评
    NSIndexPath *cellPath = [NSIndexPath indexPathForItem:0 inSection:1];
    CurrentAmong_GuardianCell *cell = (CurrentAmong_GuardianCell *)[self.mainTableView cellForRowAtIndexPath:cellPath];
    
    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weidianping:"]]) {
        if (cell) {
            [cell.dianDianButton setImage:[UIImage imageNamed:@"mainicon-dd-setup"] forState:UIControlStateNormal];
        }
    }
    NSString *url = [NSString stringWithFormat:@"http://dsjtj.%@/Api/GetAdvert",aedudomain];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"3",@"advertType",[RRTManager manager].loginManager.loginInfo.tokenId,@"toKen",nil];
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
            NSIndexPath *cellPath = [NSIndexPath indexPathForItem:0 inSection:0];
            CurrentHeaderCell *cell = (CurrentHeaderCell *)[self.mainTableView cellForRowAtIndexPath:cellPath];
            if (cell) {
                // 初始化广告页
                adView = [[AdverView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 90) AdverType:HomePageTopAdver];
                adView.delegate = self;
                [adView setPicArray:array];
                [adView setLinkUrlArray:linkUrlArray];
                [adView setAdNameArray:adNameArray];
                [cell.advertiseMentView addSubview:adView];
            }
        }else{
            [self removeAdverView];
        }
    } fail:^(id errors) {
        [self removeAdverView];
    } cache:^(id cache) {
        
    }];
    
    brage = [[Brage alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(message:)
                                                 name: MESSAGE
                                               object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(ModificationHeaderImageview:)
                                                 name: ModificationHeader
                                               object: nil];
}

- (void)message:(NSNotification *)notefication{
    NSString* uid = [RRTManager manager].loginManager.loginInfo.userId;
    if (brage ) {
        brage.val=[[IMCache shareIMCache]
                     getPushBrage:uid];
    }
    [self.mainTableView reloadData];
}

-(void)ModificationHeaderImageview:(NSNotification*)notefication
{
    NSIndexPath *cellPath = [NSIndexPath indexPathForItem:0 inSection:0];
    CurrentHeaderCell *cell = (CurrentHeaderCell *)[self.mainTableView cellForRowAtIndexPath:cellPath];
    [cell.userHeaderImageView setImageWithURL:[NSURL URLWithString:[RRTManager manager].loginManager.loginInfo.userAvatar] placeholderImage:[UIImage imageNamed:@"default"] options:SDWebImageRefreshCached];
//    BOOL issettingid=[[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"%@isSettingId",[RRTManager manager].loginManager.loginInfo.userId]];
//    if (issettingid){
//        NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"currentImage.png"];
//        UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
//        NSIndexPath *cellPath = [NSIndexPath indexPathForItem:0 inSection:0];
//        CurrentHeaderCell *cell = (CurrentHeaderCell *)[self.mainTableView cellForRowAtIndexPath:cellPath];
//        if (cell) {
//            [cell.userHeaderImageView setImage:savedImage];
//        }
//    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name: MESSAGE object: nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ModificationHeader object:nil];
}

#pragma mark -- 获取用户信息
#pragma mark --

- (void)requestData
{
    __weak CurrentGuarDianViewController *_self = self;
    // 获取个人信息
//    [PersonalInfoNetService GetUserByToKen:[RRTManager manager].loginManager.loginInfo.tokenId
//                                Successful:^(id model) {
//                                    [_self gotoTheUI:model];
//                                    [self.mainTableView headerEndRefreshing];
//                                } Error:^(id model) {
//                                    if (model) {
//                                        [self showUploadView:model];
//                                        [self.mainTableView headerEndRefreshing];
//                                    }
//                                } Cache:^(id model) {
//                                    [_self gotoTheUI:model];
//                                    [self.mainTableView headerEndRefreshing];
//                                }];
    
    NSString *url2 = [NSString stringWithFormat:@"http://home.%@/api/GetUserByToKen",aedudomain];
    NSDictionary *dic2 = [NSDictionary dictionaryWithObjectsAndKeys:[RRTManager manager].loginManager.loginInfo.tokenId,@"Token",[RRTManager manager].loginManager.loginInfo.userId,@"userId",nil];
    [HttpUtil GetWithUrl:url2 parameters:dic2 success:^(id json) {
        PersonModel *result = [[PersonModel alloc] initWithString:json error:nil];
        if (result.st == 0) {
            [_self gotoTheUI:result.msg];
            [self.mainTableView headerEndRefreshing];
        }else{
            ErrorModel *erromodel = [[ErrorModel alloc] initWithString:json error:nil];
            [self showUploadView:erromodel.msg];
            [self.mainTableView headerEndRefreshing];
        }
    } fail:^(id errors) {
        [self showUploadView:errors];
        [self.mainTableView headerEndRefreshing];
    } cache:^(id cache) {
        PersonModel *result = [[PersonModel alloc] initWithString:cache error:nil];
        if (result.st == 0 ) {
            [_self gotoTheUI:result.msg];
            [self.mainTableView headerEndRefreshing];
        }
    }];
    
    // 获取开通服务情况
    [self.netWorkManager getClearServiceDetails:[RRTManager manager].loginManager.loginInfo.userId
                                       userrole:[RRTManager manager].loginManager.loginInfo.userRole success:^(NSMutableArray *data) {
                                           if (data) {
                                               tmpNumber = [data[0] intValue];
                                               [self.mainTableView headerEndRefreshing];
                                           }
                                       } failed:^(NSString *errorMSG) {
                                           [self.mainTableView headerEndRefreshing];
                                       }];
    
    // 社区动态
    
    NSString *url1 = [NSString stringWithFormat:@"http://home.%@/api/GetActivity",aedudomain];
    NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:@"",@"typeId",[RRTManager manager].loginManager.loginInfo.userId,@"userId",[NSString stringWithFormat:@"%d",1],@"pageSize",[NSString stringWithFormat:@"%d",1],@"pageIndex",nil];
    [HttpUtil GetWithUrl:url1 parameters:dic1 success:^(id json) {
        TheMyTendency *theGoodFriendTendency = [[TheMyTendency alloc] initWithString:json error:nil];
        if (theGoodFriendTendency.st == 0) {
            [self updateView:[theGoodFriendTendency.msg.list mutableCopy]];
            [self.mainTableView headerEndRefreshing];
        }else{
            ErrorModel *erromodel = [[ErrorModel alloc] initWithString:json error:nil];
            [self showUploadView:erromodel.msg];
            [self.mainTableView headerEndRefreshing];
        }
    } fail:^(id errors) {
        [self showUploadView:errors];
    } cache:^(id cache) {
        TheMyTendency *theGoodFriendTendency = [[TheMyTendency alloc] initWithString:cache error:nil];
        if (theGoodFriendTendency.st == 0) {
            [self updateView:[theGoodFriendTendency.msg.list mutableCopy]];
            [self.mainTableView headerEndRefreshing];
        }
    }];
    
    // 获取教育资讯
    NSString *url = [NSString stringWithFormat:@"http://nmapi.%@/home/GetNewsList",aedudomain];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"1",@"count",nil];
    [HttpUtil GetWithUrl:url parameters:dic success:^(id json) {
        AeduNewModel *aeduNewModel = [[AeduNewModel alloc] initWithString:json error:nil];
        if (aeduNewModel.result == 1) {
            _educationArray = (NSMutableArray*)aeduNewModel.items;
            [self.mainTableView reloadData];
            [self.mainTableView headerEndRefreshing];
        }else{
            ErrorModel *erromodel = [[ErrorModel alloc] initWithString:json error:nil];
            [self showUploadView:erromodel.msg];
            [self.mainTableView headerEndRefreshing];
        }
    } fail:^(id errors) {
        [self showUploadView:errors];
    } cache:^(id cache) {
        AeduNewModel *aeduNewModel = [[AeduNewModel alloc] initWithString:cache error:nil];
        if (aeduNewModel.result == 1) {
            _educationArray = (NSMutableArray*)aeduNewModel.items;
            [self.mainTableView reloadData];
            [self.mainTableView headerEndRefreshing];
        }
    }];

    // 我的班级动态
    
    url = [NSString stringWithFormat:@"http://home.%@/api/GetMyClassActivity",aedudomain];
    dic = [NSDictionary dictionaryWithObjectsAndKeys:[RRTManager manager].loginManager.loginInfo.tokenId,@"toKen",@"1",@"pageIndex",@"1",@"pageSize",nil];
    
    [HttpUtil GetWithUrl:url parameters:dic success:^(id json) {
        TheMyTendency *theMyTendency = [[TheMyTendency alloc] initWithString:json error:nil];
        if (theMyTendency.st == 0) {
            _myClassActivityArray = (NSMutableArray*)theMyTendency.msg.list;
            [self.mainTableView headerEndRefreshing];
            [self.mainTableView reloadData];
        }
        [self.mainTableView headerEndRefreshing];
    } fail:^(id errors) {
        [self.mainTableView headerEndRefreshing];
    } cache:^(id cache) {
        TheMyTendency *theMyTendency = [[TheMyTendency alloc] initWithString:cache error:nil];
        if (theMyTendency.st == 0) {
            _myClassActivityArray = (NSMutableArray*)theMyTendency.msg.list;
            [self.mainTableView reloadData];
            
        }
    }];
    
    // 获取班级列表
    
    url = [NSString stringWithFormat:@"http://nmapi.%@/class/GetClassList",aedudomain];
    dic = [NSDictionary dictionaryWithObjectsAndKeys:[RRTManager manager].loginManager.loginInfo.userId,@"userId",[RRTManager manager].loginManager.loginInfo.userId,@"UserRole",nil];
    [HttpUtil GetWithUrl:url parameters:dic success:^(id json) {
        MyCurrentClassListModel *list = [[MyCurrentClassListModel alloc] initWithString:json error:nil];
        if (list.result == 1) {
            [self.mainTableView headerEndRefreshing];
            self.myClassListArray = (NSMutableArray*)list.items;
        }
    } fail:^(id errors) {
        [self.mainTableView headerEndRefreshing];
    } cache:^(id cache) {
        MyCurrentClassListModel *list = [[MyCurrentClassListModel alloc] initWithString:cache error:nil];
        if (list.result == 1) {
            [self.mainTableView headerEndRefreshing];
            self.myClassListArray = (NSMutableArray*)list.items;
        }
    }];
    
    [self getOfflineMessages];
}
#pragma mark -- 获取离线消息

- (void)getOfflineMessages
{
    [self.netWorkManager getOfflineMessages:[RRTManager manager].loginManager.loginInfo.userId
                                    success:^(NSMutableArray *data) {
                                        NSArray *array = [NSArray array];
                                        array = [ReceiveMessage objectArrayWithKeyValuesArray:data];
                                        if(array.count > 0)
                                        {
                                            [self processingData:array];
                                        }
                                        
                                    } failed:^(NSString *errorMSG) {
                                        
                                    }];
}
- (void)processingData:(NSArray *)array
{
    for (ReceiveMessage *msg in array) {
        PacketBuilder* packetPacketBuilder =[Packet builder];
        
        [packetPacketBuilder setFrom:[NSString stringWithFormat:@"%@",[msg.PubUser objectForKey:@"UserId"]]];
        [packetPacketBuilder setTo:[msg.RecieveUser objectForKey:@"UserId"]];
        
        MessagePacketBuilder* messagePacketBuilder=[MessagePacket builder];
        [messagePacketBuilder setGuid:msg.MessageId];
        [messagePacketBuilder setState:msg.StatusId];
        [messagePacketBuilder setType:msg.Type];
        [messagePacketBuilder setAutoid:[msg.LineId intValue]];
        
        MessageBodyBuilder* messageBodyBuilder=[MessageBody builder];
        [messageBodyBuilder setType:msg.BodyType];
        [messageBodyBuilder setContent:msg.MessageContent];
        [messageBodyBuilder setPictureuri:msg.Pic[0]];
        [messageBodyBuilder setAudiouri:msg.Audio[0]];
        [messageBodyBuilder setSender:[msg.PubUser objectForKey:@"UserName"]];
        [messageBodyBuilder setReceiver:[RRTManager manager].loginManager.loginInfo.userName];
        [messageBodyBuilder setSendtime:msg.PubTime];
        [messageBodyBuilder setPushmsgtype:msg.HeadType];
        if (msg.Type==[[NSString stringWithFormat:@"%d",(int)MessageTypeGroupChat] intValue]&&msg.GroupId!=nil&&msg.GroupName!=nil&&msg.GroupType!=0) {
            [messageBodyBuilder setGroupid:msg.GroupId];
            [messageBodyBuilder setGroupname:msg.GroupName];
            [messageBodyBuilder setGrouptype:[NSString stringWithFormat:@"%@",msg.GroupType]];
        }
        if (msg.Type == [[NSString stringWithFormat:@"%d",(int)MessageTypeRecommend] intValue]) {
            [messageBodyBuilder setUrl:msg.Url];
            [messageBodyBuilder setUrldesc:msg.UrlDescription];
            [messageBodyBuilder setUrlpic:msg.UrlPicture];
        }
        [messagePacketBuilder setBodyBuilder:messageBodyBuilder];
        [packetPacketBuilder setMessageBuilder:messagePacketBuilder];
        
        Packet* packetMsg =[packetPacketBuilder build];
        if (packetMsg.message.type==MessageTypeGroupChat) {
            [[IMCache shareIMCache] savePacket:packetMsg sessionid:[NSString stringWithFormat:@"%@%@",packetMsg.message.body.groupid,packetMsg.to]];
        } else if(packetMsg.message.type==MessageTypeChat){
            [[IMCache shareIMCache] savePacket:packetMsg sessionid:[NSString stringWithFormat:@"%@",[msg.PubUser objectForKey:@"UserId"]]];
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE object:nil];
}
#pragma mark -- 刷新界面
#pragma mark --

- (void)gotoTheUI:(PersonModelMsg *)data
{
    if (data) {
        NSIndexPath *cellPath = [NSIndexPath indexPathForItem:0 inSection:0];
        CurrentHeaderCell *cell = (CurrentHeaderCell *)[self.mainTableView cellForRowAtIndexPath:cellPath];
        if (cell) {
            NSUserDefaults* nud = [NSUserDefaults standardUserDefaults];
            BOOL issettingid=[nud boolForKey:[NSString stringWithFormat:@"%@isSettingId",[RRTManager manager].loginManager.loginInfo.userId]];
            if (issettingid) {
                [self issettinged];
            }else{
                [cell.userHeaderImageView setImageWithURL:[NSURL URLWithString:[RRTManager manager].loginManager.loginInfo.userAvatar] placeholderImage:[UIImage imageNamed:@"default"]];
            }
            
            cell.userNameLabel.text = [NSString stringWithFormat:@"%@ (%@)",[RRTManager manager].loginManager.loginInfo.userName,data.RoleName];
            
            if ([data.SchoolName isKindOfClass:[NSNull class]] || data.SchoolName.length <= 0) {
                cell.userSchoolNameLabel.text = @"暂未加入任何学校";
            } else{
                cell.userSchoolNameLabel.text = data.SchoolName;
                
            }
            /**
             *  通知传值
             */
            NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:data.RoleName,@"RoleName", nil];
            NSNotification *notification = [NSNotification notificationWithName:@"RoleName" object:nil userInfo:dict];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            if ([data.ExperiencePoints isKindOfClass:[NSNull class]]) {
                cell.integralLabel.text = @"暂无积分";
            } else{
                cell.integralLabel.text = [NSString stringWithFormat:@"%@",data.ExperiencePoints];
            }
        }
    }
}

- (void)updateView:(NSMutableArray *)data
{
    if (data && [data count] > 0) {
        _communityArray = data;
        [self.mainTableView reloadData];
    }
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.1;
    }else if (section == 3){
        return 1;
    } else{
        return 15;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 165;
    } else if(indexPath.section == 1){
        return 110;
    } else{
        return 62;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
        case 1:
            return 1;
        case 2:
            return 1;
        case 3:
            return 4;
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        static NSString *cellIdentifier = @"CurrentHeaderCell";
        CurrentHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"CurrentHeaderCell" owner:self options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;//没有点击效果
        }
        [cell.userHeaderImageView setImageWithURL:[NSURL URLWithString:[RRTManager manager].loginManager.loginInfo.userAvatar] placeholderImage:[UIImage imageNamed:@"default"] options:SDWebImageRefreshCached];
        [cell.clickIntegralButton addTarget:self action:@selector(clickIteralButton) forControlEvents:UIControlEventTouchUpInside];
        [cell.headerButton addTarget:self action:@selector(clickTheHearder:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
        
    } else if (indexPath.section == 1){
        static NSString *cellIdentifier = @"CurrentAmong_GuardianCell";
        CurrentAmong_GuardianCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            //通过xib的名称加载自定义的cell
            cell = [[[NSBundle mainBundle] loadNibNamed:@"CurrentAmong_GuardianCell" owner:self options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [cell.jobButton addTarget:self action:@selector(clickJobButton:) forControlEvents:UIControlEventTouchUpInside];
        [cell.noticeButton addTarget:self action:@selector(clickNoticeButton:) forControlEvents:UIControlEventTouchUpInside];
        [cell.resultButton addTarget:self action:@selector(clickRuseltButton:) forControlEvents:UIControlEventTouchUpInside];
        [cell.dianDianButton addTarget:self action:@selector(clickDianDianButton:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    } else if (indexPath.section == 2){
        static NSString *cellIdentifier = @"PushNoticeCell";
        PushNoticeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];// 飘红气泡
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"PushNoticeCell" owner:self options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        NSString* uid = [RRTManager manager].loginManager.loginInfo.userId;
        brage.top =-5 ;
        brage.left =22 ;
        brage.val = [[IMCache shareIMCache] getPushBrage:uid];
        [cell addSubview:brage];
        Packet* packet=[[IMCache shareIMCache] queryLastPushPacket:uid];
        if (packet!=nil) {
            NSString* title=@"家校消息";
//            if (packet.message.type==MessageTypePush) {
//                switch (packet.message.body.pushmsgtype) {
//                    case -1:
//                        title=@"未知";
//                        break;
//                    case 0:
//                        title=@"全部";
//                        break;
//                    case 1:
//                        title=@"留言";
//                        break;
//                    case 2:
//                        title=@"成绩";
//                        break;
//                    case 3:
//                        title=@"平安";
//                        break;
//                    case 4:
//                        title=@"考勤";
//                        break;
//                    case 5:
//                        title=@"好友申请";
//                        break;
//                    case 6:
//                        title=@"小纸条";
//                        break;
//                    case 7:
//                        title=@"系统消息";
//                        break;
//                    case 8:
//                        title=@"作业";
//                        break;
//                    case 9:
//                        title=@"祝福";
//                        break;
//                    case 10:
//                        title=@"表现";
//                        break;
//                    case 11:
//                        title=@"通知";
//                        break;
//                    case 15:
//                        title=@"回复";
//                        break;
//                    case 16:
//                        title=@"断网通知";
//                        break;
//                    case 17:
//                        title=@"账号";
//                        break;
//                    case 18:
//                        title=@"服务到期";
//                        break;
//                    case 19:
//                        title=@"密码找回";
//                        break;
//                    case 20:
//                        title=@"测试信息";
//                        break;
//                    case 21:
//                        title=@"短信充值处理成功提醒";
//                        break;
//                    case 22:
//                        title=@"短信余额提醒";
//                        break;
//                    case 23:
//                        title=@"登录验证码";
//                        break;
//                        
//                    default:
//                        title=@"未知";
//                        break;
//                }
//            }
            cell.titleTypeLabel.text=title;
            cell.conmentLabel.text=packet.message.body.content;
            cell.timeLabel.text=packet.message.body.sendtime;
        }else{
            cell.titleTypeLabel.text=@"家校消息";
            cell.conmentLabel.text=@"暂无消息 %>_<%";
            cell.timeLabel.text=@"";
        }
        return cell;
    } else{
        static NSString *cellIdentifier = @"CurrentFooterCell";
        CurrentFooterCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"CurrentFooterCell" owner:self options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if (indexPath.row == 0) {
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
                cell.timeLabel.text = @"";
            }
        } else if (indexPath.row == 1){
            cell.userHeaderImageView.hidden = NO;
            cell.userHeaderImageView2.hidden = YES;
            cell.userHeaderImageView3.hidden = YES;
            cell.userHeaderImageView4.hidden = YES;
            
            cell.titleLabel.hidden = NO;
            cell.titleLabel1.hidden = YES;
            cell.titleLabel2.hidden = YES;
            cell.titleLabel3.hidden = YES;
            if (_communityArray && [_communityArray count] > 0) {
                
                TheMyTendencyList *VM = (TheMyTendencyList *)[_communityArray objectAtIndex:0];
                cell.conmmentLabel.text = [NSString stringWithFormat:@"%@: %@",VM.UserName,VM.Body];
                cell.timeLabel.text = VM.DateTime;

            } else{
                cell.conmmentLabel.text = @"暂无社区动态 %>_<%";
                cell.timeLabel.text = @"";
            }
            
        } else if (indexPath.row == 2){
            cell.userHeaderImageView.hidden = YES;
            cell.userHeaderImageView2.hidden = YES;
            cell.userHeaderImageView3.hidden = YES;
            cell.userHeaderImageView4.hidden = NO;
            
            cell.titleLabel.hidden = YES;
            cell.titleLabel1.hidden = YES;
            cell.titleLabel2.hidden = YES;
            cell.titleLabel3.hidden = NO;
            NSMutableArray *recommentSouce = [[IMCache shareIMCache] queryPacketRecomment:NO uid:[RRTManager manager].loginManager.loginInfo.userId];
            if (recommentSouce && [recommentSouce count] > 0) {
                Packet *packte = (Packet *)[recommentSouce objectAtIndex:0];
                
                cell.conmmentLabel.text = packte.message.body.urldesc;
                cell.timeLabel.text =packte.message.body.receivetime;
            } else{
                cell.conmmentLabel.text = @"暂无资源推荐";
                cell.timeLabel.text = @"";
            }
        }else if (indexPath.row == 3){
            cell.userHeaderImageView.hidden = YES;
            cell.userHeaderImageView2.hidden = NO;
            cell.userHeaderImageView3.hidden = YES;
            cell.userHeaderImageView4.hidden = YES;
            cell.titleLabel.hidden = YES;
            cell.titleLabel1.hidden = YES;
            cell.titleLabel3.hidden = YES;
            cell.titleLabel2.hidden = NO;
            
            if (_myClassActivityArray && [_myClassActivityArray count] > 0) {
                TheMyTendencyList *MN = (TheMyTendencyList *)[_myClassActivityArray objectAtIndex:0];
                cell.conmmentLabel.text = [NSString stringWithFormat:@"%@: %@",MN.UserName,MN.Body];
                cell.timeLabel.text = MN.DateTime;
            } else{
                cell.conmmentLabel.text = @"暂无班级动态 %>_<%";
                cell.timeLabel.text = @"";
            }
        }  else if (indexPath.row == 4){
            cell.userHeaderImageView.hidden = YES;
            cell.userHeaderImageView2.hidden = YES;
            cell.userHeaderImageView3.hidden = YES;
            cell.userHeaderImageView4.hidden = NO;
            
            cell.titleLabel.hidden = YES;
            cell.titleLabel1.hidden = YES;
            cell.titleLabel2.hidden = YES;
            cell.titleLabel3.hidden = NO;
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 2) {
        [self.navigationController pushViewController:CommunicationGuardianVCID
                                       withStoryBoard:DeskStoryBoardName withBlock:^(UIViewController *viewController) {
                                           //                                           CommunicationGuardianViewController *VC = (CommunicationGuardianViewController *)viewController;
                                           //                                           VC.theTitle = @"通知";
                                           //                                           VC.headType = 11;
                                       }];
        [self bigData:P_SchoolNofication];

    } else if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            NoNavViewController *VC = [[NoNavViewController alloc] init];
            NSString *URL0 = [NSString stringWithFormat:@"http://www.%@/MoblieNews",aedudomain];
            VC.URL = URL0;
            VC.title = @"教育资讯";
            [self.navigationController pushViewController:VC animated:YES];
            [self bigData:P_EducationConsult];

        } else if (indexPath.row == 1){
            [self.navigationController pushViewController:GoodFriendCircleVCID
                                           withStoryBoard:ActivityStoryBoardName
                                                withBlock:nil];
            [self bigData:P_SocialDynamic];

        }else if (indexPath.row == 2){
            RecommentViewController *vc = [[RecommentViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }else if (indexPath.row == 3){
            if ([self.myClassListArray count] > 0) {
                [self.navigationController pushViewController:MyClassVCID
                                               withStoryBoard:DiscoverStoryBoardName withBlock:nil];
            } else{
                [self showImage:nil status:@"你还没加入任何班级哦"];
            }
            [self bigData:P_ClassDynamic];

        }
    }

}

#pragma mark -- 点击头像
#pragma mark --
- (void)clickTheHearder:(UIButton *)sender
{
    [self.sideMenuViewController presentLeftMenuViewController];
    [self bigData:P_PersonalInfo];
}

#pragma mark -- AdverViewDelegate
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
    [adView removeFromSuperview];
    self.mainTableView.frame = CGRectMake(0, -80, SCREENWIDTH, SCREENHEIGHT + 80 - 49);
}
#pragma mark -- 积分按钮响应
#pragma mark --

- (void)clickIteralButton
{
    NoNavViewController *VC = [[NoNavViewController alloc] init];
    NSString *URL0 = [NSString stringWithFormat:@"http://www.%@/gift/pointsmall?token=%@",aedudomain,[RRTManager manager].loginManager.loginInfo.tokenId];
    VC.URL = URL0;
    VC.title = @"商城";
    [self.navigationController pushViewController:VC animated:YES];
    
    [self bigData:P_Intergral];

}

#pragma mark -- 作业、通知、成绩、点点微评 按钮响应
#pragma mark --

- (void)clickJobButton:(UIButton *)sender
{
    
    if (tmpNumber == -1||tmpNumber == 1) {
        [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"您的账号未开通或付费到期！"];
        
    } else{
        NoNavViewController *VC = [[NoNavViewController alloc] init];
        NSString *URL0 = [NSString stringWithFormat:@"http://phoneweb.%@/parent/exam?isapp=true",aedudomain];
        VC.URL = URL0;
        VC.title = @"成绩系统";
        [self.navigationController pushViewController:VC animated:YES];
//        [self.navigationController pushViewController:CommunicationGuardianVCID
//                                       withStoryBoard:DeskStoryBoardName withBlock:^(UIViewController *viewController) {
//                                           CommunicationGuardianViewController *VC = (CommunicationGuardianViewController *)viewController;
//                                           VC.theTitle = @"作业";
//                                           VC.headType = 8;
//                                       }];
    }
    
    [self bigData:P_Performance];

}

- (void)clickNoticeButton:(UIButton *)sender
{
    if (tmpNumber==-1||tmpNumber==1) {
        [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"您的账号未开通或付费到期！"];
        
    } else{
        NoNavViewController *VC = [[NoNavViewController alloc] init];
        NSString *URL01 = [NSString stringWithFormat:@"http://phoneweb.%@/parent/card?isapp=true",aedudomain];
        VC.URL = URL01;
        VC.title = @"平安考勤";
        [self.navigationController pushViewController:VC animated:YES];
//        [self.navigationController pushViewController:CommunicationGuardianVCID
//                                       withStoryBoard:DeskStoryBoardName withBlock:^(UIViewController *viewController) {
//                                           CommunicationGuardianViewController *VC = (CommunicationGuardianViewController *)viewController;
//                                           VC.theTitle = @"通知";
//                                           VC.headType = 11;
//                                       }];
    }
    [self bigData:P_CheckOnWorkAttendance];

}

- (void)clickRuseltButton:(UIButton *)sender
{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weidianping:"]]) {
        NSString *str = [NSString stringWithFormat:@"weidianping://token=%@",[RRTManager manager].loginManager.loginInfo.tokenId];
        NSURL *url = [NSURL URLWithString:str];
        [[UIApplication sharedApplication] openURL:url];
    } else {
        // 下载完后会有一个下载地址
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=948188537"]];
    }
    [self bigData:P_DianDianWeiPing];

}

- (void)clickDianDianButton:(UIButton *)sender
{
    if (tmpNumber==-1||tmpNumber==1) {
        [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"您的账号未开通或付费到期！"];
        
    } else{
        NoNavViewController *VC = [[NoNavViewController alloc] init];
        NSString *URL01 = [NSString stringWithFormat:@"http://phoneweb.%@/parent/home/timetable",aedudomain];
        VC.URL = URL01;
        VC.title = @"课程表";
        [self.navigationController pushViewController:VC animated:YES];
    }
    [self bigData:P_CourseList];

}

#pragma mark -- 侧边菜单选各项卡响应
#pragma mark --

- (IBAction)clickcodeCardButton:(UIButton *)sender
{
    MyZBPhotoViewController *ZBVc = [[MyZBPhotoViewController alloc]init];
    [self.navigationController pushViewController:ZBVc animated:YES];
}

- (IBAction)clickgradingButton:(UIButton *)sender {
    NSString *webLink = @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=641431831";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:webLink]];
    self.navigationController.tabBarController.tabBar.hidden = NO;

}

- (IBAction)clickaboutButton:(UIButton *)sender
{
    self.navigationController.tabBarController.tabBar.hidden = NO;
    [self.navigationController pushViewController:AboutVCID
                                   withStoryBoard:SettingStoryBoardName
                                        withBlock:nil];
}

- (IBAction)clickpersonalInformationButton:(UIButton *)sender
{
    [self.navigationController pushViewController:ModificationVCID
                                   withStoryBoard:SettingStoryBoardName
                                        withBlock:^(UIViewController *viewController) {
                                            ModificationViewController *VC = (ModificationViewController *)viewController;
                                            VC.delegate = self;
                                            VC.isRole = @"老师";
                                        }];
    [self bigData:P_PersonalInfo];
}

- (IBAction)clickfeedBackButton:(UIButton *)sender
{
    self.navigationController.navigationBar.hidden = YES;
    WebViewController *VC = [[WebViewController alloc] init];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                 style:UIBarButtonItemStylePlain
                                                                target:nil
                                                                action:nil];
    [self.navigationItem setBackBarButtonItem:backItem];
    
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    CFShow((__bridge CFTypeRef)(infoDic));
    NSString *appVersion = [infoDic objectForKey:@"CFBundleVersion"];
    NSString *theAppVersion = [NSString stringWithFormat:@"v%@",appVersion];
    
    NSString *str = [NSString stringWithFormat:@"http://dsjtj.%@/Question/index?token=%@&ProductId=5&Edition=%@",aedudomain,[RRTManager manager].loginManager.loginInfo.tokenId,theAppVersion];
    NSString *URL2 = str;
    VC.URL = URL2;
    VC.title = @"问题反馈";
    [self.navigationController pushViewController:VC animated:YES];
}

- (IBAction)clickaccountButton:(UIButton *)sender
{
    self.navigationController.tabBarController.tabBar.hidden = NO;
    [self.navigationController pushViewController:SwitchAccountVCID
                                   withStoryBoard:AboutMeStoryBoardName
                                        withBlock:nil];
}

#pragma mark -- ModificationVCDelegete

- (void)issettinged
{
    BOOL issettingid=[[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"%@isSettingId",[RRTManager manager].loginManager.loginInfo.userId]];
    if (issettingid) {
        NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"currentImage.png"];
        UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
        NSIndexPath *cellPath = [NSIndexPath indexPathForItem:0 inSection:0];
        CurrentHeaderCell *cell = (CurrentHeaderCell *)[self.mainTableView cellForRowAtIndexPath:cellPath];
        if (cell) {
            [cell.userHeaderImageView setImage:savedImage];
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

@end