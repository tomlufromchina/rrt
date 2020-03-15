//
//  MyselfTendencyViewController.h
//  RenrenTong
//
//  Created by 符其彬 on 15/4/8.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "BaseViewController.h"
#import "MLEmojiLabel.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "UIImageView+MJWebCache.h"
#import "PhotoUITapGestureRecognizer.h"

@interface MyselfTendencyViewController : BaseViewController
@property (nonatomic, weak, readwrite) BaseViewController *myselfTendencyViewController;
@property (strong, nonatomic) UITableView *mainTableView;
- (void)headerReresh;
@end
