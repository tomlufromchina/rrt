//
//  MainLoginViewController.h
//  RenrenTong
//
//  Created by 符其彬 on 15/1/27.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "BaseViewController.h"
#import "LoginViewController.h"
#import "TelephoneRegisteringViewController.h"
#import "Advert.h"

@interface MainLoginViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UIButton *theLeftButton;
@property (weak, nonatomic) IBOutlet UIButton *theRightButton;
@property (nonatomic, strong) LoginViewController *theLoginVC;
@property (nonatomic, strong) TelephoneRegisteringViewController *theTelePhoneVC;
@property (weak, nonatomic) IBOutlet UIView *grayColorView1;
@property (weak, nonatomic) IBOutlet UIView *grayColorView2;
@property (weak, nonatomic) IBOutlet UIView *greedColorView1;
@property (weak, nonatomic) IBOutlet UIView *greedColorView2;
- (IBAction)clickTheLeftButton:(UIButton *)sender;
- (IBAction)clickTheRightButton:(UIButton *)sender;

@end
