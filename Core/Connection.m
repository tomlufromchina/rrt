//
//  Connection.m
//  AeduIM
//
//  Created by 唐彬 on 14-12-9.
//  Copyright (c) 2014年 唐彬. All rights reserved.
//

#import "Connection.h"

@implementation Connection

static Connection* instance=nil;
+(Connection*)shareConnection{
    @synchronized(self){
        if (instance==nil) {
            instance=[[super alloc] init];
        }
        return instance;
    }
}

- (void)dealloc
{
    NSLog(@"%@  %@",NSStringFromClass([self class]),NSStringFromSelector(_cmd));
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        packetdata=[[NSMutableData alloc] init];
        _connectionopen=NO;
        isSSLConnect=NO;
        isLogin=NO;
        isReconect=NO;
    }
    return self;
}

-(void)connect{
    if (!self.account) {
        return;
    }
    [[[NetWorkManager alloc] init] getIMserverSuccess:^(NSString *ip, int port) {
        self.ip=ip;
        self.port=port;
        if (!socket)
        {
            socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
            
            NSError *err;
            _connectionopen=[socket connectToHost:_ip onPort:_port withTimeout:5 error:&err];
            if (isSSLConnect) {
                NSMutableDictionary *sslSettings = [[NSMutableDictionary alloc] init];
                NSData *pkcs12data = [[NSData alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"client" ofType:@"p12"]];
                CFDataRef inPKCS12Data = (CFDataRef)CFBridgingRetain(pkcs12data);
                CFStringRef password = CFSTR("tangbin");
                const void *keys[] = { kSecImportExportPassphrase };
                const void *values[] = { password };
                CFDictionaryRef options = CFDictionaryCreate(NULL, keys, values, 1, NULL, NULL);
                
                CFArrayRef items = CFArrayCreate(NULL, 0, 0, NULL);
                
                OSStatus securityError = SecPKCS12Import(inPKCS12Data, options, &items);
                CFRelease(options);
                CFRelease(password);
                
                if(securityError == errSecSuccess)
                    NSLog(@"Success opening p12 certificate.");
                
                CFDictionaryRef identityDict = CFArrayGetValueAtIndex(items, 0);
                SecIdentityRef myIdent = (SecIdentityRef)CFDictionaryGetValue(identityDict,
                                                                              kSecImportItemIdentity);
                SecIdentityRef  certArray[1] = { myIdent };
                CFArrayRef myCerts = CFArrayCreate(NULL, (void *)certArray, 1, NULL);
                
                [sslSettings setObject:(id)CFBridgingRelease(myCerts) forKey:(NSString *)kCFStreamSSLCertificates];
                //                [sslSettings setObject:NSStreamSocketSecurityLevelNegotiatedSSL forKey:(NSString *)kCFStreamSSLLevel];
                //                [sslSettings setObject:(id)kCFBooleanTrue forKey:(NSString *)kCFStreamSSLAllowsAnyRoot];
                [sslSettings setObject:@(YES) forKey:GCDAsyncSocketManuallyEvaluateTrust];
                [sslSettings setObject:@"tangbin" forKey:(NSString *)kCFStreamSSLPeerName];
                [socket startTLS:sslSettings];
            }
            if (err != nil)
            {
                NSLog(@"%@",err);
            }
        }
        if (_connectionopen)
        {
            [socket readDataWithTimeout:-1 tag:0];
        }
    } failed:^(NSString *errorMSG) {
        NSLog(@"%@",errorMSG);
        [self performSelector:@selector(sendNotification:) withObject:CONNECT_FAILED afterDelay:10];
        NSLog(@"%@",@"--------获取消息服务器失败---------");
        NSLog(@"%@",@"10S后重新获取");
    }];
}


-(void)connectSSL
{
    isSSLConnect=YES;
    [self connect];
}

-(void)reConnect{
    isReconect=YES;
    [self connect];
}

- (void)socketDidSecure:(GCDAsyncSocket *)sock
{
    // This method will be called if USE_SECURE_CONNECTION is set
    
    NSLog(@"%s %d", __FUNCTION__, __LINE__);
}

- (void)socket:(GCDAsyncSocket *)sock didReceiveTrust:(SecTrustRef)trust
completionHandler:(void (^)(BOOL shouldTrustPeer))completionHandler
{
    NSLog(@"%s %d", __FUNCTION__, __LINE__);
    dispatch_queue_t bgQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(bgQueue, ^{
        
        SecKeyRef key = SecTrustCopyPublicKey(trust);
        SecTrustResultType result = kSecTrustResultDeny;
        OSStatus status = SecTrustEvaluate(trust, &result);
        
        if (status == noErr && (result == kSecTrustResultProceed || result == kSecTrustResultUnspecified)) {
            completionHandler(YES);
        }
        else {
            if (key!=NULL&&result==kSecTrustResultRecoverableTrustFailure) {
                completionHandler(YES);
            }else{
                completionHandler(NO);
            }
        }
        CFRelease(key);
    });
}


-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    NSLog(@"%s %d", __FUNCTION__, __LINE__);
    [packetdata appendData:data];
    int length=8;
    if (packetdata.length<length) {// 这里很关键，是用来当拆包时候剩余长度小于4字节8位的时候的保护，不加就出错咯
        [socket readDataWithTimeout: -1 tag: 0];
        return;
    }
    if (packetdata.length > 0&&packetdata.length >= 8) {// 有数据时，读取前8字节判断消息长度
        printf("packet-size :%lu\n",(unsigned long)[packetdata length]);
        NSData* headdata=[packetdata subdataWithRange:NSMakeRange(0, length)];
        int size =0;
        [headdata getBytes: &size length: sizeof(size)];
        
        printf("msg-size : %d\n",size);
        
        if (length<0||length>1024*1024*1024) {
            //错误的数据
            [self disconnect];
            return;
        }
        if (size+length > packetdata.length) {// 如果消息内容不够，则重置，相当于不读取size
            [socket readDataWithTimeout: -1 tag: 0];
            return ;// 父类接收新数据，以拼凑成完整数据
        } else {
            NSData* bodydata=[packetdata subdataWithRange:NSMakeRange(length, size)];
            
            Packet* p = [Packet parseFromData:bodydata];
            
            [packetdata replaceBytesInRange:NSMakeRange(0, size+length) withBytes:nil length:0];
            if (p!=nil) {
                [PacketProcess process:socket pk:p];
            }
            if (packetdata.length > 0) {// 如果读取内容后还粘了包，就让父类再重读 一次，进行下一次解析
                [socket readDataWithTimeout: -1 tag: 0];
                return ;// 父类接收新数据，以拼凑成完整数据
            }else{
                [packetdata replaceBytesInRange:NSMakeRange(0, packetdata.length) withBytes:nil];
            }
        }
    }
    [socket readDataWithTimeout: -1 tag: 0];
}

-(void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag{
    NSLog(@"%s %d, tag = %ld", __FUNCTION__, __LINE__, tag);
}

-(void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port{
    [[NSNotificationCenter defaultCenter] postNotificationName:CONNECT_SUCCESS object:nil];
    NSLog(@"%s %d", __FUNCTION__, __LINE__);
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err;{
    [self performSelector:@selector(sendNotification:) withObject:CONNECT_FAILED afterDelay:10];
    NSLog(@"%@",@"##########消息服务器连接失败！############");
    NSLog(@"%@",@"############10S后重连############");
    NSLog(@"%s %d  %@", __FUNCTION__, __LINE__,[err userInfo]);
}

-(void)sendNotification:(NSString*)notificationid{
    [self disconnect];
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationid object:nil];
}

-(void)disconnect{
    [socket disconnect];
    [packetdata setData:nil];
    socket=nil;
    isLogin=NO;
    _connectionopen=NO;
    isReconect=NO;
}
/**
 *登陆
 **/
-(void)Auth{
    isLogin=YES;
    [IqProcess authorWith:socket acc:_account pwd:_pwd phone:_phone];
}

-(void)sendMessage:(Packet*)msgpacket{
    NSData* data=[msgpacket data];
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



-(BOOL)isLogin{
    return isLogin;
}

-(void)setLogin:(BOOL)b{
    isLogin=b;
}

-(BOOL)connectionOpen{
    return _connectionopen;
}

-(BOOL)reConnectioning{
    return isReconect;
}
-(void)setreConnectioning:(BOOL)b{
    isReconect=b;
}

-(GCDAsyncSocket*) getsocket{
    return socket;
}

@end
