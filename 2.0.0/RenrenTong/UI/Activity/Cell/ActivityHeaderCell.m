//
//  ActivityHeaderCell.m
//  RenrenTong
//
//  Created by jeffrey on 14-7-7.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "ActivityHeaderCell.h"

@implementation ActivityHeaderCell

- (void)awakeFromNib
{
    // Initialization code
    
    self.messageView.backgroundColor = appColor;
    self.messageView.layer.cornerRadius = 2.0;
    self.messageBtn.layer.cornerRadius = 2.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
