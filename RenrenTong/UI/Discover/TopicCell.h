//
//  TopicCell.h
//  RenrenTong
//
//  Created by aedu on 15/3/27.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MicroblogFrame,TopView,BootView;

@interface TopicCell : UITableViewCell

@property (nonatomic, strong) MicroblogFrame *microblogFrame;
@property (nonatomic, weak) TopView *topView;
@property (nonatomic, weak) BootView *bootView;

+ (instancetype)cellWithTabelView:(UITableView *)tableView;

@end
