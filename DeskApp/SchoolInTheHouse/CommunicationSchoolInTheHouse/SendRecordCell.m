//
//  SendRecordCell.m
//  RenrenTong
//
//  Created by 符其彬 on 15/2/2.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "SendRecordCell.h"

@implementation SendRecordCell

- (void)awakeFromNib {


}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)clickImageViewAction:(UIButton *)sender
{
    
}

- (void)setChecked:(BOOL)checked{
    if (checked)
    {
        self.clickImageView.image = [UIImage imageNamed:@"check_yes"];
    }
    else
    {
        self.clickImageView.image = [UIImage imageNamed:@"check_un"];
        self.backgroundView.backgroundColor = [UIColor whiteColor];
    }
    m_checked = checked;
    
    
}
@end
