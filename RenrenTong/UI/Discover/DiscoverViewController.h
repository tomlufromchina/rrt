//
//  DiscoverViewController.h
//  RenrenTong
//
//  Created by aedu on 15/3/26.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "BaseViewController.h"

@interface DiscoverViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic, weak)UITableView *mainView;

@end
