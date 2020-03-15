//
//  PacketProcess.h
//  AeduIM
//
//  Created by 唐彬 on 14-12-8.
//  Copyright (c) 2014年 唐彬. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h"
#import "BasePacket.pb.h"
#import "IqProcess.h"
#import "MessageProcess.h"
#import "PresenceProcess.h"
@interface PacketProcess : NSObject
+(void)process:(GCDAsyncSocket*) socket pk:(Packet*) pk;
@end
