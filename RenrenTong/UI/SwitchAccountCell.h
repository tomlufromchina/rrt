//
//  SwitchAccountCell.h
//  RenrenTong
//
//  Created by 符其彬 on 14/12/9.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SwitchAccountCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *backGroupView;
@property (weak, nonatomic) IBOutlet UIButton *delegateButton;
@property (weak, nonatomic) IBOutlet UIImageView *userFaceImageView;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userNumber;
@property (weak, nonatomic) IBOutlet UIImageView *addImageView;
@property (weak, nonatomic) IBOutlet UILabel *theNewAccountLabel;

@end
