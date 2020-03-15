//
//  ChangePasswordViewController.m
//  RenrenTong
//
//  Created by 符其彬 on 15/1/19.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "LoginViewController.h"
#import "MainLoginViewController.h"
#import "AppDelegate.h"

@interface ChangePasswordViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) NetWorkManager *netWorkManager;

@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"修改密码";
    
    self.navigationController.navigationBar.translucent = NO;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"保存"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(save)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.view1.left = 10;
    self.view1.width = SCREENWIDTH - 20;
    self.view1.layer.cornerRadius = 5;
    self.textFild1.left = 5;
    self.textFild1.width = SCREENWIDTH - 20;
    self.textFild1.secureTextEntry = YES;
    self.textFild1.delegate = self;
    
    self.view2.left = 10;
    self.view2.width = SCREENWIDTH - 20;
    self.view2.layer.cornerRadius = 5;

    self.textFild2.left = 5;
    self.textFild2.width = SCREENWIDTH - 20;
    self.textFild2.secureTextEntry = YES;
    self.textFild2.delegate = self;
    
    self.view3.left = 10;
    self.view3.width = SCREENWIDTH - 20;
    self.view3.layer.cornerRadius = 5;

    self.textFild3.left = 5;
    self.textFild3.width = SCREENWIDTH - 20;
    self.textFild3.secureTextEntry = YES;
    self.textFild3.delegate = self;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]
                                          initWithTarget:self
                                          action:@selector(didTappedBackground:)];
    tapGesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGesture];
    
    self.netWorkManager = [[NetWorkManager alloc] init];

}

#pragma mark -- 保存新密码

- (void)save
{
    [self show];
    if ([self validateTheLogin]) {
        NSRange range = [self.textFild2.text rangeOfString:@" "];
        if (range.length == 0) {
            [self.netWorkManager changeThePassWord:[RRTManager manager].loginManager.loginInfo.userId
                                            oldPwd:self.textFild1.text
                                            newPwd:self.textFild2.text
                                           success:^(NSString *data) {
                                               [self showImage:[UIImage imageNamed:@"confirm-ok72.png"] status:@"修改成功！"];
                                               [self performSelector:@selector(outGoin) withObject:self afterDelay:1.0];
                                               
                                           } failed:^(NSString *errorMSG) {
                                               [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:errorMSG];
                                               
                                           }];
            
        } else{
            [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"不能包含空格哦！"];
        }
    }
}

#pragma mark -- 退出登录
- (void)outGoin
{
    [self showWithStatus:nil];
    //清除密码
    [[RRTManager manager].loginManager logout];
    
    //清除IM缓存
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString* cachesDirectory = [paths objectAtIndex:0];
    
    NSString *voicePath = [cachesDirectory stringByAppendingPathComponent:
                           [NSString stringWithFormat:ChatVoicePath]];
    NSArray *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:voicePath error:NULL];
    NSEnumerator *e = [contents objectEnumerator];
    NSString *filename;
    while ((filename = [e nextObject])) {
        [[NSFileManager defaultManager] removeItemAtPath:[voicePath stringByAppendingPathComponent:filename]
                                                   error:NULL];
    }
    
    
    NSString *picPath = [cachesDirectory stringByAppendingPathComponent:
                         [NSString stringWithFormat:ChatImagePath]];
    contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:picPath error:NULL];
    e = [contents objectEnumerator];
    while ((filename = [e nextObject])) {
        [[NSFileManager defaultManager] removeItemAtPath:[picPath stringByAppendingPathComponent:filename]
                                                   error:NULL];
    }
    
    //activity
    NSString *activityPath = [cachesDirectory stringByAppendingPathComponent:
                              [NSString stringWithFormat:ActivityPath]];
    contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:activityPath error:NULL];
    e = [contents objectEnumerator];
    while ((filename = [e nextObject])) {
        [[NSFileManager defaultManager] removeItemAtPath:[activityPath stringByAppendingPathComponent:filename]
                                                   error:NULL];
    }
    [self dismiss];
    
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:LoginStoryBoardName
                                                             bundle:nil];
    MainLoginViewController *loginVC = [mainStoryBoard instantiateViewControllerWithIdentifier:
                                    MainLoginVCID];
    
//    loginVC.bFromLaunch = YES;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
    UIWindow *window = ((AppDelegate*)[UIApplication sharedApplication].delegate).window;
    window.rootViewController = nav;
}

#pragma mark - Ubility
#pragma mark -
- (BOOL)validateTheLogin
{
    if (self.textFild1.text.length <= 0) {
        [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"请输入当前密码！"];
        
        return NO;
    }
    
    if (self.textFild2.text.length <= 0) {
        [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"请输入新密码！"];
        
        return NO;
    }
    
    if (self.textFild3.text.length <= 0) {
        [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"请再次输入新密码！"];
        
        return NO;
    }
    
    if (self.textFild2.text.length < 6 || self.textFild2.text.length > 16) {
        [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"密码最少要6位,最多16位哦！" ];
        
        return NO;
    }
    
    if ([self.textFild1.text isEqualToString:self.textFild2.text]) {
        [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"当前密码和新密码不能一致哦！" ];
        
        return NO;
    }
    
    if (![self.textFild2.text isEqualToString:self.textFild3.text]) {
        [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"两次输入的密码不一致哦！" ];
        
        return NO;
    }
    
    return YES;
}

#pragma mark - Tap Gesture
#pragma mark -
- (void)didTappedBackground:(UIGestureRecognizer*)ges
{
    [self.view endEditing:YES];
}

@end
