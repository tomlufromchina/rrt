//
//  FriendCell.h
//  RenrenTong
//
//  Created by aedu on 15/3/23.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Brage.h"

@interface FriendCell : UITableViewCell
@property (strong, nonatomic) UIImageView *icon;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *role;
@property (strong, nonatomic) Brage *brage;

@end
