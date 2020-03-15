//
//  SuccessRegisterViewController.m
//  RenrenTong
//
//  Created by 符其彬 on 15/5/18.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "SuccessRegisterViewController.h"
#import "AppDelegate.h"
#import "UILabel+Tool.h"
@interface SuccessRegisterViewController ()
@property (nonatomic, strong) NetWorkManager *netWorkManager;

@end

@implementation SuccessRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =  @"注册";
    self.automaticallyAdjustsScrollViewInsets = NO;
    _netWorkManager = [[NetWorkManager alloc] init];
    
    self.descriptionLabel.text = @"你的账号为手机号码，密码为手机号码后六位，登录后请及时修改。";
    [self.descriptionLabel setAttrColor:self.descriptionLabel.text scaleText:@[@"账号",@"手机号码",@"密码",@"手机号码后六位"] Color:theLoginButtonColor];

}

- (IBAction)clickGoinAppButton:(UIButton *)sender
{
    [self.netWorkManager loginWithUserName:_phoneStr
                              withPassword:_passwordStr
                                   success:^(Login *login)
     {
         [self dismiss];
         [self gotoMainUI:login];
         
     } failed:^(NSString *errorMSG) {
         [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"亲，您输入的用户名或密码错误或者网络不可用哦!"];
     }];
}
- (void)gotoMainUI:(Login*)login
{
    login.account = _loginModelMsg.UserName;
    login.password = _passwordStr;
    [RRTManager manager].loginManager.loginInfo = login;
    
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
    
}

@end
