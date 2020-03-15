//
//  ContactTableViewController.h
//  RenrenTong
//
//  Created by jeffrey on 14-5-17.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import <UIKit/UIKit.h>

//notification name
#define kContactDeleted @"kContactDeleted"
#define kContactAdded @"kContactAdded"

@protocol ContactTableViewControllerDelegate <NSObject>

- (void)sendNewFriendObject:(NewFriends *)newFriend;

@end

@interface ContactTableViewController : BaseTableViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate>

@property (nonatomic,assign) id<ContactTableViewControllerDelegate> delegate;

@end
