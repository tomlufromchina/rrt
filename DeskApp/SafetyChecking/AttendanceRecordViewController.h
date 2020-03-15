//
//  AttendanceRecordViewController.h
//  RenrenTong
//
//  Created by 符其彬 on 14-9-26.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "BaseViewController.h"
#import "AttendAlertView.h"


@interface AttendanceRecordViewController : BaseViewController<AttendAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (weak, nonatomic) IBOutlet UILabel *currentData;
@property (nonatomic, strong) NSString *titleName;
@property (nonatomic, strong) NSString *todayData;
@property (nonatomic, assign) long long lassId;

@end
