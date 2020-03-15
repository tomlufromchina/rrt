//
//  ModificationViewController.h
//  RenrenTong
//
//  Created by 符其彬 on 14-11-3.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "BaseViewController.h"
#import "AttendAlertView.h"
#import "TSLocateView.h"
#import <MobileCoreServices/UTCoreTypes.h>

@protocol ModificationVCDelegate<NSObject>

@required
//A 想通知B,A发生了一些事情,可以让B成为A的代理先
-(void)issettinged;
@end


@interface ModificationViewController : BaseViewController<AttendAlertViewDelegate,UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (nonatomic, assign)   id <ModificationVCDelegate>   delegate;
@property (nonatomic, copy) NSString *isRole;


@end
