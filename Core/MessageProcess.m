    //
//  MessageProcess.m
//  IM
//
//  Created by 唐彬 on 15-1-8.
//  Copyright (c) 2015年 唐彬. All rights reserved.
//

#import "MessageProcess.h"
@implementation MessageProcess
+(void)process:(GCDAsyncSocket*)socket pk:(Packet*) pk{
    @try {
      
            if (pk.message.type==MessageTypeGroupChat) {
                    [[IMCache shareIMCache] savePacket:pk sessionid:[NSString stringWithFormat:@"%@%@",pk.message.body.groupid,pk.to]];
            } else if(pk.message.type==MessageTypeChat||pk.message.type==MessageTypePush){
                [[IMCache shareIMCache] savePacket:pk sessionid:pk.from];
            }else if (pk.message.type==MessageTypeRecommend){
                [[IMCache shareIMCache] savePacket:pk sessionid:pk.from];
            }
        if ([[NSString stringWithFormat:@"%d",pk.to.intValue] isEqualToString:[RRTManager manager].loginManager.loginInfo.userId]) {
            [SoundCenter playSound];
            [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE object:nil];
        }
        }
    @catch (NSException *exception) {
        
    }
}
@end
