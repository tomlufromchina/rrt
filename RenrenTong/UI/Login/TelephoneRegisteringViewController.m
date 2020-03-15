//
//  TelephoneRegisteringViewController.m
//  RenrenTong
//
//  Created by 符其彬 on 14/12/9.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "TelephoneRegisteringViewController.h"
#import "AccountNumberViewController.h"
#import "NoNavViewController.h"

@interface TelephoneRegisteringViewController ()
{
    BOOL isFirst;
}

@property (nonatomic, strong) NetWorkManager *netWorkManager;
@property (nonatomic, strong) NSString *theDynamicPassword;

@end

@implementation TelephoneRegisteringViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = @"手机号码登录";
    [self initView];
    // 手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]
                                          initWithTarget:self
                                          action:@selector(didTappedBackground:)];
    tapGesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGesture];
    
    self.netWorkManager = [[NetWorkManager alloc] init];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)initView
{
    self.getPassWordButton.enabled = YES;
    self.headerView.backgroundColor = RegisterHeaderColor;
    self.getPassWordButton.backgroundColor = theLoginButtonColor;
    [self.getPassWordButton setTitle:@"获取" forState:UIControlStateNormal];
    self.registeringButton.backgroundColor = theLoginButtonColor;
    
    self.phoneNumberView.layer.cornerRadius = 10.0f;
    self.passwordView.layer.cornerRadius = 10.0f;
    
    self.phoneNumberView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.phoneNumberView.userInteractionEnabled = YES;
    self.phoneNumberView.layer.borderWidth = 0.3;
    self.phoneNumberView.layer.cornerRadius = 8.0f;
    
    self.passwordView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.passwordView.userInteractionEnabled = YES;
    self.passwordView.layer.borderWidth = 0.3;
    self.passwordView.layer.cornerRadius = 8.0f;
    
    self.getPassWordButton.layer.cornerRadius = 8.0f;
    self.registeringButton.layer.cornerRadius = 8.0f;
    self.startUserButton.top = self.registeringButton.bottom + 15;
    self.fogetterButton.top = self.registeringButton.bottom + 15;
    self.phoneTextFiled.keyboardType = UIKeyboardTypeNumberPad;
    self.passwordTextFiled.keyboardType = UIKeyboardTypeNumberPad;
    
    self.phoneNumberView.left = 10;
    self.phoneNumberView.width = SCREENWIDTH - 20;
    
    self.passwordView.left = 10;
    self.passwordView.width = SCREENWIDTH - 20;
    
    self.phoneTextFiled.tintColor = theLoginButtonColor;
    self.passwordTextFiled.tintColor = theLoginButtonColor;
    
    self.phoneTextFiled.width = SCREENWIDTH - 60;
    self.passwordTextFiled.width = SCREENWIDTH/2 + 20;
}

#pragma mark - keyboard show and hide
#pragma mark -
//- (void)keyboardShow:(NSNotification *)note
//{
//    CGRect rect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    CGFloat ty = 0;
//    ty = rect.size.height - 110 ;
//    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]
//                     animations:^{
//                         if ([self.phoneTextFiled isFirstResponder]) {
//                             self.view.transform = CGAffineTransformMakeTranslation(0, -ty + 150);
//                             
//                         } else{
//                             self.theTelePhoneViewController.view.transform = CGAffineTransformMakeTranslation(0, -ty);
//                             
//                         }
//                     }];
//    
//}
//
//- (void)keyboardHide:(NSNotification *)note
//{
//    
//    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]
//                     animations:^{
//                         self.theTelePhoneViewController.view.transform = CGAffineTransformIdentity;
//                         [self initView];
//                     }];
//}

//-(void)dealloc
//{
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
//}

#pragma mark -- 获取手机动态密码
- (void)requsetPhoneBase64Data:(NSString *)theData
{

    [self.netWorkManager getDynamicPassword:theData
                               sendMsgValue:1
                                    success:^(NSString *data) {
                                        [self dismiss];
                                        self.theDynamicPassword = data;
                                        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                                        [userDefaults setObject:self.theDynamicPassword forKey:@"theDynamicPassword"];
                                        [userDefaults synchronize];
                                        
                                        if (!isFirst) {
                                            [self time];
                                        } else {
                                            self.passwordTitle.hidden = NO;
                                            self.passwordTitle.text = @"*我们已经将动态密码以短信的形式发出";
                                        }
                                        
                                    } failed:^(NSString *errorMSG) {
                                        self.getPassWordButton.enabled = YES;
                                        self.getPassWordButton.backgroundColor = homeHeaderColor;
                                        [self.getPassWordButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                                        [self.getPassWordButton setTitle:@"获取" forState:UIControlStateNormal];
                                        self.passwordTitle.hidden = NO;
                                        self.passwordTitle.text = [NSString stringWithFormat:@"*%@",errorMSG];
                                    }];
}

#pragma mark -- 倒计时

- (void)time
{
    __block int timeout = 60;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.getPassWordButton.enabled = YES;
                self.getPassWordButton.backgroundColor = homeHeaderColor;
                [self.getPassWordButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [self.getPassWordButton setTitle:@"获取" forState:UIControlStateNormal];
                
                self.passwordTitle.hidden = NO;
                self.passwordTitle.text = @"*动态密码的有效期为24小时，请查看短信";
            });
        }else{
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.passwordTitle.hidden = NO;
                self.passwordTitle.text = [NSString stringWithFormat:@"*我们已将动态密码已短信形式发出(%@)",strTime];
                
            });
            timeout --;
            
        }
    });
    dispatch_resume(_timer);
    
    isFirst = YES;
}
#pragma mark -- 获取手机base64编码
- (IBAction)clickGetPassWordButton:(UIButton *)sender
{
    self.getPassWordButton.enabled = NO;
    self.getPassWordButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.getPassWordButton setTitleColor:[UIColor grayColor]forState:UIControlStateNormal];
    [self.getPassWordButton setTitle:@"已获取" forState:UIControlStateNormal];
    
    if (![self isValidateMobile:self.phoneTextFiled.text]) {
        
        [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"您的手机格式不正确，请检查"];
        self.getPassWordButton.enabled = YES;
        self.getPassWordButton.backgroundColor = homeHeaderColor;
        [self.getPassWordButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.getPassWordButton setTitle:@"获取" forState:UIControlStateNormal];

        
    } else {

        // base64编码
        [self.netWorkManager getPhoneBase64Code:self.phoneTextFiled.text success:^(NSString *data) {
            [self dismiss];
            if (data) {
                [self requsetPhoneBase64Data:data];
                
            }
        } failed:^(NSString *errorMSG) {
            
        }];
    }
    
}

#pragma mark -- 确定
- (IBAction)clickRegisterButton:(UIButton *)sender
{
    self.passwordTitle.hidden = YES;
    if (![self isValidateMobile:self.phoneTextFiled.text]) {
        
        [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"您的手机格式不正确，请检查"];

    }
    if ([self validateTheLogin]) {
        
        [self.theTelePhoneViewController.navigationController pushViewController:AccountNumberVCID
                                       withStoryBoard:LoginStoryBoardName
                                            withBlock:^(UIViewController *viewController) {
                                                AccountNumberViewController *VC = (AccountNumberViewController*)viewController;
                                                VC.currentDynamicPassword = self.passwordTextFiled.text;
                                                VC.thePhoneNumber = self.phoneTextFiled.text;
                                            }];
    
    }
}

#pragma mark -- 注册

- (IBAction)clickNewUsersRegisterButton:(UIButton *)sender
{
    [self.theTelePhoneViewController.navigationController pushViewController:NewRegisterVCID
                                                          withStoryBoard:LoginStoryBoardName
                                                               withBlock:nil];
}

#pragma mark -- 忘记密码

- (IBAction)clickFogetPasswordButton:(UIButton *)sender
{
    NoNavViewController *VC = [[NoNavViewController alloc] init];
    NSString *URL0 = [NSString stringWithFormat:@"http://passport.%@/MobilePassport/MobileForGetPwd",aedudomain];
    VC.URL = URL0;
    VC.title = @"找回密码";
    [self.navigationController pushViewController:VC animated:YES];
}

- (BOOL)validateTheLogin
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *myString = [userDefaultes stringForKey:@"theDynamicPassword"];
    
    if (self.phoneTextFiled.text.length <= 0) {
        [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"请输入手机号"];

        return NO;
    }
    if (self.phoneTextFiled.text.length != 11) {
        [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"您的手机格式不正确，请检查"];

        return NO;
    }
    if (self.passwordTextFiled.text.length <= 0) {
        [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"请输入动态密码"];

        return NO;
    }
    if ([self.passwordTextFiled.text isEqualToString:myString]) {
        return YES;
    }
    if (self.passwordTextFiled.text.length != 6) {
        [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"请输入6位验证码！"];
        
        return NO;
    }
    if ([[[self.getPassWordButton titleLabel] text] isEqualToString:@"获取密码"]) {
        [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"请点击获取动态密码！"];
        return NO;
    }
    
    if (![self.passwordTextFiled.text isEqualToString:myString]) {
        [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"你输入的动态密码错误！"];
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

#pragma mark - Tap Gesture
#pragma mark -
- (void)didTappedBackground:(UIGestureRecognizer*)ges
{
    [self.view endEditing:YES];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [self dismiss];
}
@end
