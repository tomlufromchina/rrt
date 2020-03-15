//
//  ATTStatisticsViewController.m
//  RenrenTong
//
//  Created by 符其彬 on 14-9-25.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "ATTStatisticsViewController.h"
#import "ATTStaticsCell.h"
#import "CardRecordsViewController.h"
#import "NetWorkManager+Attend.h"

@interface ATTStatisticsViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>
@property (nonatomic, strong) NetWorkManager *netWorkManger;
@property (nonatomic, strong) NSArray *identities;
@property (nonatomic, strong) UIButton *calendarButton;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@property (nonatomic, assign) NSInteger buttonIndex;



@end

@implementation ATTStatisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@",self.classinfo);
    self.title = @"刷卡记录";
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    [self.mainTableView setSeparatorColor:appColor];
    self.netWorkManger = [[NetWorkManager alloc] init];
    
    //Add search button
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"查询"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(checkRecords)];
    
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [self requestData];

}
#pragma mark -- 解析数据
#pragma mark --
- (void)requestData
{
    
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
    ATTStaticsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ATTStaticsCell"
                                                            forIndexPath:indexPath];

    if (indexPath.section == 2 && indexPath.row == 0) {
        UIImageView *imageView = (UIImageView *)[cell viewWithTag:2];
        imageView.hidden = YES;
        cell.chooseClassLabel.text = @"请选择班级";
        cell.chooseClassLabel.tag = 0;
    } else {
//        UILabel *timeLabel = (UILabel *)[cell viewWithTag:1];
        //获取当前时间
        NSDate *senddate = [NSDate date];
        NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"yyyy-MM-dd"];
        NSString *locationString = [dateformatter stringFromDate:senddate];
        cell.chooseClassLabel.text = locationString;
        
        self.calendarButton = (UIButton *)[cell viewWithTag:101];
        [self.calendarButton addTarget:self action:@selector(clickCalendarButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 2 && indexPath.row == 0) {
        if (!self.classinfo) {
            [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"未加入任何班级"];

            return;
        }
        UIActionSheet* sheet=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
        for(int i=0;i<[_classinfo count];i++)
        {
            CheckingForTeachers* cft=[_classinfo objectAtIndex:i];
            NSString *str=cft.classAlias;
            [sheet addButtonWithTitle:str];
        }
        [sheet addButtonWithTitle:@"取消"];
        sheet.cancelButtonIndex=[_classinfo count];
        [sheet showInView:self.view];
    }
}

#pragma mark -- 日历按钮点击响应事件
#pragma mark -- 

- (void)clickCalendarButton:(UIButton *)sender
{
    //点击哪一行？
    CGPoint hitPoint = [sender convertPoint:CGPointZero toView:self.mainTableView];
    NSIndexPath *indexPath = [self.mainTableView indexPathForRowAtPoint:hitPoint];
    //将其保存
    self.selectedIndexPath = indexPath;
    
    NSLog(@"The selected index is:%d----%d", self.selectedIndexPath.section, self.selectedIndexPath.row);

    [self showDateAlertView:103];
}

#pragma mark -- ShowAlertView
#pragma mark -- 
- (void)showDateAlertView:(int)tag
{
    UIDatePicker* myDatePicker = [[UIDatePicker alloc] init];
    myDatePicker.width = SCREENWIDTH - 40;
    myDatePicker.datePickerMode = UIDatePickerModeDate;
    myDatePicker.tag = 102;
    AttendAlertView *alertView = [[AttendAlertView alloc] init];
    alertView.delegate = self;
    alertView.tag = tag;
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"取消",@"确定", nil]];//添加按钮
    [alertView setContainerView:myDatePicker];
    
    [alertView show];
}



#pragma mark -- AttendAlertView_DelegeteMethods
#pragma mark --
- (void)customAttendAlertViewButtonTouchUpInside: (AttendAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView tag]==103) {
        if (buttonIndex == 1) {
            UIDatePicker* datepicker = (UIDatePicker *)[alertView viewWithTag:102];
            ATTStaticsCell *cell = (ATTStaticsCell *)[self.mainTableView cellForRowAtIndexPath:self.selectedIndexPath];
            NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            NSString * dateString = [formatter stringFromDate:[datepicker date]];
            cell.chooseClassLabel.text = dateString;
        }
    }
    
    [alertView close];
}

#pragma mark -- UIActionSheetDelegate
#pragma mark --

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    self.buttonIndex = buttonIndex;
    if (buttonIndex<[_classinfo count]) {
        //获取cell上的label
        NSIndexPath *cellPath = [NSIndexPath indexPathForItem:0 inSection:2];
        ATTStaticsCell *cell = (ATTStaticsCell *)[self.mainTableView cellForRowAtIndexPath:cellPath];
        if (cell) {
//            UILabel *label = (UILabel*)[cell viewWithTag:1];
            CheckingForTeachers* cft = [_classinfo objectAtIndex:buttonIndex];
            cell.chooseClassLabel.text = cft.classAlias;
            cell.chooseClassLabel.tag = 1;
        }
    }
}

#pragma mark -- 查询按钮响应方法
#pragma mark --

- (void)checkRecords
{
    
    // 开始时间
    NSIndexPath *cellPath = [NSIndexPath indexPathForItem:0 inSection:0];
    ATTStaticsCell *cell = (ATTStaticsCell *)[self.mainTableView cellForRowAtIndexPath:cellPath];
    NSString* begintime=cell.chooseClassLabel.text;
    // 截止时间
    cellPath = [NSIndexPath indexPathForItem:0 inSection:1];
    cell = (ATTStaticsCell *)[self.mainTableView cellForRowAtIndexPath:cellPath];
    NSString* endtime=cell.chooseClassLabel.text;
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd"];
    NSDate* b=[dateformatter dateFromString:begintime];
    NSDate* e=[dateformatter dateFromString:endtime];
    
    
    NSTimeInterval secondsInterval= [e timeIntervalSinceDate:b];
    
    if (secondsInterval>=0) {
        
        cellPath = [NSIndexPath indexPathForItem:0 inSection:2];
        cell = (ATTStaticsCell *)[self.mainTableView cellForRowAtIndexPath:cellPath];
//        UILabel *label = (UILabel*)[cell viewWithTag:1];
        NSString* cls=@"请选择班级";
        
        if (cell.chooseClassLabel.tag == 1) {
            cls=cell.chooseClassLabel.text;
        } else {
            [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"请选择班级"];

            return;
        }
        [self.navigationController pushViewController:CardRecordsVCID
                                       withStoryBoard:DeskStoryBoardName
                                            withBlock:^(UIViewController *viewController) {
                                                CardRecordsViewController *VC = (CardRecordsViewController *)viewController;
                                                VC.beginTime = begintime;
                                                VC.endTime = endtime;
                                                
                                                if (self.buttonIndex == 0) {
                                                    if (self.classinfo) {
                                                        CheckingForTeachers *tempCFT = self.classinfo[0];
                                                        VC.classId = tempCFT.ClassId;
//                                                        NSLog(@"%lld",tempCFT.ClassId);
                                                    }
                                                    
                                                } else if (self.buttonIndex == 1){
                                                    if (self.classinfo) {
                                                        CheckingForTeachers *tempCFT = self.classinfo[1];
                                                        VC.classId = tempCFT.ClassId;
//                                                        NSLog(@"%lld",tempCFT.ClassId);
                                                    }
                                                    
                                                } else if (self.buttonIndex == 2){
                                                    if (self.classinfo) {
                                                        CheckingForTeachers *tempCFT = self.classinfo[2];
                                                        VC.classId = tempCFT.ClassId;
                                                    }
                                                    
                                                } else if (self.buttonIndex == 3){
                                                    if (self.classinfo) {
                                                        CheckingForTeachers *tempCFT = self.classinfo[3];
                                                        VC.classId = tempCFT.ClassId;
                                                    }
                                                    
                                                } else if (self.buttonIndex == 4){
                                                    if (self.classinfo) {
                                                        CheckingForTeachers *tempCFT = self.classinfo[4];
                                                        VC.classId = tempCFT.ClassId;
                                                    }
                                                    
                                                } else if (self.buttonIndex == 5){
                                                    if (self.classinfo) {
                                                        CheckingForTeachers *tempCFT = self.classinfo[5];
                                                        VC.classId = tempCFT.ClassId;
                                                    }
                                                    
                                                } else if (self.buttonIndex == 6){
                                                    if (self.classinfo) {
                                                        CheckingForTeachers *tempCFT = self.classinfo[6];
                                                        VC.classId = tempCFT.ClassId;
                                                    }
                                                    
                                                } else if (self.buttonIndex == 7){
                                                    if (self.classinfo) {
                                                        CheckingForTeachers *tempCFT = self.classinfo[7];
                                                        VC.classId = tempCFT.ClassId;
                                                    }
                                                    
                                                } else if (self.buttonIndex == 8){
                                                    if (self.classinfo) {
                                                        CheckingForTeachers *tempCFT = self.classinfo[8];
                                                        VC.classId = tempCFT.ClassId;
                                                    }
                                                    
                                                } else if (self.buttonIndex == 9){
                                                    if (self.classinfo) {
                                                        CheckingForTeachers *tempCFT = self.classinfo[9];
                                                        VC.classId = tempCFT.ClassId;
                                                    }
                                                    
                                                } else if (self.buttonIndex == 10){
                                                    if (self.classinfo) {
                                                        CheckingForTeachers *tempCFT = self.classinfo[10];
                                                        VC.classId = tempCFT.ClassId;
                                                    }
                                                    
                                                } else if (self.buttonIndex == 11){
                                                    if (self.classinfo) {
                                                        CheckingForTeachers *tempCFT = self.classinfo[11];
                                                        VC.classId = tempCFT.ClassId;
                                                    }
                                                    
                                                } else if (self.buttonIndex == 12){
                                                    if (self.classinfo) {
                                                        CheckingForTeachers *tempCFT = self.classinfo[12];
                                                        VC.classId = tempCFT.ClassId;
                                                    }
                                                    
                                                } else if (self.buttonIndex == 13){
                                                    if (self.classinfo) {
                                                        CheckingForTeachers *tempCFT = self.classinfo[13];
                                                        VC.classId = tempCFT.ClassId;
                                                    }
                                                    
                                                } else if (self.buttonIndex == 14){
                                                    if (self.classinfo) {
                                                        CheckingForTeachers *tempCFT = self.classinfo[14];
                                                        VC.classId = tempCFT.ClassId;
                                                    }
                                                    
                                                } else if (self.buttonIndex == 15){
                                                    if (self.classinfo) {
                                                        CheckingForTeachers *tempCFT = self.classinfo[15];
                                                        VC.classId = tempCFT.ClassId;
                                                    }
                                                    
                                                }
                                                
                                            }];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"开始时间早于结束时间" message:@"你确定查询吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
        [alert addButtonWithTitle:@"确定"];
        [alert show];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    self.hidesBottomBarWhenPushed = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.hidesBottomBarWhenPushed = YES;
    [self dismiss];
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
