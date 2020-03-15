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
#import "PersonageDetailsViewController.h"
#import "XYAlertViewHeader.h"

@interface MeViewController ()<UIActionSheetDelegate>
@property (nonatomic, strong) NSArray *files;
@property (nonatomic,strong) LXActionSheet *actionSheet;

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
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
        case 1:
            return 1;
        case 2:
            return 1;
        case 3:
            return 1;
        default:
            return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.1;
    } else if (section == 1){
        return 0.1;
    } else if (section == 2){
        return 0.1;
    } else {
        return 60;
    }
    
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 60)];
    if (section == 3) {
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
    } else{
        return view;
    }
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 60;
        
    } else{
        return 50;
    }
    
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
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        Login *login = [RRTManager manager].loginManager.loginInfo;
        
        UIImageView *avatarImgView = (UIImageView*)[cell viewWithTag:1];
        UILabel *nameLabel =(UILabel*)[cell viewWithTag:2];
        UILabel *accountLabel = (UILabel*)[cell viewWithTag:3];
        
        [avatarImgView setImageWithUrlStr:login.userAvatar
                          placholderImage:[UIImage imageNamed:@"default.png"]];
        nameLabel.text = login.userName;
        accountLabel.text = login.account;
        return cell;
    } else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"OtherCell" forIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        UILabel *menuLabel = (UILabel *)[cell viewWithTag:1];
        UILabel *huancunLabel = (UILabel *)[cell viewWithTag:10];
        if (indexPath.section == 1) {
            SDImageCache *imageCache = [SDWebImageManager sharedManager].imageCache;
            NSString *cache = [NSString stringWithFormat:@"%.1fM", imageCache.getSize / (1024 * 1024.0)];
            huancunLabel.text = cache;
            menuLabel.text = @"清除缓存";
        } else if (indexPath.section == 2){
            menuLabel.text = @"使用指南";
            huancunLabel.hidden = YES;
        } else{
            menuLabel.text = @"关于";
            huancunLabel.hidden = YES;
        }
        
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        [self.navigationController pushViewController:PersonageDetailsVCID
                                       withStoryBoard:SettingStoryBoardName
                                            withBlock:nil];
    } else if (indexPath.section == 1){
        // create an alertView
        XYAlertView *alertView = [XYAlertView alertViewWithTitle:@"提示!"
                                                         message:@"缓存文件可以用来帮你节省流量，但较大时会占用较多的磁盘空间。\n确定开始清理吗？"
                                                         buttons:[NSArray arrayWithObjects:@"确定", @"取消", nil]
                                                    afterDismiss:^(int buttonIndex) {
                                                        
                                                        if (buttonIndex == 0) {
                                                            
                                                            [self clearCacheSuccess];
                                                        }
                                                        
                                                        
                                                    }];
        // set the second button as gray style
        [alertView setButtonStyle:XYButtonStyleGray atIndex:1];
        // display
        [alertView show];
        
    } else if (indexPath.section == 2){
        [self.navigationController pushViewController:UserGuideVCID
                                       withStoryBoard:SettingStoryBoardName
                                            withBlock:nil];
        
    } else if (indexPath.section == 3){
        [self.navigationController pushViewController:AboutVCID
                                       withStoryBoard:SettingStoryBoardName
                                            withBlock:nil];
    }
}

#pragma mark -- 清除缓存
#pragma mark --
- (void)clearCacheSuccess
{
    SDImageCache *imageCache = [SDWebImageManager sharedManager].imageCache;
    NSString *cache = [NSString stringWithFormat:@"%.1fM", imageCache.getSize / (1024 * 1024.0)];
    if (![cache isEqualToString:@"0.0M"]) {
        // clearDisk清文件
        [[SDImageCache sharedImageCache] clearDisk];
        // clearMemory清内存。
        [[SDImageCache sharedImageCache] clearMemory];
        [self showSuccessWithStatus:[NSString stringWithFormat:@"清除缓存%@B",cache]];
        
    } else {
        
        [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"没有缓存可清理啦~#^_^#"];

    }
    
    [self.tableView reloadData];
    
}

- (void)logout:(UIButton*)sender
{
//    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil
//                                                       delegate:self
//                                              cancelButtonTitle:@"取消"
//                                         destructiveButtonTitle:nil
//                                              otherButtonTitles:@"退出登陆", nil];
//    [sheet showInView:self.view];
    self.actionSheet = [[LXActionSheet alloc]initWithTitle:@"退出后不会删除任何历史数据,下次登录依然可以使用本账号" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"退出登录" otherButtonTitles:nil];
    [self.actionSheet showInView:self.view];
}

#pragma mark - LXActionSheetDelegate

- (void)didClickOnButtonIndex:(NSInteger *)buttonIndex
{
    if (buttonIndex == 0) {
        
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
        LoginViewController *loginVC = [mainStoryBoard instantiateViewControllerWithIdentifier:
                                        LoginVCID];
        
        loginVC.bFromLaunch = YES;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
        
        UIWindow *window = ((AppDelegate*)[UIApplication sharedApplication].delegate).window;
        
        window.rootViewController = nav;
    }
}

- (void)didClickOnDestructiveButton
{
    NSLog(@"destructuctive");
}

- (void)didClickOnCancelButton
{
    NSLog(@"cancelButton");
}

//- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (buttonIndex == 0) {
//        
//        [self showWithStatus:nil];
//        //断开IM
//        [[RRTManager manager].imManager disConnect];
//        //清除密码
//        [[RRTManager manager].loginManager logout];
//        
//        //清除IM缓存
//        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
//        NSString* cachesDirectory = [paths objectAtIndex:0];
//        
//        NSString *voicePath = [cachesDirectory stringByAppendingPathComponent:
//                               [NSString stringWithFormat:ChatVoicePath]];
//        NSArray *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:voicePath error:NULL];
//        NSEnumerator *e = [contents objectEnumerator];
//        NSString *filename;
//        while ((filename = [e nextObject])) {
//            [[NSFileManager defaultManager] removeItemAtPath:[voicePath stringByAppendingPathComponent:filename]
//                                                       error:NULL];
//        }
//        
//        
//        NSString *picPath = [cachesDirectory stringByAppendingPathComponent:
//                             [NSString stringWithFormat:ChatImagePath]];
//        contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:picPath error:NULL];
//        e = [contents objectEnumerator];
//        while ((filename = [e nextObject])) {
//            [[NSFileManager defaultManager] removeItemAtPath:[picPath stringByAppendingPathComponent:filename]
//                                                       error:NULL];
//        }
//        
//        //activity
//        NSString *activityPath = [cachesDirectory stringByAppendingPathComponent:
//                             [NSString stringWithFormat:ActivityPath]];
//        contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:activityPath error:NULL];
//        e = [contents objectEnumerator];
//        while ((filename = [e nextObject])) {
//            [[NSFileManager defaultManager] removeItemAtPath:[activityPath stringByAppendingPathComponent:filename]
//                                                       error:NULL];
//        }
//        
//        
//        
//        [self dismiss];
//        
//        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:LoginStoryBoardName
//                                                                 bundle:nil];
//        LoginViewController *loginVC = [mainStoryBoard instantiateViewControllerWithIdentifier:
//                                        LoginVCID];
//        
//        loginVC.bFromLaunch = YES;
//        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
//        
//        UIWindow *window = ((AppDelegate*)[UIApplication sharedApplication].delegate).window;
//        
//        window.rootViewController = nav;
//    }
//}

- (void)viewDidAppear:(BOOL)animated
{
    self.hidesBottomBarWhenPushed = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.hidesBottomBarWhenPushed = NO;
}


@end
