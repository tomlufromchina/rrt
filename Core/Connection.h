//
//  Connection.h
//  AeduIM
//
//  Created by 唐彬 on 14-12-9.
//  Copyright (c) 2014年 唐彬. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h"
#import "PacketProcess.h"

@interface Connection : NSObject<GCDAsyncSocketDelegate>
{
    GCDAsyncSocket *socket;
    NSMutableData* packetdata;
    BOOL isSSLConnect;
    BOOL isLogin;
    BOOL isReconect;
}
@property(readonly,nonatomic,assign) BOOL connectionopen;
@property(readwrite,nonatomic,strong) NSString* ip;
@property(readwrite,nonatomic,assign) int port;
@property(readwrite,nonatomic,strong) NSString* account;
@property(readwrite,nonatomic,strong) NSString* pwd;
@property(readwrite,nonatomic,strong) NSString* phone;
+(Connection*)shareConnection;
-(void)connect;
-(void)connectSSL;
-(void)reConnect;
-(void)disconnect;

-(void)Auth;

-(void)sendMessage:(Packet*)msgpacket;
-(BOOL)isLogin;
-(void)setLogin:(BOOL)b;
-(BOOL)reConnectioning;
-(GCDAsyncSocket*) getsocket;
@end
