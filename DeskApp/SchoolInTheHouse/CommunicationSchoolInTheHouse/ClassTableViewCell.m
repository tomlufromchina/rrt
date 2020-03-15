//
//  ClassTableViewCell.m
//  RenrenTong
//
//  Created by aedu on 15/1/30.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "ClassTableViewCell.h"
#import "BaseButton.h"

@implementation ClassTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectBtn = [[BaseButton alloc] initWithFrame:CGRectMake(10, 15, 140, 30)];
        [self.selectBtn setImage:[UIImage imageNamed:@"check_un"] forState:UIControlStateNormal];
        self.selectBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:self.selectBtn];
        
        
        self.individualBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWIDTH - 110, 0, 100, 60)];
        [self.individualBtn setTitleColor:theLoginButtonColor forState:UIControlStateNormal];
        self.individualBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:self.individualBtn];
    }
    return self;
}
- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setChecked:(BOOL)checked
{
    _checked = checked;
    if (checked)
    {
        [self.selectBtn setImage:[UIImage imageNamed:@"check_yes"] forState:UIControlStateNormal];

    }
    else
    {
        [self.selectBtn setImage:[UIImage imageNamed:@"check_un"] forState:UIControlStateNormal];
    }
}
@end
