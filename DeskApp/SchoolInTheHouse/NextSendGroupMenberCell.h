//
//  NextSendGroupMenberCell.h
//  RenrenTong
//
//  Created by 符其彬 on 14-10-26.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NextSendGroupMenberCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *noticeButton;
@property (weak, nonatomic) IBOutlet UIButton *taskButton;
@property (weak, nonatomic) IBOutlet UIButton *presentationButton;
@property (weak, nonatomic) IBOutlet UIButton *wishButton;
- (IBAction)clickNoticeButton:(UIButton *)sender;
- (IBAction)clickTaskButton:(UIButton *)sender;
- (IBAction)clickpresentationButton:(UIButton *)sender;
- (IBAction)clickWishButton:(UIButton *)sender;

@end
