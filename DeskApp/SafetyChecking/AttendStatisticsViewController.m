//
//  AttendStatisticsViewController.m
//  RenrenTong
//
//  Created by 唐彬 on 14-9-26.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "AttendStatisticsViewController.h"

@interface AttendStatisticsViewController ()
@property (nonatomic, assign) NSInteger buttonIdenx;
@end
//考勤统计
@implementation AttendStatisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                                         style:UIBarButtonItemStylePlain
                                                                                        target:nil
                                                                                        action:nil];
    [self.navigationItem setBackBarButtonItem:backItem];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"查询"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(search)];
    
    self.navigationItem.rightBarButtonItem = rightItem;
    self.title=@"考勤统计";
    
    self.tabview.delegate = self;
    self.tabview.dataSource = self;
    [self.tabview setSeparatorColor:appColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)search{
    
    
    //获取cell上的label
    NSIndexPath *cellPath = [NSIndexPath indexPathForItem:0 inSection:0];
    AttendsvCell *cell = (AttendsvCell*)[self.tabview cellForRowAtIndexPath:cellPath];
    NSString* begintime=cell.timelable.text;
    
     cellPath = [NSIndexPath indexPathForItem:0 inSection:1];
    cell = (AttendsvCell*)[self.tabview cellForRowAtIndexPath:cellPath];
    NSString* endtime=cell.timelable.text;
    
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd"];

    NSDate* b=[dateformatter dateFromString:begintime];
    NSDate* e=[dateformatter dateFromString:endtime];
    
    
    NSTimeInterval secondsInterval= [e timeIntervalSinceDate:b];
    
    if (secondsInterval>=0) {
        cellPath = [NSIndexPath indexPathForItem:0 inSection:2];
        cell = (AttendsvCell*)[self.tabview cellForRowAtIndexPath:cellPath];
        NSString* cls=@"请选择班级";
        if (cell.timelable.tag==1) {
            cls=cell.timelable.text;
        }else{
            [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:cls];

            return;
        }
        
        cellPath = [NSIndexPath indexPathForItem:0 inSection:3];
        cell = (AttendsvCell*)[self.tabview cellForRowAtIndexPath:cellPath];
        int UserType=0;
        if (cell.zxbtn.tag==1) {
            UserType=1;
        }else if (cell.zdbtn.tag == 1){
            UserType=2;
        } else if (cell.allButton.tag == 1){
            UserType = 0;
        }
        AttendStatisticsRSViewController* asrsvc=[[AttendStatisticsRSViewController alloc] init];
        asrsvc.begintime=begintime;
        asrsvc.endtime=endtime;
        asrsvc.UserType=UserType;        
        if (self.buttonIdenx == 0) {
            if (self.classinfo) {
                CheckingForTeachers *tempCFT = self.classinfo[0];
                asrsvc.classid = tempCFT.ClassId;
                NSLog(@"%lld",tempCFT.ClassId);
            }
            
        } else if (self.buttonIdenx == 1){
            if (self.classinfo) {
                CheckingForTeachers *tempCFT = self.classinfo[1];
                asrsvc.classid = tempCFT.ClassId;
                NSLog(@"%lld",tempCFT.ClassId);
            }
            
        } else if (self.buttonIdenx == 2){
            if (self.classinfo) {
                CheckingForTeachers *tempCFT = self.classinfo[2];
                asrsvc.classid = tempCFT.ClassId;
            }
            
        } else if (self.buttonIdenx == 3){
            if (self.classinfo) {
                CheckingForTeachers *tempCFT = self.classinfo[3];
                asrsvc.classid = tempCFT.ClassId;
            }
            
        } else if (self.buttonIdenx == 4){
            if (self.classinfo) {
                CheckingForTeachers *tempCFT = self.classinfo[4];
                asrsvc.classid = tempCFT.ClassId;
            }
            
        } else if (self.buttonIdenx == 5){
            if (self.classinfo) {
                CheckingForTeachers *tempCFT = self.classinfo[5];
                asrsvc.classid = tempCFT.ClassId;
            }
            
        } else if (self.buttonIdenx == 6){
            if (self.classinfo) {
                CheckingForTeachers *tempCFT = self.classinfo[6];
                asrsvc.classid = tempCFT.ClassId;
            }
            
        } else if (self.buttonIdenx == 7){
            if (self.classinfo) {
                CheckingForTeachers *tempCFT = self.classinfo[7];
                asrsvc.classid = tempCFT.ClassId;
            }
            
        } else if (self.buttonIdenx == 8){
            if (self.classinfo) {
                CheckingForTeachers *tempCFT = self.classinfo[8];
                asrsvc.classid = tempCFT.ClassId;
            }
            
        } else if (self.buttonIdenx == 9){
            if (self.classinfo) {
                CheckingForTeachers *tempCFT = self.classinfo[9];
                asrsvc.classid = tempCFT.ClassId;
            }
            
        } else if (self.buttonIdenx == 10){
            if (self.classinfo) {
                CheckingForTeachers *tempCFT = self.classinfo[10];
                asrsvc.classid = tempCFT.ClassId;
            }
            
        } else if (self.buttonIdenx == 11){
            if (self.classinfo) {
                CheckingForTeachers *tempCFT = self.classinfo[11];
                asrsvc.classid = tempCFT.ClassId;
            }
            
        } else if (self.buttonIdenx == 12){
            if (self.classinfo) {
                CheckingForTeachers *tempCFT = self.classinfo[12];
                asrsvc.classid = tempCFT.ClassId;
            }
            
        } else if (self.buttonIdenx == 13){
            if (self.classinfo) {
                CheckingForTeachers *tempCFT = self.classinfo[13];
                asrsvc.classid = tempCFT.ClassId;
            }
            
        } else if (self.buttonIdenx == 14){
            if (self.classinfo) {
                CheckingForTeachers *tempCFT = self.classinfo[14];
                asrsvc.classid = tempCFT.ClassId;
            }
            
        } else if (self.buttonIdenx == 15){
            if (self.classinfo) {
                CheckingForTeachers *tempCFT = self.classinfo[15];
                asrsvc.classid = tempCFT.ClassId;
            }
            
        }
        asrsvc.cls=cls;
        [self.navigationController pushViewController:asrsvc animated:YES];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"开始时间早于结束时间" message:@"你确定查询吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
        [alert addButtonWithTitle:@"确定"];
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        NSIndexPath *cellPath = [NSIndexPath indexPathForItem:0 inSection:0];
        AttendsvCell *cell = (AttendsvCell*)[self.tabview cellForRowAtIndexPath:cellPath];
        NSString* begintime=cell.timelable.text;
        
        cellPath = [NSIndexPath indexPathForItem:0 inSection:1];
        cell = (AttendsvCell*)[self.tabview cellForRowAtIndexPath:cellPath];
        NSString* endtime=cell.timelable.text;
        
        cellPath = [NSIndexPath indexPathForItem:0 inSection:2];
        cell = (AttendsvCell*)[self.tabview cellForRowAtIndexPath:cellPath];
        NSString* cls=@"请选择班级";
        if (cell.timelable.tag==1) {
            cls=cell.timelable.text;
        }else{
            [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:cls];

            return;
        }
        
        cellPath = [NSIndexPath indexPathForItem:0 inSection:3];
        cell = (AttendsvCell*)[self.tabview cellForRowAtIndexPath:cellPath];
        int UserType=0;
        if (cell.zxbtn.tag==1) {
            UserType=1;
        }else{
            UserType=2;
        }
        AttendStatisticsRSViewController* asrsvc=[[AttendStatisticsRSViewController alloc] init];
        asrsvc.begintime=begintime;
        asrsvc.endtime=endtime;
        asrsvc.UserType=UserType;
        asrsvc.classid=classid;
        asrsvc.cls=cls;
        [self.navigationController pushViewController:asrsvc animated:YES];
    }
}

- (void)showDateAlertWithTag:(int)tag {
    UIDatePicker* datepicker=[[UIDatePicker alloc] init];
    datepicker.width=SCREENWIDTH-40;
    datepicker.datePickerMode=UIDatePickerModeDate;
    datepicker.tag=2013;
    AttendAlertView* alertView=[[AttendAlertView alloc] init];
    alertView.delegate=self;
    alertView.tag=tag;
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"取消",@"确定", nil]];//添加按钮
    [alertView setContainerView:datepicker];
    [alertView show];

}

// Default button behaviour
- (void)customAttendAlertViewButtonTouchUpInside: (AttendAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        int tag=(int)[alertView tag];
        UIDatePicker* datepicker =(UIDatePicker*)[alertView viewWithTag:2013];
        NSDate* date=[datepicker date];
        AttendsvCell *cell=nil;
        if (tag==888) {
            //获取cell上的label
            NSIndexPath *cellPath = [NSIndexPath indexPathForItem:0 inSection:0];
            cell = (AttendsvCell*)[self.tabview cellForRowAtIndexPath:cellPath];
            
        }else if(tag==8888){
            //获取cell上的label
            NSIndexPath *cellPath = [NSIndexPath indexPathForItem:0 inSection:1];
            cell = (AttendsvCell*)[self.tabview cellForRowAtIndexPath:cellPath];
            
        }
        if (cell) {
            NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
            [dateformatter setDateFormat:@"yyyy-MM-dd"];
            NSString *locationString = [dateformatter stringFromDate:date];
            cell.timelable.text = locationString;
        }
    }
    [alertView close];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 50;
    }else{
        return 30;
    }
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
        case 3:
            return 1;
        default:
            return 0;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"开始时间";
            break;
        case 1:
            return @"截止时间";
            break;
        case 2:
            return @"选择班级";
            break;
        case 3:
            return @"统计范围";
            break;
            
        default:
            return @"";
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //指定cellIdentifier为自定义的cell
    static NSString *CellIdentifier = @"attsvCell";
    //自定义cell类
    AttendsvCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        //通过xib的名称加载自定义的cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"AttendsvCell" owner:self options:nil] lastObject];
    }
    
    cell.timelable.tag=0;
    if (indexPath.section==0||indexPath.section==1) {
        cell.riliimg.hidden=NO;
        cell.zxbtn.hidden=YES;
        cell.zxlable.hidden=YES;
        cell.zdbtn.hidden=YES;
        cell.allButton.hidden = YES;
        cell.zdlable.hidden=YES;
        cell.allLabel.hidden = YES;
        cell.timelable.hidden=NO;
        NSDate *senddate = [NSDate date];
        NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"yyyy-MM-dd"];
        NSString *locationString = [dateformatter stringFromDate:senddate];
        cell.timelable.text = locationString;
    }else{
        cell.riliimg.hidden=YES;
        if (indexPath.section==2) {
            cell.zxbtn.hidden=YES;
            cell.zxlable.hidden=YES;
            cell.allLabel.hidden = YES;
            cell.zdbtn.hidden=YES;
            cell.zdlable.hidden=YES;
            cell.timelable.hidden=NO;
            cell.allButton.hidden = YES;
        }else if(indexPath.section==3){
            
            cell.zxbtn.hidden=NO;
            cell.zxlable.hidden=NO;
            cell.zdbtn.hidden=NO;
            cell.zdlable.hidden=NO;
            cell.allButton.hidden = NO;
            cell.timelable.hidden=YES;
        }
    }
    return cell;

}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==0) {
        [self showDateAlertWithTag:888];
    }
    if (indexPath.section==1) {
        [self showDateAlertWithTag:8888];
    }
    if (indexPath.section==2) {
        
        if (!self.classinfo) {
            [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"未加入任何班级"];

            
            return;
        }
        UIActionSheet* sheet=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
        
        for(int i=0;i<[_classinfo count];i++)
        {
            CheckingForTeachers* cft=[_classinfo objectAtIndex:i];
            NSString *str=cft.classAlias;
            classid = cft.ClassId;
            [sheet addButtonWithTitle:str];
        }
        [sheet addButtonWithTitle:@"取消"];
        sheet.cancelButtonIndex=[_classinfo count];
        [sheet showInView:self.view];
    }
}



#pragma mark -- UIActionSheetDelegate
#pragma mark --

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    self.buttonIdenx = buttonIndex;
    if (buttonIndex<[_classinfo count]) {
        //获取cell上的label
        NSIndexPath *cellPath = [NSIndexPath indexPathForItem:0 inSection:2];
        AttendsvCell *cell = (AttendsvCell*)[self.tabview cellForRowAtIndexPath:cellPath];
        if (cell) {
            CheckingForTeachers* cft=[_classinfo objectAtIndex:buttonIndex];
            cell.timelable.text=cft.classAlias;
            cell.timelable.tag=1;
        }
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

@end
