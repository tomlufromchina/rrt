//
//  GuardianDetailsViewController.h
//  RenrenTong
//
//  Created by 符其彬 on 15/2/6.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "BaseViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "ReceiveMessage.h"

@interface GuardianDetailsViewController : BaseViewController

@property(nonatomic, strong)ReceiveMessage *message;
@property(nonatomic, strong)NSString *PubUser;
@property(nonatomic, strong)NSString *PubUserID;

@end
