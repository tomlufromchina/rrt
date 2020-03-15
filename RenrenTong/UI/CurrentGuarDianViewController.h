//
//  CurrentGuarDianViewController.h
//  RenrenTong
//
//  Created by 符其彬 on 15/3/23.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "BaseViewController.h"
#import "Brage.h"
#import "SlideBaseViewController.h"

@interface CurrentGuarDianViewController : SlideBaseViewController
@property (strong, nonatomic) UITableView *mainTableView;
- (void)requestData;

@end
