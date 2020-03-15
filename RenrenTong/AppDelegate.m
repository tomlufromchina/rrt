//
//  AppDelegate.m
//  RenrenTong
//
//  Created by jeffrey on 14-5-15.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "AppDelegate.h"
#import "UMFeedback.h"
#import "ViewControllerIdentifier.h"
#import "LoginViewController.h"
#import "MainLoginViewController.h"
#import "AdvertisementViewController.h"
#import "UMSocial.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSinaHandler.h"
#import "UMSocialWechatHandler.h"

@implementation AppDelegate

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    
    [DataManager setUpCoreDataStack];
    [UIApplication sharedApplication].applicationIconBadgeNumber=0;
    if ([[url scheme] hasPrefix:@"AeduIosRenrenTong"]) {
        if (!timer) {
            timer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(updatestatus) userInfo:nil repeats:YES];
            [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        }
        return [self qidiBoot:url];
    }else{
        return NO;
    }
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //友盟分享：
    [UMSocialData setAppKey:@"54882922fd98c5d701000b21"];
    //打开调试log的开关
    [UMSocialData openLog:YES];
    //如果你要支持不同的屏幕方向，需要这样设置，否则在iPhone只支持一个竖屏方向
    [UMSocialConfig setSupportedInterfaceOrientations:UIInterfaceOrientationMaskAll];
    //设置微信AppId，设置分享url，默认使用友盟的网址
    [UMSocialWechatHandler setWXAppId:@"wxd930ea5d5a258f4f" appSecret:@"db426a9829e4b49a0dcac7b4162da6b6" url:@"http://www.umeng.com/social"];
    
    //打开新浪微博的SSO开关
    [UMSocialSinaHandler openSSOWithRedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
    //    //设置分享到QQ空间的应用Id，和分享url 链接
    [UMSocialQQHandler setQQWithAppId:@"100424468" appKey:@"c7394704798a158208a74ab60104f0ba" url:@"http://www.umeng.com/social"];
    //    //设置支持没有客户端情况下使用SSO授权
    [UMSocialQQHandler setSupportWebView:YES];
    
    [DataManager setUpCoreDataStack];
    
    [UIApplication sharedApplication].applicationIconBadgeNumber=0;
    // 友盟反馈
    [UMFeedback setAppkey:APPKEY];
    [UMFeedback setLogEnabled:NO];
    
    //IOS8 推送类型注册
    [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    [application registerForRemoteNotifications];
    //IOS8 推送类型注册
    
    //设置NavBar的背景色
    [[UINavigationBar appearance] setBarTintColor:theLoginButtonColor];
    //设置NavBar左右两边按钮的颜色
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    //设置NavBar的title的颜色
    [[UINavigationBar appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
    
    
    
    NSURL *url = [launchOptions objectForKey:UIApplicationLaunchOptionsURLKey];
    if(url) {//做出相应的判断
        return [self qidiBoot:url];
    }else{
        AdvertisementViewController *adVC = [[AdvertisementViewController alloc]init];
        self.window.rootViewController = adVC;
    }
    
    //判断是否由远程消息通知触发应用程序启动
    if ([launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey]!=nil) {
        NSDictionary *remotenotification=[launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒"
        //                                                                         message:[NSString stringWithFormat:@"type%@guid%@",[remotenotification  objectForKey:@"MessageType"],[remotenotification  objectForKey:@"Guid"]]
        //                                                                        delegate:self
        //                                                               cancelButtonTitle:@"Close"
        //                                                               otherButtonTitles:@"OK",nil];
        //        [alert show];
        [self saveRemoteNotification:remotenotification];
        [self openRemoteNotification];
        //获取应用程序消息通知标记数（即小红圈中的数字）
        //        NSInteger badge = [UIApplication sharedApplication].applicationIconBadgeNumber;
        //        if (badge>0) {
        //            //如果应用程序消息通知标记数（即小红圈中的数字）大于0，清除标记。
        //            badge--;
        //            //清除标记。清除小红圈中数字，小红圈中数字为0，小红圈才会消除。
        //            [UIApplication sharedApplication].applicationIconBadgeNumber = badge;
        //        }
    }
    
    // 网络监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged1:)
                                                 name: kTheReachabilityChangedNotification
                                               object: nil];
    self.hostReach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    [self.hostReach startNotifier];
    // 2.开启定时器更新服务器数据状态
    if (!timer) {
        timer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(updatestatus) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    }
    return YES;
}

-(void)saveRemoteNotification:(NSDictionary*)remotenotification{
    NSUserDefaults* nud=[NSUserDefaults standardUserDefaults];
    
    [nud setObject:remotenotification forKey:@"remotenotification"];
    [nud setObject:[NSNumber numberWithBool:NO] forKey:@"isopenremotenotification"];
    [nud synchronize];
}
- (void)updatestatus
{
    @try {
        if ([RRTManager manager].loginManager&&[RRTManager manager].loginManager.loginInfo) {
            synmsg= [[IMCache shareIMCache] getUnSynPacket:[RRTManager manager].loginManager.loginInfo.userId];
            if ([synmsg count]>0) {
                self.request = [[ASIFormDataRequest alloc] init];
                [self setRequest:[ASIFormDataRequest requestWithURL:
                                  [NSURL URLWithString:[NSString stringWithFormat:@"http://pushservice.%@/message/updatestatus",aedudomain]]]];
                
                
                [self.request setPostValue:[NSNumber numberWithInt:4] forKey:@"StatusId"];
                for (int i = 0; i < [synmsg count]; i++) {
                    Packet* pk= synmsg[i];
                    NSString *MessageId = [NSString stringWithFormat:@"%@",pk.message.guid];
                    [self.request addPostValue:MessageId forKey:[NSString stringWithFormat:@"MessageIdList[%d]",i]];
                }
                [self.request setTimeOutSeconds:20];
                [self.request setDelegate:self];
                [self.request setDidFailSelector:@selector(updateFailed:)];
                [self.request setDidFinishSelector:@selector(updateSendFinished:)];
                [self.request startAsynchronous];
            }
        }
    }
    @catch (NSException *exception) {
        
    }
    
}
#pragma mark -- 发送成功回调

- (void)updateFailed:(ASIHTTPRequest *)theRequest
{
    
    NSLog(@"The error is:%@", theRequest.error);
}
- (void)updateSendFinished:(ASIHTTPRequest *)theRequest
{
    NSData *deData = theRequest.responseData;
    if (deData) {
        @try {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:deData
                                                                 options:kNilOptions
                                                                   error:nil];
            if (dict) {
                BOOL result = [[dict objectForKey:@"result"] boolValue];
                NSLog(@"%@",dict);
                if (result == 1) {
                    NSString* idstr=[dict objectForKey:@"message"];
                    if (idstr!=nil&&idstr.length>0) {
                        NSArray *ids = [idstr componentsSeparatedByString:@","];
                        for (int i = 0; i < [ids count]; i++) {
                            [[IMCache shareIMCache] updatePacketState:[ids objectAtIndex:i] state:4];
                            NSLog(@"guid:%@同步成功", [ids objectAtIndex:i]);
                        }
                    }
                }
            }
        }
        @catch (NSException *exception) {
            
        }
    }
}
#pragma mark -- 网络监听回调

-(void)reachabilityChanged1:(NSNotification *)note
{
    Reachability *currReach = [note object];
    NSParameterAssert([currReach isKindOfClass:[Reachability class]]);
    //对连接改变做出响应处理动作
    NetworkStatus status = [currReach currentReachabilityStatus];
    //如果没有连接到网络就弹出提醒实况
    self.isReachable = YES;
    if(status == NotReachable){
        self.isReachable = NO;
    } else{
        self.isReachable = YES;
    }
}




#pragma mark
#pragma mark 家校通启迪平台启动

-(BOOL)qidiBoot:(NSURL*)url{
    if ([[url scheme] hasPrefix:@"AeduIosRenrenTong"]) {
        //处理链接
        NSArray* array=[[url absoluteString] componentsSeparatedByString:@"="];
        if (array==nil||[array count]<2) {
            return NO;
        }
        //在这里还是要登录一次，避免token过期
        NetWorkManager *networkManager = [[NetWorkManager alloc] init];
        [networkManager loginQiDiUserName:[array objectAtIndex:1]
                                  success:^(Login *login)
         {
             login.account = [array objectAtIndex:1];
             login.password = @"1111";
             [RRTManager manager].loginManager.loginInfo = login;
             
             UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:MainStoryBoardName
                                                                      bundle:nil];
             UITableViewController *mainVC = [mainStoryBoard instantiateViewControllerWithIdentifier:
                                              MainVCID];
             UIWindow *window = ((AppDelegate*)[UIApplication sharedApplication].delegate).window;
             window.rootViewController = mainVC;
         } failed:^(NSString *errorMSG) {
             UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:LoginStoryBoardName
                                                                      bundle:nil];
             MainLoginViewController *loginVC = [mainStoryBoard instantiateViewControllerWithIdentifier:
                                                 MainLoginVCID];
             //             loginVC.bFromLaunch = YES;
             UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
             self.window.rootViewController = nav;
             
         }];
        return YES;
    }else{
        return NO;
    }
}

//---------------------------------------------------系统推送-----------------------------------------------------------


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString* token=[[[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]] stringByReplacingOccurrencesOfString:@" " withString:@""];
    //获取终端设备标识，这个标识需要通过接口发送到服务器端，服务器端推送消息到APNS时需要知道终端的标识，APNS通过注册的终端标识找到终端设备。
    NSLog(@"My token is:%@", token);
    BaiDuPushParams* bdpp=[BaiDuPushParams shareBaiDuPushParams];
    bdpp.deviceToken=token;
    [[[NetWorkManager alloc] init] bindPush];
}


- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSString *error_str = [NSString stringWithFormat: @"%@", error];
    NSLog(@"Failed to get token, error:%@", error_str);
}


//处理收到的消息推送
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //在此处理接收到远程的消息。
        [self saveRemoteNotification:userInfo];
        [self openRemoteNotification];
        if (!timer) {
            timer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(updatestatus) userInfo:nil repeats:YES];
            [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        
    }
    
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    //在此处理接收到本地的消息。
    NSLog(@"Receive remote notification : %@",notification);
}
//---------------------------------------------------系统推送-----------------------------------------------------------

//如果需要支持 iOS8,请加上这些代码
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    //    [UIApplication sharedApplication].applicationIconBadgeNumber=[[MessageNoticeCenter shareMessageNoticeCenter] getBadgeNumber];
    NSLog(@"%s %d", __FUNCTION__, __LINE__);
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSLog(@"%s %d", __FUNCTION__, __LINE__);
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSLog(@"%s %d", __FUNCTION__, __LINE__);
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [UMSocialSnsService  applicationDidBecomeActive];
    NSLog(@"%s %d", __FUNCTION__, __LINE__);
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    NSLog(@"%s %d", __FUNCTION__, __LINE__);
}
-(void)openRemoteNotification{
    @try {
        if ([RRTManager manager].loginManager&&[RRTManager manager].loginManager.loginInfo) {
            NSUserDefaults* nud=  [NSUserDefaults standardUserDefaults];
            BOOL isopenremotenotification= [[nud objectForKey:@"isopenremotenotification"] boolValue];
            if (!isopenremotenotification) {
                [nud setObject:[NSNumber numberWithBool:YES] forKey:@"isopenremotenotification"];
                [nud synchronize];
                NSDictionary* dic = [nud objectForKey:@"remotenotification"];
                if (dic==nil) {
                    [nud removeObjectForKey:@"remotenotification"];
                    [nud removeObjectForKey:@"isopenremotenotification"];
                }
                NSString* Guid=[dic  objectForKey:@"Guid"];
                NetWorkManager* networkmanager=[[NetWorkManager alloc] init];
                [networkmanager getMessageWithGuid:Guid success:^(NSMutableArray *data) {
                    NSArray *array = [NSArray array];
                    array = [ReceiveMessage objectArrayWithKeyValuesArray:data];
                    if(array.count > 0)
                    {
//                        if ([array count]==1) {
                            ReceiveMessage *msg =[array objectAtIndex:0];
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
                        [messageBodyBuilder setUrl:msg.Url];
                        [messageBodyBuilder setUrldesc:msg.UrlDescription];
                        [messageBodyBuilder setUrlpic:msg.UrlPicture];
                            [messagePacketBuilder setBodyBuilder:messageBodyBuilder];
                            [packetPacketBuilder setMessageBuilder:messagePacketBuilder];
                            Packet*   pk =[packetPacketBuilder build];
                            [[IMCache shareIMCache] savePacket:pk sessionid:[NSString stringWithFormat:@"%@",[msg.PubUser objectForKey:@"UserId"]]];
                            
                            [nud removeObjectForKey:@"remotenotification"];
                            [nud removeObjectForKey:@"isopenremotenotification"];
                            [nud synchronize];
                        UIViewController *vc = [self getCurrentVC];
//                        UINavigationController *na = vc.navigationController;
                        if ([[NSString stringWithFormat:@"%d",pk.to.intValue] isEqualToString:[RRTManager manager].loginManager.loginInfo.userId]) {
                            [OpenRemoteNotification openRemoteNotification:pk navigationController:vc msg:msg];
                        }
                        
//                        }
                    }
                } failed:^(NSString *errorMSG) {
                    [nud setObject:[NSNumber numberWithBool:NO] forKey:@"isopenremotenotification"];
                    [nud synchronize];
                }];
                
            }
            
        }
    }
    @catch (NSException *exception) {
        
    }
}
- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}
@end
