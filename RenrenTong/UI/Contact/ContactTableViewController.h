//
//  ContactTableViewController.h
//  RenrenTong
//
//  Created by jeffrey on 14-5-17.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatViewController.h"
#import "Brage.h"
#import "ContactMainCell.h"
#import "MessageNetService.h"

#define kContactAdded @"kContactAdded"



@interface ContactTableViewController : BaseTableViewController<UITableViewDataSource,UITableViewDelegate>{
    int PageIndex;
}


@end
