//
//  CommunicationGuardianViewController.h
//  RenrenTong
//
//  Created by aedu on 15/1/30.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "BaseViewController.h"

@interface CommunicationGuardianViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, copy) NSString *theTitle;
/**
 *  查看的类型
 */
@property (nonatomic, assign) int headType;
@end
