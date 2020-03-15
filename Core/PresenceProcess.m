//
//  PresenceProcess.m
//  RenrenTong
//
//  Created by 唐彬 on 15-2-3.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "PresenceProcess.h"

@implementation PresenceProcess
+(void)process:(GCDAsyncSocket*) socket pk:(Packet*) pk{
//    PresencePacket* pp=pk.presence;
    NSLog(@"%@",pk);
    [SoundCenter playSound];
}
@end
