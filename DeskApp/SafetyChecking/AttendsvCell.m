//
//  AttendsvCell.m
//  RenrenTong
//
//  Created by 唐彬 on 14-10-8.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "AttendsvCell.h"

@implementation AttendsvCell

- (void)awakeFromNib {
    self.zxbtn.tag=1;
    self.zdbtn.tag=0;
    self.allButton.tag = 0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
- (IBAction)zxclick:(id)sender {
    [self.zxbtn setImage:[UIImage imageNamed:@"已选"] forState:UIControlStateNormal];
    self.zxbtn.tag=1;
    [self.zdbtn setImage:[UIImage imageNamed:@"未选"] forState:UIControlStateNormal];
    self.zdbtn.tag=0;
    [self.allButton setImage:[UIImage imageNamed:@"未选"] forState:UIControlStateNormal];
    self.allButton.tag=0;
}

- (IBAction)zdclick:(id)sender {
    [self.zdbtn setImage:[UIImage imageNamed:@"已选"] forState:UIControlStateNormal];
    self.zdbtn.tag=1;
    [self.zxbtn setImage:[UIImage imageNamed:@"未选"] forState:UIControlStateNormal];
    self.zxbtn.tag=0;
    [self.allButton setImage:[UIImage imageNamed:@"未选"] forState:UIControlStateNormal];
    self.allButton.tag=0;
}

- (IBAction)allClick:(UIButton *)sender {
    [self.allButton setImage:[UIImage imageNamed:@"已选"] forState:UIControlStateNormal];
    self.allButton.tag=1;
    
    [self.zdbtn setImage:[UIImage imageNamed:@"未选"] forState:UIControlStateNormal];
    self.zdbtn.tag=0;
    [self.zxbtn setImage:[UIImage imageNamed:@"未选"] forState:UIControlStateNormal];
    self.zxbtn.tag=0;
}
@end
