//
//  SeveralParentsCell.m
//  RenrenTong
//
//  Created by 符其彬 on 14-10-23.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "SeveralParentsCell.h"

@implementation SeveralParentsCell

- (void)setTheChecked:(BOOL)checked
{
    if (checked){
        [self.groupButton setImage:[UIImage imageNamed:@"已选"] forState:UIControlStateNormal];
    } else{
        [self.groupButton setImage:[UIImage imageNamed:@"未选"] forState:UIControlStateNormal];
    }
    m_checked = checked;
    
}

@end
