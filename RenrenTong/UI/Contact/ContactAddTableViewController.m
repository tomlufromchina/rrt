//
//  ContactAddTableViewController.m
//  RenrenTong
//
//  Created by jeffrey on 14-6-11.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "ContactAddTableViewController.h"
#import "ContactSendVerificationViewController.h"
#import "ContactDetailViewController.h"
#import "ViewControllerIdentifier.h"
#import "AddFriendViewController.h"
#import "ContactSendVerificationViewController.h"
#import "ContactTableViewController.h"
#import "MessageNetService.h"

#import "MJRefresh.h"

@interface ContactAddTableViewController ()

@property (nonatomic, strong) NetWorkManager *netWorkManager;
@property (nonatomic, strong) NSArray *dataSource;//数据源
@property (nonatomic, strong) NSMutableArray *indexs;

@end

@implementation ContactAddTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"新的朋友";
    _netWorkManager = [[NetWorkManager alloc] init];
    [self requestNetWorkNewFriendData];
    
    //Add search button
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"添加"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(addFirend2)];
    
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.indexs = [NSMutableArray array];
    
    //上拉刷新和下拉加载更多
    [self setupRefresh];
}

- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.tableView addHeaderWithTarget:self action:@selector(headerReresh)];
}

/*****新的朋友请求*****/
- (void)requestNetWorkNewFriendData
{
    [self show];
    NSString *url = [NSString stringWithFormat:@"http://home.%@/Api/GetInvitation",aedudomain];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[RRTManager manager].loginManager.loginInfo.userId,@"UserId",nil];
    [HttpUtil GetWithUrl:url parameters:dic success:^(id json) {
        GetInvitation *loginModel = [[GetInvitation alloc] initWithString:json error:nil];
        if (loginModel.st == 0) {
            [self updateUI:loginModel.msg.list];
            [self dismiss];
        } else{
            [self dismiss];
        }
    } fail:^(id errors) {
        [self dismiss];
    } cache:^(id cache) {
        
    }];
//    __weak ContactAddTableViewController *_self = self;
//    
//    [self.netWorkManager newFriends:[RRTManager manager].loginManager.loginInfo.userId success:^(NSArray *newFriend) {
//        [_self dismiss];//请求完，取消菊花
//        
//        if ([newFriend count] == 0) {
//            [_self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"暂时没有新的朋友哦！"];
//
//        }
//        [_self updateUI:newFriend];
//    } failed:^(NSString *errorMSG) {
//        [_self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:errorMSG];
//    }];
}

- (void)updateUI:(NSArray *)data
{
    if (data && [data count] > 0) {
        self.dataSource = [NSArray arrayWithArray:data];
        [self.tableView reloadData];
    }
}

- (void)sendNewFriendObject:(NewFriends *)newFriend
{
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated
{
    self.hidesBottomBarWhenPushed = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self dismiss];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource count];
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContactAddCell"
                                                            forIndexPath:indexPath];
    UIImageView *headImage = (UIImageView *)[cell viewWithTag:1];
    UILabel *name = (UILabel *) [cell viewWithTag:2];
    UILabel *time = (UILabel *) [cell viewWithTag:3];
    UIButton *acceptBtn = (UIButton*)[cell viewWithTag:4];
    UILabel *label = (UILabel*)[cell viewWithTag:6];
    
    GetInvitationMsglist *tmp = [self.dataSource objectAtIndex:indexPath.row];
    
    [headImage setImageWithURL:[NSURL URLWithString:tmp.SenderPictureUrl] placeholderImage:[UIImage imageNamed:@"default"]];
    
    name.text = tmp.SenderUserName;
    if (tmp.Body.length != 0) {
        time.text = [NSString stringWithFormat:@"%@%@",@"验证信息:",[self flattenHTML:tmp.Body]];
    }else{
        time.text = @"没有验证消息哦!";
    }
    
    acceptBtn.layer.cornerRadius = 2.0;
    [acceptBtn addTarget:self action:@selector(acceptFirend:)
        forControlEvents:UIControlEventTouchUpInside];
    acceptBtn.backgroundColor = appColor;
    
    
    /*判断是否是已添加or接受*/
    if ([tmp.TypeId isEqualToString:@"1"]) {
        [acceptBtn setHidden:YES];
        [label setHidden:NO];
    }else {
        [acceptBtn setHidden:NO];
        [label setHidden:YES];
    }
    
    
    return cell;
}

#pragma mark - tableview delegate
#pragma mark -
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NewFriends *tmp = [self.dataSource objectAtIndex:indexPath.row];

    [self.navigationController pushViewController:ChatVCID
                                   withStoryBoard:MessageStoryBoardName
                                        withBlock:^(UIViewController *viewController) {
                                            ChatViewController *vc = (ChatViewController*)viewController;
                                            vc.UserId =tmp.SenderUserId;
                                            vc.UserName=tmp.SenderUserName;
                                        }];
    

}

#pragma mark - 接受
#pragma mark -
- (void)acceptFirend:(UIButton*)button
{
    //获取NSIndexPath和cell上面的每个button
    CGPoint hitPoint = [button convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:hitPoint];
    
    __block GetInvitationMsglist *tmp = (GetInvitationMsglist*)[self.dataSource objectAtIndex:indexPath.row];
    
    //好友添加接受
    
    NSString *type = [NSString stringWithFormat:@"%@", tmp.TypeId];
    if ([type isEqualToString:@"0"]) {
        [self show];
        NSString *url = [NSString stringWithFormat:@"http://home.%@/Api/PostAcceptInvitation",aedudomain];
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:tmp.InvitationId,@"InvitationId",nil];
        [HttpUtil PostWithUrl:url parameters:dic success:^(id json) {
            ErrorModel *result = [[ErrorModel alloc] initWithString:json error:nil];
            if (result.st.intValue == 0) {
                [self showImage:[UIImage imageNamed:@"confirm-ok72.png"] status:@"接受成功"];
            } else{
                [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"操作失败"];
            }
            tmp.TypeId = @"1";
            [self.tableView reloadData];
            [self dismiss];//请求完，取消菊花
            [self gotoMainUI];
        } fail:^(id errors) {
            [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"操作失败"];
        } cache:^(id cache) {
        }];
    //家长绑定接受
    }else if ([type isEqualToString:@"1"]){
        [self show];
        NSString *url = [NSString stringWithFormat:@" http://interface.%@/sjrrt/AcceptBinding",aedudomain];
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[RRTManager manager].loginManager.loginInfo.tokenId,@"Token",@"1",@"Type",[RRTManager manager].loginManager.loginInfo.userId,@"ChildrenUserId",nil];
        [HttpUtil PostWithUrl:url parameters:dic success:^(id json) {
            ErrorModel *result = [[ErrorModel alloc] initWithString:json error:nil];
            if (result.st.intValue == 0) {
                [self showImage:[UIImage imageNamed:@"confirm-ok72.png"] status:@"接受成功"];
                tmp.IsFollows = [NSString stringWithFormat:@"%d", ![tmp.IsFollows boolValue]];
                [self.tableView reloadData];
                [self dismiss];
                [self gotoMainUI];
            } else{
                [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"操作失败"];
            }
        } fail:^(id errors) {
            [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"操作失败"];
        } cache:^(id cache) {
        }];
    }
}
- (NSString *)flattenHTML:(NSString *)html {
    
    NSScanner *theScanner;
    NSString *text = nil;
    
    theScanner = [NSScanner scannerWithString:html];
    
    while ([theScanner isAtEnd] == NO) {
        // find start of tag
        [theScanner scanUpToString:@"<" intoString:NULL] ;
        // find end of tag
        [theScanner scanUpToString:@">" intoString:&text] ;
        // replace the found tag with a space
        //(you can filter multi-spaces out later if you wish)
        html = [html stringByReplacingOccurrencesOfString:
                [NSString stringWithFormat:@"%@>", text]
                                               withString:@""];
        html=[html stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
        html=[html stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    return html;
}
- (void)gotoMainUI
{
//    [self performSelector:@selector(back) withObject:nil afterDelay:0.5f];
//    self.block();
    //注册通知
    [[NSNotificationCenter defaultCenter] postNotificationName:kContactAdded
                                                        object:nil
                                                      userInfo:nil];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)addFirend2
{
    [self.navigationController pushViewController:AddFriendVCID
                                   withStoryBoard:ContactStoryBoardName
                                        withBlock:nil];
}

#pragma mark - 下拉刷新
#pragma mark -
- (void)headerReresh
{
    [self requestNetWorkNewFriendData];
}

@end
