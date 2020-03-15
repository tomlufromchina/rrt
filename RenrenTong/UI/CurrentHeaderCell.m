//
//  CurrentHeaderCell.m
//  RenrenTong
//
//  Created by 符其彬 on 15/3/23.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "CurrentHeaderCell.h"

@implementation CurrentHeaderCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    self.integralButton.layer.cornerRadius = 26.0*0.5;
    self.integralButton.clipsToBounds = YES;
    
    [self.userHeaderImageView.layer setCornerRadius:(self.userHeaderImageView.frame.size.height/2)];
    
    self.userHeaderImageView.layer.masksToBounds = YES;
    self.userHeaderImageView .contentMode = UIViewContentModeScaleAspectFit;
    self.userHeaderImageView.layer.shadowColor = [UIColor grayColor].CGColor;
    self.userHeaderImageView.layer.shadowOffset = CGSizeMake(8, 8);
    self.userHeaderImageView.layer.shadowOpacity = 1.0f;
    self.userHeaderImageView.layer.shadowRadius = 4.0f;
    
    self.userHeaderImageView.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.userHeaderImageView.layer.borderWidth = 2.0f;
    self.userHeaderImageView.userInteractionEnabled = YES;
    self.userHeaderImageView.backgroundColor = [UIColor clearColor];
    [self.userHeaderImageView setImageWithURL:[NSURL URLWithString:[RRTManager manager].loginManager.loginInfo.userAvatar] placeholderImage:[UIImage imageNamed:@"default"] options:SDWebImageRefreshCached];
}

@end
