//
//  LoginViewController.m
//  RenrenTong
//
//  Created by jeffrey on 14-5-15.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "LoginViewController.h"
#import "ViewControllerIdentifier.h"
#import "AppDelegate.h"
#import "SSKeychain.h"
#import "FindPasswordViewController.h"
#import "RegisterViewController.h"

@interface LoginViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UIButton *findPasswordBtn;

@property (weak, nonatomic) IBOutlet UIView *subView;
@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (nonatomic, strong) NetWorkManager *netWorkManager;

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"登陆";
    //Add right button
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"取消"
                                                                  style:UIBarButtonItemStyleBordered
                                                                 target:self
                                                                 action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    
    self.accountTextField.delegate = self;
    self.passwordTextField.delegate = self;
    self.loginBtn.layer.cornerRadius = 2.0f;
    self.loginBtn.backgroundColor = appColor;
    
    //根据之前的登录信息初始化登录界面
    Login *loginInfo = [RRTManager manager].loginManager.loginInfo;
    if (loginInfo) {
        self.accountTextField.text = loginInfo.account;
        self.passwordTextField.text = loginInfo.password;
    }
    
    _netWorkManager = [[NetWorkManager alloc] init];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.bFromLaunch) {
        self.navigationController.navigationBarHidden = YES;
    } else {
        self.navigationController.navigationBarHidden = NO;
    }
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    [self dismiss];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginClicked:(id)sender
{
    [self.accountTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    
    if ([self validateTheLogin]) {
        [self showWithStatus:@"正在登录....."];

        __weak LoginViewController *_self = self;
        
        //test account :158279   password:7565
        [self.netWorkManager loginWithUserName:_self.accountTextField.text
                                  withPassword:_self.passwordTextField.text
                                       success:^(Login *login)
         {
             [self dismiss];
             [_self gotoMainUI:login];
             
         } failed:^(NSString *errorMSG) {
             [self showWithTitle:@"用户名或密码错误" withTime:1.5f];
         }];
    }
}

- (void)gotoMainUI:(Login*)login
{
    login.account = self.accountTextField.text;
    login.password = self.passwordTextField.text;
    [RRTManager manager].loginManager.loginInfo = login;

    

    
    if (self.bFromLaunch) {
        [[RRTManager manager].imManager connect];

        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:MainStoryBoardName
                                                                 bundle:nil];
        UITableViewController *mainVC = [mainStoryBoard instantiateViewControllerWithIdentifier:
                                         MainVCID];
        
        UIWindow *window = ((AppDelegate*)[UIApplication sharedApplication].delegate).window;
        window.rootViewController = mainVC;
    } else {
        [[RRTManager manager].imManager disConnect];
        
        [[RRTManager manager].imManager connect];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)signinClicked:(id)sender
{
    [self.navigationController pushViewController:RegisterVCID
                                   withStoryBoard:LoginStoryBoardName
                                        withBlock:nil];
}
- (IBAction)lostpasswordClicked:(id)sender
{
    [self.navigationController pushViewController:FindPasswordVCID
                                   withStoryBoard:LoginStoryBoardName
                                        withBlock:nil];
}

- (BOOL)validateTheLogin
{
    if (self.accountTextField.text.length <= 0) {
        [self showWithTitle:@"请输入用户名" defaultStr:nil];
        return NO;
    }
    if (self.passwordTextField.text.length <= 0) {
        [self showWithTitle:@"请输入密码" defaultStr:nil];
        return NO;
    }
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.passwordTextField resignFirstResponder];
    [self.accountTextField resignFirstResponder];
}

#pragma mark -- UITextField delegate
//开始编辑输入框的时候，软键盘出现，执行此事件
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect frame = textField.frame;
    frame.origin.y = self.subView.frame.origin.y + frame.origin.y;
    int offset = frame.origin.y + 32 - (self.view.frame.size.height - 216.0);//键盘高度216
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset > 0)
        self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
}

#pragma mark - text field delegate
#pragma mark -
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self loginClicked:nil];
    
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}

- (void)goBack
{
    if (!self.bFromLaunch) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
