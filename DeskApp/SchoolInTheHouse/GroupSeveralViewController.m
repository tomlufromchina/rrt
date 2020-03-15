//
//  GroupSeveralViewController.m
//  RenrenTong
//
//  Created by 符其彬 on 14-10-22.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "GroupSeveralViewController.h"
#import "SendGoupMenberViewController.h"
#import "GroupSeveralCell.h"

#import "NetWorkManager+SchoolAndHouse.h"

@interface GroupSeveralViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIActionSheetDelegate>
@property (nonatomic, strong) NetWorkManager *netWorkManager;
@property (nonatomic, strong) NSMutableArray *groupCounts;
@property (nonatomic, strong) NSMutableArray *groupIdArray;
@property (nonatomic, strong) NSMutableArray *groupMenber;
@property (nonatomic, strong) NSMutableArray *groupMenberId;
@property (nonatomic, strong)  NSMutableDictionary * buttonStatedic;// 防止重用

@property (nonatomic, assign) BOOL isClick;
@property (nonatomic, assign) int i;

@end

@implementation GroupSeveralViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"给群组个别成员发送";
    self.navigationController.navigationBar.translucent = NO;
        //Add search button
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"下一步"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(clickNextButton)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.mainCollectionView.delegate = self;
    self.mainCollectionView.dataSource = self;
    
    self.mainCollectionView.collectionViewLayout = [self flowLayout];
    
    self.allBtn.tag = 0;
    self.Contrary.tag = 0;
    
    self.netWorkManager = [[NetWorkManager alloc] init];
    self.groupCounts = [[NSMutableArray alloc] init];
    self.groupIdArray = [[NSMutableArray alloc] init];
    self.groupMenber = [[NSMutableArray alloc] init];
    self.groupMenberId = [[NSMutableArray alloc
                           ] init];
    self.buttonStatedic=[[NSMutableDictionary alloc] init];
    
    [self requestData];


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

#pragma mark -- 教师创建的班级界面刷新
- (void)gotoUpdataUI:(NSMutableArray *)data
{
    if (data) {
        for (int i = 0; i < [data count]; i ++) {
            [self.groupCounts addObject:[data[i] objectForKey:@"GroupName"]];
            
            [self.groupIdArray addObject:[data[i] objectForKey:@"GroupId"]];
        }
        self.mainCollectionView.hidden = NO;
        [self.mainCollectionView reloadData];
    }
    
}

#pragma mark -- 下一步之前判断

- (BOOL)validateTheGoto
{
    BOOL b = NO;// 先设置全部未选中
    for (int i = 0; i < [self.groupMenber count]; i++) {
        
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

#pragma mark -- 下一步
- (void)clickNextButton
{
    if ([self validateTheGoto]) {
        [self.navigationController pushViewController:SendGroupMenberVCID withStoryBoard:DeskStoryBoardName withBlock:^(UIViewController *viewController) {
            
            SendGoupMenberViewController *VC = (SendGoupMenberViewController*)viewController;
            // 初始化数组
            VC.groupMenberInfo = [[NSMutableArray alloc] init];
            for (int i = 0; i < [self.groupMenber count]; i++) {
                BOOL tempb=[[self.buttonStatedic objectForKey:[NSNumber numberWithInt:i]] boolValue];
                if (tempb) {
                    NSString *info = [self.groupMenberId objectAtIndex:i];
                    [VC.groupMenberInfo addObject:info];
                }
            }
            // 传班级Id。。
            switch (self.i) {
                case 0:
                {
                    VC.groupId = self.groupIdArray[0];
                    
                }
                    break;
                case 1:
                {
                    VC.groupId = self.groupIdArray[1];
                }
                    break;
                case 2:
                {
                    VC.groupId = self.groupIdArray[2];
                }
                    break;
                case 3:
                {
                    VC.groupId = self.groupIdArray[3];
                    
                }
                    break;
                case 4:
                {
                    VC.groupId = self.groupIdArray[4];
                }
                    break;
                case 5:
                {
                    VC.groupId = self.groupIdArray[5];
                }
                    break;
                case 6:
                {
                    VC.groupId = self.groupIdArray[6];
                }
                    break;
                case 7:
                {
                    VC.groupId = self.groupIdArray[7];
                }
                    break;
                case 8:
                {
                    VC.groupId = self.groupIdArray[8];
                }
                    break;
                case 9:
                {
                    VC.groupId = self.groupIdArray[9];
                }
                    break;
                case 10:
                {
                    VC.groupId = self.groupIdArray[10];
                }
                    break;
                case 11:
                {
                    VC.groupId = self.groupIdArray[11];
                    
                }
                    break;
                case 12:
                {
                    VC.groupId = self.groupIdArray[12];
                }
                    break;
                case 13:
                {
                    VC.groupId = self.groupIdArray[13];
                }
                    break;
                case 14:
                {
                    VC.groupId = self.groupIdArray[14];
                }
                    break;
                    
                case 15:
                {
                    VC.groupId = self.groupIdArray[15];
                }
                    break;
                    
                default:
                    break;
            }
            
        }];
        
    }
    
}
#pragma mark -- 全选
- (IBAction)clickAllButton:(UIButton *)sender {
    
    [self.allBtn setImage:[UIImage imageNamed:@"已选"] forState:UIControlStateNormal];
    self.allBtn.tag = 1;
    
    [self.Contrary setImage:[UIImage imageNamed:@"未选"] forState:UIControlStateNormal];
    self.Contrary.tag = 0;
    for (int i = 0; i < [self.groupMenber count]; i++) {
        NSIndexPath* path=[NSIndexPath indexPathForRow:(NSInteger)i inSection:0];
        GroupSeveralCell *cell = (GroupSeveralCell *)[self.mainCollectionView cellForItemAtIndexPath:path];
        UIButton *chooseButton = cell.groupButton;
        [chooseButton setImage:[UIImage imageNamed:@"已选"] forState:UIControlStateNormal];
        [self.buttonStatedic setObject:[NSNumber numberWithInt:1] forKey:[NSNumber numberWithInt:i]];
        
    }
    
}
#pragma mark -- 反选
- (IBAction)clickContrayButton:(UIButton *)sender {
    [self.Contrary setImage:[UIImage imageNamed:@"已选"] forState:UIControlStateNormal];
    self.Contrary.tag = 1;
    
    [self.allBtn setImage:[UIImage imageNamed:@"未选"] forState:UIControlStateNormal];
    self.allBtn.tag = 0;
    
    for (int i = 0; i < [self.groupMenber count]; i++) {
        NSIndexPath* path=[NSIndexPath indexPathForRow:(NSInteger)i inSection:0];
        GroupSeveralCell *cell = (GroupSeveralCell *)[self.mainCollectionView cellForItemAtIndexPath:path];
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

#pragma mark -- 选择成员
- (IBAction)chooseClassButton:(UIButton *)sender
{
    
    UIActionSheet* sheet = [[UIActionSheet alloc] initWithTitle:nil
                                                       delegate:self
                                              cancelButtonTitle:nil
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:nil];
    for(int i = 0; i < [self.groupCounts count]; i++)
    {
        [sheet addButtonWithTitle:self.groupCounts[i]];
    }
    [sheet addButtonWithTitle:@"取消"];
    sheet.cancelButtonIndex = [self.groupCounts count];
    [sheet showInView:self.view];
    
    [self.mainCollectionView reloadData];
    
}

#pragma mark -- UIActionSheetDelegate
#pragma mark --

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.mainCollectionView reloadData];

    if (buttonIndex < [self.groupCounts count]) {
        NSString* theClassName = [self.groupCounts objectAtIndex:buttonIndex];
        self.classTitleLabel.text = theClassName;
        
        long long theClassId = [[self.groupIdArray objectAtIndex:buttonIndex] longLongValue];
        [self show];
        [self.netWorkManager getGroupMember:[RRTManager manager].loginManager.loginInfo.tokenId
                                    groupId:theClassId
                                    success:^(NSMutableArray *data) {
                                        [self dismiss];
                                        [self updateUI:data];
                                        
                                    } failed:^(NSString *errorMSG) {
                                        [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:errorMSG];
                                    }];
    }
}

#pragma mark -- 设置layout
#pragma mark --
- (UICollectionViewFlowLayout *)flowLayout
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(100, 50);
    layout.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);
    layout.minimumLineSpacing = 20;
    return layout;
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个section的item个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.groupMenber count];
}

//每个UICollectionView展示的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GroupSeveralCell *cell = (GroupSeveralCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"GroupSeveralCell" forIndexPath:indexPath];
    UIButton *chooseButton = cell.groupButton;
    chooseButton.tag=indexPath.row;
    [chooseButton addTarget:self action:@selector(clickChooseButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *studentName = (UILabel *)[cell viewWithTag:102];
    if (self.groupMenber && [self.groupMenber count] > 0) {
        studentName.text = [self.groupMenber objectAtIndex:indexPath.row];
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
        for (int i = 0; i < [self.groupMenber count]; i++) {
            BOOL tempb=[[self.buttonStatedic objectForKey:[NSNumber numberWithInt:i]] boolValue];
            if (!tempb) {
                isallchecked=NO;
                break;
            }
        }
        if (isallchecked) {
            [self.allBtn setImage:[UIImage imageNamed:@"已选"] forState:UIControlStateNormal];
            self.allBtn.tag = 1;
            [self.Contrary setImage:[UIImage imageNamed:@"未选"] forState:UIControlStateNormal];
            self.Contrary.tag = 0;
            
        }else{
            [self.allBtn setImage:[UIImage imageNamed:@"未选"] forState:UIControlStateNormal];
            self.allBtn.tag = 0;
        }
        
    } else {
        [self.buttonStatedic setObject:[NSNumber numberWithInt:0] forKey:[NSNumber numberWithInt:sender.tag]];        [sender setImage:[UIImage imageNamed:@"未选"] forState:UIControlStateNormal];
        [self.allBtn setImage:[UIImage imageNamed:@"未选"] forState:UIControlStateNormal];
        self.allBtn.tag = 0;
        [self.Contrary setImage:[UIImage imageNamed:@"未选"] forState:UIControlStateNormal];
        self.Contrary.tag = 0;
        
    }
    
}

#pragma mark -- 解析群组人数
- (void)updateUI:(NSMutableArray *)data
{
    if (data) {
        [self.groupMenber removeAllObjects];
        for (int j = 0; j < [data count]; j ++) {
            [self.groupMenber addObject:[data[j] objectForKey:@"UserName"]];
            [self.groupMenberId addObject:[data[j] objectForKey:@"UserId"]];
            [self.buttonStatedic setObject:[NSNumber numberWithInt:0] forKey:[NSNumber numberWithInt:j]];
        }
        self.mainCollectionView.hidden = NO;
        [self.mainCollectionView reloadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
