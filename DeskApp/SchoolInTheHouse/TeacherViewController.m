//
//  TeacherViewController.m
//  RenrenTong
//
//  Created by 符其彬 on 14-10-22.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "TeacherViewController.h"
#import "SendTeacherViewController.h"
#import "TeacherCell.h"
#import "NetWorkManager+SchoolAndHouse.h"

@interface TeacherViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic, strong)NetWorkManager *netWorkManager;
@property (nonatomic, strong) NSMutableArray *teacherCounts;
@property (nonatomic, strong) NSMutableArray *teacherIdArray;
@property (nonatomic, strong) NSMutableDictionary * buttonStatedic;// 防止重用
@end

@implementation TeacherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"给教师发送";
    
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
    self.teacherCounts = [[NSMutableArray alloc] init];
    self.teacherIdArray = [[NSMutableArray alloc] init];
    self.buttonStatedic=[[NSMutableDictionary alloc] init];
    self.allButton.tag = 0;
    self.turnOverButton.tag = 0;
    
    [self requestData];
    
    
}

#pragma mark -- 获取教师列表解析

- (void)requestData
{
    [self show];
    [self.netWorkManager getTeacherList:[RRTManager manager].loginManager.loginInfo.tokenId
                              teacherId:[RRTManager manager].loginManager.loginInfo.userId
                                success:^(NSMutableArray *data) {
                                    [self dismiss];
                                    [self gotoUpdataUI:data];
        
    } failed:^(NSString *errorMSG) {
        [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:errorMSG];
        
    }];
}

#pragma mark -- 获取教师列表
- (void)gotoUpdataUI:(NSMutableArray *)data
{
    if (data) {
        [self.teacherCounts removeAllObjects];
        
        [self.teacherCounts addObjectsFromArray:[self chineseCharacterSort1:data]];
        
        for (int i = 0; i < [self.teacherCounts count]; i ++) {
            CurrentTeacher *obj =( (ChineseString*)[self.teacherCounts objectAtIndex:i]).cste;
            [self.teacherIdArray addObject:[NSString stringWithFormat:@"%lld",obj.TeacherId]];
            [self.buttonStatedic setObject:[NSNumber numberWithInt:0] forKey:[NSNumber numberWithInt:i]];
        }
        self.mainCollectionView.hidden = NO;
        [self.mainCollectionView reloadData];
    }
}
#pragma mark -- 排序
- (NSMutableArray *)chineseCharacterSort1:(NSMutableArray *)array
{
    // 排序
    NSMutableArray *chineseStringsArray=[NSMutableArray array];
    for(int i=0;i<[array count];i++){
        ChineseString *chineseString=[[ChineseString alloc]init];
        CurrentTeacher* cste=[array objectAtIndex:i];
        chineseString.string=[NSString stringWithString:cste.TeacherName];
        if(chineseString.string==nil){
            chineseString.string=@"";
        }
        
        if(![chineseString.string isEqualToString:@""]){
            NSString *pinYinResult=[NSString string];
            for(int j=0;j<chineseString.string.length;j++){
                NSString *singlePinyinLetter=[[NSString stringWithFormat:@"%c",pinyinFirstLetter([chineseString.string characterAtIndex:j])]uppercaseString];
                
                pinYinResult=[pinYinResult stringByAppendingString:singlePinyinLetter];
            }
            chineseString.pinYin=pinYinResult;
        }else{
            chineseString.pinYin=@"";
        }
        chineseString.cste=cste;
        [chineseStringsArray addObject:chineseString];
    }
    
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"pinYin" ascending:YES]];
    [chineseStringsArray sortUsingDescriptors:sortDescriptors];
    
    return chineseStringsArray;
    
}

#pragma mark -- 下一步之前判断

- (BOOL)validateTheGoto
{
    BOOL b = NO;// 先设置全部未选中
    for (int i = 0; i < [self.teacherCounts count]; i++) {
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
        [self.navigationController pushViewController:SendTeacherVCID
                                       withStoryBoard:DeskStoryBoardName
                                            withBlock:^(UIViewController *viewController) {
                                                SendTeacherViewController *VC = (SendTeacherViewController *)viewController;
                                                VC.teacherIdArray = [[NSMutableArray alloc] init];
                                                
                                                for (int i = 0; i < [self.teacherCounts count]; i++) {
                                                    
                                                    BOOL tempb=[[self.buttonStatedic objectForKey:[NSNumber numberWithInt:i]] boolValue];
                                                    
                                                    if (tempb) {
                                                        NSString *info = [self.teacherIdArray objectAtIndex:i];
                                                        [VC.teacherIdArray addObject:info];
                                                    }
                                                    
                                                }                                                
                                            }];
    }
    
}
#pragma mark -- 全选

- (IBAction)clickAllButton:(UIButton *)sender {
    [self.allButton setImage:[UIImage imageNamed:@"已选"] forState:UIControlStateNormal];
    self.allButton.tag = 1;
    
    [self.turnOverButton setImage:[UIImage imageNamed:@"未选"] forState:UIControlStateNormal];
    self.turnOverButton.tag = 0;
    
    for (int i = 0; i < [self.teacherCounts count]; i++) {
        NSIndexPath* path=[NSIndexPath indexPathForRow:(NSInteger)i inSection:0];
        TeacherCell *cell = (TeacherCell *)[self.mainCollectionView cellForItemAtIndexPath:path];
        UIButton *chooseButton = cell.checkBoxButton;
        [chooseButton setImage:[UIImage imageNamed:@"已选"] forState:UIControlStateNormal];
        [self.buttonStatedic setObject:[NSNumber numberWithInt:1] forKey:[NSNumber numberWithInt:i]];
    }
}

#pragma -- 反选
- (IBAction)clickTurnOverButton:(UIButton *)sender {
    [self.turnOverButton setImage:[UIImage imageNamed:@"已选"] forState:UIControlStateNormal];
    self.turnOverButton.tag = 1;
    
    [self.allButton setImage:[UIImage imageNamed:@"未选"] forState:UIControlStateNormal];
    self.allButton.tag = 0;
    
    for (int i = 0; i < [self.teacherCounts count]; i++) {
        NSIndexPath* path=[NSIndexPath indexPathForRow:(NSInteger)i inSection:0];
        TeacherCell *cell = (TeacherCell *)[self.mainCollectionView cellForItemAtIndexPath:path];
        UIButton *chooseButton = cell.checkBoxButton;
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

#pragma mark -- UICollectionViewDataSourceAndDelegate

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个section的item个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.teacherCounts count];
}

//每个UICollectionView展示的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TeacherCell *cell = (TeacherCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"TeacherCell" forIndexPath:indexPath];
    
    UIButton *chooseButton = cell.checkBoxButton;
    chooseButton.tag=indexPath.row;
    [chooseButton addTarget:self action:@selector(clickChooseButton:) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.teacherCounts && [self.teacherCounts count] > 0) {
        
        CurrentTeacher *obj =( (ChineseString*)[self.teacherCounts objectAtIndex:indexPath.row]).cste;
        if (obj.UserService == -1 || obj.UserService == 1) {
            cell.teacherName.textColor = [UIColor redColor];
            chooseButton.hidden = YES;
        } else{
            cell.teacherName.textColor = [UIColor blackColor];
            chooseButton.hidden = NO;
            
        }
        cell.teacherName.text = obj.TeacherName;

    } else{
        cell.teacherName.text = @"";
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

#pragma mark -- collectionViewCell按钮响应
- (void)clickChooseButton:(UIButton *)sender{
    BOOL b=[[self.buttonStatedic objectForKey:[NSNumber numberWithInt:sender.tag]] boolValue];
    if (!b) {
        [sender setImage:[UIImage imageNamed:@"已选"] forState:UIControlStateNormal];
        [self.buttonStatedic setObject:[NSNumber numberWithInt:1] forKey:[NSNumber numberWithInt:sender.tag]];
        BOOL isallchecked=YES;
        for (int i = 0; i < [self.teacherCounts count]; i++) {
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
