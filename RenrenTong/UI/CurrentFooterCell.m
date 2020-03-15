//
//  CurrentFooterCell.m
//  RenrenTong
//
//  Created by 符其彬 on 15/3/23.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "CurrentFooterCell.h"

@implementation CurrentFooterCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];


    self.userHeaderImageView.layer.cornerRadius = 39.0*0.5;
    self.userHeaderImageView.clipsToBounds = YES;
}

@end
