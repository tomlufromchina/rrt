//
//  TeacherAttendViewController.m
//  RenrenTong
//
//  Created by 唐彬 on 14-9-26.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "TeacherAttendViewController.h"
#import "TodayAttendanceViewController.h"
#import "ATTStatisticsViewController.h"
#import "AttendanceRecordViewController.h"
#import "NetWorkManager+Attend.h"

@interface TeacherAttendViewController (){
    NSMutableArray*  ClassInfo;
}
@property (nonatomic, strong) NetWorkManager *netWorkManger;
@property (nonatomic, strong) CheckingForTeachers *CFT;
@property (nonatomic, strong) TodayAttendance *TA;

@end

@implementation TeacherAttendViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                                         style:UIBarButtonItemStylePlain
                                                                                        target:nil
                                                                                        action:nil];
    [self.navigationItem setBackBarButtonItem:backItem];
    
    
    
    self.scrollview.contentSize=CGSizeMake(SCREENWIDTH, self.icond4.bottom);
    self.netWorkManger = [[NetWorkManager alloc] init];
    NSUserDefaults* nud = [NSUserDefaults standardUserDefaults];
//    [nud setBool:NO forKey:[NSString stringWithFormat:@"%@issettingid",[RRTManager manager].loginManager.loginInfo.userId]];  // 清除存储。。。
    //判断的标示
    BOOL issettingid=[nud boolForKey:[NSString stringWithFormat:@"%@issettingid",[RRTManager manager].loginManager.loginInfo.userId]];
    if (issettingid) {
        [self issettinged];
    }else{
        [self requestData];
    }
}
#pragma mark -- AeduSettingDelegate

- (void)issettinged{
    NSUserDefaults* nud=[NSUserDefaults standardUserDefaults];
    
    BOOL issettingid=[nud boolForKey:[NSString stringWithFormat:@"%@issettingid",[RRTManager manager].loginManager.loginInfo.userId]];
    if (issettingid) {
        //取数据
        NSMutableDictionary* dic=[nud objectForKey:[NSString stringWithFormat:@"%@issettingclassinfo",[RRTManager manager].loginManager.loginInfo.userId]];
        if (dic) {
            CheckingForTeachers *tempCFT=[[CheckingForTeachers alloc] init];
            tempCFT.ClassId=[[dic objectForKey:@"ClassId"] longLongValue];
            tempCFT.gradeId=[[dic objectForKey:@"gradeId"] intValue];
            tempCFT.schoolId=[[dic objectForKey:@"schoolId"] intValue];
            tempCFT.studentCount=[[dic objectForKey:@"studentCount"] intValue];
            tempCFT.memberCount=[[dic objectForKey:@"memberCount"] intValue];
            tempCFT.classType=[[dic objectForKey:@"classType"] intValue];
            tempCFT.masterAccount=[[dic objectForKey:@"masterAccount"] intValue];
            tempCFT.classSubjectType=[[dic objectForKey:@"classSubjectType"] intValue];
            tempCFT.statusId=[[dic objectForKey:@"statusId"] intValue];
            tempCFT.masterId=[[dic objectForKey:@"masterId"] intValue];
            tempCFT.className=[dic objectForKey:@"className"];
            tempCFT.classAlias=[dic objectForKey:@"classAlias"];
            tempCFT.classLayer=[dic objectForKey:@"classLayer"];
            NSMutableArray* classinfo=[[NSMutableArray alloc] init];
            [classinfo addObject:tempCFT];
            ClassInfo=classinfo;
            self.CFT = tempCFT;
            self.classtitle.text = self.CFT.classAlias;
            
            NSInteger CDInteger = [nud integerForKey:@"CDInteger"];
            self.bdd1.text = [NSString stringWithFormat:@"%d",CDInteger];
            
            NSInteger WSKInteger = [nud integerForKey:@"WSKInteger"];
            self.bdd2.text = [NSString stringWithFormat:@"%d",WSKInteger];
            
            NSInteger ZTInteger = [nud integerForKey:@"ZTInteger"];
            self.bdd3.text = [NSString stringWithFormat:@"%d",ZTInteger];

//            [self requestData];
        }

    }
}

#pragma mark -- 解析数据
#pragma mark --
- (void)requestData
{
    [self show];
    [self.netWorkManger getCheckingOfTearchs:[RRTManager manager].loginManager.loginInfo.tokenId
                                   teacherId:[RRTManager manager].loginManager.loginInfo.userId
                                     success:^(NSMutableArray *data) {
                                         [self dismiss];
                                         [self gotoUpdataUI:data];
                                         
                                     } failed:^(NSString *errorMSG) {
                                         [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:errorMSG];
                                         
                                     }];
    //获取当前时间
    NSDate *senddate=[NSDate date];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd"];
    NSString *locationString=[dateformatter stringFromDate:senddate];
    
    [self.netWorkManger todayAttendance:[RRTManager manager].loginManager.loginInfo.userId
                                 mydate:locationString
                                success:^(NSMutableArray *data) {
                                    [self dismiss];
                                    [self UpdataUI:data];
                                } failed:^(NSString *errorMSG) {
                                    [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:errorMSG];
                                }];
}

#pragma mark -- 刷新界面
#pragma mark --
- (void)gotoUpdataUI:(NSMutableArray *)array
{
    if (array && [array count] > 0) {
        
        ClassInfo=array;
        if (!self.CFT) {
            self.CFT = array[0];// 默认第一个班级(取的是第一个班级)
        }
        
        self.classtitle.text = self.CFT.classAlias;

    }

}

#pragma mark -- 今日考勤响应
#pragma mark --
- (IBAction)clickTodayButton:(UIButton *)sender
{
    [self.navigationController pushViewController:TodayAttendanceVCID
                                   withStoryBoard:DeskStoryBoardName
                                        withBlock:^(UIViewController *viewController) {
        TodayAttendanceViewController *VC = (TodayAttendanceViewController *)viewController;
        VC.teacherId = self.CFT.masterId;
    }];
    
}

#pragma mark -- 考勤统计响应
#pragma mark --
- (IBAction)clickStatisticsButton:(UIButton *)sender
{
    AttendStatisticsViewController* asvc=[[AttendStatisticsViewController alloc] init];
    if (ClassInfo) {
        asvc.classinfo=ClassInfo;
        NSLog(@"%@",asvc.classinfo);
    }
    [self.navigationController pushViewController:asvc animated:YES];
}


#pragma mark -- 刷卡记录响应
#pragma mark --
- (IBAction)clickRecordButton:(UIButton *)sender
{
    [self.navigationController pushViewController:ATTStatisticsVCID
                                   withStoryBoard:DeskStoryBoardName
                                        withBlock:^(UIViewController *viewController) {
        ATTStatisticsViewController *VC = (ATTStatisticsViewController *)viewController;
        VC.CLId = self.CFT.ClassId;
        VC.classinfo = ClassInfo;
    }];
}
#pragma mark -- 设置响应
#pragma mark --
- (IBAction)clickSettingButton:(UIButton *)sender
{
    [self.navigationController pushViewController:SettingVCID withStoryBoard:DeskStoryBoardName withBlock:^(UIViewController *viewController) {
        SettingViewController *VC = (SettingViewController *)viewController;
        VC.delegate=self;
        VC.classinfo = ClassInfo;
        
    }];
}

#pragma mark -- 头部按钮响应
#pragma mark -- 
- (IBAction)headerButton:(UIButton *)sender {
    [self.navigationController pushViewController:AttendanceRecordVCID withStoryBoard:DeskStoryBoardName withBlock:^(UIViewController *viewController) {
        AttendanceRecordViewController *VC = (AttendanceRecordViewController *)viewController;
        VC.titleName = self.classtitle.text;
        VC.todayData = self.TA.mydate;
        
        NSUserDefaults* nud = [NSUserDefaults standardUserDefaults];
        
        //判断的标示
        BOOL issettingid=[nud boolForKey:[NSString stringWithFormat:@"%@issettingid",[RRTManager manager].loginManager.loginInfo.userId]];
        /* 判断是否被设置过了 设置过就去设置的班级Id 没设置过取第一个班级id */
        if (issettingid) {
            //取数据
            NSMutableDictionary* dic=[nud objectForKey:[NSString stringWithFormat:@"%@issettingclassinfo",[RRTManager manager].loginManager.loginInfo.userId]];
            if (dic) {
                CheckingForTeachers *tempCFT=[[CheckingForTeachers alloc] init];
                tempCFT.ClassId=[[dic objectForKey:@"ClassId"] longLongValue];
                
                VC.lassId = tempCFT.ClassId;
//                NSLog(@"%lld",VC.lassId);
            }
            
        }else{
            VC.lassId = self.TA.ClassId;// 默认的班级
//            NSLog(@"%lld",VC.lassId);
        }
    }];
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

#pragma mark -- 获取早退 迟到 未刷卡的 数量 接口
#pragma mark --
- (void)viewWillAppear:(BOOL)animated
{
    
    
}

- (void)UpdataUI:(NSMutableArray *)array
{
    if (array) {
        
        self.TA = array[0];// 取的是第一个数据
        self.bdd1.text = [NSString stringWithFormat:@"%d",self.TA.cidaoNum];
        self.bdd2.text = [NSString stringWithFormat:@"%d",self.TA.noRecordNum];
        self.bdd3.text = [NSString stringWithFormat:@"%d",self.TA.zaotuiNum];
    }
}



@end
