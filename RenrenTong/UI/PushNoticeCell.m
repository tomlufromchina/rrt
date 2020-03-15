//
//  PushNoticeCell.m
//  RenrenTong
//
//  Created by 符其彬 on 15/3/27.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "PushNoticeCell.h"

@implementation PushNoticeCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];


    self.titltImageView.layer.cornerRadius = 39.0*0.5;
    self.titltImageView.clipsToBounds = YES;
}

@end
