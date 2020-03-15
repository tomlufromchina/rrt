//
//  IqProcess.m
//  AeduIM
//
//  Created by 唐彬 on 14-12-8.
//  Copyright (c) 2014年 唐彬. All rights reserved.
//

#import "IqProcess.h"
@implementation IqProcess
static Packet* hBeatRequest;
static Packet* hBeatResPonse;
+(void)process:(GCDAsyncSocket*) socket pk:(Packet*) pk{
    NSLog(@"%@",pk);
    if (!hBeatRequest||!hBeatResPonse) {
        PacketBuilder* requestPacketBuilder =[Packet builder];
        IqPacketBuilder* requestIq = [IqPacket builder];
        IqActionBuilder* requestAction=[IqAction builder];
        [requestAction setHeartbeatRequest:HeartbeatRequest];
        [requestIq setAction:[requestAction build]];
        [requestIq setType:IqTypeGet];
        
        [requestPacketBuilder setFrom:@"MessageServer"];
        [requestPacketBuilder setTo:@"Client"];
        [requestPacketBuilder setIq:[requestIq build]];
        hBeatRequest=[requestPacketBuilder build];
        
        
        
        PacketBuilder* responsePacketBuilder =[Packet builder];
        IqPacketBuilder* responseIq = [IqPacket builder];
        IqActionResponseBuilder* responseAction=[IqActionResponse builder];
        [responseAction setHeartbeatResponse:HeartbeatResponse];
        [responseIq setActionresponse:[responseAction build]];
        [responseIq setType:IqTypeResult];
        
        [responsePacketBuilder setFrom:@"Client"];
        [responsePacketBuilder setTo:@"MessageServer"];
        [responsePacketBuilder setIq:[responseIq build]];
        hBeatResPonse=[responsePacketBuilder build];
        
        
    }
   IqPacket* iq= pk.iq;
    if (iq.type==IqTypeGet) {
        if ([iq hasAction]) {
            if ([[iq action] hasHeartbeatRequest]) {
                [IqProcess processHeartbeat:socket pk:pk];
            }
        }
    }else if(iq.type==IqTypeResult){
        if ([iq hasActionresponse]) {
            if ( [[iq actionresponse] hasLoginresponse]) {
                [self processLoginResponse:[[iq actionresponse] loginresponse]];
            }
        }
    }
}

/**
 * 响应心跳包
 */
+(void)processHeartbeat:(GCDAsyncSocket*) socket pk:(Packet*) pk{
    
    if ([pk isEqual:hBeatRequest]&&hBeatResPonse) {
        NSData* data=[hBeatResPonse data];
        NSInteger length=(NSInteger)[data length];
        NSMutableData *msgdata = [NSMutableData dataWithBytes: &length length: sizeof(length)];
        if (msgdata.length<8) {
            Byte byte[] = {0};
            NSData *tempdata = [[NSData alloc] initWithBytes:byte length:1];
            NSInteger times=8-[msgdata length];
            for (int i=0; i<times; i++) {
                [msgdata appendData:tempdata];
            }
        }
        [msgdata getBytes: &length length: sizeof(length)];
        [msgdata appendData:data];
        [socket writeData:msgdata withTimeout: -1 tag: 0];
    }
}


/**
 * 登陆
 */
+(void)authorWith:(GCDAsyncSocket*) socket acc:(NSString*) acc pwd:(NSString*)pwd phone:(NSString*)phone{
    PacketBuilder* loginPacketBuilder =[Packet builder];
    IqPacketBuilder* authoriq = [IqPacket builder];
    IqActionBuilder* iqLoginAction=[IqAction builder];
    LoginActionBuilder* loginAction=[LoginAction builder];
    if (acc) {
        [loginAction setAccount:acc];
    }
    if (pwd) {
        [loginAction setPassword:pwd];
    }
    if (phone) {
        [loginAction setPhone:phone];
    }
    [iqLoginAction setLoginaction:[loginAction build]];
    [authoriq setType:IqTypeSet];
    [authoriq setAction:[iqLoginAction build]];
    [loginPacketBuilder setFrom:@"Client"];
    [loginPacketBuilder setTo:@"MessageServer"];
    [loginPacketBuilder setIq:[authoriq build]];
    Packet* authpacket= [loginPacketBuilder build];
    NSData* data=[authpacket data];
    NSInteger length=(NSInteger)[data length];
    NSMutableData *msgdata = [NSMutableData dataWithBytes: &length length: sizeof(length)];
    if (msgdata.length<8) {
        Byte byte[] = {0};
        NSData *tempdata = [[NSData alloc] initWithBytes:byte length:1];
        NSInteger times=8-[msgdata length];
        for (int i=0; i<times; i++) {
            [msgdata appendData:tempdata];
        }
    }
    [msgdata getBytes: &length length: sizeof(length)];
    [msgdata appendData:data];
    
    [socket writeData:msgdata withTimeout: -1 tag: 0];
}



/**
 * 处理登陆响应
 */
+(void)processLoginResponse:(LoginResponse*) loginresponse {
    if ([loginresponse statecode]==0) {
        //登陆失败
        [[NSNotificationCenter defaultCenter] postNotificationName:LOGIN_FAILED object:[loginresponse responsemsg]];
    } else if ([loginresponse statecode]==1){
        //登陆成功
        [[NSNotificationCenter defaultCenter] postNotificationName:LOGIN_SUCCESS object:[loginresponse responsemsg]];
    }
}

@end
