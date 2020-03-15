//
//  IqProcess.h
//  AeduIM
//
//  Created by 唐彬 on 14-12-8.
//  Copyright (c) 2014年 唐彬. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h"
#import "BasePacket.pb.h"
@interface IqProcess : NSObject
+(void)process:(GCDAsyncSocket*) socket pk:(Packet*) pk;
/**
 * 登陆
 */
+(void)authorWith:(GCDAsyncSocket*) socket acc:(NSString*) acc pwd:(NSString*)pwd phone:(NSString*)phone;
@end
