//
//  CardRecordsViewController.h
//  RenrenTong
//
//  Created by 符其彬 on 14-9-25.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "BaseViewController.h"

@interface CardRecordsViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (nonatomic, assign) long long classId;
@property (nonatomic, assign) NSString *beginTime;
@property (nonatomic, assign) NSString *endTime;
@end
