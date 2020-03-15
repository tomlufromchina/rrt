//
//  WeiboListCell.h
//  RenrenTong
//
//  Created by 符其彬 on 14-8-26.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLEmojiLabel.h"

@interface WeiboListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userface;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UIView *potoview;
@property (weak, nonatomic) IBOutlet UILabel *timer;

@property (weak, nonatomic) IBOutlet UIView *praiseView;
@property (weak, nonatomic) IBOutlet UIView *discuss;
@property (weak, nonatomic) IBOutlet UILabel *praiseLabel;
@property (weak, nonatomic) IBOutlet UILabel *discussLabel;

@end
