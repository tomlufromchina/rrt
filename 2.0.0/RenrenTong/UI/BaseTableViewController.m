//
//  BaseTableViewController.m
//  RenrenTong
//
//  Created by jeffrey on 14-9-5.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "BaseTableViewController.h"
#import "SVProgressHUD.h"
#import "MJRefresh.h"

@interface BaseTableViewController ()

@end

@implementation BaseTableViewController

#pragma mark - ViewController lifecycle
#pragma mark -
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - show HUD
#pragma mark -
- (void)showWithStatus:(NSString*)status
{
    [SVProgressHUD showWithStatus:status];
}

- (void)showProgress:(CGFloat)progress
{
    [SVProgressHUD showProgress:progress];
}

- (void)showProgress:(CGFloat)progress status:(NSString*)status
{
    [SVProgressHUD showProgress:progress status:status];
}

- (void)showSuccessWithStatus:(NSString*)string
{
    [SVProgressHUD showSuccessWithStatus:string];
}

- (void)showErrorWithStatus:(NSString *)string
{
    [SVProgressHUD showErrorWithStatus:string];
}

- (void)showWithTitle:(NSString *)title withTime:(NSTimeInterval)time
{
    [SVProgressHUD showWithTitle:title withTime:time];
}

- (void)showWithTitle:(NSString *)title defaultStr:(NSString *)defaultStr
{
    [SVProgressHUD showWithTitle:title defaultStr:defaultStr];
}

- (void)dismiss
{
    [SVProgressHUD dismiss];
}

#pragma mark - refresh and load more
#pragma mark -
- (void)enableRefresh:(BOOL)bRefresh action:(SEL)action
{
    if (bRefresh) {
        [self.tableView addHeaderWithTarget:self action:action];
    } else {
        [self.tableView removeHeader];
    }
}

- (void)enableLoadMore:(BOOL)bLoadMore action:(SEL)action
{
    if (bLoadMore) {
        [self.tableView addFooterWithTarget:self action:action];
    } else {
        [self.tableView removeFooter];
    }
}

- (void)endRefresh
{
    [self.tableView headerEndRefreshing];
}

- (void)endLoadMore
{
    [self.tableView footerEndRefreshing];
}

@end
