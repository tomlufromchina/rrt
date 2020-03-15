//
//  MessageTableViewController.h
//  RenrenTong
//
//  Created by jeffrey on 14-5-16.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DAContextMenuTableViewController.h"
#import "ContactTableViewController.h"
#import "IMCache.h"
#import "Group.h"
#import "BaseViewController.h"

@interface MessageTableViewController : BaseViewController
{
    UIView * nochatview;
    NetWorkManager *netWorkManager;
}
@property (strong, nonatomic) UITableView *tableView;
@end
