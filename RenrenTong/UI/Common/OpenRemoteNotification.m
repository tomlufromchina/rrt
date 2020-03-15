//
//  OpenRemoteNotification.m
//  RenrenTong
//
//  Created by 唐彬 on 15-3-7.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "OpenRemoteNotification.h"
#import "NoNavViewController.h"

@implementation OpenRemoteNotification
+(void)openRemoteNotification:(Packet*)pk navigationController:(UINavigationController*)navigationController msg:(ReceiveMessage*)msg{
    if (pk.message.type==MessageTypeChat)
    {
        [navigationController pushViewController:ChatVCID
                                       withStoryBoard:MessageStoryBoardName
                                            withBlock:^(UIViewController *viewController) {
                                                ChatViewController *vc = (ChatViewController*)viewController;
                                                vc.UserId =pk.from;
                                                vc.UserName=pk.message.body.sender;
                                            }];
    }else if(pk.message.type==MessageTypePush){
        GuardianDetailsViewController *deVC = [[GuardianDetailsViewController alloc]init];
        deVC.message = msg;
        [navigationController pushViewController:deVC animated:YES];
    }else if (pk.message.type==MessageTypeRecommend){
        NoNavViewController *VC = [[NoNavViewController alloc] init];
        VC.URL = pk.message.body.url;
        [navigationController pushViewController:VC animated:YES];
    }

}
@end
