//
//  MessageCell.m
//  RenrenTong
//
//  Created by aedu on 15/2/9.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "MessageCell.h"

@implementation MessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.msgLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 5, 80, 30)];
        self.msgLabel.font = [UIFont systemFontOfSize:17];
        self.msgLabel.text =@"";
        [self.contentView addSubview:self.msgLabel];
        
        
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 35, SCREENWIDTH- 70, 30)];
        self.timeLabel.font = [UIFont systemFontOfSize:15];
        self.timeLabel.text = @"";
        [self.timeLabel setTextColor:[UIColor lightGrayColor]];
        [self.contentView addSubview:self.timeLabel];
        
        self.msgIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 39, 39)];
        self.msgIcon.image = nil;
        [self.contentView addSubview:self.msgIcon];
        
        self.theTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.msgLabel.right - 10, 5, SCREENWIDTH - 150, 30)];
        self.theTimeLabel.textAlignment = NSTextAlignmentRight;
        self.theTimeLabel.font = [UIFont systemFontOfSize:15];
        [self.theTimeLabel setTextColor:[UIColor lightGrayColor]];
        self.theTimeLabel.text = @"";
        [self.contentView addSubview:self.theTimeLabel];
        
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
