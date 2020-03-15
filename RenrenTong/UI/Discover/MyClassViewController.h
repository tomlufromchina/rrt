//
//  MyClassViewController.h
//  RenrenTong
//
//  Created by 符其彬 on 15/3/27.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "BaseViewController.h"
#import "DXPopover.h"
#import "MyClassListView.h"
#import "MLEmojiLabel.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "UIImageView+MJWebCache.h"
#import "PhotoUITapGestureRecognizer.h"

@interface MyClassViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (nonatomic, strong) UIButton *titlebtn;
@property (nonatomic, assign) int pageIndex;
@property (nonatomic, assign) int pageSize;

@end
