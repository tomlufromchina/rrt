//
//  PresenceProcess.h
//  RenrenTong
//
//  Created by 唐彬 on 15-2-3.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PresenceProcess : NSObject

+(void)process:(GCDAsyncSocket*) socket pk:(Packet*) pk;
@end
