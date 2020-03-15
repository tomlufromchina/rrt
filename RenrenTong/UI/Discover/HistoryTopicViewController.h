//
//  HistoryTopicViewController.h
//  RenrenTong
//
//  Created by aedu on 15/4/2.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "BaseViewController.h"

@interface HistoryTopicViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic, weak)UITableView *mainView;

@end
