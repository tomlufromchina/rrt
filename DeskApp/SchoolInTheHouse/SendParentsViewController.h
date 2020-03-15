//
//  SendParentsViewController.h
//  RenrenTong
//
//  Created by 符其彬 on 14-10-25.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "BaseViewController.h"

@interface SendParentsViewController : BaseViewController
@property (nonatomic, strong) NSMutableArray *studentId;
@property (nonatomic, strong) NSString *classId;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@end
