//
//  ParentsAttendanceStatisticsViewController.h
//  RenrenTong
//
//  Created by 符其彬 on 14-10-11.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "BaseViewController.h"
#import "AttendAlertView.h"
#import "ParentATTStatisticsViewController.h"

@interface ParentsAttendanceStatisticsViewController : BaseViewController<AttendAlertViewDelegate,UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property(strong,nonatomic,readwrite)NSDictionary* childinfo;
@end
