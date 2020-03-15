//
//  MeViewController.m
//  RenrenTong
//
//  Created by jeffrey on 14-8-26.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "MeViewController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"

@interface MeViewController ()<UIActionSheetDelegate>

@end

@implementation MeViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"设置";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 60;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, 280, 40)];
    button.backgroundColor = [UIColor redColor];
    button.layer.cornerRadius = 2.0f;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self
               action:@selector(logout:)
     forControlEvents:UIControlEventTouchUpInside];

    [button setTitle:@"退出登录" forState:UIControlStateNormal];
    
    [view addSubview:button];
    return view;
    
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"MeHeaderCell" forIndexPath:indexPath];
        
        Login *login = [RRTManager manager].loginManager.loginInfo;
        
        UIImageView *avatarImgView = (UIImageView*)[cell viewWithTag:1];
        UILabel *nameLabel =(UILabel*)[cell viewWithTag:2];
        UILabel *accountLabel = (UILabel*)[cell viewWithTag:3];
        
        [avatarImgView setImageWithUrlStr:login.userAvatar
                          placholderImage:[UIImage imageNamed:@"default.png"]];
        nameLabel.text = login.userName;
        accountLabel.text = login.account;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)logout:(UIButton*)sender
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:@"退出登陆", nil];
    [sheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
        [self showWithStatus:nil];
        //断开IM
        [[RRTManager manager].imManager disConnect];
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
        LoginViewController *loginVC = [mainStoryBoard instantiateViewControllerWithIdentifier:
                                        LoginVCID];
        
        loginVC.bFromLaunch = YES;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
        
        UIWindow *window = ((AppDelegate*)[UIApplication sharedApplication].delegate).window;
        
        window.rootViewController = nav;
    }
}


@end
