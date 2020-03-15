//
//  AttendStatisticsLSViewController.h
//  RenrenTong
//
//  Created by 唐彬 on 14-10-9.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonCheckingObejects.h"
#import "AttendsvlsCell.h"

@interface AttendStatisticsLSViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray* datasource;
    NSMutableDictionary* mdic;
}
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property(nonatomic,readwrite,strong)NSMutableArray *data;//未刷卡
@property(nonatomic,readwrite,assign)int type;//异常
@end
