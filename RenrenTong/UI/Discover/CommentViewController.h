//
//  CommentViewController.h
//  RenrenTong
//
//  Created by aedu on 15/3/31.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "BaseViewController.h"
#import "HotTopic.h"
#import "Microblog.h"

@interface CommentViewController : BaseViewController
@property(nonatomic, strong)HotTopic *hotTopic;
@property(nonatomic, strong)Microblog *micBlog;
@property(nonatomic, weak)UITableView *mainView;

@end
