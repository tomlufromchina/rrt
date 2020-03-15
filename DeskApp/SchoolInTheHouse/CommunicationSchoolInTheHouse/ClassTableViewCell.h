//
//  ClassTableViewCell.h
//  RenrenTong
//
//  Created by aedu on 15/1/30.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BaseButton;

@interface ClassTableViewCell : UITableViewCell
@property (strong, nonatomic) BaseButton *selectBtn;

@property (strong, nonatomic) UIButton *individualBtn;

@property(nonatomic, assign)BOOL checked;
@end
