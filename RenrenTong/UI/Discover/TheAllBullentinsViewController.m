//
//  TheAllBullentinsViewController.m
//  RenrenTong
//
//  Created by 符其彬 on 15/4/4.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "TheAllBullentinsViewController.h"
#import "AllBulletinsDetailsViewController.h"
#import "MJRefresh.h"
#import "TheAllBullentinsCell.h"
#import "MJRefresh.h"
#import "AlbumList.h"

@interface TheAllBullentinsViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
    int selectionCount;
    NSMutableArray* selectflag;
    NSMutableArray *bulletinsIds;// 删除公告id
}
@property (nonatomic, strong) NetWorkManager *netWorkManager;
@property (nonatomic, strong) NSMutableArray *myClassBulletinArray;//班级公告数据源
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, assign) int pageIndex;
@property (nonatomic, assign) int pageSize;
@property (nonatomic, assign) BOOL bEditMode;

@end

@implementation TheAllBullentinsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"所有公告";
    
    self.mainTableView.dataSource = self;
    self.mainTableView.delegate = self;
    self.mainTableView.allowsMultipleSelection = YES;
    
    _rightButton = [[UIButton alloc]initWithFrame:CGRectMake(10,0,50,50)];
    _rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [_rightButton setTitle:@"删除" forState:UIControlStateNormal];
    [_rightButton setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
    [_rightButton addTarget:self action:@selector(clickTheAllElectsButton:)forControlEvents:UIControlEventTouchUpInside];
    _rightButton.tag = 1;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:_rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;

    self.netWorkManager = [[NetWorkManager alloc] init];
    self.pageIndex = 1;
    self.pageSize = 10;
    selectionCount = 0;
    self.bEditMode = NO;
    
    
    self.myClassBulletinArray = [NSMutableArray array];
    selectflag = [[NSMutableArray alloc] init];
    

    //上拉刷新和下拉加载更多
    [self setupRefresh];
    
    // 工具栏
    self.toolView.layer.borderWidth = 1;
    self.toolView.layer.borderColor = [[UIColor groupTableViewBackgroundColor] CGColor];
    self.allElectsButton.layer.borderWidth = 1;
    self.allElectsButton.layer.borderColor = [theLoginButtonColor CGColor];
    self.allElectsButton.layer.cornerRadius = 3.0f;
    self.deleteButton.layer.cornerRadius = 3.0f;
    
    if ([self.mainTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.mainTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.mainTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.mainTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    // 请求数据
    [self requestData];

}

#pragma mark -- 删除、完成按钮响应
#pragma mark --

- (void)clickTheAllElectsButton:(UIButton *)sender
{
    NSArray *anArrayOfIndexPath = [NSArray arrayWithArray:[self.mainTableView indexPathsForVisibleRows]];
    if (sender.tag == 1){
        [sender setTitle:@"完成" forState:UIControlStateNormal];
        NSLog(@"%D",sender.tag);
        sender.tag=2;
        self.bEditMode = YES;
        [self.deleteButton setEnabled:NO];
        for (int i = 0; i < [anArrayOfIndexPath count]; i++) {
            NSIndexPath *indexPath= [anArrayOfIndexPath objectAtIndex:i];
            TheAllBullentinsCell *cell = (TheAllBullentinsCell*)[self.mainTableView cellForRowAtIndexPath:indexPath];
            [UIView animateWithDuration:1 animations:^{
                cell.m_checkImageView.frame = CGRectMake(9, 42, 19, 19);
                cell.backGroupView.frame = CGRectMake(cell.m_checkImageView.right + 10, 0, 285, 104);
            }];
            [[selectflag objectAtIndex:indexPath.section] setObject:[NSNumber numberWithBool:NO] forKey:[NSNumber numberWithInteger:indexPath.row]];
            [cell setChecked:NO];
            self.selectionLabel.text = @"已选(0)";
        }
        self.mainTableView.height=self.mainTableView.height-50;
        self.toolView.top = self.mainTableView.bottom;
    }else if (sender.tag==2){
        [sender setTitle:@"删除" forState:UIControlStateNormal];
        NSLog(@"%D",sender.tag);
        sender.tag=1;
        self.bEditMode = NO;
        [self.deleteButton setEnabled:NO];
        for (int i = 0; i < [anArrayOfIndexPath count]; i++) {
            NSIndexPath *indexPath= [anArrayOfIndexPath objectAtIndex:i];
            TheAllBullentinsCell *cell = (TheAllBullentinsCell*)[self.mainTableView cellForRowAtIndexPath:indexPath];
            [UIView animateWithDuration:1 animations:^{
                cell.m_checkImageView.frame = CGRectMake(-19, 42, 19, 19);
                cell.backGroupView.frame = CGRectMake(8, 0, 285, 104);
            }];
        }
        self.mainTableView.height=self.mainTableView.height+50;
        self.toolView.top = self.mainTableView.bottom;
    }
    [self.mainTableView reloadData];
}

#pragma mark -- 数据请求
#pragma mark --

- (void)requestData
{
//    [self show];
    NSString *url = [NSString stringWithFormat:@"http://nmapi.%@/class/GetNoticeList",aedudomain];
    NSString *pageS = [NSString stringWithFormat:@"%d",self.pageSize];
    NSString *pageI = [NSString stringWithFormat:@"%d",self.pageIndex];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self.classID,@"classId",pageI,@"pageIndex",pageS,@"pageSize",nil];
    [HttpUtil GetWithUrl:url parameters:dic success:^(id json) {
        MyCurrentClassModelBulletin *list = [[MyCurrentClassModelBulletin alloc] initWithString:json error:nil];
        [self dismiss];
        if (list.result == 1) {
            if (self.pageIndex > 1) {
                [self.myClassBulletinArray addObject:list.items];
            }else{
                self.myClassBulletinArray = (NSMutableArray*)list.items;
            }
            [self updateView:self.myClassBulletinArray];
        }else{
            ErrorModel *erromodel = [[ErrorModel alloc] initWithString:json error:nil];
            [self showImage:nil status:erromodel.msg];
        }
        [self endRefresh];
    } fail:^(id errors) {
        [self endRefresh];
        [self showImage:nil status:errors];
    } cache:^(id cache) {
    }];
}

#pragma mark -- 刷新
#pragma mark --
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.mainTableView addHeaderWithTarget:self action:@selector(headerReresh)];
    [self.mainTableView addFooterWithTarget:self action:@selector(footerReresh)];
}

#pragma mark - 上拉刷新和下拉加载
#pragma mark -
-(void)endRefresh
{
    [self.mainTableView headerEndRefreshing];
    [self.mainTableView footerEndRefreshing];
}
- (void)headerReresh
{
    self.pageIndex = 1;
    [self requestData];
}

- (void)footerReresh
{
    [self requestData];
}

#pragma mark -- 刷新界面
#pragma mark --

- (void)updateView:(NSMutableArray *)data
{
    if (data) {
        NSMutableDictionary* flagdic=[NSMutableDictionary dictionaryWithCapacity:[data count]];
        for(int i = 0; i < [data count]; i ++) {
            [flagdic setObject:[NSNumber numberWithBool:NO]
                        forKey:[NSNumber numberWithInt:i]];
            
        }
        [selectflag addObject:flagdic];
        self.pageIndex ++;
        [self.mainTableView reloadData];
    }
    
}

#pragma mark -- 列表代理和数据源方法
#pragma mark --

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
    static NSString *cellIdentifier = @"TheAllBullentinsCell";
    //自定义cell类
    TheAllBullentinsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        //通过xib的名称加载自定义的cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TheAllBullentinsCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (self.myClassBulletinArray && [self.myClassBulletinArray count] > 0) {
        MyCurrentClassModelBulletinitems *MB = [self.myClassBulletinArray objectAtIndex:indexPath.row];
        cell.commentTitleLabel.text = MB.ArchiveTitle;
        cell.commentLabel.text = MB.ArchiveText;
        cell.readingLabel.text = [NSString stringWithFormat:@"阅读(%@)",MB.HitCount];
        cell.timeLabel.text = MB.PubTime;
    }
    
    // 仿重用
    BOOL flag = [[[selectflag objectAtIndex:indexPath.section] objectForKey:[NSNumber numberWithInteger:indexPath.row]] boolValue];
    if (flag) {
        [cell setChecked:YES];
    } else{
        [cell setChecked:NO];
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

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TheAllBullentinsCell *cell = (TheAllBullentinsCell*)[self.mainTableView cellForRowAtIndexPath:indexPath];
    
    if (self.bEditMode) {
        // 仿重用
        BOOL flag = [[[selectflag objectAtIndex:indexPath.section] objectForKey:[NSNumber numberWithInteger:indexPath.row]] boolValue];
        if (flag) {
            [cell setChecked:NO];
            [[selectflag objectAtIndex:indexPath.section] setObject:[NSNumber numberWithBool:NO] forKey:[NSNumber numberWithInteger:indexPath.row]];
            selectionCount --;
        } else{
            [cell setChecked:YES];
            [[selectflag objectAtIndex:indexPath.section] setObject:[NSNumber numberWithBool:YES] forKey:[NSNumber numberWithInteger:indexPath.row]];
            selectionCount ++;
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
    } else{
        [self.navigationController pushViewController:AllBulletinsDetailsVCID
                                       withStoryBoard:DiscoverStoryBoardName
                                            withBlock:^(UIViewController *viewController) {
                                                AllBulletinsDetailsViewController *vc = (AllBulletinsDetailsViewController*)viewController;
                                                MyCurrentClassModelBulletinitems *MB = [self.myClassBulletinArray objectAtIndex:indexPath.row];
                                                vc.titleStr = MB.ArchiveTitle;
                                                vc.commentStr = MB.ArchiveText;
                                                vc.readingStr = MB.HitCount;
                                                vc.timeStr = MB.PubTime;
                                            }];

    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark -- 删除按钮响应
#pragma mark --
- (IBAction)clickDeleteButton:(UIButton *)sender
{
    bulletinsIds = [[NSMutableArray alloc] init];
    for (int k = 0; k < [selectflag count]; k ++) {
        NSMutableDictionary* tempdic = [selectflag objectAtIndex:k];
        for (int r = 0; r < [tempdic count]; r ++) {
            BOOL flag = [[[selectflag objectAtIndex:k] objectForKey:[NSNumber numberWithInteger:r]] boolValue];
            if (flag) {
                MyClassListsBulletin *MB = (MyClassListsBulletin *)[self.myClassBulletinArray objectAtIndex:r];
                [bulletinsIds addObject:MB.ArchiveId];
                
            }
        }
    }
    
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"确定要删除吗？"
                              message:nil
                              delegate:self
                              cancelButtonTitle:@"取消"
                              otherButtonTitles:@"确定", nil];
    [alertView show];
}
#pragma mark -  UIAlertView Delegate
#pragma mark -
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self showWithStatus:@"删除公告中..."];
        
        [self.netWorkManager deleteBulletinOrArticle:bulletinsIds
                                             success:^(NSString *data) {
                                                 
                                                 [self showImage:[UIImage imageNamed:@"confirm-ok72.png"] status:@"删除成功..."];
                                                 [self deleteBulltinsSuccess];
                                             } failed:^(NSString *errorMSG) {
                                                 [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"删除失败..."];
                                                 [self.allElectsButton setTitle:@"全选" forState:UIControlStateNormal];
                                             }];
        
    } else{
        
    }
}

- (void)deleteBulltinsSuccess
{
    [self requestData];// 刷新界面
    [self clickTheAllElectsButton:_rightButton];
    [self.allElectsButton setTitle:@"全选" forState:UIControlStateNormal];
}

#pragma mark --全选按钮响应
#pragma mark --
- (IBAction)clickAllElectsButton:(UIButton *)sender
{
    if ([[[(UIButton*)sender titleLabel] text] isEqualToString:@"全选"]) {
        for (int s = 0; s < [selectflag count]; s ++) {
            NSMutableDictionary* dic = [selectflag objectAtIndex:s];
            for (int r = 0; r < [dic count]; r++) {
                [[selectflag objectAtIndex:s] setObject:[NSNumber numberWithBool:YES] forKey:[NSNumber numberWithInteger:r]];
            }
            self.selectionLabel.text = [NSString stringWithFormat:@"已选(%d)",[dic count]];
            selectionCount = [dic count];
        }
        self.deleteButton.backgroundColor = theLoginButtonColor;
        [self.deleteButton setEnabled:YES];
        [(UIButton*)sender setTitle:@"取消" forState:UIControlStateNormal];
    } else{
        for (int s = 0; s < [selectflag count]; s ++) {
            NSMutableDictionary* dic = [selectflag objectAtIndex:s];
            for (int r = 0; r < [dic count]; r ++) {
                [[selectflag objectAtIndex:s] setObject:[NSNumber numberWithBool:NO] forKey:[NSNumber numberWithInteger:r]];
            }
            self.selectionLabel.text = @"已选(0)";
            selectionCount = 0;
        }
        self.deleteButton.backgroundColor = [UIColor lightGrayColor];
        [self.deleteButton setEnabled:NO];
        [(UIButton*)sender setTitle:@"全选" forState:UIControlStateNormal];
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
