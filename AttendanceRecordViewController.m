//
//  AttendanceRecordViewController.m
//  RenrenTong
//
//  Created by 符其彬 on 14-9-26.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "AttendanceRecordViewController.h"

@interface AttendanceRecordViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation AttendanceRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.title = @"AAA";
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AttendanceRecordCell"
                                                            forIndexPath:indexPath];
    UIImageView *unusualImageView = (UIImageView *)[cell viewWithTag:1];
    UIImageView *usualImageView = (UIImageView *)[cell viewWithTag:2];
    UIImageView *lateImageView = (UIImageView *)[cell viewWithTag:4];
    UIImageView *leaveImageView = (UIImageView *)[cell viewWithTag:5];
    UIImageView *notImageView = (UIImageView *)[cell viewWithTag:6];
    UIImageView *vacateImageView = (UIImageView *)[cell viewWithTag:7];
    
    if (indexPath.row == 0) {
        unusualImageView.hidden = NO;
        usualImageView.hidden = YES;
        lateImageView.hidden = NO;
        leaveImageView.hidden = NO;
        notImageView.hidden = NO;
        vacateImageView.hidden = NO;
    } else {
        unusualImageView.hidden = YES;
        usualImageView.hidden = NO;
        lateImageView.hidden = YES;
        leaveImageView.hidden = YES;
        notImageView.hidden = YES;
        vacateImageView.hidden = YES;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController pushViewController:RecordDetailVCID
                                   withStoryBoard:DeskStoryBoardName withBlock:nil];
    
}
#pragma mark -- 点击日历按钮响应事件
#pragma mark --
- (IBAction)clickCalendarButton:(UIButton *)sender {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
