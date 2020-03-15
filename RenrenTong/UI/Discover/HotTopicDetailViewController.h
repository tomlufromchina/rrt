//
//  HotTopicDetailViewController.h
//  RenrenTong
//
//  Created by aedu on 15/3/26.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "BaseViewController.h"
#import "HotTopic.h"

@interface HotTopicDetailViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic, weak)UITableView *mainView;

@property(nonatomic, strong)HotTopic *hotTopic;
@property(nonatomic, assign)int tag;

@end
