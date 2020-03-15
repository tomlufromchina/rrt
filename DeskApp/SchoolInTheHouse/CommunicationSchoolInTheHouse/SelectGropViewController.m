//
//  SelectGropViewController.m
//  RenrenTong
//
//  Created by aedu on 15/1/30.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "SelectGropViewController.h"
#import "ClassTableViewCell.h"
#import "SiftGroupController.h"
#import "GroupHeaderView.h"
#import "IWPopMenuView.h"
#import "IWTitleButton.h"
#import "BaseButton.h"
#import "TeacherHeaderView.h"
#import "MJExtension.h"
#import "NetWorkManager+NetworkTool.h"
#import "GroupList.h"

@interface SelectGropViewController ()<SiftGroupControllerDelegate,IWPopMenuViewDelegate,TeacherHeaderViewDelegate>
/**
 *  防重用数组
 */
@property(nonatomic, strong)NSMutableArray *selectArray;
/**
 *  选中的老师数组
 */
@property(nonatomic, strong)NSMutableArray *selectedArray;
/**
 *  数据源数组
 */
@property(nonatomic, strong)NSMutableArray *dataSoures;
/**
 *  教师群组
 */
@property(nonatomic, strong)NSMutableArray *teacherGroups;
/**
 *  学生群组
 */
@property(nonatomic, strong)NSMutableArray *studentGroups;
/**
 *  所有群组
 */
@property(nonatomic, strong)NSMutableArray *allGroups;

@property (nonatomic, weak) IWPopMenuView *popView;

@property (nonatomic, weak) UIView *bgView;

@property (nonatomic, weak) UIButton *selectedBtnType;

@property (nonatomic, weak) TeacherHeaderView *headerView;

@property (nonatomic, weak) UIButton *certainBtn;
@property (nonatomic, weak) UIButton *selectAllbtn;
@property (nonatomic, strong) NetWorkManager *netWorkManager;
@property (nonatomic, assign) int states;
@end

@implementation SelectGropViewController

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
- (NSMutableArray *)allGroups
{
    if (!_allGroups) {
        _allGroups = [NSMutableArray array];
    }
    return _allGroups;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择群组";
    
    self.edgesForExtendedLayout = UIRectEdgeNone;


//    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
//    backItem.title = @"";
//    [self.navigationItem setBackBarButtonItem:backItem];
    
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 40, SCREENWIDTH, SCREENHEIGHT - 140)];
    self.mainView = tableView;
    self.mainView.delegate = self;
    self.mainView.dataSource = self;
    [self.view addSubview:tableView];
    
    TeacherHeaderView *headerView = [[TeacherHeaderView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 40)];
    headerView.delegate = self;
    for (int i = 0; i < 2; i++) {
        UIButton *button = headerView.subviews[i];
        if (i == 0) {
            [button setTitle:@"教师群组" forState:UIControlStateNormal];
        }
        if (i == 1) {
            [button setTitle:@"学生群组" forState:UIControlStateNormal];
        }
    }
    self.states = 1;
    self.headerView = headerView;
    [self.view addSubview:headerView];
    
    [self createFooter];
    self.selectedArray = [NSMutableArray array];
    self.selectArray = [NSMutableArray array];
    [self getTeacherGroup];
}

#pragma mark - 获取老师的创建的群组
- (void)getTeacherGroup
{
    [MBProgressHUD showMessage:@"加载中..."];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUD];
    });
    [self.netWorkManager getTeacherGroups: [RRTManager manager].loginManager.loginInfo.tokenId
                teacherId:[RRTManager manager].loginManager.loginInfo.userId 
                        success:^(NSMutableArray *data) {
                            self.allGroups = (NSMutableArray *)[GroupList objectArrayWithKeyValuesArray:data];
                            [self processingData];

                                       } failed:^(NSString *errorMSG) {
                                           [MBProgressHUD hideHUD];
                                           [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:errorMSG];
                                       }];
}

#pragma mark - 处理数据
- (void)processingData
{
    NSMutableArray *teacherGroups = [NSMutableArray array];
    NSMutableArray *studentGroups = [NSMutableArray array];
    for (GroupList *group in self.allGroups) {
        if (group.GroupType == 1) {
            [studentGroups addObject:group];
        }
        else if (group.GroupType == 3)
        {
            [teacherGroups addObject:group];
        }
        
    }
    self.teacherGroups = teacherGroups;
    self.studentGroups = studentGroups;
    self.dataSoures = teacherGroups;
    for (int i = 0; i < self.dataSoures.count; i++) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:@"NO" forKey:@"checked"];
        [self.selectArray addObject:dic];
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
    if ([self.delegate respondsToSelector:@selector(selectGroupArray:states:)]) {
        [self.delegate selectGroupArray:self.selectedArray states:self.states];
    }
}
#pragma mark - 选中的群组成员
- (void)selectedArray:(NSMutableArray *)array
{
    if ([self.delegate respondsToSelector:@selector(selectGroupArray:states:)]) {
        [self.delegate selectGroupArray:array states:self.states];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSoures.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *string = @"ClassCell";
    ClassTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:string];
    if (cell == nil) {
        cell = [[ClassTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:string];
    }
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    [cell.individualBtn addTarget:self action:@selector(individualBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.individualBtn setTitle:@"个别成员发送" forState:UIControlStateNormal];
    cell.individualBtn.tag = indexPath.row;
    GroupList *group = self.dataSoures[indexPath.row];
    [cell.selectBtn setTitle:group.GroupName forState:UIControlStateNormal];
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ClassTableViewCell *cell = (ClassTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    NSUInteger row = [indexPath row];
    GroupList *group = self.dataSoures[row];
    NSMutableDictionary *dic = [self.selectArray objectAtIndex:row];
    if ([[dic objectForKey:@"checked"] isEqualToString:@"NO"]) {
        [self.selectedArray addObject:group];
        [dic setObject:@"YES" forKey:@"checked"];
        [cell setChecked:YES];
    }else {
        for (int i = 0; i < self.selectedArray.count; i++) {
            GroupList *group = [self.selectedArray objectAtIndex:i];
            if ([group.GroupName isEqualToString:cell.selectBtn.currentTitle]) {
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
- (void)individualBtnClick:(UIButton *)btn
{
    GroupList *group = self.dataSoures[btn.tag];
    SiftGroupController *siftVC = [[SiftGroupController alloc]init];
    siftVC.delegate = self;
    siftVC.groupId = group.GroupId;
    [self.navigationController pushViewController:siftVC animated:NO];
    
}
#pragma mark - TeacherHeaderViewDelegate
- (void)didClickButton:(IWTitleButton *)button
{
    if (button.tag == 1) {
        self.dataSoures = self.teacherGroups;
        self.states = 1;
    }else if (button.tag == 2)
    {
        self.states = 2;
        self.dataSoures = self.studentGroups;
    }
    [self.selectArray removeAllObjects];
    for (int i = 0; i < self.dataSoures.count; i++) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:@"NO" forKey:@"checked"];
        [self.selectArray addObject:dic];
    }
    [self.selectedArray removeAllObjects];
    [self.certainBtn setTitle:@"确定" forState:UIControlStateNormal];
    [self.selectAllbtn setTitle:@"全选" forState:UIControlStateNormal];
    self.selectAllbtn.tag = 101;
    [self.mainView reloadData];
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
