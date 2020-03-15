//
//  CTGrouperViewController.h
//  RenrenTong
//
//  Created by aedu on 15/3/25.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "BaseViewController.h"

@interface CTGrouperViewController : BaseViewController
<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic, strong)NSString *groupId;
@property(nonatomic, assign)int groupType;
@property(nonatomic, strong)NSString *groupName;

@property(nonatomic, weak)UITableView *mainView;

@end
