//
//  SuccessRegisterViewController.h
//  RenrenTong
//
//  Created by 符其彬 on 15/5/18.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "BaseViewController.h"
#import "LoginModel.h"
@interface SuccessRegisterViewController : BaseViewController
@property (nonatomic, strong) LoginModelMsgss *loginModelMsg;
@property (nonatomic, copy) NSString *passwordStr;
@property (nonatomic, copy) NSString *phoneStr;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
- (IBAction)clickGoinAppButton:(UIButton *)sender;
@end
