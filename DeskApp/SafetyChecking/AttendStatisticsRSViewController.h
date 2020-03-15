//
//  AttendStatisticsRSViewController.h
//  RenrenTong
//
//  Created by 唐彬 on 14-9-26.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "BaseViewController.h"
#import "NetWorkManager+Attend.h"
#import "AttendsvrsTableViewCell.h"
#import "AttendStatisticsLSViewController.h"

@interface AttendStatisticsRSViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>{
    NetWorkManager* networkmanager;
    int zcdata;//正常
    BOOL wskflag;
    BOOL ycflag;
    BOOL zcflag;
}
@property (weak, nonatomic) IBOutlet UITableView *tabview;
@property(nonatomic,readwrite,strong)NSString* begintime;
@property(nonatomic,readwrite,strong)NSString* endtime;
@property(nonatomic,readwrite,assign)int UserType;
@property(nonatomic,readwrite,assign)long long classid;
@property(nonatomic,readwrite,strong)NSString* cls;
@property(nonatomic,readwrite,strong)NSMutableArray *wskdata;//未刷卡
@property(nonatomic,readwrite,strong)NSMutableArray *ycdata;//异常
@end
