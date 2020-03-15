//
//  IncreaseAccountViewController.h
//  RenrenTong
//
//  Created by 符其彬 on 14/12/11.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "BaseViewController.h"

@protocol IncreaseAccountVCDelegate<NSObject>

@required
- (void)chooseTheUserInformation;
@end

@interface IncreaseAccountViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UIView *userView;
@property (weak, nonatomic) IBOutlet UITextField *userNumber;
@property (weak, nonatomic) IBOutlet UIView *passAccountView;
@property (weak, nonatomic) IBOutlet UITextField *passAccount;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (nonatomic, assign)   id <IncreaseAccountVCDelegate>delegate;

- (IBAction)clickAddButton:(UIButton *)sender;

@end
