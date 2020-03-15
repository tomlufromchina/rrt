//
//  CurrentHeaderCell.h
//  RenrenTong
//
//  Created by 符其彬 on 15/3/23.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CurrentHeaderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *advertiseMentView;
@property (weak, nonatomic) IBOutlet UIImageView *userHeaderImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userSchoolNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *integralButton;
@property (weak, nonatomic) IBOutlet UILabel *integralLabel;
@property (weak, nonatomic) IBOutlet UIButton *clickIntegralButton;
@property (weak, nonatomic) IBOutlet UIButton *headerButton;

@end
