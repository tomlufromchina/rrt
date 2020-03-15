//
//  TheNoticeCell.h
//  RenrenTong
//
//  Created by 符其彬 on 14/12/12.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLEmojiLabel.h"

@interface TheNoticeCell : UITableViewCell
@property (strong, nonatomic) MLEmojiLabel *content;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;


@end
