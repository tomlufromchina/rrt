//
//  NewRegisterViewController.h
//  RenrenTong
//
//  Created by 符其彬 on 15/5/18.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "BaseViewController.h"
#import "LoginModel.h"
@interface NewRegisterViewController : BaseViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *teacherHeaderImageView;
@property (weak, nonatomic) IBOutlet UIImageView *parentsImageView;
@property (weak, nonatomic) IBOutlet UIImageView *studentImageView;
@property (weak, nonatomic) IBOutlet UIButton *teacherButton;
@property (weak, nonatomic) IBOutlet UIButton *parentsButton;
@property (weak, nonatomic) IBOutlet UIButton *studentButton;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextFiled;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UIImageView *phoneLineImageView;
@property (weak, nonatomic) IBOutlet UIImageView *nameLineImageView;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@property (nonatomic, strong) LoginModelMsgss *loginModelMsg;
- (IBAction)clickTeacherButton:(UIButton *)sender;
- (IBAction)clickParentButton:(UIButton *)sender;
- (IBAction)clickStudntButton:(UIButton *)sender;
- (IBAction)clcikSureButton:(UIButton *)sender;
- (IBAction)clickOneButton:(UIButton *)sender;
- (IBAction)clickTowButton:(UIButton *)sender;
- (IBAction)clickThreeButton:(UIButton *)sender;

@end
