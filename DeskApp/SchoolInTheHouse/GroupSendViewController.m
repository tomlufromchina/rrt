//
//  GroupSendViewController.m
//  RenrenTong
//
//  Created by 符其彬 on 14-10-22.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "GroupSendViewController.h"
#import "SendGoupViewController.h"
#import "GroupSendCell.h"

#import "NetWorkManager+SchoolAndHouse.h"

@interface GroupSendViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic, assign) BOOL isClick;
@property (nonatomic, strong) UIButton *chooseButton;
@property (nonatomic, strong) NetWorkManager *netWorkManager;
@property (nonatomic, strong) NSMutableArray *groupCounts;
@property (nonatomic, strong) NSMutableArray *groupIdArray;
@property (nonatomic, strong) NSMutableDictionary * buttonStatedic;// 防止重用

@end

@implementation GroupSendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"给群组发送";
    
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
    self.groupCounts = [[NSMutableArray alloc] init];
    self.groupIdArray = [[NSMutableArray alloc] init];
    self.buttonStatedic=[[NSMutableDictionary alloc] init];
    
    [self requestData];
    
    self.allButton.tag = 0;
    self.turnOverButton.tag = 0;
    
    
}

#pragma mark -- 获取教师创建的班级请求
- (void)requestData
{
    [self show];
    [self.netWorkManager getTeacherGroupCounts:[RRTManager manager].loginManager.loginInfo.tokenId
                                     teacherId:[RRTManager manager].loginManager.loginInfo.userId
                                       success:^(NSMutableArray *data) {
                                           [self dismiss];
                                           [self gotoUpdataUI:data];
        
    } failed:^(NSString *errorMSG) {
        
    }];
}

#pragma mark -- 获取教师创建的班级界面刷新
- (void)gotoUpdataUI:(NSMutableArray *)data
{
    if (data) {
        for (int i = 0; i < [data count]; i ++) {
            [self.groupCounts addObject:[data[i] objectForKey:@"GroupName"]];
            
            [self.groupIdArray addObject:[data[i] objectForKey:@"GroupId"]];
            [self.buttonStatedic setObject:[NSNumber numberWithInt:0] forKey:[NSNumber numberWithInt:i]];
        }
        self.mainCollectionView.hidden = NO;
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

#pragma mark -- UICollectionDataSoueceAndDelegete

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个section的item个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.groupCounts count];
}

//每个UICollectionView展示的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GroupSendCell *cell = (GroupSendCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"GroupSendCell" forIndexPath:indexPath];
    UIButton *chooseButton = cell.groupButton;
    chooseButton.tag=indexPath.row;
    [chooseButton addTarget:self action:@selector(clickChooseButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *studentName = (UILabel *)[cell viewWithTag:102];
    if (self.groupCounts && [self.groupCounts count] > 0) {
        studentName.text = [self.groupCounts objectAtIndex:indexPath.row];
    } else {
        studentName.text = @"";
    }
    BOOL b=[[self.buttonStatedic objectForKey:[NSNumber numberWithInt:indexPath.row]] boolValue];
    if (!b) {
        [chooseButton setImage:[UIImage imageNamed:@"未选"] forState:UIControlStateNormal];
    }else{
        [chooseButton setImage:[UIImage imageNamed:@"已选"] forState:UIControlStateNormal];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark -- collectionViewCellButton相应事件

- (void)clickChooseButton:(UIButton *)sender
{
    BOOL b=[[self.buttonStatedic objectForKey:[NSNumber numberWithInt:sender.tag]] boolValue];
    if (!b) {
        [sender setImage:[UIImage imageNamed:@"已选"] forState:UIControlStateNormal];
        [self.buttonStatedic setObject:[NSNumber numberWithInt:1] forKey:[NSNumber numberWithInt:sender.tag]];
        BOOL isallchecked=YES;
        for (int i = 0; i < [self.groupCounts count]; i++) {
            BOOL tempb=[[self.buttonStatedic objectForKey:[NSNumber numberWithInt:i]] boolValue];
            if (!tempb) {
                isallchecked=NO;
                break;
            }
        }
        if (isallchecked) {
            [self.allButton setImage:[UIImage imageNamed:@"已选"] forState:UIControlStateNormal];
            self.allButton.tag = 1;
            [self.turnOverButton setImage:[UIImage imageNamed:@"未选"] forState:UIControlStateNormal];
            self.turnOverButton.tag = 0;
            
        }else{
            [self.allButton setImage:[UIImage imageNamed:@"未选"] forState:UIControlStateNormal];
            self.allButton.tag = 0;
        }
    } else {
        [self.buttonStatedic setObject:[NSNumber numberWithInt:0] forKey:[NSNumber numberWithInt:sender.tag]];        [sender setImage:[UIImage imageNamed:@"未选"] forState:UIControlStateNormal];
        [self.allButton setImage:[UIImage imageNamed:@"未选"] forState:UIControlStateNormal];
        self.allButton.tag = 0;
        [self.turnOverButton setImage:[UIImage imageNamed:@"未选"] forState:UIControlStateNormal];
        self.turnOverButton.tag = 0;
    }
    
}

#pragma mark -- 全选响应
- (IBAction)clickAllButton:(UIButton *)sender
{
    [self.allButton setImage:[UIImage imageNamed:@"已选"] forState:UIControlStateNormal];
    self.allButton.tag = 1;
    
    [self.turnOverButton setImage:[UIImage imageNamed:@"未选"] forState:UIControlStateNormal];
    self.turnOverButton.tag = 0;
    
    for (int i = 0; i < [self.groupCounts count]; i++) {
        NSIndexPath* path=[NSIndexPath indexPathForRow:(NSInteger)i inSection:0];
        GroupSendCell *cell = (GroupSendCell *)[self.mainCollectionView cellForItemAtIndexPath:path];
        UIButton *chooseButton = cell.groupButton;
        [chooseButton setImage:[UIImage imageNamed:@"已选"] forState:UIControlStateNormal];
        [self.buttonStatedic setObject:[NSNumber numberWithInt:1] forKey:[NSNumber numberWithInt:i]];
    }
    
}
#pragma mark -- 反选响应
- (IBAction)clickTurnOverButton:(UIButton *)sender
{
    [self.turnOverButton setImage:[UIImage imageNamed:@"已选"] forState:UIControlStateNormal];
    self.turnOverButton.tag = 1;
    
    [self.allButton setImage:[UIImage imageNamed:@"未选"] forState:UIControlStateNormal];
    self.allButton.tag = 0;
    
    for (int i = 0; i < [self.groupCounts count]; i++) {
        NSIndexPath* path=[NSIndexPath indexPathForRow:(NSInteger)i inSection:0];
        GroupSendCell *cell = (GroupSendCell *)[self.mainCollectionView cellForItemAtIndexPath:path];
        UIButton *chooseButton = cell.groupButton;
        BOOL b=[[self.buttonStatedic objectForKey:[NSNumber numberWithInt:i]] boolValue];
        if (!b) {
            [chooseButton setImage:[UIImage imageNamed:@"已选"] forState:UIControlStateNormal];
            [self.buttonStatedic setObject:[NSNumber numberWithInt:1] forKey:[NSNumber numberWithInt:i]];
        }else{
            [chooseButton setImage:[UIImage imageNamed:@"未选"] forState:UIControlStateNormal];
            [self.buttonStatedic setObject:[NSNumber numberWithInt:0] forKey:[NSNumber numberWithInt:i]];
        }
        
    }
}
#pragma mark -- 下一步响应
- (void)clickNextButton
{
 
    if ([self validateTheGoto]) {
        
        [self.navigationController pushViewController:SendGroupVCID withStoryBoard:DeskStoryBoardName withBlock:^(UIViewController *viewController) {
            SendGoupViewController *VC = (SendGoupViewController*)viewController;
            // 初始化数组
            VC.classIdInfo = [[NSMutableArray alloc] init];
            for (int i = 0; i < [self.groupCounts count]; i++) {
                BOOL tempb=[[self.buttonStatedic objectForKey:[NSNumber numberWithInt:i]] boolValue];
                if (tempb) {
                    NSString *info = [self.groupIdArray objectAtIndex:i];
                    [VC.classIdInfo addObject:info];
                }
            }            
        }];
        
    }
   
}

#pragma mark -- 下一步之前判断

- (BOOL)validateTheGoto
{
    BOOL b = NO;// 先设置全部未选中
    for (int i = 0; i < [self.groupCounts count]; i++) {
        BOOL tempb=[[self.buttonStatedic objectForKey:[NSNumber numberWithInt:i]] boolValue];
        if (tempb) {
            b = YES;
            break;
        }
        
    }
    if (!b) {
        [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"请选择发送对象"];

    }
    return b;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
