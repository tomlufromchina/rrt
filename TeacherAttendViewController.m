//
//  TeacherAttendViewController.m
//  RenrenTong
//
//  Created by 唐彬 on 14-9-26.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "TeacherAttendViewController.h"

@interface TeacherAttendViewController ()

@end

@implementation TeacherAttendViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.scrollview.contentSize=CGSizeMake(SCREENWIDTH, self.icond4.bottom);
}
#pragma mark -- 今日考勤响应
#pragma mark --
- (IBAction)clickTodayButton:(UIButton *)sender
{
    [self.navigationController pushViewController:TodayAttendanceVCID
                                   withStoryBoard:DeskStoryBoardName withBlock:nil];
}

#pragma mark -- 考勤统计响应
#pragma mark --
- (IBAction)clickStatisticsButton:(UIButton *)sender
{
    
}


#pragma mark -- 刷卡记录响应
#pragma mark --
- (IBAction)clickRecordButton:(UIButton *)sender
{
    [self.navigationController pushViewController:ATTStatisticsVCID
                                   withStoryBoard:DeskStoryBoardName withBlock:nil];
}
#pragma mark -- 设置响应
#pragma mark --
- (IBAction)clickSettingButton:(UIButton *)sender
{
    
    [self.navigationController pushViewController:SettingVCID
                                   withStoryBoard:DeskStoryBoardName withBlock:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
