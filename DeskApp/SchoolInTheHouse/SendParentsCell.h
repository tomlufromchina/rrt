//
//  SendParentsCell.h
//  RenrenTong
//
//  Created by 符其彬 on 14-10-26.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SendParentsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *messageButton;
@property (weak, nonatomic) IBOutlet UIButton *netButton;
- (IBAction)clickMessageButton:(UIButton *)sender;
- (IBAction)clickNetButton:(UIButton *)sender;

@end
