//
//  SelectGropViewController.h
//  RenrenTong
//
//  Created by aedu on 15/1/30.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "BaseViewController.h"
@protocol SelectGropViewControllerDelegate <NSObject>

- (void)selectGroupArray:(NSMutableArray *)array states:(int)states;

@end

@interface SelectGropViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic, weak)UITableView *mainView;
@property(nonatomic, weak)UIView *footerView;
@property(nonatomic, weak)id<SelectGropViewControllerDelegate> delegate;


@end
