//
//  ParentATTStatisticsViewController.h
//  RenrenTong
//
//  Created by 符其彬 on 14-10-11.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "BaseViewController.h"

@interface ParentATTStatisticsViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property(strong,nonatomic,readwrite)NSDictionary* childinfo;
@property(strong,nonatomic,readwrite)NSDate* begindate;
@property(strong,nonatomic,readwrite)NSDate* enddate;
@end
