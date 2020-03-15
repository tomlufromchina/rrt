//
//  FriendCell.m
//  RenrenTong
//
//  Created by aedu on 15/3/23.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "FriendCell.h"

@implementation FriendCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.icon = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 30, 30)];
        self.icon.layer.cornerRadius = 3.0;
        self.icon.clipsToBounds = YES;
        [self.icon setImage:[UIImage imageNamed:@"check_un"]];
        [self.contentView addSubview:self.icon];
        
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 15, 180, 30)];
        self.nameLabel.text = @"张三";
        self.nameLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:self.nameLabel];
        
        self.brage = [[Brage alloc]init];
        self.brage.frame = CGRectMake(33, 0, 30, 30);
        self.brage.vallable.frame = CGRectMake(3, 7, 24, 16);
        [self.contentView addSubview:self.brage];
        
        self.role = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH - 200, 15, 170, 30)];
        self.role.font = [UIFont systemFontOfSize:15];
        self.role.textAlignment = NSTextAlignmentRight;
        [self.role setTextColor:[UIColor grayColor]];
        [self.contentView addSubview:self.role];
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
