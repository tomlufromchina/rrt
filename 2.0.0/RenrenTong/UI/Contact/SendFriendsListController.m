//
//  SendFriendsListController.m
//  RenrenTong
//
//  Created by 符其彬 on 14-8-20.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "SendFriendsListController.h"
#import "ContactDetailViewController.h"
#import "ViewControllerIdentifier.h"

@interface SendFriendsListController ()
{
    SendFriendDetail *_detail;
}
@property (nonatomic, strong) NetWorkManager *netWorkManager;
@property (nonatomic, strong) NSArray *dataSource;//数据源

@end

@implementation SendFriendsListController

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
    self.netWorkManager = [[NetWorkManager alloc] init];
    self.dataSource = [[NSMutableArray alloc] init];
    self.title = @"朋友列表";
    
    [self performSelector:@selector(requestData) withObject:nil afterDelay:0.3];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self dismiss];
    
}

- (void)requestData
{
    [self showWithStatus:@""];
    
    __block SendFriendsListController *_self = self;
    [self.netWorkManager addFriendsOfSearch:[RRTManager manager].loginManager.loginInfo.tokenId ParUserAccount:self.text success:^(NSArray *data) {
        [_self dismiss];
        [_self updateUI:data];
    } failed:^(NSString *errorMSG) {
        [_self showErrorWithStatus:@"没有找到用户，请输入正确的账号哦!"];
        [_self performSelector:@selector(backView) withObject:nil afterDelay:1.0f];
    }];
}

- (void)backView
{
    [self.navigationController popViewControllerAnimated:YES];

}

- (void)updateUI:(NSArray *)data
{
    self.dataSource = [NSArray arrayWithArray:data];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SendFriendsDetailcell" forIndexPath:indexPath];
    
    UIImageView *headImage = (UIImageView *)[cell viewWithTag:1];
    UILabel *name = (UILabel *)[cell viewWithTag:2];
    UILabel *number = (UILabel *)[cell viewWithTag:3];
    
    _detail = [self.dataSource objectAtIndex:indexPath.row];
    [headImage setImageWithURL:[NSURL URLWithString:_detail.PicInfo] placeholderImage:[UIImage imageNamed:@"default"]];
    name.text = _detail.TrueName;
    number.text = [NSString stringWithFormat:@"%@%@",@"账号:",_detail.UserAccount];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.navigationController pushViewController:ContactDetailVCID
                                   withStoryBoard:ContactStoryBoardName
                                        withBlock:^(UIViewController *viewController) {
        ContactDetailViewController *vc = (ContactDetailViewController*)viewController;
        vc.OUserId = _detail.UserId;
        vc.headUrl = _detail.PicInfo;
    }];
}

@end
