//
//  TheAllBullentinsCell.h
//  RenrenTong
//
//  Created by 符其彬 on 15/4/4.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TheAllBullentinsCell : UITableViewCell
{
    BOOL			m_checked;
}

@property (weak, nonatomic) IBOutlet UIView *backGroupView;
@property (weak, nonatomic) IBOutlet UILabel *commentTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UILabel *readingLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *m_checkImageView;

- (void)setChecked:(BOOL)checked;

@end
