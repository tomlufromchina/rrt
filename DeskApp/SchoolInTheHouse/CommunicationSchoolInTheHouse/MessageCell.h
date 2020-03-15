//
//  MessageCell.h
//  RenrenTong
//
//  Created by aedu on 15/2/9.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageCell : UITableViewCell

@property (strong, nonatomic) UILabel *msgLabel;

@property (strong, nonatomic) UILabel *timeLabel;

@property (strong, nonatomic) UIImageView *msgIcon;

@property (nonatomic, strong) UILabel *theTimeLabel;

@end
