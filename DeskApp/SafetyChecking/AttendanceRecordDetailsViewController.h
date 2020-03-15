//
//  AttendanceRecordDetailsViewController.h
//  RenrenTong
//
//  Created by 符其彬 on 14-9-26.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "BaseViewController.h"
#import "AttendAlertView.h"

@interface AttendanceRecordDetailsViewController : BaseViewController<AttendAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (weak, nonatomic) IBOutlet UILabel *currentData;
@property (nonatomic, assign) NSString *subTitle;
@property (nonatomic, assign) long long classId;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, assign) int userId;

@end
