//
//  SelectTeacherViewController.m
//  RenrenTong
//
//  Created by aedu on 15/1/30.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "SelectTeacherViewController.h"
#import "ClassTableViewCell.h"
#import "SifeTeacherController.h"
#import "BaseButton.h"
#import "TeacherHeaderView.h"
#import "MJExtension.h"
#import "NetWorkManager+NetworkTool.h"
#import "TeacherGroup.h"
#import "TeacherList.h"

@interface SelectTeacherViewController ()<SifeTeacherControllerDelegate,TeacherHeaderViewDelegate>
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
 *  教师角色
 */
@property(nonatomic, strong)NSMutableArray *teacherGroups;
/**
 *  所有教师
 */
@property(nonatomic, strong)NSMutableArray *allTeachers;

/**
 *  所有教师组别
 */
@property(nonatomic, strong)NSMutableArray *allGroups;
@property (nonatomic, weak) UIButton *selectedBtnType;
@property (nonatomic, weak) UIButton *certainBtn;
@property (nonatomic, weak) UIButton *selectAllbtn;
@property (nonatomic, weak) UIImageView *noImage;
@property (nonatomic, strong) NetWorkManager *netWorkManager;

@end

@implementation SelectTeacherViewController
- (NSMutableArray *)dataSoures
{
    if (!_dataSoures) {
        _dataSoures = [NSMutableArray array];
    }
    return _dataSoures;
}
- (NetWorkManager *)netWorkManager
{
    if (!_netWorkManager) {
        _netWorkManager = [[NetWorkManager alloc]init];
    }
    return _netWorkManager;
}
- (NSMutableArray *)allTeachers
{
    if (!_allTeachers) {
        _allTeachers = [NSMutableArray array];
    }
    return _allTeachers;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择教师";
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
//    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
//    backItem.title = @"";
//    [self.navigationItem setBackBarButtonItem:backItem];
    
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - 100)];
    self.mainView = tableView;
    self.mainView.delegate = self;
    self.mainView.dataSource = self;
    [self.view addSubview:tableView];
    
    
    self.selectedArray = [NSMutableArray array];
    self.selectArray = [NSMutableArray array];
    [self createFooter];
    [self processingData];
    [self getTeachers];

}

#pragma mark - 获取教师成员列表
- (void)getTeachers
{
    [self.netWorkManager getTeacherLists:[RRTManager manager].loginManager.loginInfo.tokenId teacherId:[RRTManager manager].loginManager.loginInfo.userId
                                 success:^(NSMutableArray *data) {
                                     [self processingTeacherData:data];
                                 }
                                  failed:^(NSString *errorMSG) {
//                        [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:errorMSG];
                                  }];
}

- (void)processingTeacherData:(NSMutableArray *)data
{
    /**
     *  校领导组别
     */
    NSMutableArray *teachers1 = [NSMutableArray array];
    /**
     *  年级主任组别
     */
    NSMutableArray *teachers2 = [NSMutableArray array];
    /**
     *  班主任组别
     */
    NSMutableArray *teachers3 = [NSMutableArray array];
    /**
     *  科任教师教师组别
     */
    NSMutableArray *teachers4 = [NSMutableArray array];
    self.allTeachers = (NSMutableArray *)[TeacherList objectArrayWithKeyValuesArray:data];
    for (TeacherList *teacher in self.allTeachers) {
        if (teacher.TeacherRole == 6) {
            [teachers1 addObject:teacher];
        }
        else if (teacher.TeacherRole == 5)
        {
            [teachers2 addObject:teacher];
        }
        else if (teacher.TeacherRole == 4)
        {
            [teachers3 addObject:teacher];
        }
        else if (teacher.TeacherRole == 3)
        {
            [teachers4 addObject:teacher];
        }
    }
    self.allGroups = [NSMutableArray arrayWithObjects:teachers1,teachers2,teachers3,teachers4, nil];
}
#pragma mark - 处理数据
- (void)processingData
{
    NSMutableArray *teacherGroups = [NSMutableArray array];
    [teacherGroups addObject:[TeacherGroup teacherWithName:@"校领导" groupTpye:3]];
    [teacherGroups addObject:[TeacherGroup teacherWithName:@"年级主任" groupTpye:2]];
    [teacherGroups addObject:[TeacherGroup teacherWithName:@"班主任" groupTpye:1]];
    [teacherGroups addObject:[TeacherGroup teacherWithName:@"科任教师" groupTpye:0]];

    self.teacherGroups = teacherGroups;
    self.dataSoures = self.teacherGroups;
    for (int i = 0; i < self.dataSoures.count; i++) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:@"NO" forKey:@"checked"];
        [self.selectArray addObject:dic];
    }
    
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
    NSMutableArray *arr = [NSMutableArray array];
    for (TeacherGroup *group in self.selectedArray) {
        for (TeacherList *teacher in self.allTeachers) {
            if (teacher.TeacherRole == group.GroupType && teacher.UserService == 0) {
                [arr addObject:teacher];
            }
        }
    }
    if ([self.delegate respondsToSelector:@selector(selectTeacherArray:)]) {
        [self.delegate selectTeacherArray:arr];
    }
}
#pragma mark - 选中的老师
- (void)selectedArray:(NSMutableArray *)array
{
    if ([self.delegate respondsToSelector:@selector(selectTeacherArray:)]) {
        [self.delegate selectTeacherArray:array];
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
    TeacherGroup *group = self.dataSoures[indexPath.row];
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
    TeacherGroup *group = self.dataSoures[row];
    NSMutableDictionary *dic = [self.selectArray objectAtIndex:row];
    if ([[dic objectForKey:@"checked"] isEqualToString:@"NO"]) {
        [self.selectedArray addObject:group];
        [dic setObject:@"YES" forKey:@"checked"];
        [cell setChecked:YES];
    }else {
        for (int i = 0; i < self.selectedArray.count; i++) {
            TeacherGroup *group = [self.selectedArray objectAtIndex:i];
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
    SifeTeacherController *siftVC = [[SifeTeacherController alloc]init];
    siftVC.delegate = self;
    siftVC.datasoures = self.allGroups[btn.tag];
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
@end
