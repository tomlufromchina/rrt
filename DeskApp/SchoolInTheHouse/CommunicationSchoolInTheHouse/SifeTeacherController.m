//
//  SiftStudentController.m
//  RenrenTong
//
//  Created by aedu on 15/1/31.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "SifeTeacherController.h"
#import "CollectionHeaderView.h"
#import "StudentCollectionViewCell.h"
#import "BaseButton.h"
#import "MJExtension.h"
#import "TeacherList.h"
#import "ChineseString.h"
#import "NetWorkManager+NetworkTool.h"
#import "PinYin4Objc.h"



@interface SifeTeacherController ()

@property (nonatomic, strong) NetWorkManager *netWorkManager;

/**
 *  分组后数据源数组
 */
@property(nonatomic,strong)NSMutableArray *teacherArray;
/**
 *  防重用标志数组
 */
@property(nonatomic,strong)NSMutableArray *dicArray;
/**
 *  标题数组
 */
@property(nonatomic,strong)NSMutableArray *headerArray;
/**
 *  选中的老师
 */
@property(nonatomic,strong)NSMutableArray *selectedArray;
/**
 *  开通服务的老师
 */
@property(nonatomic,strong)NSMutableArray *userService;

@property(nonatomic,weak)UIButton *certainBtn;
@property(nonatomic,weak)UIButton *selectAllBtn;

@end

@implementation SifeTeacherController
- (NetWorkManager *)netWorkManager
{
    if (!_netWorkManager) {
        _netWorkManager = [[NetWorkManager alloc]init];
    }
    return _netWorkManager;
}

- (NSMutableArray *)teacherArray
{
    if (!_teacherArray) {
        _teacherArray = [NSMutableArray array];
    }
    return _teacherArray;
}
- (NSMutableArray *)headerArray
{
    if (!_headerArray) {
        _headerArray = [NSMutableArray array];
    }
    return _headerArray;
}
- (NSMutableArray *)datasoures
{
    if (!_datasoures) {
        _datasoures = [NSMutableArray array];
    }
    return _datasoures;
}
- (NSMutableArray *)selectedArray
{
    if (!_selectedArray) {
        _selectedArray = [NSMutableArray array];
    }
    return _selectedArray;
}
- (NSMutableArray *)userService
{
    if (!_userService) {
        _userService = [NSMutableArray array];
    }
    return _userService;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"成员列表";
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [back setFrame:CGRectMake(-3, 2, 40, 30)];
    [back setTitle:@"返回" forState:UIControlStateNormal];
    [back addTarget:self action:@selector(popToBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:back];
    self.navigationItem.leftBarButtonItem = barButton;
    
    self.collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - 40) collectionViewLayout:[self flowLayout]];
    self.collectionView.dataSource=self;
    self.collectionView.delegate=self;
    [self.collectionView setBackgroundColor:[UIColor whiteColor]];
    
    //注册Cell，必须要有
    [self.collectionView registerClass:[StudentCollectionViewCell class]forCellWithReuseIdentifier:@"CollectionCell"];
    [self.collectionView registerClass:[CollectionHeaderView class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                   withReuseIdentifier:@"HeaderView"];
    
    [self.view addSubview:self.collectionView];
    [self createFooter];
    [self processingData];
    
}
- (void)popToBack
{
    if (self.selectedArray.count != 0 ) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil
                                                        message:@"是否放弃当前操作!!"
                                                       delegate:nil
                                              cancelButtonTitle:@"关闭"
                                              otherButtonTitles:@"确定", nil];
        alert.tag = 10000;
        alert.delegate = self;
        [alert show];
    }else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==10000) {
        if (buttonIndex==1) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}


#pragma mark - 处理数据
- (void)processingData
{
    self.teacherArray = [self getChineseStringArr:self.datasoures];
    for (TeacherList *teacher in self.datasoures) {
        if (teacher.UserService == 0)
            [self.userService addObject:teacher];
    }
    [self createDicArray];
    if (self.datasoures.count == 0) {
        [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"暂无数据"];
    }
    [self.collectionView reloadData];
    
}
- (void)createDicArray
{
    self.dicArray =  [NSMutableArray array];
    [self.dicArray removeAllObjects];
    for (int i = 0; i < self.teacherArray.count; i++) {
        NSMutableArray *arr = [NSMutableArray array];
        NSArray *temp = [self.teacherArray objectAtIndex:i];
        for (int j = 0; j < [temp count]; j++) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setValue:@"NO" forKey:@"checked"];
            [arr addObject:dic];
        }
        [self.dicArray addObject:arr];
    }
    
}
#pragma mark - 字母分组
- (NSMutableArray *)getChineseStringArr:(NSMutableArray *)arrToSort {
    NSMutableArray *chineseStringsArray = [NSMutableArray array];
    for(int i = 0; i < [arrToSort count]; i++) {
        ChineseString *chineseString=[[ChineseString alloc]init];
        TeacherList *teacher = arrToSort[i];
        chineseString.string=[NSString stringWithString:teacher.TeacherName];
        
        if(chineseString.string==nil){
            chineseString.string=@"";
        }
        
        if(![chineseString.string isEqualToString:@""]){
            //join the pinYin
            NSString *pinYinResult = [NSString string];
            for(int j = 0;j < chineseString.string.length; j++) {
                HanyuPinyinOutputFormat *outputFormat=[[HanyuPinyinOutputFormat alloc] init];
                [outputFormat setToneType:ToneTypeWithoutTone];
                [outputFormat setVCharType:VCharTypeWithV];
                [outputFormat setCaseType:CaseTypeLowercase];
                pinYinResult=[PinyinHelper toHanyuPinyinStringWithNSString:chineseString.string withHanyuPinyinOutputFormat:outputFormat withNSString:@""];
            }
            chineseString.pinYin = pinYinResult;
        } else {
            chineseString.pinYin = @"";
        }
        chineseString.teacher = teacher;
        [chineseStringsArray addObject:chineseString];
    }
    
    //sort the ChineseStringArr by pinYin
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"pinYin" ascending:YES]];
    [chineseStringsArray sortUsingDescriptors:sortDescriptors];
    
    
    NSMutableArray *arrayForArrays = [NSMutableArray array];
    BOOL checkValueAtIndex = NO;  //flag to check
    NSMutableArray *TempArrForGrouping = nil;
    
    for(int index = 0; index < [chineseStringsArray count]; index++)
    {
        ChineseString *chineseStr = (ChineseString *)[chineseStringsArray objectAtIndex:index];
        NSMutableString *strchar= [NSMutableString stringWithString:chineseStr.pinYin];
        if (strchar.length > 0) {
            NSString *sr= [strchar substringToIndex:1];
            if(![self.headerArray containsObject:[sr uppercaseString]])//here I'm checking whether the
            {
                [self.headerArray addObject:[sr uppercaseString]];
                TempArrForGrouping = [[NSMutableArray alloc] init];
                checkValueAtIndex = NO;
            }
            if([self.headerArray containsObject:[sr uppercaseString]])
            {
                [TempArrForGrouping addObject:[chineseStringsArray objectAtIndex:index]];
                if(checkValueAtIndex == NO)
                {
                    [arrayForArrays addObject:TempArrForGrouping];
                    checkValueAtIndex = YES;
                }
            }
        }
    }
    return arrayForArrays;
}




#pragma mark - 底部的View
- (void)createFooter
{
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT - 40, SCREENWIDTH, 40)];
    footerView.backgroundColor = [UIColor colorWithRed:240.0/255 green:236.0/255 blue:236.0/255 alpha:1.0];
    self.footerView = footerView;
    footerView.userInteractionEnabled = YES;
    [self.view addSubview:footerView];
    UIButton *selectAllBtn = [[UIButton alloc]initWithFrame:CGRectMake(5, 0, 40, 40)];
    [selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
    selectAllBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [selectAllBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [selectAllBtn addTarget:self action:@selector(selectAllBtnClick:) forControlEvents:UIControlEventTouchDown];
    selectAllBtn.tag = 101;
    self.selectAllBtn = selectAllBtn;
    [self.footerView addSubview:selectAllBtn];
    
    UIButton *certainBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREENWIDTH / 2 - 40, 5, 80, 30)];
    [certainBtn setTitle:[NSString stringWithFormat:@"确定(%d)",self.selectedArray.count] forState:UIControlStateNormal];
    certainBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [certainBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    certainBtn.backgroundColor = theLoginButtonColor;
    certainBtn.layer.cornerRadius = 5.0;
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
        for (int i = 0; i < self.dicArray.count; i++) {
            for (NSMutableDictionary *dic in [self.dicArray objectAtIndex:i]) {
                [dic setObject:@"YES" forKey:@"checked"];
            }
        }
        [self.selectedArray addObjectsFromArray:self.userService];
        btn.tag = 102;
    }else if(btn.tag == 102)
    {
        [btn setTitle:@"全选" forState:UIControlStateNormal];
        for (int i = 0; i < self.dicArray.count; i++) {
            for (NSMutableDictionary *dic in [self.dicArray objectAtIndex:i]) {
                [dic setObject:@"NO" forKey:@"checked"];
            }
        }
        btn.tag = 101;
    }
    [self.certainBtn setTitle:[NSString stringWithFormat:@"确定(%d)",self.selectedArray.count] forState:UIControlStateNormal];
    [self.collectionView reloadData];
}
#pragma mark - 确定
- (void)certainBtnClick:(UIButton *)btn
{
    [self.navigationController popToViewController: [self.navigationController.viewControllers objectAtIndex: ([self.navigationController.viewControllers count] - 3)] animated:YES];
    if ([self.delegate respondsToSelector:@selector(selectedArray:)]) {
        [self.delegate selectedArray:self.selectedArray];
    }
}

- (UICollectionViewFlowLayout *)flowLayout
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    layout.itemSize = CGSizeMake(70, 30);
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    layout.minimumLineSpacing = 20;
    layout.headerReferenceSize = CGSizeMake(SCREENWIDTH, 30.0f);// 设置headerView高度
    return layout;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.teacherArray.count;
    
}
//每个section的item个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray *temp = [self.teacherArray objectAtIndex:section];
    return [temp count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString * CellIdentifier = @"CollectionCell";
    StudentCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    NSUInteger section = [indexPath section];
    NSUInteger row = [indexPath row];
    NSMutableDictionary *dic = [[self.dicArray objectAtIndex:section] objectAtIndex:row];
    if ([[dic objectForKey:@"checked"] isEqualToString:@"NO"]) {
        [dic setObject:@"NO" forKey:@"checked"];
        [cell setChecked:NO];
        
    }else {
        [dic setObject:@"YES" forKey:@"checked"];
        [cell setChecked:YES];
    }
    BaseButton *btn = cell.btn;
    cell.btn.userInteractionEnabled = NO;
    TeacherList *teacher = [[TeacherList alloc]init];
  
        ChineseString *str = (ChineseString *) [[self.teacherArray objectAtIndex:section] objectAtIndex:row];
        teacher = str.teacher;
    [btn setTitle:[NSString stringWithFormat:@"%@",teacher.TeacherName] forState:UIControlStateNormal];
    if (teacher.UserService == -1) {
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        btn.imageView.hidden = YES;
        cell.userInteractionEnabled = NO;
    }else
    {
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.imageView.hidden = NO;
        cell.userInteractionEnabled = YES;
    }
    return cell;
    
}
//定义每个Item 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(80, 30);
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionReusableView *reusableView = nil;
    if (kind == UICollectionElementKindSectionHeader){
        
        CollectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        
        NSString *title = [self.headerArray objectAtIndex:indexPath.section];
        headerView.textLabel.text = title;
        
        reusableView = headerView;
        
    }
    return reusableView;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    StudentCollectionViewCell *cell = (StudentCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    NSUInteger section = [indexPath section];
    NSUInteger row = [indexPath row];
    NSMutableDictionary *dic = [[self.dicArray objectAtIndex:section] objectAtIndex:row];
    if ([[dic objectForKey:@"checked"] isEqualToString:@"NO"]) {
            ChineseString *str = (ChineseString *) self.teacherArray[section][row];;
            [self.selectedArray addObject:str.teacher];       
        [dic setObject:@"YES" forKey:@"checked"];
        [cell setChecked:YES];
    }else {
        for (int i = 0; i < self.selectedArray.count; i++) {
            TeacherList *teacher = [self.selectedArray objectAtIndex:i];
            if ([teacher.TeacherName isEqualToString:cell.btn.currentTitle]) {
                [self.selectedArray removeObjectAtIndex:i];
            }
        }
        [dic setObject:@"NO" forKey:@"checked"];
        [cell setChecked:NO];
    }
    if(self.selectedArray.count != self.userService.count)
    {
        [self.selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
        self.selectAllBtn.tag = 101;
    }
    [self.certainBtn setTitle:[NSString stringWithFormat:@"确定(%d)",self.selectedArray.count] forState:UIControlStateNormal];

}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


@end
