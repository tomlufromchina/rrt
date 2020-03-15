//
//  WeiBoContactsTableViewController.m
//  RenrenTong
//
//  Created by 司月皓 on 14-7-25.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "WeiBoContactsTableViewController.h"

@interface WeiBoContactsTableViewController ()

@property (nonatomic, strong) NSArray *contacts;
@property (nonatomic, strong) NetWorkManager *net;
@property (nonatomic, strong) NSMutableArray *dataSource;


@end

@implementation WeiBoContactsTableViewController

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
    self.title = @"我的好友";
    
    self.contacts = [DataManager allContacts];
    self.net = [[NetWorkManager alloc] init];
    self.dataSource = [[NSMutableArray alloc] init];
    [self requestData];
    
}

- (void)requestData
{
    [self show];
    [self.net AddressBookDetail:[RRTManager manager].loginManager.loginInfo.userId
                          token:[RRTManager manager].loginManager.loginInfo.tokenId
                      PageIndex:1
                        success:^(NSMutableArray *data) {
                            if (data && [data count] > 0) {
                                for (int i = 0; i < [data count]; i ++) {
                                    [_dataSource addObject:data[i]];
                                }
                                [self.tableView reloadData];
                            }
                        } failed:^(NSString *errorMSG) {
                            [self showImage:[UIImage imageNamed:@"confirm-err72"] status:errorMSG];
                        }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source
#pragma mark -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [_dataSource count];
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WeiBoContactsCell"
                                                            forIndexPath:indexPath];
    GoodFriend *GF = [_dataSource objectAtIndex:indexPath.row];

    UILabel *nameLabel = (UILabel *)[cell viewWithTag:1];
    nameLabel.text = GF.UserName;
    UILabel *roleLabel = (UILabel *)[cell viewWithTag:3];
    roleLabel.text = GF.Roles;
    UIImageView *avatarImgView = (UIImageView*)[cell viewWithTag:2];
    [avatarImgView setImageWithUrlStr:GF.PictureUrl
                      placholderImage:[UIImage imageNamed:@"default.png"]];

    return cell;
}

#pragma mark - tableview delegate
#pragma mark -
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_dataSource && [_dataSource count] > 0) {
        GoodFriend *GF = [_dataSource objectAtIndex:indexPath.row];
        [self.delegate sendWeiBoContactsName:GF.UserName];
        [self.navigationController popViewControllerAnimated:YES];
    }
}


@end
