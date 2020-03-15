//
//  AccountNumberViewController.h
//  RenrenTong
//
//  Created by 符其彬 on 14/12/19.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "BaseViewController.h"

@interface AccountNumberViewController : BaseViewController
@property (nonatomic, copy) NSString *currentDynamicPassword;
@property (nonatomic, copy) NSString *thePhoneNumber;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@end
