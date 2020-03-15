//
//  MyClassCell.m
//  RenrenTong
//
//  Created by 符其彬 on 15/3/27.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "MyClassCell.h"

@implementation MyClassCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    self.userHeaderImageView.layer.masksToBounds = YES;
    self.userHeaderImageView.layer.cornerRadius = self.userHeaderImageView.width * 0.5;
}

@end
