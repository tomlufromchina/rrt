//
//  SendFriendsListController.h
//  RenrenTong
//
//  Created by 符其彬 on 14-8-20.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SendFriendsListController : BaseTableViewController

@property (nonatomic, copy) NSString *areaName;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *headImg;
@property (nonatomic, copy) NSString *selfID;
@property (nonatomic, copy) NSString *userNumber;
@property (nonatomic, assign) BOOL bitFriend;

@property (nonatomic, copy) NSString *text;

@end
