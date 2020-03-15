//
//  TheTeacherViewController.m
//  RenrenTong
//
//  Created by 符其彬 on 14/12/6.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "TheTeacherViewController.h"
#import "ParentAttendViewController.h"
#import "TeacherAttendViewController.h"
#import "WebViewController.h"
#import "NoNavViewController.h"
#import "TheNoticeViewController.h"
#import "ModificationViewController.h"
#import "MJRefresh.h"
#import "UIImage+Addition.h"
#import "CommunicationGuardianViewController.h"
#import "MJExtension.h"
#import "ReceiveMessage.h"
#import "MyZBPhotoViewController.h"

@interface TheTeacherViewController ()<ModificationVCDelegate>
{
    UIView *chooseTitleTableView;
    UIView* dim;
    UIView *statusBarView;
    UIButton *button;
    Brage * cjbrage;
    
    Brage * wpbrage;
    
    Brage * lxrbrage;

}

@property (nonatomic, strong) NetWorkManager *netWorkManager;
@property (strong, nonatomic) UMFeedback *feedback;

@end

@implementation TheTeacherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weidianping:"]]) {
        [self.WPButton setImage:[UIImage imageNamed:@"mainicon-dd-setup"] forState:UIControlStateNormal];
    }
    
    
    if (SCREENHEIGHT == 480) {
        
        self.userFaceView.top = 10;
        self.userFaceView.left = SCREENWIDTH/4 + SCREENWIDTH/6 - 15;
        self.userFaceView.width = SCREENWIDTH/4;
        self.userFaceView.height = SCREENWIDTH/4;
        self.userNameLabel.font = [UIFont systemFontOfSize:15.0f];
        self.addressLabel.font = [UIFont systemFontOfSize:13.0f];
        self.integralLabel.font = [UIFont systemFontOfSize:13.0f];
        self.newsLabel.font = [UIFont systemFontOfSize:14.0f];
        self.notieLabel.font = [UIFont systemFontOfSize:14.0f];
        self.theNewsButton.titleLabel.font = [UIFont systemFontOfSize: 14.0];
        self.theNoticeButton.titleLabel.font = [UIFont systemFontOfSize: 14.0];
        self.userNameLabel.top = self.userFaceView.bottom + 5;
        self.interalImageView.top = self.userNameLabel.top + 25;
        self.integralLabel.top = self.interalImageView.top - 4;
        self.newsLabel.top = self.integralLabel.bottom + 5;
        self.notieLabel.top = self.integralLabel.bottom + 5;

    } else{
        self.userFaceView.left = SCREENWIDTH/3;
        self.userFaceView.width = SCREENWIDTH/3;
        self.userFaceView.height = SCREENWIDTH/3;
        self.userNameLabel.top = self.userFaceView.bottom + 10;
        self.interalImageView.top = self.userNameLabel.top + 30;
        self.integralLabel.top = self.interalImageView.top - 4;
        self.newsLabel.top = self.integralLabel.bottom + 10;
        self.notieLabel.top = self.integralLabel.bottom + 10;

    }
    // 适配
    self.newsLabel.text = [NSString stringWithFormat:@"%d",[self getUnreadCount]];
    
    self.leftButton.left = 10;
    self.leftButton.top = 30;
    self.leftLabel.left = 7;
    self.leftLabel.top = self.leftButton.bottom - 10;
    
    self.rightButton.right = SCREENWIDTH - 10;
    self.rightButton.top = 30;
    self.rightLabel.right = SCREENWIDTH - 10;
    self.rightLabel.top = self.rightButton.bottom - 10;
    
    self.userNameLabel.left = 0;
    self.userNameLabel.width = SCREENWIDTH;

    self.interalImageView.left = self.userFaceView.left - 40;
    self.integralLabel.left = self.interalImageView.right;
    self.addressLabel.left = self.integralLabel.right + 5;
    self.addressLabel.top = self.integralLabel.top;
    
    self.newsLabel.left = SCREENWIDTH/4 - 5;
    self.theNewsButton.left = self.newsLabel.left;
    self.theNewsButton.top = self.newsLabel.bottom - 10;
    self.theNoticeButton.width = SCREENWIDTH/4;
    
    self.FGView.left = 2*SCREENWIDTH/4;
    self.FGView.top = self.newsLabel.top;
    self.FGView.height = self.theNewsButton.height - 5;
    self.FGView.alpha = 0.5;
    
    self.notieLabel.left = 2*SCREENWIDTH/4 + 5;
    
    self.theNoticeButton.left = self.notieLabel.left;
    self.theNoticeButton.top = self.notieLabel.bottom - 10;
    self.theNoticeButton.width = SCREENWIDTH/4;
    
    self.headerView.height = self.theNewsButton.bottom - 10;
    
    // 四个按钮
    self.FBButton.top = self.theNewsButton.bottom - 20;
    self.FBButton.left = (SCREENWIDTH/2 - 100)/2;
    self.FBLabel.left = self.FBButton.left;
    self.FBLabel.top = self.FBButton.bottom - 10;
    
    self.WPButton.top = self.theNewsButton.bottom - 20;
    self.WPButton.left = (SCREENWIDTH/2 - 100)/2 +SCREENWIDTH/2;
    self.WPLabel.left = self.WPButton.left;
    self.WPLabel.top = self.WPButton.bottom - 10;
    
    self.KQButton.top = self.FBLabel.bottom - 5;
    self.KQButton.left = (SCREENWIDTH/2 - 100)/2;
    self.KQLabel.top = self.KQButton.bottom - 15;
    self.KQLabel.left = self.KQButton.left;
    
    self.CJButton.top = self.FBLabel.bottom - 5 ;
    self.CJButton.left = (SCREENWIDTH/2 - 100)/2 +SCREENWIDTH/2;
    self.CJLabel.top = self.CJButton.bottom - 15;
    self.CJLabel.left = self.CJButton.left;
    
    cjbrage=[[Brage alloc] init];
    cjbrage.left = 57;
    cjbrage.val= 0;
    [self.CJButton addSubview:cjbrage];
    
    wpbrage=[[Brage alloc] init];
    wpbrage.left = 57;
    [self.WPButton addSubview:wpbrage];
    
    lxrbrage=[[Brage alloc] init];
    lxrbrage.left = 15;
    lxrbrage.top = -15;
    [self.rightButton addSubview:lxrbrage];
    
    self.mainScrollView.contentSize=CGSizeMake(0, self.CJLabel.bottom + 30);
    self.mainScrollView.contentOffset = CGPointMake(0, 0);
    self.mainScrollView.showsVerticalScrollIndicator = FALSE;
    self.mainScrollView.showsHorizontalScrollIndicator = NO;
    
    self.userFaceView.tag = 0;
    [self.userFaceView.layer setCornerRadius:(self.userFaceView.frame.size.height/2)];
    
    self.userFaceView.layer.masksToBounds = YES;
    self.userFaceView .contentMode = UIViewContentModeScaleAspectFit;
    self.userFaceView.layer.shadowColor = [UIColor grayColor].CGColor;
    self.userFaceView.layer.shadowOffset = CGSizeMake(8, 8);
    self.userFaceView.layer.shadowOpacity = 0.5f;
    self.userFaceView.layer.shadowRadius = 4.0f;
    
    self.userFaceView.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.userFaceView.layer.borderWidth = 3.0f;
    self.userFaceView.userInteractionEnabled = YES;
    self.userFaceView.backgroundColor = [UIColor clearColor];
    
    self.headerView.width = SCREENWIDTH;
    
    UITapGestureRecognizer* singleRecognizer= [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTheHearder:)];
    singleRecognizer.numberOfTapsRequired = 1;
    [self.userFaceView addGestureRecognizer:singleRecognizer];

    UISwipeGestureRecognizer *swipeGesture=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeGesture:)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
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
    
//    [self initAdvertisement];
    
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
    switchButton.left = 45;
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
    
    // 手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]
                                          initWithTarget:self
                                          action:@selector(didTappedBackground:)];
    tapGesture.cancelsTouchesInView = NO;
    [dim addGestureRecognizer:tapGesture];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = CGRectMake(0, 0, SCREENWIDTH, self.headerView.height);
    gradient.colors = [NSArray arrayWithObjects:
                       (id)homeHeaderColor.CGColor,
                       (id)homeHeaderColor1.CGColor,
                       nil];
    
    [self.headerView.layer insertSublayer:gradient atIndex:0];
    
    // 友盟反馈
//    [UMFeedback setAppkey:APPKEY];
    self.feedback = [UMFeedback sharedInstance];
    self.feedback.delegate = self;
    _netWorkManager = [[NetWorkManager alloc] init];
    
    [self setupRefresh];
    [self requestData];
    NSString* uid=[RRTManager manager].loginManager.loginInfo.userId;
//    self.notieLabel.text = [NSString stringWithFormat:@"%i",[[IMCache shareIMCache] getPushBrage:uid type:PushTypeNotification]];
    self.newsLabel.text = [NSString stringWithFormat:@"%i",[[IMCache shareIMCache] getAllFriendBrage:uid]];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(message:)
                                                 name: MESSAGE
                                               object: nil];
    [self getOfflineMessages];
}
-(void)message:(NSNotification*)notefication{
    NSString* uid=[RRTManager manager].loginManager.loginInfo.userId;
    if (self.notieLabel) {
//        self.notieLabel.text = [NSString stringWithFormat:@"%i",[[IMCache shareIMCache] getPushBrage:uid type:PushTypeNotification]];
        self.newsLabel.text = [NSString stringWithFormat:@"%i",[[IMCache shareIMCache] getAllFriendBrage:uid]];
    }
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name: MESSAGE object: nil];
    
}


#pragma mark -- 获取聊天未读消息
-(int)getUnreadCount{
    
    int result=0;
//    IMManager* immanager=[RRTManager manager].imManager;
//        NSManagedObjectContext *context = [immanager.xmppMessageArchivingStorage
//                                           mainThreadManagedObjectContext];
//        
//        NSEntityDescription *entity = [immanager.xmppMessageArchivingStorage contactEntity:context];
//        NSFetchRequest *request = [[NSFetchRequest alloc] init];
//        [request setEntity:entity];
//        
//        //获取当前用户的所有最新聊天列表
//        NSPredicate *predicate = [NSPredicate predicateWithFormat:
//                                  @"streamBareJidStr == %@",
//                                  [[RRTManager manager].imManager jidStrFromUserId:[RRTManager manager].imManager.userId]];
//        [request setPredicate:predicate];
//        
//        NSSortDescriptor *sortDesc = [NSSortDescriptor sortDescriptorWithKey:@"mostRecentMessageTimestamp"
//                                                                   ascending:NO];
//        [request setSortDescriptors:[NSArray arrayWithObjects:sortDesc, nil]];
//        
//        NSArray *array = [context executeFetchRequest:request error:nil];
//        
//        //对数据排序，置顶的放最上面（置顶的时间）
//        NSMutableArray *tmpArray = [NSMutableArray arrayWithArray:array];
//        for (int i = 0; i < [array count]; i++) {
//            XMPPMessageArchiving_Contact_CoreDataObject *mostMessage =
//            (XMPPMessageArchiving_Contact_CoreDataObject*)[array objectAtIndex:i];
//            
//            if ([mostMessage.bToped boolValue]) {
//                [tmpArray removeObject:mostMessage];
//                [tmpArray insertObject:mostMessage atIndex:0];
//            }
//        }
//    
//        
//        
//        
//        //获取每个最新列表的未读消息个数
//        entity = [immanager.xmppMessageArchivingStorage messageEntity:context];
//        [request setEntity:entity];
//        [request setSortDescriptors:nil];
//        
//        for (int i = 0; i < [tmpArray count]; i++) {
//            XMPPMessageArchiving_Contact_CoreDataObject *mostMessage =
//            (XMPPMessageArchiving_Contact_CoreDataObject*)[tmpArray objectAtIndex:i];
//            
//            predicate = [NSPredicate predicateWithFormat:@"bRead == %@ && \
//                         streamBareJidStr CONTAINS[cd] %@ && \
//                         bareJidStr CONTAINS[cd] %@",
//                         [NSNumber numberWithBool:NO],
//                         mostMessage.streamBareJidStr,
//                         mostMessage.bareJidStr];
//            
//            [request setPredicate:predicate];
//            NSArray *array = [context executeFetchRequest:request error:nil];
//            int unread = [array count];
//            result=result+unread;
//        }
    return result;
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
    [self requestData];
}

#pragma mark -- 获取用户信息请求

- (void)requestData
{
    // 数据量小不做model，节约时间
    __weak TheTeacherViewController *_self = self;
    
    [self show];
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

#pragma mark -- 开通服务情况
- (void)gotoGetServiceDatails:(NSMutableArray *)data
{
    if (data) {
        int tmpNumber = [data[0] intValue];
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
                
                self.leftButton.left = 10;
                self.leftButton.top = 30;
                self.leftLabel.left = 7;
                self.leftLabel.top = self.leftButton.bottom - 10;
                
                self.rightButton.right = SCREENWIDTH - 10;
                self.rightButton.top = 30;
                self.rightLabel.right = SCREENWIDTH - 10;
                self.rightLabel.top = self.rightButton.bottom - 10;
                
                self.userFaceView.top = self.RedPackageView.bottom + 10;
                self.userFaceView.left = SCREENWIDTH/4 + SCREENWIDTH/6 - 15;
                self.userFaceView.width = SCREENWIDTH/4;
                self.userFaceView.height = SCREENWIDTH/4;
                
                self.userNameLabel.top = self.userFaceView.bottom + 5;
                self.userNameLabel.left = 0;
                self.userNameLabel.width = SCREENWIDTH;
                
                self.userNameLabel.font = [UIFont systemFontOfSize:15.0f];
                self.addressLabel.font = [UIFont systemFontOfSize:13.0f];
                self.integralLabel.font = [UIFont systemFontOfSize:13.0f];
                self.newsLabel.font = [UIFont systemFontOfSize:14.0f];
                self.notieLabel.font = [UIFont systemFontOfSize:14.0f];
                
                self.interalImageView.left = self.userFaceView.left - 40;
                self.interalImageView.top = self.userNameLabel.bottom + 8;
                self.integralLabel.left = self.interalImageView.right;
                self.addressLabel.left = self.integralLabel.right + 5;
                self.integralLabel.top = self.userNameLabel.bottom + 5;
                self.addressLabel.top = self.userNameLabel.bottom + 5;
                
                self.newsLabel.left = SCREENWIDTH/4 - 5;
                self.newsLabel.top = self.integralLabel.bottom;
                self.theNewsButton.left = self.newsLabel.left;
                self.theNewsButton.top = self.newsLabel.bottom - 10;

                self.FGView.left = 2*SCREENWIDTH/4;
                self.FGView.top = self.newsLabel.top;
                self.FGView.height = self.theNewsButton.height - 5;
                self.FGView.alpha = 0.5;
                
                self.notieLabel.left = 2*SCREENWIDTH/4 + 5;
                self.notieLabel.top = self.integralLabel.bottom;
                self.theNoticeButton.width = SCREENWIDTH/4;
                self.theNoticeButton.top = self.newsLabel.bottom - 10;
                self.theNoticeButton.left = self.notieLabel.left;
                
                self.headerView.height = self.theNewsButton.bottom - 10;
                
                self.FBButton.top = self.theNewsButton.bottom - 20;
                self.FBButton.left = (SCREENWIDTH/2 - 100)/2;
                self.FBLabel.left = self.FBButton.left;
                self.FBLabel.top = self.FBButton.bottom - 10;
                
                self.WPButton.top = self.theNewsButton.bottom - 20;
                self.WPButton.left = (SCREENWIDTH/2 - 100)/2 +SCREENWIDTH/2;
                self.WPLabel.left = self.WPButton.left;
                self.WPLabel.top = self.WPButton.bottom - 10;
                
                self.KQButton.top = self.FBLabel.bottom - 5;
                self.KQButton.left = (SCREENWIDTH/2 - 100)/2;
                self.KQLabel.top = self.KQButton.bottom - 15;
                self.KQLabel.left = self.KQButton.left;
                
                self.CJButton.top = self.FBLabel.bottom - 5 ;
                self.CJButton.left = (SCREENWIDTH/2 - 100)/2 +SCREENWIDTH/2;
                self.CJLabel.top = self.CJButton.bottom - 15;
                self.CJLabel.left = self.CJButton.left;
                
                self.mainScrollView.contentSize=CGSizeMake(0, self.CJLabel.bottom + 5);
                
            } else{
                self.RedPackageView.left = 0;
                self.RedPackageView.top = 0;
                self.RedPackageView.width = SCREENWIDTH;
                
                self.leftButton.left = 10;
                self.leftButton.top = 30;
                self.leftLabel.left = 7;
                self.leftLabel.top = self.leftButton.bottom - 10;
                
                self.rightButton.right = SCREENWIDTH - 10;
                self.rightButton.top = 30;
                self.rightLabel.right = SCREENWIDTH - 10;
                self.rightLabel.top = self.rightButton.bottom - 10;
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


- (void)clickHidenViewButton:(id)sender
{
    [self.stateView removeFromSuperview];
}

#pragma mark -- 刷新界面数据
- (void)gotoTheUI:(NSMutableArray *)data
{
    if (data && [data count] > 0) {
        
        NSString *theRole = [NSString stringWithFormat:@"%@",[RRTManager manager].loginManager.loginInfo.userRole];
        if ([theRole isEqualToString:@"3"]) {
            self.userNameLabel.text = [NSString stringWithFormat:@"%@ (老师)",[RRTManager manager].loginManager.loginInfo.userName];
        } else if ([theRole isEqualToString:@"4"]){
            self.userNameLabel.text = [NSString stringWithFormat:@"%@ (领导)",[RRTManager manager].loginManager.loginInfo.userName];
        } else if ([theRole isEqualToString:@"5"]){
            self.userNameLabel.text = [NSString stringWithFormat:@"%@ (领导)",[RRTManager manager].loginManager.loginInfo.userName];
        } else if ([theRole isEqualToString:@"6"]){
            self.userNameLabel.text = [NSString stringWithFormat:@"%@ (领导)",[RRTManager manager].loginManager.loginInfo.userName];
        }
        
        
        if ([[data[0] objectForKey:@"SchoolName"] isKindOfClass:[NSNull class]]) {
            self.addressLabel.text = @"您还没有填写学校地址哦！";
        } else{
            self.addressLabel.text = [data[0] objectForKey:@"SchoolName"];

        }
        
        if ([[data[0] objectForKey:@"ExperiencePoints"] isKindOfClass:[NSNull class]]) {
            self.integralLabel.text = @"暂无积分";
        } else{
            self.integralLabel.text = [NSString stringWithFormat:@"%@",[data[0] objectForKey:@"ExperiencePoints"]];
        }
        self.notieLabel.text = [NSString stringWithFormat:@"%@",[data[0] objectForKey:@"MsmMessageCount"]];
        
        NSUserDefaults* nud = [NSUserDefaults standardUserDefaults];
        BOOL issettingid=[nud boolForKey:[NSString stringWithFormat:@"%@isSettingId",[RRTManager manager].loginManager.loginInfo.userId]];
        if (issettingid) {
            [self issettinged];
        }else{
//            [self.userFaceView setImageWithUrlStr:[data[0] objectForKey:@"PictureUrl"] placholderImage:[UIImage imageNamed:@"default.png"]];
            [self.userFaceView setImageWithURL:[NSURL URLWithString:[data[0] objectForKey:@"PictureUrl"]] placeholderImage:[UIImage imageNamed:@"default.png"]];
        }
    }
}

#pragma mark -- ModificationVCDelegete

- (void)issettinged
{
    NSUserDefaults* nud=[NSUserDefaults standardUserDefaults];
    
    BOOL issettingid=[nud boolForKey:[NSString stringWithFormat:@"%@isSettingId",[RRTManager manager].loginManager.loginInfo.userId]];
    if (issettingid) {
        NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"currentImage.png"];
        UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
        [self.userFaceView setImage:savedImage];
    }
}

#pragma mark -- 点击头像
- (void)clickTheHearder:(UITapGestureRecognizer *)sender
{
    self.navigationController.tabBarController.tabBar.hidden = YES;
    statusBarView.backgroundColor=[UIColor colorWithRed:16.0/255 green:82.0/255 blue:25.0/255 alpha:1];
    dim.backgroundColor = [UIColor blackColor];
    
    if (!self.userFaceView.tag) {
        [self hideTopToolView:NO];
        self.userFaceView.tag = 1;
    }else{
        [self hideTopToolView:YES];
        self.userFaceView.tag = 0;
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

#pragma mark -- 切换账号
- (void)clickSwitchButton:(UIButton *)sender
{
    self.navigationController.tabBarController.tabBar.hidden = NO;
    statusBarView.backgroundColor=homeHeaderColor;
    [self.navigationController pushViewController:SwitchAccountVCID
                                   withStoryBoard:AboutMeStoryBoardName
                                        withBlock:nil];
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
        self.userFaceView.tag = 1;
        
    }];
}

#pragma mark -- 发布消息响应
- (IBAction)clickNewsButton:(UIButton *)sender
{
    
    [self.navigationController pushViewController:CommunicationTeacherVCID
                                   withStoryBoard:DeskStoryBoardName
                                        withBlock:nil];
}
#pragma mark -- 微点评响应
- (IBAction)clickWeiDianPingButton:(UIButton *)sender
{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weidianping:"]]) {
        NSString *str = [NSString stringWithFormat:@"weidianping://token=%@",[RRTManager manager].loginManager.loginInfo.tokenId];
        NSURL *url = [NSURL URLWithString:str];
        [[UIApplication sharedApplication] openURL:url];
    } else {
        // 下载完后会有一个下载地址
        NSString *webLink = @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=948188537";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:webLink]];
    }
    
}
#pragma mark -- 考勤响应
- (IBAction)clickCheckingButton:(UIButton *)sender
{
    NoNavViewController *VC = [[NoNavViewController alloc] init];
    NSString *URL01 = [NSString stringWithFormat: @"http://phoneweb.%@/teacher/swing/default?isapp=true",aedudomain];
    VC.URL = URL01;
    VC.title = @"考勤记录";
    [self.navigationController pushViewController:VC animated:YES];
    
}
#pragma mark -- 看成绩响应
- (IBAction)clickResultButton:(UIButton *)sender
{
    
    NoNavViewController *VC = [[NoNavViewController alloc] init];
    
    NSString *URL01 = [NSString stringWithFormat:@"http://phoneweb.%@/teacher/exam/index?isapp=true",aedudomain];
    VC.URL = URL01;
    VC.title = @"成绩系统";
    [self.navigationController pushViewController:VC animated:YES];
    
}
#pragma mark -- 反馈响应
- (IBAction)clickFeedbackButton:(UIButton *)sender
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
#pragma mark -- 联系人响应
- (IBAction)clickContactButton:(UIButton *)sender
{
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController pushViewController:ContactVCID
                                   withStoryBoard:MainStoryBoardName
                                        withBlock:nil];
}
#pragma mark -- 个人信息
- (IBAction)clickPersonalInformationButton:(UIButton *)sender
{
#warning 临时加得以后会改
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"myInteger"];
    [defaults synchronize];
    self.newsLabel.text = @"0";
    [self.navigationController pushViewController:MessageVCID
                                   withStoryBoard:MainStoryBoardName
                                        withBlock:nil];
}
#pragma mark -- 学校通知
- (IBAction)clickSchoolNoticeButton:(UIButton *)sender
{
    
    if (![self.notieLabel.text  isEqual: @"0"]) {
        // 清除学校通知消息：
        [self.netWorkManager settingSchoolNoticeState:[RRTManager manager].loginManager.loginInfo.tokenId
    
                                               userId:[RRTManager manager].loginManager.loginInfo.userId
    
                                              success:^(NSString *data) {
                                                    
        
                                                } failed:^(NSString *errorMSG) {
                                                    
                                                }];
    }
    [self.navigationController pushViewController:CommunicationGuardianVCID
                                   withStoryBoard:DeskStoryBoardName withBlock:^(UIViewController *viewController) {
                                       CommunicationGuardianViewController *VC = (CommunicationGuardianViewController *)viewController;
                                       VC.theTitle = @"通知";
                                       VC.headType = 11;
                                   }];
}

#pragma mark - Tap Gesture
#pragma mark -

- (void)didTappedBackground:(UIGestureRecognizer*)ges
{
    self.navigationController.tabBarController.tabBar.hidden = NO;
    statusBarView.backgroundColor=homeHeaderColor;
    if (self.userFaceView.tag) {
        [self hideTopToolView:YES];
        self.userFaceView.tag = 0;
    }
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
    [self hideTopToolView:YES];
    statusBarView.backgroundColor=homeHeaderColor;
    self.userFaceView.tag = 0;
    
    [self requestData];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [self dismiss];

    self.navigationController.navigationBar.hidden = NO;
    
}

@end
