//
//  TheStudentsViewController.h
//  RenrenTong
//
//  Created by 符其彬 on 15/2/27.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "BaseViewController.h"

@interface TheStudentsViewController : BaseViewController
@property (nonatomic, copy) NSString *theTitle;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@end
