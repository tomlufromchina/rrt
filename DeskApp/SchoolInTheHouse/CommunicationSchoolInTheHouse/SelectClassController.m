//
//  SelectClassController.m
//  RenrenTong
//
//  Created by aedu on 15/1/30.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "SelectClassController.h"
#import "ClassTableViewCell.h"
#import "SiftStudentController.h"
#import "ClassHeaderView.h"
#import "IWPopMenuView.h"
#import "BaseButton.h"
#import "NetWorkManager+NetworkTool.h"
#import "ClassList.h"
#import "MJExtension.h"
#import "ClassType.h"
#import "SchoolGrade.h"
#import "IWTitleButton.h"


@interface SelectClassController ()<SiftStudentControllerDelegate,ClassHeaderViewDelegate,IWPopMenuViewDelegate>
/**
 *  防重用数组
 */
@property(nonatomic, strong)NSMutableArray *selectArray;
/**
 *  选中的班级数组
 */
@property(nonatomic, strong)NSMutableArray *selectedArray;
/**
 *  数据源数组
 */
@property(nonatomic, strong)NSMutableArray *dataSoures;

/**
 *  所有班级
 */
@property(nonatomic, strong)NSMutableArray *allClass;

/**
 *  所有年级
 */
@property(nonatomic, strong)NSMutableArray *allGrade;

/**
 *  学段数组
 */
@property(nonatomic, strong)NSArray *classTypes;

/**
 *  年级数组
 */
@property(nonatomic, strong)NSArray *schoolGrades;


@property (nonatomic, weak) IWPopMenuView *popView;

@property (nonatomic, weak) UIView *bgView;

/**
 *  选中的标题按钮
 */
@property (nonatomic, weak) IWTitleButton *selectedBtnType;

@property (nonatomic, weak) ClassHeaderView *headerView;

@property (nonatomic, weak) UIButton *certainBtn;
@property (nonatomic, weak) UIButton *selectAllbtn;

@property (nonatomic, strong) NetWorkManager *netWorkManager;

/**
 *  学生是否全选
 */
@property(nonatomic, assign)BOOL IsSeletAll;

/**
 *  学生是否住校
 */
@property(nonatomic, assign)int IsOnCampus;
@end

@implementation SelectClassController

- (NetWorkManager *)netWorkManager
{
    if (!_netWorkManager) {
        _netWorkManager = [[NetWorkManager alloc]init];
    }
    return _netWorkManager;
}
- (NSMutableArray *)dataSoures
{
    if (!_dataSoures) {
        _dataSoures = [NSMutableArray array];
    }
    return _dataSoures;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择班级";
    self.IsSeletAll = NO;
    self.IsOnCampus = -1;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 40, SCREENWIDTH, SCREENHEIGHT - 140)];
    self.mainView = tableView;
    self.mainView.delegate = self;
    self.mainView.dataSource = self;
    [self.view addSubview:tableView];
    [self createFooter];
    

    ClassHeaderView *headerView = [[ClassHeaderView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 40)];
    headerView.delegate = self;
    self.headerView = headerView;
    [self.view addSubview:headerView];
    
    self.selectedArray = [NSMutableArray array];
    self.selectArray = [NSMutableArray array];
    self.allClass = [NSMutableArray array];
    self.classTypes = [NSArray array];
    self.allGrade = [NSMutableArray array];
    self.schoolGrades = [NSArray array];
    [self getTeacherClassList];
    [self getSchoolType];
}

#pragma mark - 获取老师的班级
- (void)getTeacherClassList
{
    [MBProgressHUD showMessage:@"加载中..."];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUD];
    });
    [self.netWorkManager getTeacherClassCount:[RRTManager manager].loginManager.loginInfo.tokenId
                                     teacherId:[RRTManager manager].loginManager.loginInfo.userId
                                       success:^(NSMutableArray *data) {
                                           [self getClassList:data];
                                       } failed:^(NSString *errorMSG) {
                                           [MBProgressHUD hideHUD];
                                           [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:errorMSG];
                                       }];
}
#pragma mark - 获取教师所在学校学段
- (void)getSchoolType
{
    [self.netWorkManager getSchoolType:[RRTManager manager].loginManager.loginInfo.tokenId
                                     teacherId:[RRTManager manager].loginManager.loginInfo.userId
                                       success:^(NSMutableArray *data) {
                                           [self dismiss];
                                           self.classTypes = [ClassType objectArrayWithKeyValuesArray:data];
                                           NSMutableArray *allGrades = [NSMutableArray array];
                                           for (ClassType *classType in self.classTypes) {
                                               for (NSDictionary *dic in classType.GradeData) {
                                                   SchoolGrade *grade = [[SchoolGrade alloc]init];
                                                   grade.GradeId = [dic objectForKey:@"GradeId"];
                                                   grade.GradeName = [dic objectForKey:@"GradeName"];
                                                   grade.ClassType = classType.ClassType;
                                                   [allGrades addObject:grade];
                                               }
                                           }
                                           self.schoolGrades = allGrades;
                                           self.allGrade = allGrades;
                                       } failed:^(NSString *errorMSG) {
                                           [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:errorMSG];
                                       }];
}

- (void)getClassList:(NSMutableArray *)array
{
    if (array) {
        for (int i = 0; i < [array count]; i ++) {
            NSDictionary *classDict = array[i];
            ClassList *classList = [ClassList objectWithKeyValues:classDict];
            [self.dataSoures addObject:classList];
            [self.allClass addObject:classList];
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setValue:@"NO" forKey:@"checked"];
            [self.selectArray addObject:dic];
        }
    }
    [MBProgressHUD hideHUD];
    [self.mainView reloadData];
}
#pragma mark - 底部的View
- (void)createFooter
{
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT - 100, SCREENWIDTH, 50)];
    footerView.backgroundColor = [UIColor colorWithRed:240.0/255 green:236.0/255 blue:236.0/255 alpha:1.0];
    self.footerView = footerView;
    footerView.userInteractionEnabled = YES;
    [self.view addSubview:footerView];
    UIButton *selectAllBtn = [[UIButton alloc]initWithFrame:CGRectMake(5, -5, 50, 50)];
    [selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
    selectAllBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [selectAllBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [selectAllBtn addTarget:self action:@selector(selectAllBtnClick:) forControlEvents:UIControlEventTouchDown];
    selectAllBtn.tag = 101;
    self.selectAllbtn = selectAllBtn;
    [self.footerView addSubview:selectAllBtn];
    
    UIButton *certainBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREENWIDTH / 2 - 40, 3, 80, 30)];
    [certainBtn setTitle:@"确定" forState:UIControlStateNormal];
    certainBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    certainBtn.layer.cornerRadius = 5.0;
    certainBtn.backgroundColor = theLoginButtonColor;
    [certainBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [certainBtn addTarget:self action:@selector(certainBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.certainBtn = certainBtn;
    [self.footerView addSubview:certainBtn];
}

#pragma mark - 全选
- (void)selectAllBtnClick:(UIButton *)btn
{
    [self.selectedArray removeAllObjects];
    if (btn.tag == 101) {
        [btn setTitle:@"取消" forState:UIControlStateNormal];
        for (NSMutableDictionary *dic in self.selectArray) {
            [dic setObject:@"YES" forKey:@"checked"];
        }
        [self.selectedArray addObjectsFromArray:self.dataSoures];
        btn.tag = 102;
    }else if (btn.tag == 102)
    {
        [btn setTitle:@"全选" forState:UIControlStateNormal];
        for (NSMutableDictionary *dic in self.selectArray) {
            [dic setObject:@"NO" forKey:@"checked"];
        }
        btn.tag = 101;
    }
    [self.certainBtn setTitle:[NSString stringWithFormat:@"确定(%d)",self.selectedArray.count] forState:UIControlStateNormal];
    [self.mainView reloadData];
    
}

#pragma mark - 确定
- (void)certainBtnClick:(UIButton *)btn 
{

    [self.navigationController popViewControllerAnimated:YES];
    if ([self.delegate respondsToSelector:@selector(selectStudentArray:IsOnCampus:)]) {
        [self.delegate selectStudentArray:self.selectedArray IsOnCampus:self.IsOnCampus];
    }
}
#pragma mark - 选中的学生
- (void)selectedArray:(NSMutableArray *)array
{
    if ([self.delegate respondsToSelector:@selector(selectStudentArray:IsOnCampus:)]) {
        [self.delegate selectStudentArray:array IsOnCampus:self.IsOnCampus];
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSoures.count;
   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *string = @"ClassCell";
    ClassTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:string];
    if (cell == nil) {
        cell = [[ClassTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:string];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.individualBtn addTarget:self action:@selector(individualBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.individualBtn setTitle:@"个别家长发送" forState:UIControlStateNormal];
    cell.individualBtn.tag = indexPath.row;
    ClassList *classList = self.dataSoures[indexPath.row];
    [cell.selectBtn setTitle:classList.ClassAlias  forState:UIControlStateNormal];
    cell.selectBtn.userInteractionEnabled = NO;
    NSUInteger row = [indexPath row];
    NSMutableDictionary *dic = [self.selectArray objectAtIndex:row];
    if ([[dic objectForKey:@"checked"] isEqualToString:@"NO"]) {
        [dic setObject:@"NO" forKey:@"checked"];
        [cell setChecked:NO];
        
    }else {
        [dic setObject:@"YES" forKey:@"checked"];
        [cell setChecked:YES];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ClassTableViewCell *cell = (ClassTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    NSUInteger row = [indexPath row];
    ClassList *classList = [self.dataSoures objectAtIndex:row];
    NSMutableDictionary *dic = [self.selectArray objectAtIndex:row];
    if ([[dic objectForKey:@"checked"] isEqualToString:@"NO"]) {
        [self.selectedArray addObject:classList];
        [dic setObject:@"YES" forKey:@"checked"];
        [cell setChecked:YES];
    }else {
        for (int i = 0; i < self.selectedArray.count; i++) {
            ClassList *classList = [self.selectedArray objectAtIndex:i];
            if ([classList.ClassAlias isEqualToString:cell.selectBtn.currentTitle]) {
                [self.selectedArray removeObjectAtIndex:i];
            }
        }
        [dic setObject:@"NO" forKey:@"checked"];
        [cell setChecked:NO];        
    }
    [self.certainBtn setTitle:[NSString stringWithFormat:@"确定(%d)",self.selectedArray.count] forState:UIControlStateNormal];
    if(self.selectedArray.count != self.dataSoures.count)
    {
        [self.selectAllbtn setTitle:@"全选" forState:UIControlStateNormal];
        self.selectAllbtn.tag = 101;
    }
}

#pragma mark - 个别成员
- (void)individualBtnClick:(UIButton *)btn;
{
    ClassList *classList = self.dataSoures[btn.tag];
    SiftStudentController *siftVC = [[SiftStudentController alloc]init];
    siftVC.delegate = self;
    siftVC.IsSelectAll = self.IsSeletAll;;
    siftVC.classId = classList.ClassId;
    siftVC.IsOnCampus = self.IsOnCampus;
    [self.navigationController pushViewController:siftVC animated:NO];
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
#pragma mark -ClassHeaderViewDelegate
- (void)didClickButton:(IWTitleButton *)button
{
    self.selectedBtnType = button;
        [self.selectedBtnType setImage:[UIImage imageNamed:@"navigationbar_arrow_up"] forState:UIControlStateNormal];
        UIView *iv = [[UIView alloc] init];
        iv.backgroundColor = [UIColor whiteColor];
        self.bgView = iv;
        CGFloat popH = 0.0;
        if (button.tag == 1) {
            [self addButtonWithName:@"不限"];
            for (ClassType *classType in self.classTypes) {
                [self addButtonWithName:classType.ClassTypeName];
            }
            popH = [self setFrame:self.bgView.subviews.count];
        }
        if (button.tag == 2) {
            [self addButtonWithName:@"不限"];
            for (SchoolGrade *schoolGrade in self.schoolGrades) {
                [self addButtonWithName:schoolGrade.GradeName];
            }
            popH = [self setFrame:self.bgView.subviews.count];
        }
        if (button.tag == 3) {
            [self addButtonWithName:@"不限"];
            [self addButtonWithName:@"住校生"];
            [self addButtonWithName:@"走读生"];
            popH = [self setFrame:self.bgView.subviews.count];
        }
        
        
        IWPopMenuView *popMenuView = [IWPopMenuView popMenuViewWithContentView:iv];
        // 设置代理
        popMenuView.delegate =  self;
        self.popView = popMenuView;
        
        // 3.显示菜单
        CGFloat popW = SCREENWIDTH;
        CGFloat popX = 0;
        CGFloat popY = 104;
        
        [popMenuView showWithRect:CGRectMake(popX, popY, popW, popH)];
        [self.bgView bringSubviewToFront:popMenuView.cover];
}
#pragma mark - 设置弹出按钮的frame
- (CGFloat)setFrame:(int)count
{
    int totalloc = 3;
    int m = count / totalloc;
    int n = count % 3;
    if (n != 0) {
        m = m + 1;
    }
    CGFloat btnWidth = 90;
    CGFloat btnHeight = 30;
    CGFloat margin=(SCREENWIDTH - totalloc * btnWidth)/(totalloc+1);
    CGFloat popH = m * btnHeight + (m + 1) * margin + 10;
    for (int i = 0; i < count; i++) {
        
        int row = i / totalloc;//行号
        int loc = i % totalloc;//列号
        CGFloat btnX = margin + (margin + btnWidth) * loc;
        CGFloat btnY = margin + (margin + btnHeight) * row;
        
        UIButton *btn = self.bgView.subviews[i];
        btn.frame = CGRectMake(btnX, btnY, btnWidth, btnHeight);
    }
    return popH;

}
- (void)addButtonWithName:(NSString *)buttonName
{
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:buttonName forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"timeline_retweet_background_highlighted"] forState:UIControlStateNormal];
    [self.bgView addSubview:button];
    button.tag = self.bgView.subviews.count;
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];

}
- (void)buttonClick:(UIButton *)btn
{
    [self.selectedBtnType setTitle:btn.currentTitle forState:UIControlStateNormal];
    if (btn.tag != 1){
        if(self.selectedBtnType.tag == 1)
        {
            [self.selectedArray removeAllObjects];
        for (UIButton *btn in self.headerView.subviews) {
            if (btn.tag == 2)
                [btn setTitle:@"不限" forState:UIControlStateNormal];
        }
        ClassType *classType = self.classTypes[btn.tag - 2];
            NSMutableArray *array = [NSMutableArray array];
            for (NSDictionary *dic in classType.GradeData) {
                SchoolGrade *grade = [[SchoolGrade alloc]init];
                grade.GradeId = [dic objectForKey:@"GradeId"];
                grade.GradeName = [dic objectForKey:@"GradeName"];
                grade.ClassType = classType.ClassType;
                [array addObject:grade];
            }
            self.schoolGrades = array;
            NSMutableArray *arr = [NSMutableArray array];
            for (ClassList *classList in self.allClass) {
                if ([classList.ClassType intValue] == [classType.ClassType intValue])
                    [arr addObject:classList];
            }
            self.dataSoures = arr;
            [self reData];
        }
        else if (self.selectedBtnType.tag == 2) {
            [self.selectedArray removeAllObjects];
            SchoolGrade *schoolGrade = self.schoolGrades[btn.tag - 2];
            NSMutableArray *arr = [NSMutableArray array];
            for (ClassList *classList in self.allClass) {
                if ([classList.GradeId intValue] == [schoolGrade.GradeId intValue] && [classList.ClassType intValue] == [schoolGrade.ClassType intValue])
                    [arr addObject:classList];
                }
                self.dataSoures = arr;
            [self reData];
            }
        else if (self.selectedBtnType.tag == 3)
        {
            self.IsSeletAll = YES;
            if (btn.tag == 2) {
                //住校生
                self.IsOnCampus = 2;
            }
            else if (btn.tag == 3)
                //走读生
                self.IsOnCampus = 0;
        }
    }
    else if (btn.tag == 1)
    {
        if ( self.selectedBtnType.tag == 3) {
            self.IsSeletAll = NO;
            self.IsOnCampus = -1;
        }
        else if (self.selectedBtnType.tag == 1) {
            [self.selectedArray removeAllObjects];
            self.schoolGrades = self.allGrade;
            self.dataSoures = self.allClass;
            for (UIButton *btn in self.headerView.subviews) {
                if (btn.tag == 2)
                    [btn setTitle:@"不限" forState:UIControlStateNormal];
            }
            [self reData];
        }
        else if (self.selectedBtnType.tag == 2)
        {
            [self.selectedArray removeAllObjects];
            self.dataSoures = self.allClass;
            for (UIButton *btn in self.headerView.subviews) {
                if (btn.tag == 1)
                    [btn setTitle:@"不限" forState:UIControlStateNormal];
            }
            [self reData];
        }
       
    }
    [self.selectedBtnType setImage:[UIImage imageNamed:@"navigationbar_arrow_down"] forState:UIControlStateNormal];
    [self.popView dismiss];
}
- (void)reData
{
    [self.selectArray removeAllObjects];
    for (int i = 0; i < self.dataSoures.count; i++) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:@"NO" forKey:@"checked"];
        [self.selectArray addObject:dic];
    }
    [self.certainBtn setTitle:@"确定" forState:UIControlStateNormal];
    [self.selectAllbtn setTitle:@"全选" forState:UIControlStateNormal];
    self.selectAllbtn.tag = 101;
    [self.mainView reloadData];
}
#pragma mark - IWPopMenuViewDelegate
- (void)popMenuViewDidClick:(IWPopMenuView *)popMenuView
{
    [self.selectedBtnType setImage:[UIImage imageNamed:@"navigationbar_arrow_down"] forState:UIControlStateNormal];
}

@end
