//
//  PacketProcess.m
//  AeduIM
//
//  Created by 唐彬 on 14-12-8.
//  Copyright (c) 2014年 唐彬. All rights reserved.
//

#import "PacketProcess.h"

@implementation PacketProcess
+(void)process:(GCDAsyncSocket*) socket pk:(Packet*) pk{
    if (pk != nil) {
        if ([pk hasError]) {
        }else{
            if ([pk hasIq]) {
                [IqProcess process:socket pk:pk];
            }else if ([pk hasMessage]){
                [MessageProcess process:socket pk:pk];
            }else if ([pk hasPresence]){
                [PresenceProcess process:socket pk:pk];
            }
        }
    }
}



@end
