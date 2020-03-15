//
//  AppDelegate.m
//  RenrenTong
//
//  Created by jeffrey on 14-5-15.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewControllerIdentifier.h"
#import "LoginViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //设置NavBar的背景色
    [[UINavigationBar appearance] setBarTintColor:appColor];
    //设置NavBar左右两边按钮的颜色
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    //设置NavBar的title的颜色
    [[UINavigationBar appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
    
    //建立数据库
    [DataManager setUpCoreDataStack];
    
    //If we need to login
    Login *loginInfo = [RRTManager manager].loginManager.loginInfo;
    if (loginInfo && loginInfo.account && loginInfo.password)
    {
        //在这里还是要登录一次，避免token过期
        NetWorkManager *networkManager = [[NetWorkManager alloc] init];
        [networkManager loginWithUserName:loginInfo.account
                                  withPassword:loginInfo.password
                                       success:^(Login *login)
         {
             
             login.account = loginInfo.account;
             login.password = loginInfo.password;
             [RRTManager manager].loginManager.loginInfo = login;
            
             [[RRTManager manager].imManager connect];
             
             UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:MainStoryBoardName
                                                                      bundle:nil];
             UITableViewController *mainVC = [mainStoryBoard instantiateViewControllerWithIdentifier:
                                              MainVCID];
             
             UIWindow *window = ((AppDelegate*)[UIApplication sharedApplication].delegate).window;
             window.rootViewController = mainVC;
         } failed:^(NSString *errorMSG) {
             UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:LoginStoryBoardName
                                                                      bundle:nil];
             LoginViewController *loginVC = [mainStoryBoard instantiateViewControllerWithIdentifier:
                                             LoginVCID];
             loginVC.bFromLaunch = YES;
             
             UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
             
             self.window.rootViewController = nav;
             
         }];
    } else {
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:LoginStoryBoardName
                                                                 bundle:nil];
        LoginViewController *loginVC = [mainStoryBoard instantiateViewControllerWithIdentifier:
                                      LoginVCID];
        loginVC.bFromLaunch = YES;

        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];

        self.window.rootViewController = nav;
    }

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
