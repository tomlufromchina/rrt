//
//  ClassViewController.m
//  RenrenTong
//
//  Created by 符其彬 on 14-10-22.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "ClassViewController.h"
#import "GroupViewController.h"
#import "ClassCell.h"
#import "NetWorkManager+SchoolAndHouse.h"

@interface ClassViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic, strong) NetWorkManager *netWorkManager;
@property (nonatomic, strong) NSMutableArray *classArray;
@property (nonatomic, strong) NSMutableArray *classIdArray;
@property (nonatomic, strong) NSMutableArray *studentCounts;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation ClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"给班级发送";
    
    self.mainCollectionView.delegate = self;
    self.mainCollectionView.dataSource = self;
    self.navigationController.navigationBar.translucent = NO;
    
    self.mainCollectionView.collectionViewLayout = [self flowLayout];
    
    //Add search button
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"下一步"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(clickNextButton)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.netWorkManager = [[NetWorkManager alloc] init];
    self.dataSource = [[NSMutableArray alloc] init];
    self.classArray = [[NSMutableArray alloc] init];
    self.classIdArray = [[NSMutableArray alloc] init];
    self.studentCounts = [[NSMutableArray alloc] init];
    [self requestData];
    
    self.allBtn.tag = 0;
    self.turnOverBtn.tag = 0;
}
#pragma mark -- 获取班级数据解析

- (void)requestData
{
    [self show];
    [self.netWorkManager getTeacherClassCounts:[RRTManager manager].loginManager.loginInfo.tokenId
                                     teacherId:[RRTManager manager].loginManager.loginInfo.userId
                                       success:^(NSMutableArray *data) {
                                           [self dismiss];
                                           [self gotoUpdataUI:data];
        
    } failed:^(NSString *errorMSG) {
        [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:errorMSG];
    }];
}

#pragma mark -- 刷新界面

- (void)gotoUpdataUI:(NSMutableArray *)data
{
    if (data && [data count] > 0) {
        for (int i = 0; i < [data count]; i ++) {
            // 班级数量
            [self.classArray addObject:[data[i] objectForKey:@"ClassAlias"]];
            
            // 班级Id
            [self.classIdArray addObject:[data[i] objectForKey:@"ClassId"]];
        }
        [self.mainCollectionView reloadData];
    }
    
}

#pragma mark -- 设置layout
#pragma mark --
- (UICollectionViewFlowLayout *)flowLayout
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(151, 50);
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.minimumLineSpacing = 0;
    return layout;
}

#pragma mark -- UICollectionView DataSource and Delegate Methods

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个section的item个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.classArray count];
}

//每个UICollectionView展示的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ClassCell *cell = (ClassCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"ClassCell" forIndexPath:indexPath];
    [cell.checkboxbtn addTarget:self action:@selector(clickChooseButton:) forControlEvents:UIControlEventTouchUpInside];
    cell.checkboxbtn.tag = 0;
    UILabel *studentName = (UILabel *)[cell viewWithTag:102];
    if (self.classArray && [self.classArray count] > 0) {
        studentName.text = [self.classArray objectAtIndex:indexPath.row];
    } else {
        studentName.text = @"";
    }
    return cell;
}

#pragma mark -- collectionViewCellButton相应事件

- (void)clickChooseButton:(UIButton *)sender
{
    if (sender.tag==0) {
        sender.tag=1;
        [sender setImage:[UIImage imageNamed:@"已选"] forState:UIControlStateNormal];
        BOOL isallchecked=YES;
        for (int i = 0; i < [self.classArray count]; i++) {
            NSIndexPath* path=[NSIndexPath indexPathForRow:(NSInteger)i inSection:0];
            ClassCell *cell = (ClassCell*)[self.mainCollectionView cellForItemAtIndexPath:path];
            UIButton *chooseButton = cell.checkboxbtn;
            if (chooseButton.tag==0) {
                isallchecked=NO;
                break;
            }
        }
        if (isallchecked) {
            [self.allBtn setImage:[UIImage imageNamed:@"已选"] forState:UIControlStateNormal];
            self.allBtn.tag = 1;
            [self.turnOverBtn setImage:[UIImage imageNamed:@"未选"] forState:UIControlStateNormal];
            self.turnOverBtn.tag = 0;

        }else{
            [self.allBtn setImage:[UIImage imageNamed:@"未选"] forState:UIControlStateNormal];
            self.allBtn.tag = 0;
        }
    } else {
        sender.tag=0;
        [sender setImage:[UIImage imageNamed:@"未选"] forState:UIControlStateNormal];
        [self.allBtn setImage:[UIImage imageNamed:@"未选"] forState:UIControlStateNormal];
        self.allBtn.tag = 0;
        [self.turnOverBtn setImage:[UIImage imageNamed:@"未选"] forState:UIControlStateNormal];
        self.turnOverBtn.tag = 0;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark -- 下一步之前判断

- (BOOL)validateTheGoto
{
    BOOL b = NO;// 先设置全部未选中
    for (int i = 0; i < [self.classIdArray count]; i++) {
        
        NSIndexPath* path=[NSIndexPath indexPathForRow:(NSInteger)i inSection:0];
        ClassCell *cell = (ClassCell*)[self.mainCollectionView cellForItemAtIndexPath:path];
        UIButton *chooseButton = cell.checkboxbtn;
        if (chooseButton.tag == 1) {
            b = YES;
            break;
        }
    }
    if (!b) {
        [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"请选择发送对象"];

    }
    return b;
}

#pragma mark -- 下一步相应事件

- (void)clickNextButton
{
    if ([self validateTheGoto]) {
        [self.navigationController pushViewController:GroupVCID
                                       withStoryBoard:DeskStoryBoardName
                                            withBlock:^(UIViewController *viewController) {
                                                GroupViewController *VC = (GroupViewController*)viewController;
                                                // 初始化数组
                                                VC.classIdInfo = [[NSMutableArray alloc] init];
                                                for (int i = 0; i < [self.classArray count]; i++) {
                                                    NSIndexPath* path=[NSIndexPath indexPathForRow:(NSInteger)i inSection:0];
                                                    ClassCell *cell = (ClassCell*)[self.mainCollectionView cellForItemAtIndexPath:path];
                                                    UIButton *chooseButton = cell.checkboxbtn;
                                                    // 将选中班级ID加入classIdInfo
                                                    if (chooseButton.tag == 1) {
                                                        NSString *info = [self.classIdArray objectAtIndex:i];
                                                        [VC.classIdInfo addObject:info];
                                                    }
                                                }
                                                
                                                
                                                
                                            }];
        
    }
    
}

#pragma mark -- 全选相应事件

- (IBAction)allButton:(UIButton *)sender
{
    [self.allBtn setImage:[UIImage imageNamed:@"已选"] forState:UIControlStateNormal];
    self.allBtn.tag = 1;
    
    [self.turnOverBtn setImage:[UIImage imageNamed:@"未选"] forState:UIControlStateNormal];
    self.turnOverBtn.tag = 0;
    
    for (int i = 0; i < [self.classArray count]; i++) {
        NSIndexPath* path=[NSIndexPath indexPathForRow:(NSInteger)i inSection:0];
        ClassCell *cell = (ClassCell*)[self.mainCollectionView cellForItemAtIndexPath:path];
        UIButton *chooseButton = cell.checkboxbtn;
        [chooseButton setImage:[UIImage imageNamed:@"已选"] forState:UIControlStateNormal];

        chooseButton.tag=1;
    }
    
}

#pragma mark -- 反选相应事件

- (IBAction)turnOverButton:(UIButton *)sender
{
    [self.turnOverBtn setImage:[UIImage imageNamed:@"已选"] forState:UIControlStateNormal];
    self.turnOverBtn.tag = 1;
    
    [self.allBtn setImage:[UIImage imageNamed:@"未选"] forState:UIControlStateNormal];
    self.allBtn.tag = 0;
    
    for (int i = 0; i < [self.classArray count]; i++) {
        NSIndexPath* path=[NSIndexPath indexPathForRow:(NSInteger)i inSection:0];
        ClassCell *cell = (ClassCell*)[self.mainCollectionView cellForItemAtIndexPath:path];
        UIButton *chooseButton = cell.checkboxbtn;
        if (chooseButton.tag==0) {
            chooseButton.tag=1;
            [chooseButton setImage:[UIImage imageNamed:@"已选"] forState:UIControlStateNormal];
        }else{
            chooseButton.tag=0;
            [chooseButton setImage:[UIImage imageNamed:@"未选"] forState:UIControlStateNormal];
        }
    }
    
}

#pragma mark -- 学生列表界面刷新

- (void)updateUI:(NSMutableArray *)data
{
    for (int j = 0; j < [data count]; j ++) {
        [self.studentCounts addObject:[data[j] objectForKey:@"StudentName"]];
    }
    self.mainCollectionView.hidden = NO;
    [self.mainCollectionView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
