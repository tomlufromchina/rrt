//
//  SiftStudentController.m
//  RenrenTong
//
//  Created by aedu on 15/1/31.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "SiftStudentController.h"
#import "CollectionHeaderView.h"
#import "StudentCollectionViewCell.h"
#import "BaseButton.h"
#import "IWTitleButton.h"
#import "IWPopMenuView.h"
#import "NetWorkManager+NetworkTool.h"
#import "StudentList.h"
#import "MJExtension.h"
#import "PinYin4Objc.h"
#import "ChineseString.h"


@interface SiftStudentController ()<IWPopMenuViewDelegate,UIAlertViewDelegate>
@property (nonatomic, strong) NetWorkManager *netWorkManager;
@property (nonatomic, strong) UIImage *downImage;
@property (nonatomic, strong) UIImage *upImage;
/**
 *  标题按钮
 */
@property (nonatomic, weak) IWTitleButton *titleButton;
@property (nonatomic, weak) IWPopMenuView *popView;

/**
 *  原始数据源数组
 */
@property(nonatomic,strong)NSMutableArray *datasoures;

/**
 *  分组后数据源数组
 */
@property(nonatomic,strong)NSMutableArray *studentArray;
/**
 *  防重用标志数组
 */
@property(nonatomic,strong)NSMutableArray *dicArray;
/**
 *  标题数组
 */
@property(nonatomic,strong)NSMutableArray *headerArray;
/**
 *  选中的学生
 */
@property(nonatomic,strong)NSMutableArray *selectedArray;
/**
 *  开通服务的学生
 */
@property(nonatomic,strong)NSMutableArray *userService;

@property(nonatomic,weak)UIButton *certainBtn;
@property(nonatomic,weak)UIButton *selectAllBtn;
@property(nonatomic,assign)BOOL IsSortByNum;

@end

@implementation SiftStudentController

- (NetWorkManager *)netWorkManager
{
    if (!_netWorkManager) {
        _netWorkManager = [[NetWorkManager alloc]init];
    }
    return _netWorkManager;
}
- (NSMutableArray *)studentArray
{
    if (!_studentArray) {
        _studentArray = [NSMutableArray array];
    }
    return _studentArray;
}
- (NSMutableArray *)selectedArray
{
    if (!_selectedArray) {
        _selectedArray = [NSMutableArray array];
    }
    return _selectedArray;
}
- (NSMutableArray *)datasoures
{
    if (!_datasoures) {
        _datasoures = [NSMutableArray array];
    }
    return _datasoures;
}
- (NSMutableArray *)headerArray
{
    if (!_headerArray) {
        _headerArray = [NSMutableArray array];
    }
    return _headerArray;
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
    //self.titleButton;
    self.title = @"班级成员";
    self.IsSortByNum = NO;
    
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [back setFrame:CGRectMake(0, 2, 40, 30)];
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
    [self getClassStudents];
    [self createFooter];

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
    }
    else
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
#pragma mark - 获取班级学生
- (void)getClassStudents
{
    [MBProgressHUD showMessage:@"加载中..."];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUD];
    });
    [self.netWorkManager getClassStudents:[RRTManager manager].loginManager.loginInfo.tokenId
                                       classId:self.classId
                                       success:^(NSMutableArray *data) {
                                           [self processingData:data];
                                       }
                                   failed:^(NSString *errorMSG) {
                                       [MBProgressHUD hideHUD];
                                           [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:errorMSG];
                                       }];
    
}

#pragma mark - 处理数据
- (void)processingData:(NSArray *)data
{
    self.datasoures = (NSMutableArray *)[StudentList objectArrayWithKeyValuesArray:data];
    NSSortDescriptor *sortByID = [NSSortDescriptor sortDescriptorWithKey:@"StudentNumber.intValue" ascending:YES];
    // 建立NSSortDescriptor 对象,按照的属性列,是否是asc升序?
    [self.datasoures sortUsingDescriptors:[NSArray arrayWithObject:sortByID]];
    
    NSMutableArray *noCampus = [NSMutableArray array];
    NSMutableArray *isCampus = [NSMutableArray array];
    for (StudentList *stu in self.datasoures) {
        if (stu.IsOnCampus) {
            [isCampus addObject:stu];
        }else
        {
            [noCampus addObject:stu];
        }
        
    }
    if (self.IsOnCampus == 0)
    {
        //走读生
        self.datasoures = noCampus;
    }
    else if (self.IsOnCampus == 2)
    {
        //住校生
        self.datasoures = isCampus;
    }
    
    for (StudentList *stu in self.datasoures) {
        if (stu.UserService == 0)
            [self.userService addObject:stu];
    }
    self.studentArray = [self getChineseStringArr:self.datasoures];
    [self createDicArray];
    [MBProgressHUD hideHUD];
    [self.collectionView reloadData];

}
- (void)createDicArray
{
    self.dicArray =  [NSMutableArray array];
    [self.dicArray removeAllObjects];
    for (int i = 0; i < self.studentArray.count; i++) {
        NSMutableArray *arr = [NSMutableArray array];
        NSArray * temp = [self.studentArray objectAtIndex:i];
        for (int j = 0; j < [temp count]; j++) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            if (self.IsSelectAll) {
                [dic setValue:@"YES" forKey:@"checked"];
            }else
            {
                [dic setValue:@"NO" forKey:@"checked"];
            }
            [arr addObject:dic];
        }
        [self.dicArray addObject:arr];
    }
    if(self.IsSelectAll)
    {
        [self.selectedArray addObjectsFromArray:self.userService];
        [self.selectAllBtn setTitle:@"取消" forState:UIControlStateNormal];
        self.selectAllBtn.tag = 102;
        [self.certainBtn setTitle:[NSString stringWithFormat:@"确定(%d)",self.selectedArray.count] forState:UIControlStateNormal];
    }
    
}

- (IWTitleButton *)titleButton
{
    if (!_titleButton) {
        
        // 1.创建标题按钮
        IWTitleButton *titleButton = [[IWTitleButton alloc] init];
        [titleButton setTitle:@"成员列表(按学号)" forState:UIControlStateNormal];
        
        [titleButton setImage:self.downImage forState:UIControlStateNormal];
        titleButton.width = 140;
        titleButton.height = 35;
        // 2.添加点击事件
        [titleButton addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.titleView = titleButton;
        _titleButton = titleButton;
    }
    return _titleButton;
}

- (void)titleButtonClick:(IWTitleButton *)btn
{
    if (self.titleButton.imageView.image == self.downImage) {
        // 1.切换按钮图片
        // 现在时向下, 需要切换到向上
        [self.titleButton setImage:self.upImage forState:UIControlStateNormal];
        
        // 1.创建自定义菜单
        UIView *iv = [[UIView alloc] init];
        iv.backgroundColor = [UIColor whiteColor];
        UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 35)];
        [btn1 setTitle:@"排序:字母" forState:UIControlStateNormal];
        [btn1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        btn1.tag = 101;
        btn1.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn1 addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [iv addSubview:btn1];
        
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 37, SCREENWIDTH, 1)];
        v.backgroundColor = [UIColor grayColor];
        [iv addSubview:v];
        
        UIButton *btn2 = [[UIButton alloc]initWithFrame:CGRectMake(0, 39, SCREENWIDTH, 35)];
        [btn2 setTitle:@"排序:学号" forState:UIControlStateNormal];
        [btn2 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        btn2.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn2 addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn2.tag = 102;
        [iv addSubview:btn2];
        
        IWPopMenuView *popMenuView = [IWPopMenuView popMenuViewWithContentView:iv];
        
        // 设置代理
        popMenuView.delegate =  self;
        self.popView = popMenuView;
        
        // 3.显示菜单
        CGFloat popW = SCREENWIDTH;
        CGFloat popH = 75;
        CGFloat popX = 0;
        CGFloat popY = 64;
        
        [popMenuView showWithRect:CGRectMake(popX, popY, popW, popH)];
        
    }
  

}

- (void)selectBtnClick:(UIButton *)btn
{
    [self.titleButton setImage:self.downImage forState:UIControlStateNormal];
    if (btn.tag == 101) {
        [self.titleButton setTitle:@"成员列表(按字母)" forState:UIControlStateNormal];
        self.studentArray = [self getChineseStringArr:self.datasoures];
        self.IsSortByNum = NO;
        
    }else{
       [self.titleButton setTitle:@"成员列表(按学号)" forState:UIControlStateNormal];
        self.studentArray = [self numberSection:self.datasoures];
        self.IsSortByNum = YES;
    }
    [self createDicArray];
    
    [self.selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
    self.selectAllBtn.tag = 101;
    [self.certainBtn setTitle:[NSString stringWithFormat:@"确定(%d)",self.selectedArray.count] forState:UIControlStateNormal];
    [self.collectionView reloadData];
    [self.popView dismiss];
}
#pragma mark - IWPopMenuViewDelegate
- (void)popMenuViewDidClick:(IWPopMenuView *)popMenuView
{
    [self.titleButton setImage:self.downImage forState:UIControlStateNormal];
}

#pragma mark - 懒加载
- (UIImage *)downImage
{
    if (!_downImage) {
        _downImage = [UIImage imageNamed:@"navigationbar_arrow_down"];
    }
    return _downImage;
}

- (UIImage *)upImage
{
    if (!_upImage) {
        _upImage = [UIImage imageNamed:@"navigationbar_arrow_up"];
    }
    return _upImage;
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
    certainBtn.titleLabel.font = [UIFont systemFontOfSize:15];
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




#pragma mark - 学号分组
- (NSMutableArray *)numberSection:(NSArray *)array
{
    [self.headerArray removeAllObjects];
    NSMutableArray *muArray = [[NSMutableArray alloc]init];
    int n = [array count] / 18;
    int m = [array count] % 18;
    if (m != 0 ) {
        n = n + 1;
    }
    for (int j = 0; j < n ; j++) {
        NSMutableArray *arr = [[NSMutableArray alloc]init];
        NSString *headerString = nil;
        for (int i = 0; i < 18; i++) {
                [arr addObject:[array objectAtIndex:(i + j * 18)]];
                if ((i + j * 18) == ([array count] - 1))
                {
                    headerString = [NSString stringWithFormat:@"%d-%d",j * 18 + 1,[array count]];
                    break;
                }else
                {
                    headerString = [NSString stringWithFormat:@"%d-%d",j * 18 + 1,(j + 1) * 18];
                }
        
        }
        [self.headerArray addObject:headerString];
        [muArray addObject:arr];
    }
    return muArray;
}
#pragma mark - 字母分组
- (NSMutableArray *)getChineseStringArr:(NSMutableArray *)arrToSort {
    [self.headerArray removeAllObjects];
    NSMutableArray *chineseStringsArray = [NSMutableArray array];
    for(int i = 0; i < [arrToSort count]; i++) {
        ChineseString *chineseString=[[ChineseString alloc]init];
        StudentList *stu = arrToSort[i];
        chineseString.string=[NSString stringWithString:stu.StudentName];
        
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
        chineseString.student = stu;
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
    return arrayForArrays;
}

- (UICollectionViewFlowLayout *)flowLayout
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    layout.itemSize = CGSizeMake(70, 30);
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    layout.minimumLineSpacing = 20;
    layout.headerReferenceSize = CGSizeMake(SCREENWIDTH, 25.0f);// 设置headerView高度
    return layout;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.studentArray.count;

}
//每个section的item个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray * temp = [self.studentArray objectAtIndex:section];

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
    StudentList *stu = [[StudentList alloc]init];
    if (self.IsSortByNum)
        stu = [[self.studentArray objectAtIndex:section] objectAtIndex:row];
    else
    {
        ChineseString *str = (ChineseString *) [[self.studentArray objectAtIndex:section] objectAtIndex:row];
        stu = str.student;
        
    }
    [btn setTitle:[NSString stringWithFormat:@"%@",stu.StudentName] forState:UIControlStateNormal];
        if (stu.UserService == -1) {
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
            if (self.IsSortByNum) {
                StudentList *stu = self.studentArray[section][row];
                [self.selectedArray addObject:stu];
            }else
            {
                ChineseString *str = (ChineseString *) self.studentArray[section][row];;
                [self.selectedArray addObject:str.student];
            }
            
            [dic setObject:@"YES" forKey:@"checked"];
            [cell setChecked:YES];
        }else {
            for (int i = 0; i < self.selectedArray.count; i++) {
                StudentList *stu = [self.selectedArray objectAtIndex:i];
                if ([stu.StudentName isEqualToString:cell.btn.currentTitle]) {
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
