//
//  TelephoneRegisteringViewController.h
//  RenrenTong
//
//  Created by 符其彬 on 14/12/9.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "BaseViewController.h"
@interface TelephoneRegisteringViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UIView *phoneNumberView;
@property (weak, nonatomic) IBOutlet UIView *passwordView;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextFiled;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextFiled;
@property (weak, nonatomic) IBOutlet UIButton *getPassWordButton;
@property (weak, nonatomic) IBOutlet UIButton *registeringButton;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *passwordTitle;
@property (nonatomic, weak, readwrite) BaseViewController *theTelePhoneViewController;
@property (weak, nonatomic) IBOutlet UIButton *startUserButton;
@property (weak, nonatomic) IBOutlet UIButton *fogetterButton;

- (IBAction)clickGetPassWordButton:(UIButton *)sender;
- (IBAction)clickRegisterButton:(UIButton *)sender;
- (IBAction)clickNewUsersRegisterButton:(UIButton *)sender;
- (IBAction)clickFogetPasswordButton:(UIButton *)sender;

@end
