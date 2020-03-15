//
//  IMManager.h
//  RenrenTong
//
//  Created by jeffrey on 14-6-9.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "XMPP.h"

#import "XMPPReconnect.h"

#import "XMPPRoster.h"
#import "XMPPRosterCoreDataStorage.h"

#import "XMPPMessageArchivingCoreDataStorage.h"
#import "XMPPMessageArchiving.h"

@protocol ChatDelegate <NSObject>

- (void)messageComming;

@end

//Manage IM
@interface IMManager : NSObject<XMPPStreamDelegate,
                                XMPPReconnectDelegate,
                                XMPPRosterDelegate>
//                                XMPPMessageArchivingStorage>

@property (nonatomic, weak) id<ChatDelegate> chatDelegate;


@property (nonatomic, strong)XMPPStream *xmppStream;

@property (nonatomic, strong)XMPPRoster *xmppRoster;
@property (nonatomic, strong)XMPPRosterCoreDataStorage *xmppRosterStorage;

@property (nonatomic, strong)XMPPMessageArchiving *xmppMessageArchivingModule;
@property (nonatomic, strong)XMPPMessageArchivingCoreDataStorage * xmppMessageArchivingStorage;

@property (nonatomic, strong)XMPPReconnect *xmppReconnect;



@property (nonatomic, copy)NSString *userId;
@property (nonatomic, copy)NSString *password;
@property (nonatomic, copy)NSString *server;

//- (void)registerAccount;

- (BOOL)connect;

- (void)disConnect;

- (void)goOnline;

- (void)goOffline;

- (void)sendMessage:(NSString*)body
                 to:(NSString*)toStr
        withSubject:(NSString*)subject
       withNickName:(NSString*)nickName;

- (NSString*)jidStrFromUserId:(NSString*)userId;
- (NSString*)userIdFromJidStr:(NSString*)jidStr;

@end
