//
//  SendGoupMenberViewController.h
//  RenrenTong
//
//  Created by 符其彬 on 14-10-25.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "BaseViewController.h"

@interface SendGoupMenberViewController : BaseViewController
@property (nonatomic, strong) NSString *groupId;
@property (nonatomic, strong) NSMutableArray *groupMenberInfo;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@end
