//
//  StudentHASDViewController.h
//  RenrenTong
//
//  Created by 唐彬 on 15-4-28.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "BaseViewController.h"

@interface StudentHASDViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>{
    int pagesize;
    int pageindex;
}
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, strong) NetWorkManager *netWorkManager;
/**
 *  信息数据
 */
@property (nonatomic, strong) NSMutableArray *messageData;

@end
