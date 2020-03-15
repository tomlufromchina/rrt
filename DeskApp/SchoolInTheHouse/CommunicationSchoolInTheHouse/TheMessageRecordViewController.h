//
//  TheMessageRecordViewController.h
//  RenrenTong
//
//  Created by 符其彬 on 15/3/6.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "BaseViewController.h"

@interface TheMessageRecordViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (nonatomic, assign) int theMsgType;

@end
