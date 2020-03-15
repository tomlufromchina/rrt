//
//  AttendStatisticsViewController.h
//  RenrenTong
//
//  Created by 唐彬 on 14-9-26.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "BaseViewController.h"
#import "AttendStatisticsRSViewController.h"
#import "AttendAlertView.h"
#import "AttendsvCell.h"
#import "CommonCheckingObejects.h"

@interface AttendStatisticsViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,AttendAlertViewDelegate,UIActionSheetDelegate>{
    long long classid;
}
@property (weak, nonatomic) IBOutlet UITableView *tabview;
@property(nonatomic,readwrite,strong)NSMutableArray* classinfo;

@end
