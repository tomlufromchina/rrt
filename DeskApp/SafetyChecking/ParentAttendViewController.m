//
//  ParentAttendViewController.m
//  RenrenTong
//
//  Created by 唐彬 on 14-9-24.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "ParentAttendViewController.h"
#import "NetWorkManager+Attend.h"

@interface ParentAttendViewController ()

@end

@implementation ParentAttendViewController
AttendCalendar* ac;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *actionItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(actionClick)];
    [self.navigationItem setRightBarButtonItem:actionItem];
    self.title=@"平安考勤";
    
    netWorkManager=[[NetWorkManager alloc] init];
    
    
    sc=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    [self.view addSubview:sc];
    ac=[[AttendCalendar alloc] initCalendar];//初始化日历
    ac.delegate=self;
    [sc addSubview:ac];
    
    acdaten=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"acdaten.png"]];
    acdaten.left=10;
    acdaten.top=ac.bottom+10;
    acdaten.width=15;
    acdaten.height=15;
    [sc addSubview:acdaten];
    
    lablen=[[UILabel alloc] initWithFrame:CGRectMake(acdaten.right+10, acdaten.top, SCREENWIDTH*0.7, 15)];
    lablen.textColor=[UIColor grayColor];
    lablen.font=[UIFont systemFontOfSize:12];
    lablen.text=@"圆圈表示今天所在的时期";
    [sc addSubview:lablen];
    
    acdatee=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"acdatee.png"]];
    acdatee.left=10;
    acdatee.top=acdaten.bottom+20;
    acdatee.width=15;
    acdatee.height=15;
    [sc addSubview:acdatee];
    
    lablee=[[UILabel alloc] initWithFrame:CGRectMake(acdaten.right+10, acdatee.top, SCREENWIDTH*0.7, 15)];
    lablee.textColor=[UIColor grayColor];
    lablee.font=[UIFont systemFontOfSize:12];
    lablee.text=@"红色背景为考勤异常时，点击可查看详情";
    [sc addSubview:lablee];
    
    sc.contentSize=CGSizeMake(SCREENWIDTH, acdatee.bottom+20);
    [self requestData];

}




#pragma mark -- UIActionSheetDelegate
#pragma mark --

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        [self.navigationController pushViewController:ParentSwipingCardVCID withStoryBoard:DeskStoryBoardName withBlock:^(UIViewController *viewController){
            ParentSwipingCardViewController *pscv = (ParentSwipingCardViewController *)viewController;
            pscv.childinfo=childinfo;
        }];
    }
    if (buttonIndex==1) {
        [self.navigationController pushViewController:ParentsAttendanceStatisticsVCID withStoryBoard:DeskStoryBoardName withBlock:^(UIViewController *viewController){
            ParentsAttendanceStatisticsViewController *  pavc = (ParentsAttendanceStatisticsViewController *)viewController;
            pavc.childinfo=childinfo;
        }];
    }
}


-(void)requestData{
    [self showWithStatus:@"数据加载中..."];
    [netWorkManager GetChildInfoWithPid:[RRTManager manager].loginManager.loginInfo.userId success:^(NSDictionary* data) {
        childinfo=data;
        self.title=[NSString stringWithFormat:@"%@%@",[childinfo objectForKey:@"UserName"],@"平安考勤"];
        if (childinfo) {
            [self showWithStatus:@"数据加载中..."];
            [netWorkManager GetYCByDate:[NSDate date] uid:[childinfo objectForKey:@"UserId"] success:^(NSArray *data1) {
                errordate=data1;
                [self setErrorDate];
                [self dismiss];
            } failed:^(NSString *errorMSG) {
                [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:errorMSG];
            }];
        }else{
            [self dismiss];
        }
    } failed:^(NSString *errorMSG) {
        [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:errorMSG];
    }];
}

-(void)setErrorDate{
    if (ac&&errordate) {
        for (NSString *datestr in errordate) {
            NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            NSDate *date=[dateFormatter dateFromString:datestr];
            [ac setErrorDateState:date];//异常日期
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)selectedDate:(NSDate *)date{
    
    for (NSString *tempdatestr in errordate) {
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *tempdate=[dateFormatter dateFromString:tempdatestr];
        NSString* datestr=[dateFormatter stringFromDate:date];
        date=[dateFormatter dateFromString:datestr];
        if ([date isEqualToDate:tempdate]) {
            [self.navigationController pushViewController:ParentATTStatisticsVCID withStoryBoard:DeskStoryBoardName withBlock:^(UIViewController *viewController){
                ParentATTStatisticsViewController *  pavc = (ParentATTStatisticsViewController *)viewController;
                pavc.begindate=date;
                pavc.enddate=date;
                pavc.childinfo=childinfo;
            }];
        }
    }
    
}

- (void)directBegin:(NSDate *)begindate End:(NSDate *)enddate{
    NSLog(@"begindate%@",begindate);
    NSLog(@"enddate%@",enddate);
    if (childinfo) {
        [self showWithStatus:@"数据加载中..."];
        [netWorkManager GetYCByDate:begindate uid:[childinfo objectForKey:@"UserId"] success:^(NSArray *data1) {
            errordate=data1;
            [self setErrorDate];
            [self dismiss];
        } failed:^(NSString *errorMSG) {
            [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:errorMSG];
        }];
    }
    acdaten.top=ac.bottom+10;
    lablen.top=acdaten.top;
    acdatee.top=acdaten.bottom+20;
    lablee.top=acdatee.top;
    sc.contentSize=CGSizeMake(SCREENWIDTH, acdatee.bottom+20);
    
}

-(void)actionClick{
    UIActionSheet* sheet=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"刷卡记录", @"考勤统计", nil];
    [sheet showInView:self.view];
}

- (void)viewDidAppear:(BOOL)animated
{
    self.hidesBottomBarWhenPushed = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.hidesBottomBarWhenPushed = YES;
    
}

@end
