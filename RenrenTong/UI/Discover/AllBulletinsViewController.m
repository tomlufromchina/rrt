//
//  AllBulletinsViewController.m
//  RenrenTong
//
//  Created by 符其彬 on 15/3/31.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "AllBulletinsViewController.h"
#import "AllBulletinsDetailsViewController.h"
#import "AllBulletinsCell.h"
#import "MJRefresh.h"

@interface AllBulletinsViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    BOOL isTransformation;
    NSMutableArray *redundantArray;
    int selectionCount;
    NSString *bulletinStrID;// 拼接后得公告ID
    BOOL allSelectButton;

}
@property (nonatomic, strong) NetWorkManager *netWorkManager;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) NSMutableArray *myClassBulletinArray;//班级公告数据源
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@property (nonatomic, strong) NSMutableArray *bulletinsIDArray;
@property (nonatomic, strong) NSMutableArray *tempBulletinsIDArray;

@end

@implementation AllBulletinsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"所有公告";
    
    self.netWorkManager = [[NetWorkManager alloc] init];
    selectionCount = 0;
    self.pageIndex = 1;
    self.pageSize = 10;
    self.allElectsButton.tag = 0;
    
    self.mainTableView.dataSource = self;
    self.mainTableView.delegate = self;
    
    //上拉刷新和下拉加载更多
    [self setupRefresh];
    
    //right button
    _rightButton = [[UIButton alloc]initWithFrame:CGRectMake(10,0,50,50)];
    _rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [_rightButton setTitle:@"删除" forState:UIControlStateNormal];
    [_rightButton setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
    [_rightButton addTarget:self action:@selector(addActions:)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:_rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    // 工具栏
    self.toolView.layer.borderWidth = 1;
    self.toolView.layer.borderColor = [[UIColor groupTableViewBackgroundColor] CGColor];
    self.allElectsButton.layer.borderWidth = 1;
    self.allElectsButton.layer.borderColor = [theLoginButtonColor CGColor];
    self.allElectsButton.layer.cornerRadius = 3.0f;
    self.deleteButton.layer.cornerRadius = 3.0f;
    
    self.myClassBulletinArray = [NSMutableArray array];
    self.bulletinsIDArray = [NSMutableArray array];
    self.tempBulletinsIDArray = [NSMutableArray array];
    redundantArray = [NSMutableArray array];
    
    if ([self.mainTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.mainTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.mainTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.mainTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    [self requestData:self.classID];
    
}

#pragma mark -- 刷新
#pragma mark --
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.mainTableView addHeaderWithTarget:self action:@selector(headerReresh)];
    [self.mainTableView addFooterWithTarget:self action:@selector(footerReresh)];
}

#pragma mark -- 数据请求
#pragma mark --

- (void)requestData:(NSString *)classID
{
 
    [self show];
    [self.netWorkManager myClassBulletin:self.classID
                                pagesize:self.pageSize
                               pageindex:self.pageIndex
                                 success:^(NSMutableArray *data) {
                                     [self dismiss];
                                     if (data && [data count]) {
                                         [self updateView:data];
                                     }
                                 } failed:^(NSString *errorMSG) {
                                     [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:errorMSG];
                                 }];
}

#pragma mark - 上拉刷新和下拉加载
#pragma mark -
- (void)headerReresh
{
    __weak AllBulletinsViewController *_self = self;
    [self show];
    self.pageIndex = 1;
    [self.netWorkManager myClassBulletin:self.classID
                                pagesize:self.pageSize
                               pageindex:self.pageIndex
                                 success:^(NSMutableArray *data) {
                                     [self dismiss];
                                     [self.myClassBulletinArray removeAllObjects];
                                     if (data && [data count]) {
                                         [self updateView:data];
                                         [_self.mainTableView headerEndRefreshing];

                                     }
                                 } failed:^(NSString *errorMSG) {
                                     [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:errorMSG];
                                     [_self.mainTableView headerEndRefreshing];

                                 }];
}

- (void)footerReresh
{
    __weak AllBulletinsViewController *_self = self;
    [self show];
    
    [self.netWorkManager myClassBulletin:self.classID
                                pagesize:self.pageSize
                               pageindex:self.pageIndex
                                 success:^(NSMutableArray *data) {
                                     [self dismiss];
                                     if (data && [data count]) {
                                         [self updateView:data];
                                         [_self.mainTableView footerEndRefreshing];
                                     }
                                 } failed:^(NSString *errorMSG) {
                                     [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:errorMSG];
                                     [_self.mainTableView footerEndRefreshing];
                                     
                                 }];
}

#pragma mark -- 刷新界面
#pragma mark --

- (void)updateView:(NSMutableArray *)data
{
    [self.myClassBulletinArray removeAllObjects];
    [self.bulletinsIDArray removeAllObjects];
    [self.tempBulletinsIDArray removeAllObjects];
    if (data) {
        for(int i = 0; i < [data count]; i ++) {
            MyClassListsBulletin *MB = [data objectAtIndex:i];
            [self.myClassBulletinArray addObject:MB];
            [self.bulletinsIDArray addObject:MB.ArchiveId];// 添加公告ID
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setValue:@"NO" forKey:@"checked"];
            [redundantArray addObject:dic];
        }
        self.pageIndex ++;
        [self.mainTableView reloadData];
    }
}

#pragma mark -- 删除、完成按钮响应
#pragma mark --

- (void)addActions:(UIButton *)sender
{
    NSArray *anArrayOfIndexPath = [NSArray arrayWithArray:[self.mainTableView indexPathsForVisibleRows]];
    for (int i = 0; i < [anArrayOfIndexPath count]; i++) {
        NSIndexPath *indexPath= [anArrayOfIndexPath objectAtIndex:i];
        AllBulletinsCell *cell = (AllBulletinsCell*)[self.mainTableView cellForRowAtIndexPath:indexPath];
        NSMutableDictionary *dic = [redundantArray objectAtIndex:[indexPath row]];
        if ([[[(UIButton*)sender titleLabel] text] isEqualToString:@"删除"]){
            [UIView animateWithDuration:0.5f animations:^{
                cell.m_checkImageView.frame = CGRectMake(9, 42, 19, 19);
                cell.backGroupView.frame = CGRectMake(cell.m_checkImageView.right + 10, 0, 285, 104);
                if (SCREENHEIGHT == 480) {
                    self.mainTableView.height = 430;
                    self.toolView.top = 430;
                } else{
                    self.mainTableView.height = 518;
                    self.toolView.top = 518;
                }
            }];
        } else{
            [UIView animateWithDuration:0.5f animations:^{
                cell.m_checkImageView.frame = CGRectMake(-19, 42, 19, 19);
                cell.backGroupView.frame = CGRectMake(8, 0, 285, 104);
                if (SCREENHEIGHT == 480) {
                    self.mainTableView.height = 480;
                    self.toolView.top = 480;
                } else{
                    self.mainTableView.height = 568;
                    self.toolView.top = 568;
                }
            }];
        }
        [dic setObject:@"NO" forKey:@"checked"];
        [cell setChecked:NO];
        self.selectionLabel.text = @"已选(0)";
        selectionCount = 0;
        [self.mainTableView reloadData];
    }
    if ([[[(UIButton*)sender titleLabel] text] isEqualToString:@"删除"]){
        [(UIButton*)sender setTitle:@"完成" forState:UIControlStateNormal];
    }else{
        [(UIButton*)sender setTitle:@"删除" forState:UIControlStateNormal];
    }

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 105;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.myClassBulletinArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"AllBulletinsCell";
    //自定义cell类
    AllBulletinsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        //通过xib的名称加载自定义的cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"AllBulletinsCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    MyClassListsBulletin *MB = [self.myClassBulletinArray objectAtIndex:indexPath.row];
    cell.commentTitleLabel.text = MB.ArchiveTitle;
    cell.commentLabel.text = MB.ArchiveText;
    cell.readingLabel.text = [NSString stringWithFormat:@"阅读(%@)",MB.HitCount];
    cell.timeLabel.text = MB.PubTime;
    [cell.clickCellButton addTarget:self action:@selector(clickWhichCell:) forControlEvents:UIControlEventTouchUpInside];
    NSMutableDictionary *dic = [redundantArray objectAtIndex:[indexPath row]];
    if ([[dic objectForKey:@"checked"] isEqualToString:@"NO"]) {
        [dic setObject:@"NO" forKey:@"checked"];
        [cell setChecked:NO];
    }else {
        [dic setObject:@"YES" forKey:@"checked"];
        [cell setChecked:YES];
    }
    if ([[[_rightButton titleLabel] text] isEqualToString:@"完成"]){
        cell.m_checkImageView.frame = CGRectMake(9, 42, 19, 19);
        cell.backGroupView.frame = CGRectMake(cell.m_checkImageView.right + 10, 0, 285, 104);
    } else{
        cell.m_checkImageView.frame = CGRectMake(-19, 42, 19, 19);
        cell.backGroupView.frame = CGRectMake(8, 0, 285, 104);
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath

{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark -- 点击哪一个Cell
#pragma mark --

- (void)clickWhichCell:(UIButton *)sender
{
    //点击哪一行？
    CGPoint hitPoint = [sender convertPoint:CGPointZero toView:self.mainTableView];
    NSIndexPath *indexPath = [self.mainTableView indexPathForRowAtPoint:hitPoint];
    //将其保存
    self.selectedIndexPath = indexPath;
    NSArray *array = [self.mainTableView indexPathsForSelectedRows];
//    int count = [array count];
    if ([[[_rightButton titleLabel] text] isEqualToString:@"完成"]){
        AllBulletinsCell *cell = (AllBulletinsCell*)[self.mainTableView cellForRowAtIndexPath:indexPath];
        NSMutableDictionary *dic = [redundantArray objectAtIndex:[indexPath row]];
        if ([[dic objectForKey:@"checked"] isEqualToString:@"NO"]) {
            [dic setObject:@"YES" forKey:@"checked"];
            [cell setChecked:YES];
            
            if (!allSelectButton) {// 判断是否点击全选按钮
                // 判断tempBulletinsIDArray是否含有bulletinsIDArray里面的元素
                NSString *str = [self.bulletinsIDArray objectAtIndex:self.selectedIndexPath.row];
                if (self.tempBulletinsIDArray && [self.tempBulletinsIDArray count] > 0) {
                    for (int i = 0; i < [self.tempBulletinsIDArray count]; i ++) {
                        NSString *tempBulletinsID = self.tempBulletinsIDArray[i];
                        for (int j = 0; j < [self.bulletinsIDArray count]; j ++) {
                            NSString *tempBulletinsID1 = self.bulletinsIDArray[j];
                            if (![tempBulletinsID isEqualToString:tempBulletinsID1] && [str isEqualToString:tempBulletinsID1]) {
                                [self.tempBulletinsIDArray addObject:str];
                                break;
                            }
                        }
                        break;
                    }
                } else{
                    [self.tempBulletinsIDArray addObject:[self.bulletinsIDArray objectAtIndex:self.selectedIndexPath.row]];
                }
                selectionCount ++;
                
            } else{
                // 判断tempBulletinsIDArray是否含有bulletinsIDArray里面的元素
                NSString *str = [self.bulletinsIDArray objectAtIndex:self.selectedIndexPath.row];
                if (self.tempBulletinsIDArray && [self.tempBulletinsIDArray count] > 0) {
                    for (int i = 0; i < [self.tempBulletinsIDArray count]; i ++) {
                        NSString *tempBulletinsID = self.tempBulletinsIDArray[i];
                        for (int j = 0; j < [self.bulletinsIDArray count]; j ++) {
                            NSString *tempBulletinsID1 = self.bulletinsIDArray[j];
                            if (![tempBulletinsID isEqualToString:tempBulletinsID1] && [str isEqualToString:tempBulletinsID1]) {
                                [self.tempBulletinsIDArray addObject:str];
                                break;
                            }
                        }
                        break;
                    }
                }
                selectionCount ++;
                if (selectionCount == [self.myClassBulletinArray count]) {
                    [self.allElectsButton setTitle:@"取消" forState:UIControlStateNormal];
                }
            }
        } else{
            if (allSelectButton) {
                [self.tempBulletinsIDArray removeObjectAtIndex:self.selectedIndexPath.row];
                [dic setObject:@"NO" forKey:@"checked"];
                [cell setChecked:NO];
                selectionCount --;
                [self.allElectsButton setTitle:@"全选" forState:UIControlStateNormal];
            } else{
                [dic setObject:@"NO" forKey:@"checked"];
                [cell setChecked:NO];
                selectionCount --;
            }
        }
        self.selectionLabel.text = [NSString stringWithFormat:@"已选(%d)",selectionCount];
        // 判断删除按钮背景颜色
        if ((![self.selectionLabel.text isEqualToString:@"已选(0)"])) {
            self.deleteButton.backgroundColor = theLoginButtonColor;
            [self.deleteButton setEnabled:YES];
        } else{
            self.deleteButton.backgroundColor = [UIColor lightGrayColor];
            [self.deleteButton setEnabled:NO];
        }
        
        [self.mainTableView reloadData];// 防止不能滑动
        
    } else{// 看详情
        [self.navigationController pushViewController:AllBulletinsDetailsVCID
                                       withStoryBoard:DiscoverStoryBoardName
                                            withBlock:^(UIViewController *viewController) {
                                                AllBulletinsDetailsViewController *vc = (AllBulletinsDetailsViewController*)viewController;
                                                MyClassListsBulletin *MB = [self.myClassBulletinArray objectAtIndex:self.selectedIndexPath.row];
                                                vc.titleStr = MB.ArchiveTitle;
                                                vc.commentStr = MB.ArchiveText;
                                                vc.readingStr = MB.HitCount;
                                                vc.timeStr = MB.PubTime;
                                            }];
    }
    
}

#pragma mark -- 删除按钮响应
#pragma mark --

- (IBAction)clickDeleteButton:(UIButton *)sender
{
    [self showWithStatus:@"删除公告中..."];
    if (self.tempBulletinsIDArray && [self.tempBulletinsIDArray count] > 0) {
        // 拼接公告ID
        bulletinStrID = self.tempBulletinsIDArray[0];
        for (int i = 1; i < [self.tempBulletinsIDArray count]; i ++) {
            NSString *tempStr = [NSString stringWithFormat:@",%@",self.tempBulletinsIDArray[i]];
            bulletinStrID = [bulletinStrID stringByAppendingString:tempStr];
        }
        [self.netWorkManager deleteBulletinOrArticle:bulletinStrID
                                             success:^(NSString *data) {
                                                 [self requestData:self.classID];// 刷新界面
                                                 // 重新至成未选状态
                                                 NSArray *anArrayOfIndexPath = [NSArray arrayWithArray:[self.mainTableView indexPathsForVisibleRows]];
                                                 for (int i = 0; i < [anArrayOfIndexPath count]; i++) {
                                                     NSIndexPath *indexPath= [anArrayOfIndexPath objectAtIndex:i];
                                                     AllBulletinsCell *cell = (AllBulletinsCell*)[self.mainTableView cellForRowAtIndexPath:indexPath];
                                                     NSMutableDictionary *dic = [redundantArray objectAtIndex:[indexPath row]];
                                                     [dic setObject:@"NO" forKey:@"checked"];
                                                     [cell setChecked:NO];
                                                     [self addActions:self.rightButton];// 恢复原来状态
                                                     
                                                 }
                                                 [self.tempBulletinsIDArray removeAllObjects];
                                                 [self.allElectsButton setTitle:@"全选" forState:UIControlStateNormal];
                                                 [self showImage:[UIImage imageNamed:@"confirm-ok72.png"] status:@"删除成功..."];
                                                 self.block();
                                             } failed:^(NSString *errorMSG) {
                                                 [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"删除失败..."];
                                                 
                                             }];
    }
}

#pragma mark -- 全选按钮响应
#pragma mark --

- (IBAction)clickAllElectsButton:(UIButton *)sender
{
    if ([[[(UIButton*)sender titleLabel] text] isEqualToString:@"全选"]){
        [self.tempBulletinsIDArray addObjectsFromArray:self.bulletinsIDArray];
        for (NSDictionary *dic in redundantArray) {
            [dic setValue:@"YES" forKey:@"checked"];
        }
        [(UIButton*)sender setTitle:@"取消" forState:UIControlStateNormal];
    }else{
        [self.tempBulletinsIDArray removeAllObjects];
        for (NSDictionary *dic in redundantArray) {
            [dic setValue:@"NO" forKey:@"checked"];
        }
        [(UIButton*)sender setTitle:@"全选" forState:UIControlStateNormal];
    }
    NSArray *anArrayOfIndexPath = [NSArray arrayWithArray:[self.mainTableView indexPathsForVisibleRows]];
    for (int i = 0; i < [anArrayOfIndexPath count]; i++) {
        NSIndexPath *indexPath = [anArrayOfIndexPath objectAtIndex:i];
        AllBulletinsCell *cell = (AllBulletinsCell*)[self.mainTableView cellForRowAtIndexPath:indexPath];
        NSMutableDictionary *dic = [redundantArray objectAtIndex:[indexPath row]];
        if ([[[(UIButton*)sender titleLabel] text] isEqualToString:@"全选"]){
            [cell setChecked:YES];
            [dic setObject:@"YES" forKey:@"checked"];
            self.selectionLabel.text = [NSString stringWithFormat:@"已选(%d)",[self.myClassBulletinArray count]];
            selectionCount = [self.myClassBulletinArray count];
            self.deleteButton.backgroundColor = theLoginButtonColor;
            [self.deleteButton setEnabled:YES];
            allSelectButton = YES;
        } else{
            [cell setChecked:NO];
            [dic setObject:@"NO" forKey:@"checked"];
            self.selectionLabel.text = @"已选(0)";
            selectionCount = 0;
            self.deleteButton.backgroundColor = [UIColor lightGrayColor];
            [self.deleteButton setEnabled:NO];
            allSelectButton = YES;
        }
    }
    [self.mainTableView reloadData];
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
