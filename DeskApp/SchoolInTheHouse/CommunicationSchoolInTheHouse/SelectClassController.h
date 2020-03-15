//
//  SelectClassController.h
//  RenrenTong
//
//  Created by aedu on 15/1/30.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "BaseViewController.h"

@protocol SelectClassControllerDelegate <NSObject>

- (void)selectStudentArray:(NSMutableArray *)array IsOnCampus:(int)isOnCampus;

@end

@interface SelectClassController : BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic, weak)UITableView *mainView;
@property(nonatomic, weak)UIView *footerView;
@property(nonatomic, weak)id<SelectClassControllerDelegate> delegate;

@end
