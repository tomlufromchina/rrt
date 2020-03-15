//
//  AdvertisementViewController.m
//  RenrenTong
//
//  Created by aedu on 14/12/5.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "AdvertisementViewController.h"
#import "TelephoneRegisteringViewController.h"
#import "ViewControllerIdentifier.h"
#import "LoginViewController.h"
#import "MainLoginViewController.h"
#import "AppDelegate.h"
#import "StartView.h"
@interface AdvertisementViewController ()<UIScrollViewDelegate,StartViewDelegate>
{
    UIScrollView *scrollView;
    UIScrollView *smallScrollView;
    NSString *tempImageURL;
}
@property (nonatomic, strong)UIImageView *adImageView;
@property (nonatomic, strong) NetWorkManager *netWorkManager;
@property (nonatomic, strong) StartView *startView;

@end

@implementation AdvertisementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _netWorkManager = [[NetWorkManager alloc] init];
    [self requestAdvertisementData];
    
}

#pragma mark -- 获取广告图片请求
- (void)requestAdvertisementData
{
    [self.netWorkManager getAdvertisement:1
                                    toKen:[RRTManager manager].loginManager.loginInfo.tokenId
                                  success:^(NSArray *data) {
                                      if (data) {
                                          tempImageURL = [data[0] objectForKey:@"ImageURL"];
                                          Advert* advert = [Advert shareAdvert];
                                          // 放到后台线程下载图片
                                          [advert performSelectorInBackground:@selector(getImageFromURL:) withObject:tempImageURL];
                                          [self setupAdImageView];
                                      }
                                  } failed:^(NSString *errorMSG) {
//                                      [self commonLogin];
                                      [self setupAdImageView];

                                  }];
}

//读取本地保存的图片
-(UIImage *) loadImage:(NSString *)fileName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath {
    UIImage * result = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.%@", directoryPath, fileName, extension]];
    
    return result;
}

#pragma mark -- 设置广告
- (void)setupAdImageView
{
    if (tempImageURL.length > 0) {
        self.adImageView = [[UIImageView alloc] init];
        self.adImageView.frame = self.view.bounds;
        // 图片太大加载很慢
        NSString * documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        UIImage * imageFromWeb = [self loadImage:@"MyImage" ofType:@"jpg" inDirectory:documentsDirectoryPath];
        if (imageFromWeb != nil) {
            [self.adImageView setImage:imageFromWeb];
            
        } else{
            [self.adImageView setImage:[UIImage imageNamed:@"HomepageDefuolt.jpg"]];
            
        }
        [self.view addSubview:self.adImageView];
    }
    //判断是又没引导页
    BOOL isPrompt = [[[NSUserDefaults standardUserDefaults] objectForKey:@"isPrompt" ] boolValue];
    if (isPrompt == YES) {
        if (tempImageURL.length > 0){
            [self performSelector:@selector(removeAdimageView) withObject:nil afterDelay:2.0f];

        } else{
            [self removeAdimageView];
        }
    } else{
        [self performSelector:@selector(removeAdimageView) withObject:nil afterDelay:2.0f];
    }
}
#pragma mark -- 移除广告
- (void)removeAdimageView
{
    BOOL isPrompt = [[[NSUserDefaults standardUserDefaults] objectForKey:@"isPrompt" ] boolValue];
    [UIView animateWithDuration:0.3f animations:^{
        self.adImageView.alpha = 0;
        if (isPrompt == YES) {
            [self commonLogin];
        }
    } completion:^(BOOL finished) {
        [self.adImageView removeFromSuperview];
        
        if (!isPrompt) {
            StartView *startView = [[StartView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
            startView.delegate = self;
            self.startView = startView;
            [self.view addSubview:startView];
        }
    }];
}

#pragma mark -- StartViewDelegete
#pragma mark --
-(void)clickTheImages
{
    [UIView animateWithDuration:1.5f animations:^{
        self.startView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.startView removeFromSuperview];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"isPrompt"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self commonLogin];
    }];
}

-(void) commonLogin{
    //建立数据库
    [DataManager setUpCoreDataStack];
    //If we need to login
    Login *loginInfo = [RRTManager manager].loginManager.loginInfo;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *accountStr = [defaults objectForKey:@"TheCurrentUserAccount"];
    
    //1. 创建一个plist文件
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path = [paths objectAtIndex:0];
    NSLog(@"path = %@",path);
    NSString *filename = [path stringByAppendingPathComponent:@"login.plist"];
    //读文件
    NSDictionary* dic2 = [NSDictionary dictionaryWithContentsOfFile:filename];
    NSLog(@"dic is:%@",dic2);
    
    if (accountStr == nil) {// 正常登录
        if (loginInfo && loginInfo.account && loginInfo.password)
        {
            // 解决登陆后白屏问题
            UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:MainStoryBoardName
                                                                     bundle:nil];
            UIViewController *mainVC = [mainStoryBoard instantiateViewControllerWithIdentifier:
                                        MainVCID];
            UINavigationController *nv = [[UINavigationController alloc] initWithRootViewController:mainVC];
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            window.rootViewController = nv;
            
            // 在这里还是要登录一次，避免token过期
            NetWorkManager *networkManager = [[NetWorkManager alloc] init];
            [networkManager loginWithUserName:loginInfo.account
                                 withPassword:loginInfo.password
                                      success:^(Login *login)
             {
                 
                 login.account = loginInfo.account;
                 login.password = loginInfo.password;
                 [RRTManager manager].loginManager.loginInfo = login;
             } failed:^(NSString *errorMSG) {
//                 UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:LoginStoryBoardName
//                                                                          bundle:nil];
//                 MainLoginViewController *loginVC = [mainStoryBoard instantiateViewControllerWithIdentifier:
//                                                 MainLoginVCID];
////                 loginVC.bFromLaunch = YES;
//                 
//                 UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
//                 UIWindow *window = [UIApplication sharedApplication].keyWindow;
//                 window.rootViewController = nav;
                 
             }];
        } else{// 不存在账号和密码的时候
            UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:LoginStoryBoardName
                                                                     bundle:nil];
            MainLoginViewController *loginVC = [mainStoryBoard instantiateViewControllerWithIdentifier:
                                            MainLoginVCID];
//            loginVC.bFromLaunch = YES;
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            window.rootViewController = nav;
        }
        
    } else {// 手机登录
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:MainStoryBoardName
                                                                 bundle:nil];
        UIViewController *mainVC = [mainStoryBoard instantiateViewControllerWithIdentifier:
                                    MainVCID];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:mainVC];
        UIWindow *window = ((AppDelegate *)[UIApplication sharedApplication].delegate).window;
        window.rootViewController = nav;
        
        NetWorkManager *networkManager = [[NetWorkManager alloc] init];
        [networkManager AccordingAccountDebarkation:accountStr
         
                                                pwd:@"3D2e3E2539d6474B95f9943F1d372a9F"
                                            success:^(Login *data) {
                                                if (data) {
                                                    [RRTManager manager].loginManager.loginInfo = data;
                                                }
                                            } failed:^(NSString *errorMSG) {
                                                [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"亲，您输入的用户名或密码错误或者网络不可用哦!"];
                                            }];
    }
}

@end
