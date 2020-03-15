//
//  IMManager.m
//  RenrenTong
//
//  Created by jeffrey on 14-6-9.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "IMManager.h"
#import "LoginViewController.h"
#import "AppDelegate.h"



@interface IMManager ()<UIAlertViewDelegate>

- (void)setupStream;

@end

@implementation IMManager

- (id)init
{
    self = [super init];
    if (self) {
//        self.server = @"10.0.1.158";    //内网
        self.server = @"116.255.240.130"; //外网
        
        [self setupStream];
    }
    
    return self;
}

#pragma mark - xmpp fuction
#pragma mark -
-(void)setupStream
{
    //初始化XMPPStream
    self.xmppStream = [[XMPPStream alloc] init];
    [self.xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    //init reconect
    self.xmppReconnect = [[XMPPReconnect alloc]init];
    [self.xmppReconnect activate:self.xmppStream];
    
    //init roster
    self.xmppRosterStorage = [[XMPPRosterCoreDataStorage alloc] init];
    self.xmppRoster = [[XMPPRoster alloc]initWithRosterStorage:self.xmppRosterStorage];
    [self.xmppRoster activate:self.xmppStream];
    [self.xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    //init message storage
    self.xmppMessageArchivingStorage = [XMPPMessageArchivingCoreDataStorage sharedInstance];
    self.xmppMessageArchivingModule = [[XMPPMessageArchiving alloc] initWithMessageArchivingStorage:self.xmppMessageArchivingStorage];
    [self.xmppMessageArchivingModule setClientSideMessageArchivingOnly:YES];
    [self.xmppMessageArchivingModule activate:self.xmppStream];
    [self.xmppMessageArchivingModule addDelegate:self delegateQueue:dispatch_get_main_queue()];
}

-(void)goOnline
{
    //发送在线状态
    XMPPPresence *presence = [XMPPPresence presence];
    [self.xmppStream sendElement:presence];
}

-(void)goOffline
{
    //发送下线状态
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    [[self xmppStream] sendElement:presence];
}

//- (void)registerAccount
//{
//    NSError *err;
//    NSString *tjid = [[NSString alloc] initWithFormat:@"anonymous@%@", _server];
//    [[self xmppStream] setMyJID:[XMPPJID jidWithString:tjid]];
//    if ( ![self.xmppStream connectWithTimeout:15 error:&err])
//    {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"连接服务器失败"
//                                                            message:[err localizedDescription]
//                                                           delegate:nil
//                                                  cancelButtonTitle:@"Ok"
//                                                  otherButtonTitles:nil];
//        [alertView show];
//    }
//}

-(BOOL)connect
{
    self.userId = [RRTManager manager].loginManager.loginInfo.userId;
    self.password = [RRTManager manager].loginManager.loginInfo.password;
    
    if (![self.xmppStream isDisconnected]) {
        return YES;
    }
    
    //设置用户
    NSString *jid = [self jidStrFromUserId:_userId];
    [[self xmppStream] setMyJID:[XMPPJID jidWithString:jid]];
    
    //设置服务器
    [self.xmppStream setHostName:self.server];
    
    //连接服务器
    NSError *error = nil;
    if (![self.xmppStream connectWithTimeout:15 error:&error]) {
        NSLog(@"cant connect %@", _server);
        return NO;
    }
    
    return YES;
}

-(void)disConnect
{
    [self goOffline];
    [self.xmppStream disconnect];
}

- (void)sendMessage:(NSString*)body
                 to:(NSString*)toStr
        withSubject:(NSString*)subject
       withNickName:(NSString*)nickName
{
    if (!body || !toStr) {
        NSLog(@"The body or jidStr is nil;");
        return;
    }
    
    XMPPMessage *message = [XMPPMessage messageWithType:@"chat" to:[XMPPJID jidWithString:[self jidStrFromUserId:toStr]]];
    [message addBody:body];
    
    [message addAttributeWithName:@"from" stringValue:[self jidStrFromUserId:_userId]];
    
    if (subject) {
        [message addSubject:subject];
    }
    
    if (nickName) {
        [message addSubject:nickName withLanguage:@"user_nick_name"];
    }

    [self.xmppStream sendElement:message];
}


#pragma mark - xmppStream delegate
#pragma mark -
//连接服务器成功回调
- (void)xmppStreamDidConnect:(XMPPStream *)sender
{
    NSError *error = nil;
    
    //登陆
    [[self xmppStream] authenticateWithPassword:self.password error:&error];
    if (error) {
        NSLog(@"The is :%@", error);
    }
    
    //注册
    
    //    NSString *jid = [[NSString alloc] initWithFormat:@"%@@%@", _userId, _server];
    //    [[self xmppStream] setMyJID:[XMPPJID jidWithString:jid]];
    //
    //    isSuc = [self.xmppStream registerWithPassword:self.password error:&error];
    //    NSLog(@"The is :%d", isSuc);
}

//验证通过
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
    [self goOnline];
    NSLog(@"密码验证成功");
}

//验证失败
- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error
{
//    NSString *array = error.name;
//    
//    array = error.stringValue;
    
    
//    BOOL i = [self.xmppStream isAuthenticated];
//    i = [self.xmppStream isAuthenticating];
    NSLog(@"密码验证失败%@", error);
}

//收到消息
- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
    //    NSLog(@"message = %@", message);

    NSString *msg = message.body;
    NSString *from = message.fromStr;
    NSString *subject = message.subject;
    NSString *type = message.type;
    
    NSLog(@"A message is coming: %@--%@--%@--%@", type, subject, from, msg);
    
    [self performSelector:@selector(sendMessageComming) withObject:nil afterDelay:0.1];
}

//发送消息成功
- (void)xmppStream:(XMPPStream *)sender didSendMessage:(XMPPMessage *)message
{
    [self performSelector:@selector(sendMessageComming) withObject:nil afterDelay:0.1];
}

//发送消息失败
- (void)xmppStream:(XMPPStream *)sender didFailToSendMessage:(XMPPMessage *)message error:(NSError *)error
{
    NSLog(@"发送消息失败");
}

- (void)sendMessageComming
{
    if (self.chatDelegate &&
        [self.chatDelegate respondsToSelector:@selector(messageComming)]) {
        [self.chatDelegate messageComming];
    }
}



//收到好友状态
- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence
{
    //    NSLog(@"presence = %@", presence);
    
    //取得好友状态
    NSString *presenceType = [presence type];
//    NSLog(@"The presence is:%@--%@---%@---%d", presenceType, [presence show], [presence status], [presence isErrorPresence]);
    //当前用户
    XMPPJID *curJid = [sender myJID];
//    NSLog(@"The current user:%@---%@---%@", [sender myJID].user, [sender myJID].domain, [sender myJID].resource);
    //发送消息的用户
    XMPPJID *fromJid = [presence from];
//    NSLog(@"The from user:%@---%@---%@", [presence from].user, [presence from].domain, [presence from].resource);
    
//    if ([presenceType     isEqualToString:@"available"] &&
//        [curJid.user      isEqualToString:fromJid.user] &&
//        [curJid.domain    isEqualToString:fromJid.domain] &&
//        ![curJid.resource isEqualToString:fromJid.resource])
//    {
//        //表示该账号在另外一台手机上登录了
//        //断开IM
//        [[RRTManager manager].imManager disConnect];
//        //清除密码
//        [[RRTManager manager].loginManager logout];
//        
//        NSString *content = @"你的人人通账号已在其它地方登录，请注意账号安全。如果这不是你的操作，你的人人通密码很可能已泄露，建议前往http://www.aedu.cn修改密码。";
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:content
//                                                            message:nil
//                                                           delegate:self
//                                                  cancelButtonTitle:nil
//                                                  otherButtonTitles:@"确定", nil];
//        [alertView show];
//        
//        return;
//        
//    }
    
    if (![fromJid.user isEqualToString:curJid.user]) {
        //“subscribe” 好友申请的回调
        //在线状态
        if ([presenceType isEqualToString:@"available"]) {
            
            //用户列表委托(后面讲)
            //            [chatDelegate newBuddyOnline:[NSString stringWithFormat:@"%@@%@", presenceFromUser, @"nqc1338a"]];
            
        }else if ([presenceType isEqualToString:@"unavailable"]) {
            //用户列表委托(后面讲)
            //            [chatDelegate buddyWentOffline:[NSString stringWithFormat:@"%@@%@", presenceFromUser, @"nqc1338a"]];
        }
        
    }
}

- (NSString *)xmppStream:(XMPPStream *)sender alternativeResourceForConflictingResource:(NSString *)conflictingResource
{
    NSLog(@"Conflicting:---:%@", conflictingResource);
    
    
    return nil;
}


- (void)xmppStream:(XMPPStream *)sender didReceiveError:(NSXMLElement *)error
{
    NSLog(@"The error is:%@", error);
}

- (void)xmppStreamWasToldToDisconnect:(XMPPStream *)sender
{
    
}

- (void)xmppStreamConnectDidTimeout:(XMPPStream *)sender
{
    
}

#pragma mark - XMPPRoster delegate
#pragma mark -
- (void)xmppRoster:(XMPPRoster *)sender didReceivePresenceSubscriptionRequest:(XMPPPresence *)presence
{
    //接受到加好友的回调，类似didReceivePresence中prescenc为“subscribe”的情况，也就是说接受加好友的回调实现有两种
    [self.xmppRoster acceptPresenceSubscriptionRequestFrom:presence.from andAddToRoster:YES];
    
    //在这里，可以接受或者拒绝接受
    
}

- (void)xmppReconnect:(XMPPReconnect *)sender didDetectAccidentalDisconnect:(SCNetworkConnectionFlags)connectionFlags
{
    NSLog(@"The xmpp server disconnected");
}

- (BOOL)xmppReconnect:(XMPPReconnect *)sender shouldAttemptAutoReconnect:(SCNetworkConnectionFlags)connectionFlags
{
    return YES;
}

#pragma mark - Ubility
#pragma mark -
- (NSString*)jidStrFromUserId:(NSString*)userId
{
    if (!userId) {
        return nil;
    }
    
    return [NSString stringWithFormat:@"%@@aedu.cn", userId];
}

- (NSString*)userIdFromJidStr:(NSString*)jidStr
{
    if (!jidStr) {
        return nil;
    }
    
    NSRange range = [jidStr rangeOfString:@"@aedu.cn"];
    if (range.length <= 0 || range.location <= 0) {
        return nil;
    }
    
    range = NSMakeRange(0, range.location);
    return [jidStr substringWithRange:range];
}

#pragma mark - UIAlertView delegate
#pragma mark -
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:LoginStoryBoardName
                                                             bundle:nil];
    LoginViewController *loginVC = [mainStoryBoard instantiateViewControllerWithIdentifier:
                                    LoginVCID];
    
    loginVC.bFromLaunch = YES;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
    
    UIWindow *window = ((AppDelegate*)[UIApplication sharedApplication].delegate).window;
    
    window.rootViewController = nav;
}

@end
