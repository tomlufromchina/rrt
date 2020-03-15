//
//  ATTStatisticsViewController.m
//  RenrenTong
//
//  Created by 符其彬 on 14-9-25.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "ATTStatisticsViewController.h"
#import "NetWorkManager+Attend.h"

@interface ATTStatisticsViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>
@property (nonatomic, strong) NetWorkManager *netWorkManger;
@property (nonatomic, strong) NSArray *identities;

@end

@implementation ATTStatisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"刷卡记录";
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    [self.mainTableView setSeparatorColor:appColor];
    self.netWorkManger = [[NetWorkManager alloc] init];
    
    //Add search button
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"查询"
                                                                  style:UIBarButtonItemStyleBordered
                                                                 target:self
                                                                 action:@selector(checkRecords)];
    
    self.navigationItem.rightBarButtonItem = rightItem;
    self.identities = [[NSArray alloc] initWithObjects:@"老师",@"学生",@"家长",@"家长",@"家长1",@"家长2",@"家长3",nil];
    
    [self requestData];

}
#pragma mark -- 解析数据
#pragma mark --
- (void)requestData
{
    [self showWithStatus:@""];
    [self.netWorkManger getCheckingOfTearchs:[NSString stringWithFormat:@"%@",[RRTManager manager].loginManager.loginInfo.userId] success:^(NSMutableArray *data) {
        [self dismiss];
        [self gotoUpdataUI:data];
    } failed:^(NSString *errorMSG) {
        [self showErrorWithStatus:errorMSG];
    }];
}
#pragma mark -- 刷新界面
#pragma mark --
- (void)gotoUpdataUI:(NSMutableArray *)array
{
    
}

#pragma mark -- UITableViewDelegate&Datasource methods
#pragma mark --

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 40;
    } else {
        return 30;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
        case 1:
            return 1;
        case 2:
            return 1;
        default:
            return 0;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"开始时间";
    } else if (section == 1){
        return @"截止时间";
    } else {
        return @"选择班级";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ATTStatisticsCell"
                                                            forIndexPath:indexPath];
    if (indexPath.section == 2 && indexPath.row == 0) {
        UIImageView *imageView = (UIImageView *)[cell viewWithTag:2];
        imageView.hidden = YES;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 2 && indexPath.row == 0) {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                             destructiveButtonTitle:nil
                                                  otherButtonTitles:[self.identities objectAtIndex:0],[self.identities objectAtIndex:1],[self.identities objectAtIndex:2],[self.identities objectAtIndex:3],[self.identities objectAtIndex:4],[self.identities objectAtIndex:5],[self.identities objectAtIndex:6],nil];
        
        [sheet showInView:self.view];
    }
}

#pragma mark -- UIActionSheetDelegate
#pragma mark --

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex <= 6) {
        //获取cell上的label
        NSIndexPath *cellPath = [NSIndexPath indexPathForItem:0 inSection:2];
        UITableViewCell *cell = [self.mainTableView cellForRowAtIndexPath:cellPath];
        if (cell) {
            UILabel *label = (UILabel*)[cell viewWithTag:1];
            label.text = [self.identities objectAtIndex:buttonIndex];
        }
    }
}

#pragma mark -- 查询按钮响应方法
#pragma mark --

- (void)checkRecords
{
    [self.navigationController pushViewController:CardRecordsVCID withStoryBoard:DeskStoryBoardName withBlock:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    self.hidesBottomBarWhenPushed = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.hidesBottomBarWhenPushed = YES;
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
