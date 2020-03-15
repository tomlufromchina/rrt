//
//  NewRegisterViewController.m
//  RenrenTong
//
//  Created by 符其彬 on 15/5/18.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "NewRegisterViewController.h"
#import "SuccessRegisterViewController.h"
@implementation NewRegisterViewController
{
    NSString *roleStr;// 1学生，2家长，3教师
    UIButton *currentRoleBtn;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    currentRoleBtn = self.teacherButton;
    self.title = @"注册";
    self.automaticallyAdjustsScrollViewInsets = NO;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]
                                          initWithTarget:self
                                          action:@selector(didTappedBackground:)];
    tapGesture.cancelsTouchesInView = NO;
    [self.mainScrollView addGestureRecognizer:tapGesture];
    
    self.sureButton.layer.cornerRadius = 5.0f;
    self.phoneTextFiled.delegate = self;
    self.nameTextField.delegate = self;
    
    //    键盘监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillshow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillhide:) name:UIKeyboardWillHideNotification object:nil];
    roleStr = @"3";
}

#pragma mark - 键盘监听及隐藏
-(void)keyboardWillshow:(NSNotification*)notification
{
    CGRect rect = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat ty = - rect.size.height + 100;
    [UIView animateWithDuration:0.25 animations:^{
        self.mainScrollView.transform = CGAffineTransformMakeTranslation(0,ty);
    }];
    
}
-(void)keyboardWillhide:(NSNotification*)notification
{
    self.mainScrollView.transform = CGAffineTransformIdentity;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == self.phoneTextFiled) {
        [self.phoneLineImageView setImage:[UIImage imageNamed:@"line-green"]];

    } else if (textField == self.nameTextField){
        [self.nameLineImageView setImage:[UIImage imageNamed:@"line-green"]];
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.phoneTextFiled) {
        [self.phoneLineImageView setImage:[UIImage imageNamed:@"line-library"]];

    } else if (textField == self.nameTextField){
        [self.nameLineImageView setImage:[UIImage imageNamed:@"line-library"]];

    }
}
- (IBAction)selectRole:(id)sender {
    switch (currentRoleBtn.tag) {
        case 1:
        case 4:
        {
            [self.teacherHeaderImageView setImage:[UIImage imageNamed:@"teacher"]];
            [self.teacherButton setBackgroundImage:[UIImage imageNamed:@"round2-"]
                                          forState:UIControlStateNormal];
            [self.teacherButton setTitleColor:theLoginButtonColor
                                     forState:UIControlStateNormal];
            
        }
            break;
        case 2:
        case 5:
        {
            [self.parentsImageView setImage:[UIImage imageNamed:@"parents"]];
            [self.parentsButton setBackgroundImage:[UIImage imageNamed:@"round2-"]
                                          forState:UIControlStateNormal];
            [self.parentsButton setTitleColor:theLoginButtonColor
                                     forState:UIControlStateNormal];
            
        }
            break;
        case 3:
        case 6:
        {
            [self.studentImageView setImage:[UIImage imageNamed:@"student"]];
            [self.studentButton setBackgroundImage:[UIImage imageNamed:@"round2-"]
                                          forState:UIControlStateNormal];
            [self.studentButton setTitleColor:theLoginButtonColor
                                     forState:UIControlStateNormal];
            
        }
            break;
        default:
            break;
    }
    currentRoleBtn = (UIButton*)sender;
    switch (currentRoleBtn.tag) {
        case 1:
        case 4:
        {
            roleStr = @"3";
            [self.teacherHeaderImageView setImage:[UIImage imageNamed:@"teacherteacher-down"]];
            [self.teacherButton setBackgroundImage:[UIImage imageNamed:@"round-"]
                                          forState:UIControlStateNormal];
            [self.teacherButton setTitleColor:[UIColor whiteColor]
                                     forState:UIControlStateNormal];
            
        }
            break;
        case 2:
        case 5:
        {
            roleStr = @"2";
            [self.parentsImageView setImage:[UIImage imageNamed:@"parents-down"]];
            [self.parentsButton setBackgroundImage:[UIImage imageNamed:@"round-"]
                                          forState:UIControlStateNormal];
            [self.parentsButton setTitleColor:[UIColor whiteColor]
                                     forState:UIControlStateNormal];
            
        }
            break;
        case 3:
        case 6:
        {
            roleStr = @"1";
            [self.studentImageView setImage:[UIImage imageNamed:@"student-down"]];
            [self.studentButton setBackgroundImage:[UIImage imageNamed:@"round-"]
                                          forState:UIControlStateNormal];
            [self.studentButton setTitleColor:[UIColor whiteColor]
                                     forState:UIControlStateNormal];
            
        }
            break;
        default:
            break;
    }
    
    
}


#pragma mark -- 确定
- (IBAction)clcikSureButton:(UIButton *)sender
{
    if (![self isValidateMobile:self.phoneTextFiled.text]) {
        [self showUploadView:@"您的手机格式不正确，请检查"];
    }
    if ([self validateTheLogin]) {
        NSString *url = [NSString stringWithFormat:@"http://passport.%@/api/PhoneRegister",aedudomain];
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self.nameTextField.text,@"username",self.phoneTextFiled.text,@"phone",roleStr,@"role",nil];
        [HttpUtil GetWithUrl:url parameters:dic success:^(id json) {
            LoginModels *loginModel = [[LoginModels alloc] initWithString:json error:nil];
            if (loginModel.status == 0) {
                _loginModelMsg = loginModel.msg;
                [self showImage:[UIImage imageNamed:@"confirm-ok72"] status:@"注册成功"];
                [self performSelector:@selector(jumpVC) withObject:self afterDelay:1.0F];
            }else{
                ErrorModel *erromodel = [[ErrorModel alloc] initWithString:json error:nil];
               [self showImage:[UIImage imageNamed:@"error"] status:erromodel.msg];
            }
        } fail:^(id errors) {
            [self showImage:[UIImage imageNamed:@"error"] status:errors];
        } cache:^(id cache) {
            
        }];
    }
}


- (void)jumpVC
{
    [self.navigationController pushViewController:SuccessRegisterVCID
                                   withStoryBoard:LoginStoryBoardName
                                        withBlock:^(UIViewController *viewController) {
                                            SuccessRegisterViewController *vc = (SuccessRegisterViewController*)viewController;
                                            NSString *tempPasswordStr = [self.phoneTextFiled.text substringWithRange:NSMakeRange(5, 6)];
                                            vc.passwordStr = tempPasswordStr;
                                            vc.loginModelMsg = _loginModelMsg;
                                            vc.phoneStr = self.phoneTextFiled.text;
                                        }];
}

#pragma mark - Tap Gesture
#pragma mark -
- (void)didTappedBackground:(UIGestureRecognizer*)ges
{
    [self.view endEditing:YES];
}
- (BOOL)validateTheLogin
{
    if (self.phoneTextFiled.text.length <= 0) {
        [self showUploadView:@"请输入您的手机号哒..."];
        return NO;
    }
    if (self.phoneTextFiled.text.length != 11) {
        [self showUploadView:@"您的手机格式不正确，请检查"];
        return NO;
    }
    if (self.nameTextField.text.length <= 0) {
        [self showUploadView:@"请输入您的名字哒..."];
        return NO;
    }
    return YES;
}
#pragma mark -- 判断手机
- (BOOL)isValidateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

@end
