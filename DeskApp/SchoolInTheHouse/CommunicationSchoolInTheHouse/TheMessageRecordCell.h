//
//  TheMessageRecordCell.h
//  RenrenTong
//
//  Created by 符其彬 on 15/3/6.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLEmojiLabel.h"

@interface TheMessageRecordCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *fromOrderLabel;
@property (strong, nonatomic) MLEmojiLabel *content;

@end
