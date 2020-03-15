//
//  WeiBoContactsTableViewController.m
//  RenrenTong
//
//  Created by 司月皓 on 14-7-25.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "WeiBoContactsTableViewController.h"

@interface WeiBoContactsTableViewController ()
{
}

@property (nonatomic, strong) NSArray *contacts;


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
    self.title = @"手机联系人";
    
    self.contacts = [DataManager allContacts];
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

    return [self.contacts count];
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WeiBoContactsCell"
                                                            forIndexPath:indexPath];
    Contact *contact = (Contact*)[self.contacts objectAtIndex:indexPath.row];

    UILabel *nameLabel = (UILabel *)[cell viewWithTag:1];
    
    nameLabel.text = contact.name;
    UIImageView *avatarImgView = (UIImageView*)[cell viewWithTag:2];
    [avatarImgView setImageWithUrlStr:contact.avatarUrl
                      placholderImage:[UIImage imageNamed:@"default.png"]];

    return cell;
}

#pragma mark - tableview delegate
#pragma mark -
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Contact *contact = (Contact*)[self.contacts objectAtIndex:indexPath.row];
    
    [self.delegate sendWeiBoContactsName:contact.name];
    [self.navigationController popViewControllerAnimated:YES];
   
}


@end
