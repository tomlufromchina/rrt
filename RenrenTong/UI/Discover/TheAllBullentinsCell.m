//
//  TheAllBullentinsCell.m
//  RenrenTong
//
//  Created by 符其彬 on 15/4/4.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "TheAllBullentinsCell.h"

@implementation TheAllBullentinsCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setChecked:(BOOL)checked{
    if (checked)
    {
        _m_checkImageView.image = [UIImage imageNamed:@"fxk2-"];
    }
    else
    {
        _m_checkImageView.image = [UIImage imageNamed:@"fxk-"];
        self.backgroundView.backgroundColor = [UIColor whiteColor];
    }
    m_checked = checked;
    
    
}

@end
