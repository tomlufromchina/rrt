//
//  SendGroupMenberCell.m
//  RenrenTong
//
//  Created by 符其彬 on 14-10-26.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "SendGroupMenberCell.h"

@implementation SendGroupMenberCell

- (void)awakeFromNib {
    // Initialization code
    self.messageButton.tag = 1;
    self.netButton.tag = 0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)clickMessageButton:(UIButton *)sender {
    [self.messageButton setImage:[UIImage imageNamed:@"已选"] forState:UIControlStateNormal];
    self.messageButton.tag = 1;
    [self.netButton setImage:[UIImage imageNamed:@"未选"] forState:UIControlStateNormal];
    self.netButton.tag = 0;
}

- (IBAction)clickNetButton:(UIButton *)sender {
    [self.netButton setImage:[UIImage imageNamed:@"已选"] forState:UIControlStateNormal];
    self.netButton.tag = 1;
    [self.messageButton setImage:[UIImage imageNamed:@"未选"]  forState:UIControlStateNormal];
    self.messageButton.tag = 0;
}
@end
