//
//  SearcherCell.h
//  RenrenTong
//
//  Created by 符其彬 on 14-11-5.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLEmojiLabel.h"

@interface SearcherCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *addFriend;
@property (weak, nonatomic) IBOutlet UIImageView *manIMG;
@property (weak, nonatomic) IBOutlet UIImageView *womenIMG;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) MLEmojiLabel *content;
@property (nonatomic, strong) UIView *photoview;

@end