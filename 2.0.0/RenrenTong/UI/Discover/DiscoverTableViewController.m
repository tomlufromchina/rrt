//
//  DiscoverTableViewController.m
//  RenrenTong
//
//  Created by jeffrey on 14-6-10.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "DiscoverTableViewController.h"
#import "ViewControllerIdentifier.h"
#import "FriendTendencyViewController.h"
#import "MyTendencyViewController.h"

@interface DiscoverTableViewController ()

@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *images;

@end

@implementation DiscoverTableViewController

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
    
    self.title = @"发现";
    
    self.titles = [NSArray arrayWithObjects:@"好友动态", @"我的空间", @"扫一扫",
                   @"摇知识", @"备考食谱", @"教育咨询", @"微课件", nil];
    
    self.images = [NSArray arrayWithObjects:@"find_friendsdynamic.png",
                   @"find_myhomepage.png",
                   @"find_scanqrcode.png",
                   @"find_rockknowledge.png",
                   @"find_recipe.png",
                   @"find_consult.png",
                   @"find_courseware.png", nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    self.hidesBottomBarWhenPushed = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.hidesBottomBarWhenPushed = NO;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 2;
        case 1:
            return 0;
        case 2:
            return 0;
        case 3:
            return 0;
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DiscoverCell"
                                                            forIndexPath:indexPath];
    
    int index = 2 * indexPath.section + indexPath.row;
    
    UILabel *label = (UILabel*)[cell viewWithTag:1];
    label.text = (NSString*)[self.titles objectAtIndex:index];
    
    UIImageView *imgView = (UIImageView*)[cell viewWithTag:2];
    [imgView setImage:[UIImage imageNamed:(NSString*)[self.images objectAtIndex:index]]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0 && indexPath.row == 1) {
        
        MyTendencyViewController *VC = [[MyTendencyViewController alloc] init];
        
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                     style:UIBarButtonItemStyleBordered
                                                                    target:nil
                                                                    action:nil];
        [self.navigationItem setBackBarButtonItem:backItem];
        
        [self.navigationController pushViewController:VC animated:YES];
    } else if (indexPath.section == 0 && indexPath.row == 0) {
        [self.navigationController pushViewController:FriendTendencyVCID
                                       withStoryBoard:ActivityStoryBoardName
                                            withBlock:nil];
    }
}

@end
