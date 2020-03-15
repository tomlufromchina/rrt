//
//  ATTStatisticsViewController.h
//  RenrenTong
//
//  Created by 符其彬 on 14-9-25.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "BaseViewController.h"
#import "AttendAlertView.h"

@interface ATTStatisticsViewController : BaseViewController<AttendAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (nonatomic, assign) long long CLId;
@property(nonatomic,readwrite,strong)NSMutableArray *classinfo;

@end
