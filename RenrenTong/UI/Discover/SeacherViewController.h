//
//  SeacherViewController.h
//  RenrenTong
//
//  Created by 符其彬 on 14-11-5.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "BaseViewController.h"
#import "UIPopoverListView.h"
#import "UIImageView+MJWebCache.h"

@interface SeacherViewController : BaseViewController<UIPopoverListViewDataSource, UIPopoverListViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *searcherButton;
@property (weak, nonatomic) IBOutlet UIImageView *backIMG;


@end
