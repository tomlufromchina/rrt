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
#import "LoginCell.h"
#import "NoNavViewController.h"

@interface LoginViewController () <UITextFieldDelegate,UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UIAlertView *alert;
    UIAlertView *alert1;
    UIAlertView *alert2;
    BOOL isMove;
    UITableView *chooseTableView;
    
    // 保存账号密码头像用户名
    
    NSUserDefaults *userDefaults;
    NSMutableArray* userName;
    NSMutableArray *theUserNumber;
    NSMutableArray *userPassAccount;
    NSMutableArray *userAvatar;
    
    NSMutableArray* tmpUserName;
    NSMutableArray *tmpTheUserNumber;
    NSMutableArray *tmpUserPassAccount;
    NSMutableArray *tmpUserAvatar;
    
    NSIndexPath *theIndexPath;
}

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UIButton *findPasswordBtn;

@property (weak, nonatomic) IBOutlet UIView *subView;

@property (nonatomic, strong) NetWorkManager *netWorkManager;

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    // 手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]
                                          initWithTarget:self
                                          action:@selector(didTappedBackground:)];
    tapGesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGesture];
    
    self.userNameView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.userNameView.userInteractionEnabled = YES;
    self.userNameView.layer.borderWidth = 0.3;
    self.userNameView.layer.cornerRadius = 8.0f;
    
    self.passWordView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.passWordView.userInteractionEnabled = YES;
    self.passWordView.layer.borderWidth = 0.3;
    self.passWordView.layer.cornerRadius = 8.0f;
    
    self.loginButton.layer.cornerRadius = 8.0f;
    self.loginButton.backgroundColor = theLoginButtonColor;
    self.phoneButton.layer.cornerRadius = 25.0f;
    self.startUserButton.top = self.loginButton.bottom + 15;
    self.fogetterButton.top = self.loginButton.bottom + 15;
    self.headerView.backgroundColor = homeHeaderColor;
    //Add right button
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"取消"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    
    self.accountTextField.delegate = self;
    self.passwordTextField.delegate = self;
    self.accountTextField.tintColor = theLoginButtonColor;
    self.passwordTextField.tintColor = theLoginButtonColor;

    
    //根据之前的登录信息初始化登录界面
    Login *loginInfo = [RRTManager manager].loginManager.loginInfo;
    if (loginInfo) {
        self.accountTextField.text = loginInfo.account;
        self.passwordTextField.text = loginInfo.password;
    }
    
    _netWorkManager = [[NetWorkManager alloc] init];
    
    
    // 网络监听
    AppDelegate *appDlg = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if(appDlg.isReachable){
        NSLog(@"网络连接正常");
        
    } else{
        NSLog(@"网络连接异常");
        
        if (is_IOS_8) {// ios8：
            
            alert = [[UIAlertView alloc] initWithTitle:@"提示！"
                                               message:@"世界上最遥远的距离就是没网。检查设置"
                                              delegate:self
                                     cancelButtonTitle:@"我知道了"
                                     otherButtonTitles:nil];
            [alert show];
            
        } else{// ios7以下：
            
            alert1 = [[UIAlertView alloc] initWithTitle:@"提示！"
                                                message:@"世界上最遥远的距离就是没网。检查设置"
                                               delegate:self
                                      cancelButtonTitle:@"我知道了"
                                      otherButtonTitles:nil];
            [alert1 show];
        }
    }
    
    UIImage *backImageName = [UIImage imageNamed:@"账号登录-点击下拉_03-"];
    UIImageView *taleviewBackImageView = [[UIImageView alloc]initWithImage:backImageName];
    chooseTableView = [[UITableView alloc] init];
    chooseTableView.top = self.userNameView.bottom;
    chooseTableView.left = 16;
    chooseTableView.width = SCREENWIDTH - 32;
    chooseTableView.height = 0;
    chooseTableView.hidden = YES;
    chooseTableView.dataSource = self;
    chooseTableView.delegate = self;
    
    [chooseTableView setBackgroundView:taleviewBackImageView];
    chooseTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:chooseTableView];
    if ([chooseTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [chooseTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([chooseTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [chooseTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    [self getLocalUserInformation];
    
}
//-(void)dealloc
//{
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
//}

#pragma mark - keyboard show and hide
#pragma mark -
//- (void)keyboardShow:(NSNotification *)note
//{
//    CGRect rect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    CGFloat ty = 0;
//    ty = rect.size.height - 110 ;
//    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]
//                     animations:^{
//                         if ([self.accountTextField isFirstResponder]) {
//                             self.view.transform = CGAffineTransformMakeTranslation(0, -ty + 80);
//
//                         } else{
//                             self.theLoginViewController.view.transform = CGAffineTransformMakeTranslation(0, -ty);
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
//                         self.theLoginViewController.view.transform = CGAffineTransformIdentity;
//                     }];
//}

#pragma mark -- 获取本地用户信息

- (void)getLocalUserInformation
{
    [tmpUserName removeAllObjects];
    
    userDefaults = [NSUserDefaults standardUserDefaults];

    tmpUserName = [NSMutableArray arrayWithArray:(NSMutableArray *)[userDefaults objectForKey:@"userName"]];
    tmpTheUserNumber = [NSMutableArray arrayWithArray:(NSMutableArray *)[userDefaults objectForKey:@"userNumber"]];
    tmpUserAvatar = [NSMutableArray arrayWithArray:(NSMutableArray *)[userDefaults objectForKey:@"userAvatar"]];
    tmpUserPassAccount = [NSMutableArray arrayWithArray:(NSMutableArray *)[userDefaults objectForKey:@"userPassAccount"]];
    
    if ((tmpUserName && [tmpUserName count] > 0) && (tmpTheUserNumber && [tmpTheUserNumber count] > 0) && (tmpUserAvatar && [tmpUserAvatar count] > 0) && (tmpUserPassAccount && [tmpUserPassAccount count] > 0)) {
        [chooseTableView reloadData];
    }
}

#pragma mark -- UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == alert) {
        if (buttonIndex == 0) {
            // IOS8 才支持：
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }
        
        
    } else if (alertView == alert1){
        
        [self.navigationController pushViewController:WithoutTheNetWorkVCID
                                       withStoryBoard:LoginStoryBoardName
                                            withBlock:nil];
        
        
    } else if (alertView == alert2){
        if (buttonIndex == 1) {
            
            if (theIndexPath) {
                NSUserDefaults *tmpUserDefaults = [NSUserDefaults standardUserDefaults];
                NSMutableArray *userName1 = [[tmpUserDefaults objectForKey:@"userName"] mutableCopy];
                tmpUserName = [NSMutableArray arrayWithArray:userName1];
                NSMutableArray *userNumber1 = [[tmpUserDefaults objectForKey:@"userNumber"] mutableCopy];
                tmpTheUserNumber = [NSMutableArray arrayWithArray:userNumber1];
                
                NSMutableArray *userAvatar1 = [[tmpUserDefaults objectForKey:@"userAvatar"] mutableCopy] ;
                tmpUserAvatar = [NSMutableArray arrayWithArray:userAvatar1];
                
                NSMutableArray *userPassAccount1 = [[tmpUserDefaults objectForKey:@"userPassAccount"] mutableCopy];
                tmpUserPassAccount = [NSMutableArray arrayWithArray:userPassAccount1];
                
                [userName1 removeObjectAtIndex:theIndexPath.row];
                [userNumber1 removeObjectAtIndex:theIndexPath.row];
                [userAvatar1 removeObjectAtIndex:theIndexPath.row];
                [userPassAccount1 removeObjectAtIndex:theIndexPath.row];
                
                [tmpUserName removeObjectAtIndex:theIndexPath.row];
                [tmpTheUserNumber removeObjectAtIndex:theIndexPath.row];
                [tmpUserAvatar removeObjectAtIndex:theIndexPath.row];
                [tmpUserPassAccount removeObjectAtIndex:theIndexPath.row];
                
                [tmpUserDefaults setObject:userName1 forKey:@"userName"];
                [tmpUserDefaults setObject:userNumber1 forKey:@"userNumber"];
                [tmpUserDefaults setObject:userAvatar1 forKey:@"userAvatar"];
                [tmpUserDefaults setObject:userPassAccount1 forKey:@"userPassAccount"];
                
                
                [chooseTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:theIndexPath]
                                       withRowAnimation:UITableViewRowAnimationTop];
                
                [chooseTableView reloadData];
                
                if ([tmpUserName count] == 0) {
                    [UIView animateWithDuration:0.5f animations:^{
                        self.drownButton.transform = CGAffineTransformMakeRotation(0);
                        chooseTableView.height = 0;
                        chooseTableView.hidden = YES;
                    }];
                    isMove = NO;
                }else{
                    self.drownButton.transform = CGAffineTransformMakeRotation(0);

                }
            }
        }
    }
}

#pragma mark -- 使用手机登录
- (IBAction)clickPhoneButton:(UIButton *)sender
{
    [self.navigationController pushViewController:TelephoneRegisteringVCID
                                   withStoryBoard:LoginStoryBoardName
                                        withBlock:nil];
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

#pragma mark -- 登录按钮响应

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
             [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"亲，您输入的用户名或密码错误或者网络不可用哦!"];
         }];
    }
}

- (void)gotoMainUI:(Login*)login
{
    login.account = self.accountTextField.text;
    login.password = self.passwordTextField.text;
    [RRTManager manager].loginManager.loginInfo = login;
    if (!self.bFromLaunch) {
        
        /**
         *  为了切换账号
         */
//        userDefaults = [NSUserDefaults standardUserDefaults];
//        [userDefaults setObject:self.accountTextField.text forKey:@"accountText"];
//        [userDefaults setObject:self.passwordTextField.text forKey:@"passwordText"];
//        [userDefaults setObject:login.userAvatar forKey:@"userAvatarURL"];
//        [userDefaults setObject:login.userName forKey:@"userUserName"];
//        [userDefaults synchronize];
        
        //统计登陆
        NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
        CFShow((__bridge CFTypeRef)(infoDic));
        NSString *appVersion = [infoDic objectForKey:@"CFBundleVersion"];
        NSString *theAppVersion = [NSString stringWithFormat:@"v%@",appVersion];
        [self.netWorkManager getBrowseNumber:[RRTManager manager].loginManager.loginInfo.userId ppId:D_Login productId:@"5" version:theAppVersion success:^(NSString *data) {
            
        } failed:^(NSString *errorMSG) {
            
        }];

        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:MainStoryBoardName
                                                                 bundle:nil];
        UIViewController *mainVC = [mainStoryBoard instantiateViewControllerWithIdentifier:
                                         MainVCID];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:mainVC];
        UIWindow *window = ((AppDelegate*)[UIApplication sharedApplication].delegate).window;
        window.rootViewController = nav;
        
        // 将账号保存到本地以便下次登录可以选择
        NSMutableArray *tmpuserNumberArray = [NSMutableArray arrayWithArray:(NSMutableArray *)[userDefaults objectForKey:@"userNumber"]];
        if (![tmpuserNumberArray containsObject:self.accountTextField.text]){
            if (!userName && !theUserNumber && !userAvatar && !userPassAccount) {
                userName = [NSMutableArray arrayWithArray:(NSMutableArray *)[userDefaults objectForKey:@"userName"]];
                theUserNumber = [NSMutableArray arrayWithArray:(NSMutableArray *)[userDefaults objectForKey:@"userNumber"]];
                userAvatar = [NSMutableArray arrayWithArray:(NSMutableArray *)[userDefaults objectForKey:@"userAvatar"]];
                userPassAccount = [NSMutableArray arrayWithArray:(NSMutableArray *)[userDefaults objectForKey:@"userPassAccount"]];
            }
            
            [userName addObject:login.userName];
            [theUserNumber addObject:self.accountTextField.text];
            [userAvatar addObject:login.userAvatar];
            [userPassAccount addObject:self.passwordTextField.text];
            
            [userDefaults setObject:userName forKey:@"userName"];
            [userDefaults setObject:theUserNumber forKey:@"userNumber"];
            [userDefaults setObject:userAvatar forKey:@"userAvatar"];
            [userDefaults setObject:userPassAccount forKey:@"userPassAccount"];
            
            [userDefaults synchronize];
            
        }
        
    } else {
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark -- 注册响应

- (IBAction)signinClicked:(id)sender
{
    [self.theLoginViewController.navigationController pushViewController:NewRegisterVCID
                                   withStoryBoard:LoginStoryBoardName
                                        withBlock:nil];
}

#pragma mark -- 忘记密码

- (IBAction)lostpasswordClicked:(id)sender
{
    NoNavViewController *VC = [[NoNavViewController alloc] init];
    NSString *URL0 = [NSString stringWithFormat:@"http://passport.%@/MobilePassport/MobileForGetPwd",aedudomain];
    VC.URL = URL0;
    VC.title = @"找回密码";
    [self.navigationController pushViewController:VC animated:YES];
}

- (BOOL)validateTheLogin
{
    if (self.accountTextField.text.length <= 0) {
        [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"请输入用户名"];

        return NO;
    }
    if (self.passwordTextField.text.length <= 0) {
        [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"请输入密码"];

        return NO;
    }
    return YES;
}

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [self.passwordTextField resignFirstResponder];
//    [self.accountTextField resignFirstResponder];
//}

#pragma mark -- UITextField delegate
//开始编辑输入框的时候，软键盘出现，执行此事件
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
//    CGRect frame = textField.frame;
//    frame.origin.y = self.subView.frame.origin.y + frame.origin.y;
//    int offset = frame.origin.y + 32 - (self.view.frame.size.height - 216.0);//键盘高度216
//    
//    NSTimeInterval animationDuration = 0.30f;
//    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
//    [UIView setAnimationDuration:animationDuration];
//    
//    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
//    if(offset > 0)
//        self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
//    
//    [UIView commitAnimations];
}

#pragma mark - text field delegate
#pragma mark -
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self loginClicked:nil];
    
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
//    self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}

- (void)goBack
{
    if (!self.bFromLaunch) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - Tap Gesture
#pragma mark -
- (void)didTappedBackground:(UIGestureRecognizer*)ges
{
    [self.view endEditing:YES];
    
}

#pragma mark -- 下拉选择账号

- (IBAction)clickDrwonButton:(UIButton *)sender
{
    if (isMove == NO) {
        if (tmpUserName && [tmpUserName count] > 0) {
            [UIView animateWithDuration:0.5f animations:^{
                self.drownButton.transform = CGAffineTransformMakeRotation(M_PI);
                chooseTableView.hidden = NO;
                chooseTableView.height = 165;
            }];
        }
        isMove = YES;
    }else{
        [UIView animateWithDuration:0.5f animations:^{
            self.drownButton.transform = CGAffineTransformMakeRotation(0);
            chooseTableView.height = 0;
            chooseTableView.hidden = YES;
        }];
        isMove = NO;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tmpUserName && [tmpUserName count] > 0) {
        return [tmpUserName count];
    } else{
        return 0;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    static NSString *CustomCellIdentifier = @"LoginCell";
    
    LoginCell *cell = [tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
    if (cell==nil) {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"LoginCell" owner:self options:nil] lastObject];
    }
    cell.backgroundColor = [UIColor clearColor];

    if (tmpUserName && [tmpUserName count] > 0) {
        cell.userName.text = [tmpUserName objectAtIndex:indexPath.row];
        [cell.headerImageView setImageWithURL:[tmpUserAvatar objectAtIndex:indexPath.row] placeholderImage:[UIImage imageNamed:@"default.png"]];
    }
    
    cell.headerImageView.userInteractionEnabled = YES;
    [cell.headerImageView.layer setCornerRadius:(cell.headerImageView.frame.size.height/2)];
    [cell.headerImageView.layer setMasksToBounds:YES];
    [cell.headerImageView setContentMode:UIViewContentModeScaleAspectFill];
    [cell.headerImageView setClipsToBounds:YES];
    cell.headerImageView.layer.shadowColor = [UIColor blackColor].CGColor;
    cell.headerImageView.layer.shadowOffset = CGSizeMake(4, 4);
    cell.headerImageView.layer.shadowOpacity = 0.5;
    cell.headerImageView.layer.shadowRadius = 2.0;
    cell.headerImageView.layer.borderColor = [[UIColor whiteColor] CGColor];
    cell.headerImageView.layer.borderWidth = 2.0f;
    cell.headerImageView.userInteractionEnabled = YES;
    cell.headerImageView.backgroundColor = [UIColor clearColor];
    
    [cell.drwonButton addTarget:self action:@selector(clickDelegateButton:) forControlEvents:UIControlEventTouchUpInside];

    
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    chooseTableView.hidden = YES;
    if (tmpUserName && [tmpUserName count] > 0) {
        if (tmpTheUserNumber && [tmpTheUserNumber count] > 0) {
            
            self.accountTextField.text = [tmpTheUserNumber objectAtIndex:indexPath.row];

        }
        if (tmpUserPassAccount && [tmpUserPassAccount count] > 0) {
            
            self.passwordTextField.text = [tmpUserPassAccount objectAtIndex:indexPath.row];
            
        }
    }
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [cell setLayoutMargins:UIEdgeInsetsZero];
        
    }
    
}

#pragma mark -- 删除响应

- (void)clickDelegateButton:(UIButton *)sender
{
    
    CGPoint hitPoint = [sender convertPoint:CGPointZero toView:chooseTableView];
    NSIndexPath *indexPath = [chooseTableView indexPathForRowAtPoint:hitPoint];
    NSLog(@"The selected index is:%d----%d", indexPath.section, indexPath.row);
    theIndexPath = indexPath;// 保存成全局
    //初始化AlertView
    alert2 = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:@"你确定要删除此账号吗？"
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定",nil];
    
    [alert2 show];
}
@end
