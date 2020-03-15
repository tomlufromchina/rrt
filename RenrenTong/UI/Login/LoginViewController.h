//
//  LoginViewController.h
//  RenrenTong
//
//  Created by jeffrey on 14-5-15.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : BaseViewController

@property (nonatomic, assign) BOOL bFromLaunch;
@property (weak, nonatomic) IBOutlet UIView *userNameView;
@property (weak, nonatomic) IBOutlet UIView *passWordView;
@property (weak, nonatomic) IBOutlet UIButton *phoneButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (nonatomic, weak, readwrite) BaseViewController *theLoginViewController;
@property (weak, nonatomic) IBOutlet UIImageView *drownButton;
@property (weak, nonatomic) IBOutlet UIButton *startUserButton;
@property (weak, nonatomic) IBOutlet UIButton *fogetterButton;
- (IBAction)clickDrwonButton:(UIButton *)sender;

@end
