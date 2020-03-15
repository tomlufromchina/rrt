//
//  ParentAttendViewController.h
//  RenrenTong
//
//  Created by 唐彬 on 14-9-24.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "AttendCalendar.h"
#import "NetWorkManager.h"
#import "ParentSwipingCardViewController.h"
#import "ParentsAttendanceStatisticsViewController.h"
#import "ParentATTStatisticsViewController.h"


@interface ParentAttendViewController : BaseViewController<AttendCalendarDelegate,UIActionSheetDelegate>{
    NetWorkManager* netWorkManager;
    NSDictionary* childinfo;
    UIImageView* acdaten;
    UILabel* lablen;
    UIImageView* acdatee;
    UILabel* lablee;
    UIScrollView* sc;
    NSArray* errordate;
}

@end
