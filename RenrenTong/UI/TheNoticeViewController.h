//
//  TheNoticeViewController.h
//  RenrenTong
//
//  Created by 符其彬 on 14/12/12.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "BaseViewController.h"

@interface TheNoticeViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (nonatomic , assign) int messageType;
@property (nonatomic, copy) NSString *theTitle;

@end
