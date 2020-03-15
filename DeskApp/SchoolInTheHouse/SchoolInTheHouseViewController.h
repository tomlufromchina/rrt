//
//  SchoolInTheHouseViewController.h
//  RenrenTong
//
//  Created by 符其彬 on 14-10-22.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "BaseViewController.h"
#import "LXActionSheet.h"
#import "UIImageView+MJWebCache.h"

@interface SchoolInTheHouseViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIButton *receiveButton;
@property (weak, nonatomic) IBOutlet UIButton *getButton;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (weak, nonatomic) IBOutlet UIButton *getMessageButton;
@property (weak, nonatomic) IBOutlet UIButton *sendMessageButton;

@end
