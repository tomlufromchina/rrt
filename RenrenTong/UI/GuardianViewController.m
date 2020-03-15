//
//  GuardianViewController.m
//  RenrenTong
//
//  Created by 符其彬 on 14/12/6.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "GuardianViewController.h"
#import "WebViewController.h"
#import "TheNoticeViewController.h"
#import "ModificationViewController.h"
#import "NoticeBookViewController.h"
#import "CommunicationGuardianViewController.h"
#import "MJRefresh.h"
#import "WebViewController.h"
#import "MJExtension.h"
#import "ReceiveMessage.h"
#import "NoNavViewController.h"
#import "MyZBPhotoViewController.h"

@interface GuardianViewController ()<ModificationVCDelegate>
{
    UIView *chooseTitleTableView;
    UIView* dim;
    NSArray *menuArray;
    UIView *statusBarView;
    UIButton *button;
    
    // 临时变量
    float width;
    float setup;
    
    StudentExam *_SE;
    StudentRank *_SR;
    NSMutableArray* subjectArray;
    NSMutableArray *subjectPlaceArray;
    
    BOOL ischuxian;
    UIView *noticeView;
    UIImageView *noticeHeaderIMG;
    UILabel *noticeLabel;
    NSArray *MessageCountArray;
    NSString *endURL;
    Brage * brage;
    int tmpNumber;
}
@property (nonatomic, strong) NetWorkManager *netWorkManager;
@property (strong, nonatomic) UMFeedback *feedback;

@end

@implementation GuardianViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
#warning 期末通知书 明年重做 目前自定义推送 不支持
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(BushBaoCun)
                                                 name: kBushBaoCun
                                               object: nil];
    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weidianping:"]]) {
        [self.WPButton setImage:[UIImage imageNamed:@"mainicon-dd-setup"] forState:UIControlStateNormal];
    }
    
    if (SCREENHEIGHT == 480) {
        self.headerImageView.top = 0;
        self.headerImageView.left = SCREENWIDTH/4 + SCREENWIDTH/6 - 15;
        self.headerImageView.width = SCREENWIDTH/4;
        self.headerImageView.height = SCREENWIDTH/4;
        self.headerImageView.tag = 0;
        
        self.leftButton.left = 10;
        self.leftButton.top = 30;
        self.leftLabel.left = 7;
        self.leftLabel.top = self.leftButton.bottom - 10;
        
        self.rightButton.right = SCREENWIDTH - 10;
        self.rightButton.top = 30;
        self.rightLabel.right = SCREENWIDTH - 10;
        self.rightLabel.top = self.rightButton.bottom - 10;
        
        self.userName.top = self.headerImageView.bottom + 5;
        self.userName.left = 0;
        self.userName.width = SCREENWIDTH;
        self.userName.font = [UIFont systemFontOfSize:15.0f];
        
        self.theIntergralImageView.left = self.headerImageView.left - 40;
        self.theIntergralImageView.top = self.userName.top + 20;
        self.integralLable.left = self.theIntergralImageView.right;
        self.integralLable.top = self.theIntergralImageView.top - 4;
        self.addressLabel.left = self.integralLable.right + 5;
        self.addressLabel.top = self.integralLable.top;
        
        self.headerView.width = SCREENWIDTH;
        self.headerView.height = self.addressLabel.bottom + 25;
        
        self.endView.left = 0;
        self.endView.top = self.addressLabel.bottom + 1;
        self.endView.width = SCREENWIDTH;
        
    } else{
        
        self.headerImageView.top = 30;
        self.headerImageView.left = SCREENWIDTH/3;
        self.headerImageView.width = SCREENWIDTH/3;
        self.headerImageView.height = SCREENWIDTH/3;
        
        self.leftButton.left = 10;
        self.leftButton.top = 30;
        self.leftLabel.left = 7;
        self.leftLabel.top = self.leftButton.bottom - 10;
        
        self.rightButton.right = SCREENWIDTH - 10;
        self.rightButton.top = 30;
        self.rightLabel.right = SCREENWIDTH - 10;
        self.rightLabel.top = self.rightButton.bottom - 10;
        
        self.userName.top = self.headerImageView.bottom + 5;
        self.userName.left = 0;
        self.userName.width = SCREENWIDTH;
        
        self.theIntergralImageView.left = self.headerImageView.left - 40;
        self.theIntergralImageView.top = self.userName.top + 25;
        
        self.integralLable.left = self.theIntergralImageView.right;
        self.integralLable.top = self.theIntergralImageView.top - 4;
        
        self.addressLabel.left = self.integralLable.right + 5;
        self.addressLabel.top = self.integralLable.top;
        
        self.headerView.width = SCREENWIDTH;
        self.headerView.height = self.addressLabel.bottom + 20;
        
        self.endView.left = 0;
        self.endView.top = self.integralLable.bottom + 5;
        self.endView.width = SCREENWIDTH;
        self.endView.bottom = self.headerView.bottom + 5;
    }
    
    self.endView.backgroundColor = [UIColor colorWithRed:59.0/255 green:142.0/255 blue:76.0/255 alpha:1.0f];
    self.headerImageView.userInteractionEnabled = YES;
    [self.headerImageView.layer setCornerRadius:(self.headerImageView.frame.size.height/2)];
    [self.headerImageView.layer setMasksToBounds:YES];
    [self.headerImageView setContentMode:UIViewContentModeScaleAspectFill];
    [self.headerImageView setClipsToBounds:YES];
    self.headerImageView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.headerImageView.layer.shadowOffset = CGSizeMake(4, 4);
    self.headerImageView.layer.shadowOpacity = 0.5;
    self.headerImageView.layer.shadowRadius = 3.0;
    self.headerImageView.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.headerImageView.layer.borderWidth = 3.0f;
    self.headerImageView.userInteractionEnabled = YES;
    self.headerImageView.backgroundColor = [UIColor clearColor];
    
    self.ZYButton.top = self.headerView.bottom ;
    self.TZButton.top = self.headerView.bottom ;
    self.CJButton.top = self.headerView.bottom ;
    self.WPButton.top = self.headerView.bottom ;
    
    self.ZYButton.left = 0;
    self.TZButton.left = SCREENWIDTH/4;
    self.CJButton.left = SCREENWIDTH/2;
    self.WPButton.left = 3*SCREENWIDTH/4;
    
    //气泡
    

    
    self.ZYLabel.left = 0;
    self.TZLabel.left = SCREENWIDTH/4;
    self.CJLabel.left = SCREENWIDTH/2;
    self.WPLabel.left = 3*SCREENWIDTH/4;
    
    self.ZYLabel.top = self.ZYButton.bottom - 10;
    self.TZLabel.top = self.TZButton.bottom - 10;
    self.CJLabel.top = self.CJButton.bottom - 10;
    self.WPLabel.top = self.WPButton.bottom - 10;
    
    if (SCREENHEIGHT == 480) {
        self.foorderView.top = self.ZYLabel.bottom + 5;

    } else{
        self.foorderView.top = self.ZYLabel.bottom + 10;

    }
    self.foorderView.left = 10;
    self.foorderView.width = SCREENWIDTH - 20;
    self.mainScrollView.contentSize=CGSizeMake(0, self.foorderView.bottom + 10);
    self.mainScrollView.contentOffset = CGPointMake(0, 0);
    self.mainScrollView.showsHorizontalScrollIndicator = NO;
    self.mainScrollView.showsVerticalScrollIndicator = FALSE;
    
    UITapGestureRecognizer* singleRecognizer= [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTheHearder:)];
    singleRecognizer.numberOfTapsRequired = 1;
    [self.headerImageView addGestureRecognizer:singleRecognizer];

    UISwipeGestureRecognizer *swipeGesture=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeGesture:)];
    [self.view addGestureRecognizer:swipeGesture];
    
    dim = [[UIView alloc] init];
    dim.backgroundColor = [UIColor blackColor];
    dim.alpha = 0;
    [self.view addSubview:dim];
    
    statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 20)];
    statusBarView.backgroundColor=homeHeaderColor;
    [self.view addSubview:statusBarView];
    
    chooseTitleTableView = [[UIView alloc] initWithFrame:CGRectMake(-SCREENWIDTH, 0, SCREENWIDTH*0.5, SCREENHEIGHT)];
    chooseTitleTableView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:chooseTitleTableView];
    
    // 菜单按钮
    NSArray *titleArray = @[@"个人资料",@"二维码名片",@"意见反馈",@"给我们评分",@"关于",@"关于"];
    for (int i = 0; i < 6; i ++) {
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.top = i * 50 + 12.5;
        button.left = 50;
        button.width = SCREENWIDTH * 0.5 - 10;
        button.height = 60;
        button.tag = i;
        [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitle:[NSString stringWithFormat:@"%@",titleArray[i]] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickOtherButton:) forControlEvents:UIControlEventTouchUpInside];
        [chooseTitleTableView addSubview:button];
        
        UIImageView *titleImageView = [[UIImageView alloc] init];
        titleImageView.top = i * 50 + 27;
        titleImageView.left = 10;
        titleImageView.width = 29;
        titleImageView.height = 29;
        [titleImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d",i]]];
        [chooseTitleTableView addSubview:titleImageView];
        
        UIView *lineView1 = [[UIView alloc] init];
        lineView1.top = i * 50 + 15;
        lineView1.left = 0;
        lineView1.width = SCREENWIDTH * 0.5;
        lineView1.height = 1;
        lineView1.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [chooseTitleTableView addSubview:lineView1];
    }
    // 切换账号按钮
    UIButton *switchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    switchButton.top = SCREENHEIGHT - 50;
    switchButton.left = 40;
    switchButton.width = SCREENWIDTH * 0.5 - 10;
    switchButton.height = 40;
    [switchButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [switchButton setTitle:@"切换账号" forState:UIControlStateNormal];
    [switchButton addTarget:self action:@selector(clickSwitchButton:) forControlEvents:UIControlEventTouchUpInside];
    [switchButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];

    [chooseTitleTableView addSubview:switchButton];
    
    UIImageView *titleImageView1 = [[UIImageView alloc] init];
    titleImageView1.top = SCREENHEIGHT - 40;
    titleImageView1.left = 10;
    titleImageView1.width = 25;
    titleImageView1.height = 25;
    [titleImageView1 setImage:[UIImage imageNamed:@"side-exit"]];
    [chooseTitleTableView addSubview:titleImageView1];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.top = SCREENHEIGHT - 55;
    lineView.left = 0;
    lineView.width = SCREENWIDTH * 0.5;
    lineView.height = 1;
    lineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [chooseTitleTableView addSubview:lineView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]
                                          initWithTarget:self
                                          action:@selector(didTappedBackground:)];
    tapGesture.cancelsTouchesInView = NO;
    [dim addGestureRecognizer:tapGesture];
    
    self.foorderView.backgroundColor = [UIColor colorWithRed:(float)236/255 green:(float)246/255 blue:(float)254/255 alpha:1.0];
    
    self.foorderView.layer.cornerRadius = 10.0f;
    
    // 友盟反馈
//    [UMFeedback setAppkey:APPKEY];
    self.feedback = [UMFeedback sharedInstance];
    self.feedback.delegate = self;
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = CGRectMake(0, 0, SCREENWIDTH, self.headerView.height);
    gradient.colors = [NSArray arrayWithObjects:
                       (id)homeHeaderColor.CGColor,
                       (id)homeHeaderColor1.CGColor,
                       nil];
    [self.headerView.layer insertSublayer:gradient atIndex:0];
    
    subjectArray = [[NSMutableArray alloc] init];
    subjectPlaceArray = [[NSMutableArray alloc] init];
    MessageCountArray = [[NSArray alloc] init];
    _netWorkManager = [[NetWorkManager alloc] init];
    
    [self setupRefresh];

    [self requestUIData];
    [self requestData];
    [self getOfflineMessages];
    [self BushBaoCun];
    
    [self requestServicerData];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(message:)
                                                 name: MESSAGE
                                               object: nil];
    
}


-(void)message:(NSNotification*)notefication{
    NSString* uid=[RRTManager manager].loginManager.loginInfo.userId;
    if (brage) {
        brage.val=[[IMCache shareIMCache] getPushBrage:uid];
    }
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name: MESSAGE object: nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kBushBaoCun object:nil];
    
}

#pragma mark -- 通知判断显示通知view

- (void)BushBaoCun
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    MessageCountArray = [userDefaults arrayForKey:@"TheMessageCount"];

    
    if (MessageCountArray && [MessageCountArray count] > 0) {
        self.endView.hidden = NO;
        self.endView.left = 0;
        self.endView.top = self.integralLable.bottom + 5;
        self.endView.width = SCREENWIDTH;
        self.endView.bottom = self.headerView.bottom + 5;
        self.endLabel.text = [NSString stringWithFormat:@"你收到 %d 份期末通知书",[MessageCountArray count]];
        UITapGestureRecognizer* singleRecognizer= [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(noticeTapGesture:)];
        singleRecognizer.numberOfTapsRequired = 1;
        [self.endView addGestureRecognizer:singleRecognizer];
    } else{
        self.endView.hidden = YES;
    }
}

#pragma mark -- 点击通知view

- (void)noticeTapGesture:(UIGestureRecognizer *)ges
{
    self.endView.hidden = YES;
    
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    endURL = [userDefaults stringForKey:@"TheURL"];
//    NSString *theURL = [NSString stringWithFormat:@"%@%@",endURL,[RRTManager manager].loginManager.loginInfo.tokenId];

//    [self.navigationController pushViewController:NoticeBookVCID
//                                   withStoryBoard:AboutMeStoryBoardName
//                                        withBlock:^(UIViewController *viewController) {
//                                            NoticeBookViewController *vc = (NoticeBookViewController*)viewController;
//                                            vc.noticeBookurl = theURL;
//                                        }];
    WebViewController *VC = [[WebViewController alloc] init];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                 style:UIBarButtonItemStylePlain
                                                                target:nil
                                                                action:nil];
    [self.navigationItem setBackBarButtonItem:backItem];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *theEndURL = [userDefaults stringForKey:@"TheURL"];
    
    NSString *str = [NSString stringWithFormat:@"%@%@",theEndURL,[RRTManager manager].loginManager.loginInfo.tokenId];
    NSString *URL2 = str;
    VC.URL = URL2;
    VC.title = @"期末通知书";
    [self.navigationController pushViewController:VC animated:YES];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"TheMessageCount"];
    [defaults synchronize];


}

#pragma mark -- 刷新
#pragma mark --
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.mainScrollView addHeaderWithTarget:self action:@selector(headerReresh)];
}

#pragma mark - 上拉刷新
#pragma mark -
- (void)headerReresh
{
    [self requestUIData];
}

#pragma mark -- 获取用户信息请求

- (void)requestUIData
{
    __weak GuardianViewController *_self = self;
    
    // 数据量小不做model，节约时间
    [self showWithStatus:@"数据加载中"];
    [self.netWorkManager getUIData:[RRTManager manager].loginManager.loginInfo.tokenId
                           success:^(NSMutableArray *data) {
                               if (data) {
                                   [self dismiss];
                                   [_self gotoTheUI:data];
                                   [_self.mainScrollView headerEndRefreshing];

                               }
                           } failed:^(NSString *errorMSG) {
                               [_self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:errorMSG];
                               [_self.mainScrollView headerEndRefreshing];

                           }];
}

#pragma mark -- 获取开通服务情况

- (void)requestServicerData
{
    [self.netWorkManager getClearServiceDetails:[RRTManager manager].loginManager.loginInfo.userId
                                       userrole:[RRTManager manager].loginManager.loginInfo.userRole success:^(NSMutableArray *data) {
                                           if (data) {
                                               [self gotoGetServiceDatails:data];
                                           }
                                           
                                       } failed:^(NSString *errorMSG) {
                                           [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:errorMSG];
                                           
                                       }];
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
        [messagePacketBuilder setBodyBuilder:messageBodyBuilder];
        
        [packetPacketBuilder setMessageBuilder:messagePacketBuilder];
        
        Packet* packetMsg =[packetPacketBuilder build];
        [[IMCache shareIMCache] savePacket:packetMsg sessionid:[NSString stringWithFormat:@"%@",[msg.PubUser objectForKey:@"UserId"]]];
    }
    [SoundCenter playSound];
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE object:nil];
}

#pragma mark -- 获取成绩排名

- (void)requestData
{
    __weak GuardianViewController *_self = self;
 
    
    [self.netWorkManager getTheStudentPlace:[RRTManager manager].loginManager.loginInfo.userId
                                   userrole:[RRTManager manager].loginManager.loginInfo.userRole success:^(NSMutableArray *data) {
                                       if (data) {
                                           [_self gotoMainTheRankUI:data];
                                       }
                           } failed:^(NSString *errorMSG) {
                               
                               [_self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:errorMSG];
                               
                               // 无数据时候处理：
                               UIImageView *noMessageIMG = [[UIImageView alloc] init];
                               noMessageIMG.frame = self.foorderView.bounds;
                               [noMessageIMG setImage:[UIImage imageNamed:@"resultNoMessege"]];
                               [self.foorderView addSubview:noMessageIMG];

                               UILabel *titleLabel = [[UILabel alloc] init];
                               titleLabel.top = 70;
                               titleLabel.left = 0;
                               titleLabel.height = 20;
                               titleLabel.textAlignment = NSTextAlignmentCenter;
                               titleLabel.width = self.foorderView.width;
                               titleLabel.textColor = [UIColor orangeColor];
                               titleLabel.text = @"亲，暂无考试数据哦~";
                               [self.foorderView addSubview:titleLabel];
                               
                               if (SCREENHEIGHT == 480) {
                                   
                                   self.RedPackageView.left = 0;
                                   self.RedPackageView.top = 0;
                                   self.RedPackageView.width = SCREENWIDTH;
                                   
                                   self.headerImageView.top = self.RedPackageView.bottom + 10;
                                   self.headerImageView.left = SCREENWIDTH/4 + SCREENWIDTH/6 - 15;
                                   self.headerImageView.width = SCREENWIDTH/4;
                                   self.headerImageView.height = SCREENWIDTH/4;
                                   self.headerImageView.tag = 0;
                                   
                                   self.leftButton.left = 10;
                                   self.leftButton.top = 30;
                                   self.leftLabel.left = 7;
                                   self.leftLabel.top = self.leftButton.bottom - 10;
                                   
                                   self.rightButton.right = SCREENWIDTH - 10;
                                   self.rightButton.top = 30;
                                   self.rightLabel.right = SCREENWIDTH - 10;
                                   self.rightLabel.top = self.rightButton.bottom - 10;
                                   
                                   self.userName.top = self.headerImageView.bottom + 5;
                                   self.userName.left = 0;
                                   self.userName.width = SCREENWIDTH;
                                   self.userName.font = [UIFont systemFontOfSize:15.0f];
                                   
                                   self.theIntergralImageView.left = self.headerImageView.left - 40;
                                   self.theIntergralImageView.top = self.userName.top + 20;
                                   self.integralLable.left = self.theIntergralImageView.right;
                                   self.integralLable.top = self.theIntergralImageView.top - 4;
                                   self.addressLabel.left = self.integralLable.right + 5;
                                   self.addressLabel.top = self.integralLable.top;
                                   
                                   self.headerView.width = SCREENWIDTH;
                                   self.headerView.height = self.addressLabel.bottom + 25;
                                   
                                   self.endView.left = 0;
                                   self.endView.top = self.addressLabel.bottom + 1;
                                   self.endView.width = SCREENWIDTH;
                                   
                                   self.ZYButton.top = self.headerView.bottom ;
                                   self.CJButton.top = self.headerView.bottom ;
                                   self.TZButton.top = self.headerView.bottom ;
                                   self.WPButton.top = self.headerView.bottom ;
                                   
                                   self.ZYLabel.left = 0;
                                   self.TZLabel.left = SCREENWIDTH/4;
                                   self.CJLabel.left = SCREENWIDTH/2;
                                   self.WPLabel.left = 3*SCREENWIDTH/4;
                                   
                                   self.ZYLabel.top = self.ZYButton.bottom - 10;
                                   self.TZLabel.top = self.TZButton.bottom - 10;
                                   self.CJLabel.top = self.CJButton.bottom - 10;
                                   self.WPLabel.top = self.WPButton.bottom - 10;
                                   
                                   self.foorderView.top = self.ZYLabel.bottom;
                                   self.foorderView.left = 10;
                                   self.foorderView.width = SCREENWIDTH - 20;
                                   self.mainScrollView.contentSize=CGSizeMake(0, self.foorderView.bottom);
                                   
                               } else{
                                   self.RedPackageView.left = 0;
                                   self.RedPackageView.top = 0;
                                   self.RedPackageView.width = SCREENWIDTH;
                               }
                               
                               CAGradientLayer *gradient = [CAGradientLayer layer];
                               gradient.frame = CGRectMake(0, 0, SCREENWIDTH, self.headerView.height);
                               gradient.colors = [NSArray arrayWithObjects:
                                                  (id)homeHeaderColor.CGColor,
                                                  (id)homeHeaderColor1.CGColor,
                                                  nil];
                               [self.headerView.layer insertSublayer:gradient atIndex:0];

                           }];
}

#pragma mark -- 开通服务情况
- (void)gotoGetServiceDatails:(NSMutableArray *)data
{
    if (data) {
        tmpNumber = [data[0] intValue];
        if (tmpNumber == 0) {
            self.stateView.hidden = YES;
            self.RedPackageView.hidden = YES;
            
        } else if (tmpNumber == -1 || tmpNumber == 1){
            self.stateView.hidden = NO;
            self.sevicerTitle.text = @"您的账号未开通或付费到期！";
            self.RedPackageView.hidden = YES;
            
        } else if (tmpNumber == 2){// 显示广告 隐藏服务
            
            self.stateView.hidden = YES;
            self.RedPackageView.hidden = NO;
            UITapGestureRecognizer* singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickRedPackageView:)];
            self.RedPackageView.userInteractionEnabled = YES;
            singleRecognizer.numberOfTapsRequired = 1;
            [self.RedPackageView addGestureRecognizer:singleRecognizer];
            
            // iphone4 ：
            if (SCREENHEIGHT == 480) {
                
                self.RedPackageView.left = 0;
                self.RedPackageView.top = 0;
                self.RedPackageView.width = SCREENWIDTH;
                
                self.headerImageView.top = self.RedPackageView.bottom + 10;
                self.headerImageView.left = SCREENWIDTH/4 + SCREENWIDTH/6 - 15;
                self.headerImageView.width = SCREENWIDTH/4;
                self.headerImageView.height = SCREENWIDTH/4;
                self.headerImageView.tag = 0;
                
                self.leftButton.left = 10;
                self.leftButton.top = 30;
                self.leftLabel.left = 7;
                self.leftLabel.top = self.leftButton.bottom - 10;
                
                self.rightButton.right = SCREENWIDTH - 10;
                self.rightButton.top = 30;
                self.rightLabel.right = SCREENWIDTH - 10;
                self.rightLabel.top = self.rightButton.bottom - 10;
                
                self.userName.top = self.headerImageView.bottom + 5;
                self.userName.left = 0;
                self.userName.width = SCREENWIDTH;
                self.userName.font = [UIFont systemFontOfSize:15.0f];
                
                self.theIntergralImageView.left = self.headerImageView.left - 40;
                self.theIntergralImageView.top = self.userName.top + 20;
                self.integralLable.left = self.theIntergralImageView.right;
                self.integralLable.top = self.theIntergralImageView.top - 4;
                self.addressLabel.left = self.integralLable.right + 5;
                self.addressLabel.top = self.integralLable.top;
                
                self.headerView.width = SCREENWIDTH;
                self.headerView.height = self.addressLabel.bottom + 25;
                
                self.endView.left = 0;
                self.endView.top = self.addressLabel.bottom + 1;
                self.endView.width = SCREENWIDTH;
                
                self.ZYButton.top = self.headerView.bottom ;
                self.CJButton.top = self.headerView.bottom ;
                self.TZButton.top = self.headerView.bottom ;
                self.WPButton.top = self.headerView.bottom ;
                
                self.ZYLabel.top = self.ZYButton.bottom - 10;
                self.TZLabel.top = self.TZButton.bottom - 10;
                self.CJLabel.top = self.CJButton.bottom - 10;
                self.WPLabel.top = self.WPButton.bottom - 10;
                
                self.foorderView.top = self.ZYLabel.bottom;
                self.foorderView.left = 10;
                self.foorderView.width = SCREENWIDTH - 20;
                self.mainScrollView.contentSize=CGSizeMake(0, self.foorderView.bottom);
                
                
            } else{
                self.RedPackageView.left = 0;
                self.RedPackageView.top = 0;
                self.RedPackageView.width = SCREENWIDTH;
            }
        }
        
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = CGRectMake(0, 0, SCREENWIDTH, self.headerView.height);
        gradient.colors = [NSArray arrayWithObjects:
                           (id)homeHeaderColor.CGColor,
                           (id)homeHeaderColor1.CGColor,
                           nil];
        [self.headerView.layer insertSublayer:gradient atIndex:0];
    }
}

#pragma mark -- 点击头部的抢红包

- (void)clickRedPackageView:(UIGestureRecognizer *)ges
{
    WebViewController *VC = [[WebViewController alloc] init];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                 style:UIBarButtonItemStylePlain
                                                                target:nil
                                                                action:nil];
    [self.navigationItem setBackBarButtonItem:backItem];
    
    NSString *URL01 = [NSString stringWithFormat:@"http://www.%@/gift/home/index?token=%@",aedudomain,[RRTManager manager].loginManager.loginInfo.tokenId];
    VC.URL = URL01;
    VC.title = @"抢红包";
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark -- 刷新获取成绩排名界面数据
- (void)gotoMainTheRankUI:(NSMutableArray *)data
{
    if (data) {
        _SR = data[0];
        // 柱形标题
        self.footderHeaderTitle.text = _SR.ExamName;
        for (int i = 0; i < [_SR.ExamSubject count]; i ++) {
            _SE = _SR.ExamSubject[i];
            [subjectArray addObject:_SE.SubjectName];
            // 学生排名换算
            if (_SR.theStudentCount > 0) {
                [subjectPlaceArray addObject:[NSNumber numberWithInt:(1.0 - ((float)_SE.ClassRank /(float)_SR.theStudentCount)) * 100.0+ (float)((float)(1.0/(float)_SR.theStudentCount) * 100.0)]];
            }
        }
        // 总排名换算
        [subjectPlaceArray addObject:[NSNumber numberWithInt:(1.0 - ((float)_SR.ClassRank/(float)_SR.theStudentCount)) * 100.0 + (float)((float)(1.0/(float)_SR.theStudentCount) * 100.0)]];
        [subjectArray addObject:@"总分"];
        if ([subjectArray count] > 0) {
            width = self.foorderView.width / [subjectArray count];
            setup = (width - 20)*0.5;
        }
        // 初始化柱形图空间
        for (int j = 0; j < [subjectArray count]; j ++) {
            Plot* plot = [[Plot alloc] initWithFrame:CGRectMake(j*width + setup, 35, 20, self.foorderView.height - 71)];
            
            float pv = [[subjectPlaceArray objectAtIndex:j] floatValue];
            if (_SR.theStudentCount) {
                if (pv >= (1 - (float)_SR.ClassRank/(float)_SR.theStudentCount) * 100 + + (float)((float)(1.0/(float)_SR.theStudentCount) * 100.0)) {
                    plot.cl = homeHeaderColor;
                }
            }
            plot.plotvalue = pv;
            [self.foorderView addSubview:plot];
            
            UILabel *label = [[UILabel alloc] init];
            label.left = j*width + (width - 40)*0.5;
            label.top = plot.bottom - 8;
            label.width = 40;
            label.height = 50;
            label.text = [subjectArray objectAtIndex:j];
            label.font = [UIFont systemFontOfSize:12];
            label.textAlignment = NSTextAlignmentCenter;
            [self.foorderView addSubview:label];
        }
        //初始化位置
        UIImageView* line = [[UIImageView alloc] init];
        line.frame = CGRectMake(0, self.foorderView.height - 71 + 35 - 17*0.5, self.foorderView.width, 17);
        line.image = [[UIImage imageNamed:@"homeline"] stretchableImageWithLeftCapWidth:19 topCapHeight:17];
        [self.foorderView addSubview:line];
        
        //获取总分y坐标
        if (_SR.theStudentCount > 0) {
         
            float tempy = (self.foorderView.height - 71)*(1 - (float)_SR.ClassRank/(float)_SR.theStudentCount) * 100*0.01 + (float)((float)(1.0/(float)_SR.theStudentCount) * 100.0);
            [UIView animateWithDuration:2 animations:^{
                line.top = line.top - tempy;
            }];
        }
    }
}

#pragma mark -- 刷新获取用户信息界面数据
- (void)gotoTheUI:(NSMutableArray *)data
{
    if (data && [data count] > 0) {
        self.userName.text = [NSString stringWithFormat:@"%@ (家长)",[RRTManager manager].loginManager.loginInfo.userName];
        
        if ([[data[0] objectForKey:@"SchoolName"] isKindOfClass:[NSNull class]]) {
            self.addressLabel.text = @"您还没有填写学校地址哦！";
        } else{
            self.addressLabel.text = [data[0] objectForKey:@"SchoolName"];
            
        }
        
        if ([[data[0] objectForKey:@"ExperiencePoints"] isKindOfClass:[NSNull class]]) {
            self.integralLable.text = @"暂无积分";
        } else{
            self.integralLable.text = [NSString stringWithFormat:@"%@",[data[0] objectForKey:@"ExperiencePoints"]];
        }
        
        NSUserDefaults* nud = [NSUserDefaults standardUserDefaults];
        BOOL issettingid=[nud boolForKey:[NSString stringWithFormat:@"%@isSettingId2",[RRTManager manager].loginManager.loginInfo.userId]];
        if (issettingid) {
            [self issettinged];
        }else{
            [self.headerImageView setImageWithUrlStr:[data[0] objectForKey:@"PictureUrl"] placholderImage:[UIImage imageNamed:@"default.png"]];
        }
    }
}

#pragma mark -- ModificationVCDelegete

- (void)issettinged
{
    NSUserDefaults* nud=[NSUserDefaults standardUserDefaults];
    
    BOOL issettingid=[nud boolForKey:[NSString stringWithFormat:@"%@isSettingId2",[RRTManager manager].loginManager.loginInfo.userId]];
    if (issettingid) {
        NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"currentImage.png"];
        UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
        [self.headerImageView setImage:savedImage];
    }
}

#pragma mark -- 点击头像
- (void)clickTheHearder:(UITapGestureRecognizer *)sender
{
    self.navigationController.tabBarController.tabBar.hidden = YES;
    statusBarView.backgroundColor=[UIColor colorWithRed:16.0/255 green:82.0/255 blue:25.0/255 alpha:1];
    dim.backgroundColor = [UIColor blackColor];

    if (!self.headerImageView.tag) {
        [self hideTopToolView:NO];
        self.headerImageView.tag = 1;
    }else{
        [self hideTopToolView:YES];
        self.headerImageView.tag = 0;
    }
}

#pragma mark -- 显示隐藏左边View
-(void)hideTopToolView:(BOOL)b
{
    dim.hidden = NO;
    if (b) {
        [UIView animateWithDuration:0.5 animations:^{
            chooseTitleTableView.left = -SCREENWIDTH;
            dim.alpha = 0;
        } completion:^(BOOL finished) {
            dim.frame = CGRectZero;
        }];
    }else{
        dim.frame = self.view.bounds;
        [UIView animateWithDuration:0.5 animations:^{
            chooseTitleTableView.left = 0;
            dim.alpha = 0.6;
        } completion:^(BOOL finished) {
            
        }];
    }
}

#pragma mark -- 其他按钮响应
- (void)clickOtherButton:(UIButton *)sender
{
    
    switch (sender.tag) {
        case 0:
        {
            [self.navigationController pushViewController:ModificationVCID
                                           withStoryBoard:SettingStoryBoardName
                                                withBlock:^(UIViewController *viewController) {
                                                    ModificationViewController *VC = (ModificationViewController *)viewController;
                                                    VC.delegate = self;
                                                    VC.isRole = @"老师";
                                                }];
        }
            break;
        case 1:
        {
            MyZBPhotoViewController *ZBVc = [[MyZBPhotoViewController alloc]init];
            [self.navigationController pushViewController:ZBVc animated:YES];
        }
            break;
        case 2:
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
            break;
        case 3:
        {
            NSString *webLink = @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=641431831";
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:webLink]];
        }
            break;
        case 4:
        {
            self.navigationController.tabBarController.tabBar.hidden = NO;
            statusBarView.backgroundColor=homeHeaderColor;
            [self.navigationController pushViewController:AboutVCID
                                           withStoryBoard:SettingStoryBoardName
                                                withBlock:nil];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark -- 切换账号
- (void)clickSwitchButton:(UIButton *)sender
{
    self.navigationController.tabBarController.tabBar.hidden = NO;
    statusBarView.backgroundColor = homeHeaderColor;
    [self.navigationController pushViewController:SwitchAccountVCID
                                   withStoryBoard:AboutMeStoryBoardName
                                        withBlock:nil];
}

#pragma mark - Tap Gesture
#pragma mark -
- (void)didTappedBackground:(UIGestureRecognizer*)ges
{
    self.navigationController.tabBarController.tabBar.hidden = NO;
    statusBarView.backgroundColor=homeHeaderColor;
    if (self.headerImageView.tag) {
        [self hideTopToolView:YES];
        self.headerImageView.tag = 0;
    }
}
#pragma mark -- 右滑
- (void)handleSwipeGesture:(UIGestureRecognizer *)ges
{
    dim.frame = self.view.bounds;
    dim.backgroundColor = [UIColor blackColor];
    self.navigationController.tabBarController.tabBar.hidden = YES;
    statusBarView.backgroundColor=[UIColor colorWithRed:16.0/255 green:82.0/255 blue:25.0/255 alpha:1];
    [UIView animateWithDuration:0.5 animations:^{
        chooseTitleTableView.left = 0;
        dim.alpha = 0.6;
    } completion:^(BOOL finished) {
        self.headerImageView.tag = 1;

    }];
}

#pragma mark -- 反馈
- (IBAction)clickFeedbackButton:(UIButton *)sender
{
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

#pragma mark -- 联系人
- (IBAction)clickContactsButton:(UIButton *)sender
{
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController pushViewController:ContactVCID
                                   withStoryBoard:MainStoryBoardName
                                        withBlock:nil];
}

#pragma mark -- 作业
- (IBAction)clickHomeWorkButton:(UIButton *)sender
{
    if (tmpNumber==-1||tmpNumber==1) {
        [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"您的账号未开通或付费到期！"];
        
    } else{
        [self.navigationController pushViewController:CommunicationGuardianVCID
                                       withStoryBoard:DeskStoryBoardName withBlock:^(UIViewController *viewController) {
                                           CommunicationGuardianViewController *VC = (CommunicationGuardianViewController *)viewController;
                                           VC.theTitle = @"作业";
                                           VC.headType = 8;
                                       }];
    }
    
}

#pragma mark -- 通知
- (IBAction)clickNotieButton:(UIButton *)sender
{
    
    if (tmpNumber==-1||tmpNumber==1) {
        [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"您的账号未开通或付费到期！"];
        
    } else{
        [self.navigationController pushViewController:CommunicationGuardianVCID
                                       withStoryBoard:DeskStoryBoardName withBlock:^(UIViewController *viewController) {
                                           CommunicationGuardianViewController *VC = (CommunicationGuardianViewController *)viewController;
                                           VC.theTitle = @"通知";
                                           VC.headType = 11;
                                       }];
    }
}

#pragma mark -- 看成绩
- (IBAction)clickResultButton:(UIButton *)sender
{
//    if (tmpNumber==-1||tmpNumber==1) {
//        [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"您的账号未开通或付费到期！"];
//    }else{
//        [self.navigationController pushViewController:CommunicationGuardianVCID
//                                       withStoryBoard:DeskStoryBoardName withBlock:^(UIViewController *viewController) {
//                                           CommunicationGuardianViewController *VC = (CommunicationGuardianViewController *)viewController;
//                                           VC.theTitle = @"成绩";
//                                           VC.headType = 2;
//                                       }];
//    }
    if (tmpNumber==-1||tmpNumber==1) {
        [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"您的账号未开通或付费到期！"];
    }else{
        NoNavViewController *VC = [[NoNavViewController alloc] init];
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
    
}
#pragma mark -- 微评
- (IBAction)clickWeiPingButton:(UIButton *)sender
{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weidianping:"]]) {
        NSString *str = [NSString stringWithFormat:@"weidianping://token=%@",[RRTManager manager].loginManager.loginInfo.tokenId];
        NSURL *url = [NSURL URLWithString:str];
        [[UIApplication sharedApplication] openURL:url];
    } else {
        // 下载完后会有一个下载地址
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=948188537"]];
    }
    
}

- (IBAction)clickHidenViewButton:(UIButton *)sender
{
    [self.stateView removeFromSuperview];
}

#pragma mark - UMFeedback Delegate

- (void)getFinishedWithError:(NSError *)error {
    if (error != nil) {
        NSLog(@"%@", error);
    } else {
        NSLog(@"%@", self.feedback.topicAndReplies);
    }
}

- (void)postFinishedWithError:(NSError *)error {
    if (error != nil) {
        NSLog(@"%@", error);
    } else {
        NSLog(@"%@", self.feedback.topicAndReplies);
    }
}

#pragma mark -- uiview生命周期
- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.tabBarController.tabBar.hidden = NO;
    chooseTitleTableView.left = - SCREENWIDTH;
    statusBarView.backgroundColor=homeHeaderColor;
    self.headerImageView.tag = 0;

    [self hideTopToolView:YES];
    
    [self requestUIData];
}
- (void)viewDidAppear:(BOOL)animated
{
    self.hidesBottomBarWhenPushed = NO;
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self dismiss];
    
    self.navigationController.navigationBar.hidden = NO;
    self.hidesBottomBarWhenPushed = YES;
    
}

@end
