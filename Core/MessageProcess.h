//
//  MessageProcess.h
//  IM
//
//  Created by 唐彬 on 15-1-8.
//  Copyright (c) 2015年 唐彬. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMCache.h"
@interface MessageProcess : NSObject
+(void)process:(GCDAsyncSocket*) socket pk:(Packet*) pk;
@end
