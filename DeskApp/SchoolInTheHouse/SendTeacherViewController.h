//
//  SendTeacherViewController.h
//  RenrenTong
//
//  Created by 符其彬 on 14-10-25.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "BaseViewController.h"

@interface SendTeacherViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (nonatomic, strong) NSMutableArray *teacherIdArray;

@end
