//
//  OpenRemoteNotification.h
//  RenrenTong
//
//  Created by 唐彬 on 15-3-7.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChatViewController.h"
#import "GuardianDetailsViewController.h"
#import "ReceiveMessage.h"
#import "BasePacket.pb.h"
@interface OpenRemoteNotification : NSObject
+(void)openRemoteNotification:(Packet*)pk navigationController:(UINavigationController*)navigationController msg:(ReceiveMessage*)msg;
@end
