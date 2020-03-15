//
//  WeiBoContactsTableViewController.h
//  RenrenTong
//
//  Created by 司月皓 on 14-7-25.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol WeiBoContacts <NSObject>

- (void)sendWeiBoContactsName:(NSString *)name;

@end

@interface WeiBoContactsTableViewController : BaseTableViewController

@property (nonatomic,assign) id<WeiBoContacts> delegate;

@end
