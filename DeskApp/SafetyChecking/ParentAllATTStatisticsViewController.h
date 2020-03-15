//
//  ParentAllATTStatisticsViewController.h
//  RenrenTong
//
//  Created by 符其彬 on 14-10-16.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "BaseViewController.h"

@interface ParentAllATTStatisticsViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (weak, nonatomic) IBOutlet UIImageView *backIMGView;
@property (nonatomic, strong) NSDictionary *infoClass;
@property (nonatomic, assign) long long classId;
@property (nonatomic, assign) NSDate *beginTime;
@property (nonatomic, assign) NSDate *endTime;


@end
