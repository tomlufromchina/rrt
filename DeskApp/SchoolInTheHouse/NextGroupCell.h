//
//  NextGroupCell.h
//  RenrenTong
//
//  Created by 符其彬 on 14-10-22.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NextGroupCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *noticeButton;
@property (weak, nonatomic) IBOutlet UIButton *taskButton;
@property (weak, nonatomic) IBOutlet UIButton *presentationButton;
@property (weak, nonatomic) IBOutlet UIButton *wishButton;
- (IBAction)clickNoticeButton:(UIButton *)sender;
- (IBAction)clickTaskButton:(UIButton *)sender;
- (IBAction)clickPresentationButton:(UIButton *)sender;
- (IBAction)clickWishButton:(UIButton *)sender;

@end
