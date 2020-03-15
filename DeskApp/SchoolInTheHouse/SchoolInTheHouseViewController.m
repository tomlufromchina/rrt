//
//  SchoolInTheHouseViewController.m
//  RenrenTong
//
//  Created by 符其彬 on 14-10-22.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "SchoolInTheHouseViewController.h"
#import "SchoolAndHouseCell.h"
#import "OtherSchoolAndHouseCell.h"
#import "MLEmojiLabel.h"
#import "MJRefresh.h"

#import "NetWorkManager+SchoolAndHouse.h"

@interface SchoolInTheHouseViewController ()<UITableViewDataSource,UITableViewDelegate,MLEmojiLabelDelegate,UIActionSheetDelegate>
{
    int recpageIndex;
    int recpageSize;
    int sendpageIndex;
    int sendpageSize;
}
@property (nonatomic, strong) NSMutableArray *emjoalablearray;
@property (nonatomic, strong) NSMutableArray *emjoalableArray1;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *dataSource1;
@property (nonatomic, strong) LXActionSheet *actionSheet;
@property (nonatomic, strong) NetWorkManager *netWorkManager;
@property (nonatomic, assign) BOOL isUpdata;
@property (nonatomic, strong) NSString *roleString;

@property (nonatomic, strong) NSString *role;



@end

@implementation SchoolInTheHouseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.title = @"家校沟通";
    
    recpageIndex = 1;
    recpageSize = 10;
    sendpageIndex=1;
    sendpageSize=10;
    
    
    self.lineView.backgroundColor = appColor;
    [self.getMessageButton setTitleColor:appColor forState:UIControlStateNormal];
    self.mainTableView.dataSource = self;
    self.mainTableView.delegate = self;
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    NSString *Str = [RRTManager manager].loginManager.loginInfo.userRole;
    NSString *roleStr = [NSString stringWithFormat:@"%@",Str];
    if ([roleStr isEqualToString:@"2"]) {
        NSString *string = @"发消息";
        //Add search button
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:string
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(clickMenu)];
        
        
        self.navigationItem.rightBarButtonItem = rightItem;
    } else {
        NSString *string = @"发短信";
        //Add search button
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:string
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(clickMenu)];
        
        
        self.navigationItem.rightBarButtonItem = rightItem;
    }
    
    
    self.netWorkManager = [[NetWorkManager alloc] init];
    self.emjoalablearray = [[NSMutableArray alloc] init];
    self.emjoalableArray1 = [[NSMutableArray alloc] init];
    self.dataSource = [[NSMutableArray alloc] init];
    self.dataSource1 = [[NSMutableArray alloc] init];
    self.isUpdata = YES;
    //上拉刷新和下拉加载更多
    [self setupRefresh];
    [self requestData];
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
- (void)headerReresh
{
    __weak SchoolInTheHouseViewController *_self = self;
    if (self.isUpdata) {
        [self show];
        recpageIndex=1;
//        [self.netWorkManager getMessageCounts:[RRTManager manager].loginManager.loginInfo.tokenId
//                                       userId:[RRTManager manager].loginManager.loginInfo.userId
//                                     userRole:[RRTManager manager].loginManager.loginInfo.userRole
//                                     pageSize:recpageSize
//                                    pageIndex:recpageIndex
//                                      success:^(NSMutableArray *data) {
//                                         [_self dismiss];
//                                         [_self.emjoalablearray removeAllObjects];
//                                         [_self.dataSource removeAllObjects];
//                                         [_self gotoUpdataUI:data];
//                                         [_self.mainTableView headerEndRefreshing];
//                                         
//                                     } failed:^(NSString *errorMSG) {
//                                         [_self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:errorMSG];
//                                         [_self.mainTableView headerEndRefreshing];
//                                         
//                                     }];
    } else {
        [self show];
        sendpageIndex=1;
        [self.netWorkManager getMyselfMessageCounts:[RRTManager manager].loginManager.loginInfo.tokenId
                                             userId:[RRTManager manager].loginManager.loginInfo.userId
                                           pageSize: sendpageSize
                                          pageIndex:sendpageIndex
                                            success:^(NSMutableArray *data) {
                                              [_self dismiss];
                                                [_self.emjoalableArray1 removeAllObjects];
                                              [_self.dataSource1 removeAllObjects];
                                              [_self gotoUpdataUI:data];
                                              [_self.mainTableView headerEndRefreshing];
                                              
                                          } failed:^(NSString *errorMSG) {
                                              [_self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:errorMSG];
                                              [_self.mainTableView headerEndRefreshing];
                                          }];
        
    }
    
}

- (void)footerReresh
{
    __weak SchoolInTheHouseViewController *_self = self;
    if (self.isUpdata) {
        [self show];
//        [self.netWorkManager getMessageCounts:[RRTManager manager].loginManager.loginInfo.tokenId
//                                       userId:[RRTManager manager].loginManager.loginInfo.userId
//                                     userRole:[RRTManager manager].loginManager.loginInfo.userRole
//                                     pageSize:recpageSize
//                                    pageIndex:recpageIndex
//                                      success:^(NSMutableArray *data) {
////                                         [_self dismiss];
//                                         [_self gotoUpdataUI:data];
//                                         [_self.mainTableView footerEndRefreshing];
//                                         
//                                     } failed:^(NSString *errorMSG) {
//                                         [_self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:errorMSG];
//                                         [_self.mainTableView footerEndRefreshing];
//                                         
//                                     }];
        
    } else {
        [self show];
        [self.netWorkManager getMyselfMessageCounts:[RRTManager manager].loginManager.loginInfo.tokenId
                                             userId:[RRTManager manager].loginManager.loginInfo.userId
                                           pageSize: sendpageSize
                                          pageIndex:sendpageIndex
                                            success:^(NSMutableArray *data) {
//                                              [_self dismiss];
                                              [_self gotoUpdataUI:data];
                                              [_self.mainTableView footerEndRefreshing];
                                              
                                          } failed:^(NSString *errorMSG) {
                                              [_self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:errorMSG];
                                              [_self.mainTableView footerEndRefreshing];
                                          }];
        
    }
    
}

#pragma mark --数据解析
#pragma mark --

- (void)requestData
{
    if (self.isUpdata) {
        [self.emjoalablearray removeAllObjects];
        [self show];
//        [self.netWorkManager getMessageCounts:[RRTManager manager].loginManager.loginInfo.tokenId
//                                       userId:[RRTManager manager].loginManager.loginInfo.userId
//                                     userRole:[RRTManager manager].loginManager.loginInfo.userRole
//                                     pageSize:recpageSize
//                                    pageIndex:recpageIndex success:^(NSMutableArray *data) {
//                                        
//                                        [self gotoUpdataUI:data];
//                                        
//                                    } failed:^(NSString *errorMSG) {
//                                        
//                                        [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:errorMSG];
//                                    }];
    } else{
        
        [self show];
        [self.emjoalableArray1 removeAllObjects];
        [self.netWorkManager getMyselfMessageCounts:[RRTManager manager].loginManager.loginInfo.tokenId
                                             userId:[RRTManager manager].loginManager.loginInfo.userId
                                           pageSize:sendpageSize
                                          pageIndex:sendpageIndex
                                            success:^(NSMutableArray *data) {
                                                [self dismiss];
                                                
                                                [self gotoUpdataUI:data];
                                                
                                            } failed:^(NSString *errorMSG) {
                                                [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:errorMSG];
                                            }];
    }
    

}

#pragma mark -- 刷新界面
#pragma mark --

- (void)gotoUpdataUI:(NSMutableArray *)data
{
    if (data) {
        if (self.isUpdata) {
            for(int i = 0; i < [data count]; i ++) {
                
                GetMessage *GMObjects = (GetMessage *)[data objectAtIndex:i];
                
                [self.emjoalablearray addObject:[self createLableWithText:GMObjects.MsgContent
                                                                     font:[UIFont systemFontOfSize:15]
                                                                    width:SCREENWIDTH - 20]];
                [self.dataSource addObject:GMObjects];
            }
            
            [self.mainTableView reloadData];
            recpageIndex++;
            
        } else {
            for(int i = 0; i < [data count]; i ++) {
                
                SendMessage *GMObjects = (SendMessage *)[data objectAtIndex:i];
                
                [self.emjoalableArray1 addObject:[self createLableWithText:GMObjects.MsgContent
                                                                     font:[UIFont systemFontOfSize:15]
                                                                    width:SCREENWIDTH - 20]];
                [self.dataSource1 addObject:GMObjects];
            }
            [self.mainTableView reloadData];
            sendpageIndex++;
        }
    }
    [self dismiss];
    
}

- (void)clickMenu
{
    NSString *Str = [RRTManager manager].loginManager.loginInfo.userRole;
    NSString *roleStr = [NSString stringWithFormat:@"%@",Str];
    if ([roleStr isEqualToString:@"2"]) {
//        self.actionSheet = [[LXActionSheet alloc]initWithTitle:nil
//                                                      delegate:self
//                                             cancelButtonTitle:@"取消"
//                                        destructiveButtonTitle:nil
//                                             otherButtonTitles:@[@"给教师发送"]];
//        [self.actionSheet showInView:self.view];
        
        UIActionSheet* sheet = [[UIActionSheet alloc] initWithTitle:nil
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                             destructiveButtonTitle:nil
                                                  otherButtonTitles:nil];
        [sheet addButtonWithTitle:@"给教师发送"];
        [sheet addButtonWithTitle:@"取消"];
        sheet.cancelButtonIndex = 1;
        [sheet showInView:self.view];

        
    } else {
//        self.actionSheet = [[LXActionSheet alloc]initWithTitle:nil
//                                                      delegate:self
//                                             cancelButtonTitle:@"取消"
//                                        destructiveButtonTitle:nil
//                                             otherButtonTitles:@[@"给群组个别成员发送",@"给群组发送",@"给个别家长发送",@"给班级发送",@"给教师发送"]];
//        [self.actionSheet showInView:self.view];
        
        NSArray *titleArray = @[@"给群组个别成员发送",@"给群组发送",@"给个别家长发送",@"给班级发送",@"给教师发送"];
        UIActionSheet* sheet = [[UIActionSheet alloc] initWithTitle:nil
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                             destructiveButtonTitle:nil
                                                  otherButtonTitles:nil];
        
        for(int i = 0; i < [titleArray count]; i++)
        {
            [sheet addButtonWithTitle:titleArray[i]];
        }
        [sheet addButtonWithTitle:@"取消"];
        sheet.cancelButtonIndex = [titleArray count];
        [sheet showInView:self.view];
        
    }
}

#pragma mark -- UIActionSheetDelegate
#pragma mark --

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    int i = (int)buttonIndex;
    NSString *Str = [RRTManager manager].loginManager.loginInfo.userRole;
    NSString *roleStr = [NSString stringWithFormat:@"%@",Str];
    switch (i) {
        case 0:
        {
            if ([roleStr isEqualToString:@"2"]) {
                [self.navigationController pushViewController:@"ContactTableViewController"
                                               withStoryBoard:MainStoryBoardName
                                                    withBlock:nil];
            } else{
                [self.navigationController pushViewController:GroupSeveralVCID
                                               withStoryBoard:DeskStoryBoardName
                                                    withBlock:nil];
            }
        }
            break;
        case 1:
        {
            if ([roleStr isEqualToString:@"2"]) {
                return;
                
            } else{
                
                [self.navigationController pushViewController:GroupSendVCID
                                               withStoryBoard:DeskStoryBoardName
                                                    withBlock:nil];
            }
        }
            break;
        case 2:
        {
            [self.navigationController pushViewController:SeveralParentsVCID
                                           withStoryBoard:DeskStoryBoardName
                                                withBlock:nil];
        }
            break;
        case 3:
        {
            [self.navigationController pushViewController:ClassViewVCID
                                           withStoryBoard:DeskStoryBoardName
                                                withBlock:nil];
            
        }
            
            break;
        case 4:
        {
            
            [self.navigationController pushViewController:TeacherVCID
                                           withStoryBoard:DeskStoryBoardName
                                                withBlock:nil];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - LXActionSheetDelegate

//- (void)didClickOnButtonIndex:(NSInteger *)buttonIndex
//{
//    int i = (int)buttonIndex;
//    NSString *Str = [RRTManager manager].loginManager.loginInfo.userRole;
//    NSString *roleStr = [NSString stringWithFormat:@"%@",Str];
//    switch (i) {
//        case 0:
//        {
//            if ([roleStr isEqualToString:@"2"]) {
//                [self.navigationController pushViewController:@"ContactTableViewController"
//                                               withStoryBoard:MainStoryBoardName
//                                                    withBlock:nil];
//            } else{
//                [self.navigationController pushViewController:GroupSeveralVCID
//                                               withStoryBoard:DeskStoryBoardName
//                                                    withBlock:nil];
//            }
//            
//        }
//            break;
//        case 1:
//        {
//            if ([roleStr isEqualToString:@"2"]) {
//                return;
//                
//            } else{
//                
//                [self.navigationController pushViewController:GroupSendVCID
//                                               withStoryBoard:DeskStoryBoardName
//                                                    withBlock:nil];
//            }
//            
//        }
//            break;
//        case 2:
//        {
//            [self.navigationController pushViewController:SeveralParentsVCID
//                                           withStoryBoard:DeskStoryBoardName
//                                                withBlock:nil];
//        }
//            break;
//        case 3:
//        {
//            [self.navigationController pushViewController:ClassViewVCID
//                                           withStoryBoard:DeskStoryBoardName
//                                                withBlock:nil];
//        }
//            break;
//        case 4:
//        {
//            NSString *role = [NSString stringWithFormat:@"%@",self.roleString];
//            if ([role isEqualToString:@"6"]) {
//                
//                [self.navigationController pushViewController:TeacherVCID
//                                               withStoryBoard:DeskStoryBoardName
//                                                    withBlock:nil];
//                
//            } else{
//                [self showWithTitle:@"只能学校领导才能给教师发送信息" withTime:2.0f];
//            }
//            
//            
//        }
//            break;
//        default:
//            break;
//    }
//}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isUpdata) {
        return [self.emjoalablearray count];
    } else{
        return [self.emjoalableArray1 count];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    if (self.isUpdata) {
        height = 30;
        height += ((MLEmojiLabel*)[self.emjoalablearray objectAtIndex:indexPath.row]).height;
        height += 10;
        return height;
    } else{
        if (self.emjoalableArray1 && [self.emjoalableArray1 count] > 0) {
            height = 30;
            height += ((MLEmojiLabel*)[self.emjoalableArray1 objectAtIndex:indexPath.row]).height;
            height += 10;
            
        }
    }
    return height;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.isUpdata) {
        
        static NSString *cellIdentifier = @"SchoolAndHouseCell";
        SchoolAndHouseCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"SchoolAndHouseCell" owner:self options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        if (indexPath.row % 2 == 0) {
            cell.backgroundColor = [UIColor whiteColor];
        } else {
            cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
        }
        
        //防止重用问题
        UIView *emjoView = (UIView *)[cell viewWithTag:103];
        if (emjoView) {
            [emjoView removeFromSuperview];
        }
        
        cell.content = [self.emjoalablearray objectAtIndex:indexPath.row];
        cell.content.top = 10;
        cell.content.left = 10;
        cell.content.tag = 103;
        [cell addSubview:[self.emjoalablearray objectAtIndex:indexPath.row]];
        
        GetMessage *GMObjects = [self.dataSource objectAtIndex:indexPath.row];
        
        UILabel *author = (UILabel *)[cell viewWithTag:101];
        UILabel *creatTime = (UILabel *)[cell viewWithTag:102];
        author.text = [NSString stringWithFormat:@"发信人：%@",GMObjects.CreateBy];
        creatTime.text = GMObjects.CreateTime;
//        creatTime.text = [NSString stringWithFormat:@"时间：%@",@"暂无"];
        
        author.top = cell.content.bottom + 5;
        creatTime.top = cell.content.bottom + 5;
        
        return cell;
        
    } else{
        
        static NSString *cellIdentifier = @"sendMessageCell";
        OtherSchoolAndHouseCell *myCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (myCell == nil) {
            myCell = [[[NSBundle mainBundle] loadNibNamed:@"sendMessageCell" owner:self options:nil] lastObject];
            myCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        if (indexPath.row % 2 == 0) {
            myCell.backgroundColor = [UIColor whiteColor];
        } else {
            myCell.backgroundColor = [UIColor groupTableViewBackgroundColor];
        }
        
        //防止重用问题
        UIView *emjoView = (UIView *)[myCell viewWithTag:103];
        if (emjoView) {
            [emjoView removeFromSuperview];
        }
        
        myCell.content = [self.emjoalableArray1 objectAtIndex:indexPath.row];
        myCell.content.top = 10;
        myCell.content.left = 10;
        myCell.content.tag = 103;
        [myCell addSubview:[self.emjoalableArray1 objectAtIndex:indexPath.row]];
        
        SendMessage *GMObjects = [self.dataSource1 objectAtIndex:indexPath.row];
        
        UILabel *author = (UILabel *)[myCell viewWithTag:101];
        UILabel *creatTime = (UILabel *)[myCell viewWithTag:102];
        author.text = [NSString stringWithFormat:@"发信人：%@",GMObjects.CreateBy];
        creatTime.text = GMObjects.CreateTime;
//        creatTime.text = [NSString stringWithFormat:@"时间：%@",@"暂无"];
        
        author.top = myCell.content.bottom + 5;
        creatTime.top = myCell.content.bottom + 5;
        
        return myCell;
        
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark -- 我收到的信息按钮相应方法
#pragma mark --

- (IBAction)clickReceiveButton:(UIButton *)sender
{
    self.isUpdata = YES;
    [self.emjoalablearray removeAllObjects];
    [self.mainTableView reloadData];
    [UIView animateWithDuration:0.5f
                     animations:^{
        self.lineView.left = self.receiveButton.left;
                     }];
    recpageIndex=1;
    [self.getMessageButton setTitleColor:appColor forState:UIControlStateNormal];
    [self.sendMessageButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self requestData];
}

#pragma mark -- 我发出的信息按钮相应方法
#pragma mark -- 

- (IBAction)clickGetButton:(UIButton *)sender
{
    self.isUpdata = NO;
    [self.emjoalableArray1 removeAllObjects];
    [self.mainTableView reloadData];
    [UIView animateWithDuration:0.5f
                     animations:^{
        self.lineView.left = self.getButton.left;
    }];
    sendpageIndex=1;
    [self.getMessageButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.sendMessageButton setTitleColor:appColor forState:UIControlStateNormal];
    [self requestData];
}

#pragma mark emjolable

-(MLEmojiLabel*)createLableWithText:(NSString*)text font:(UIFont*)font  width:(int)width{
    MLEmojiLabel*_emojiLabel= [[MLEmojiLabel alloc]init];
    _emojiLabel.numberOfLines = 0;
    _emojiLabel.font = font;
    _emojiLabel.emojiDelegate = self;
    _emojiLabel.backgroundColor = [UIColor clearColor];
    _emojiLabel.lineBreakMode = NSLineBreakByCharWrapping;
    _emojiLabel.isNeedAtAndPoundSign = YES;
    [_emojiLabel setEmojiText:text];
    _emojiLabel.frame = CGRectMake(0, 0, width, 0);
    [_emojiLabel sizeToFit];
    return _emojiLabel;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self requestGetTeacherRole];
}
#pragma mark -- 获取老师中担当的角色
- (void)requestGetTeacherRole
{
    [self.netWorkManager getTeacherRole:[RRTManager manager].loginManager.loginInfo.tokenId
                              teacherId:[RRTManager manager].loginManager.loginInfo.userId success:^(NSString *data) {
                                  [self dismiss];
                                  [self getTeacherRole:data];
                              } failed:^(NSString *errorMSG) {
                                  [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:errorMSG];
                              }];
    
}
#pragma mark -- 将获取的角色放到全局变量
- (void)getTeacherRole:(NSString *)role
{
    self.roleString = role;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
