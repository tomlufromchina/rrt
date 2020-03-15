//
//  SettingViewController.h
//  RenrenTong
//
//  Created by 符其彬 on 14-9-25.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "BaseViewController.h"
@protocol AeduSettingDelegate<NSObject>

@required
//A 想通知B,A发生了一些事情,可以让B成为A的代理先
-(void)issettinged;
@end

@interface SettingViewController : BaseViewController{
    CheckingForTeachers* cft;
    TodayAttendance *ta;
}
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property(nonatomic,readwrite,strong)NSMutableArray *classinfo;
@property (nonatomic, assign)   id <AeduSettingDelegate>   delegate;

@end
