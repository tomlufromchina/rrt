//
//  NextSendParentsCell.m
//  RenrenTong
//
//  Created by 符其彬 on 14-10-26.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "NextSendParentsCell.h"

@implementation NextSendParentsCell

- (void)awakeFromNib {
    // Initialization code
    self.noticeButton.tag = 1;
    self.taskButton.tag = 0;
    self.presentationButton.tag = 0;
    self.wishButton.tag = 0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)clickNoticeButton:(UIButton *)sender {
    [self.noticeButton setImage:[UIImage imageNamed:@"已选"] forState:UIControlStateNormal];
    self.noticeButton.tag = 1;
    [self.taskButton setImage:[UIImage imageNamed:@"未选"] forState:UIControlStateNormal];
    self.taskButton.tag = 0;
    [self.presentationButton setImage:[UIImage imageNamed:@"未选"] forState:UIControlStateNormal];
    self.presentationButton.tag = 0;
    [self.wishButton setImage:[UIImage imageNamed:@"未选"] forState:UIControlStateNormal];
    self.wishButton.tag = 0;
}

- (IBAction)clickNetButton:(UIButton *)sender {
    [self.noticeButton setImage:[UIImage imageNamed:@"未选"] forState:UIControlStateNormal];
    self.noticeButton.tag = 0;
    [self.taskButton setImage:[UIImage imageNamed:@"已选"] forState:UIControlStateNormal];
    self.taskButton.tag = 1;
    [self.presentationButton setImage:[UIImage imageNamed:@"未选"] forState:UIControlStateNormal];
    self.presentationButton.tag = 0;
    [self.wishButton setImage:[UIImage imageNamed:@"未选"] forState:UIControlStateNormal];
    self.wishButton.tag = 0;
}

- (IBAction)clickPresentationButton:(UIButton *)sender {
    [self.noticeButton setImage:[UIImage imageNamed:@"未选"] forState:UIControlStateNormal];
    self.noticeButton.tag = 0;
    [self.taskButton setImage:[UIImage imageNamed:@"未选"] forState:UIControlStateNormal];
    self.taskButton.tag = 0;
    [self.presentationButton setImage:[UIImage imageNamed:@"已选"] forState:UIControlStateNormal];
    self.presentationButton.tag = 1;
    [self.wishButton setImage:[UIImage imageNamed:@"未选"] forState:UIControlStateNormal];
    self.wishButton.tag = 0;
}

- (IBAction)clickWishButton:(UIButton *)sender {
    [self.noticeButton setImage:[UIImage imageNamed:@"未选"] forState:UIControlStateNormal];
    self.noticeButton.tag = 0;
    [self.taskButton setImage:[UIImage imageNamed:@"未选"] forState:UIControlStateNormal];
    self.taskButton.tag = 0;
    [self.presentationButton setImage:[UIImage imageNamed:@"未选"] forState:UIControlStateNormal];
    self.presentationButton.tag = 0;
    [self.wishButton setImage:[UIImage imageNamed:@"已选"] forState:UIControlStateNormal];
    self.wishButton.tag = 1;
}
@end
