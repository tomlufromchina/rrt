//
//  SwitchAccountViewController.m
//  RenrenTong
//
//  Created by 符其彬 on 14/12/8.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "SwitchAccountViewController.h"
#import "IncreaseAccountViewController.h"
#import "LoginViewController.h"
#import "MainLoginViewController.h"
#import "SwitchAccountCell.h"
#import "AppDelegate.h"

@interface SwitchAccountViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,IncreaseAccountVCDelegate>
{
    NSMutableArray* userName;
    NSMutableArray *userNumber;
    NSMutableArray *userPassAccount;
    NSMutableArray *userAvatar;
}
@property (nonatomic, strong) NetWorkManager *netWorkManager;


@end

@implementation SwitchAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"切换账号";
    
    self.mainTableView.dataSource = self;
    self.mainTableView.delegate = self;
    self.mainTableView.backgroundColor = [UIColor whiteColor];
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UILongPressGestureRecognizer *longpressGesutre=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongpressGesture:)];
    //长按时间为1秒
    longpressGesutre.minimumPressDuration = 0.5f;
    //允许15秒中运动
    longpressGesutre.allowableMovement = 15;
    //所需触摸1次
    longpressGesutre.numberOfTouchesRequired = 1;
    
    [self.mainTableView addGestureRecognizer:longpressGesutre];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]
                                          initWithTarget:self
                                          action:@selector(didTappedBackground:)];
    tapGesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGesture];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"退出登录"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(clickSendButton:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    _netWorkManager = [[NetWorkManager alloc] init];
    [self getLocalUserInformation];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(ModificationHeaderImageview:)
                                                 name: ModificationHeader
                                               object: nil];
}

-(void)ModificationHeaderImageview:(NSNotification*)notefication
{
    BOOL issettingid=[[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"%@isSettingId",[RRTManager manager].loginManager.loginInfo.userId]];
    if (issettingid){
        [self.mainTableView reloadData];
    }
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ModificationHeader object:nil];

}

#pragma mark -- 获取本地用户信息
- (void)getLocalUserInformation
{
    [userName removeAllObjects];

    // 登录账号密码头像
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *accountText = [userDefaults stringForKey:@"accountText"];
    NSString *passwordText = [userDefaults stringForKey:@"passwordText"];
    NSString *userAvatarURL = [userDefaults stringForKey:@"userAvatarURL"];
    NSString *userUserName = [userDefaults stringForKey:@"userUserName"];
    
    userName = [NSMutableArray arrayWithArray:(NSMutableArray *)[userDefaults objectForKey:@"userName"]];
    if (userUserName) {
        [userName addObject:userUserName];

    }

    userNumber = [NSMutableArray arrayWithArray:(NSMutableArray *)[userDefaults objectForKey:@"userNumber"]];
    if (accountText) {
        [userNumber addObject:accountText];

    }

    userAvatar = [NSMutableArray arrayWithArray:(NSMutableArray *)[userDefaults objectForKey:@"userAvatar"]];
    if (userAvatarURL) {
        [userAvatar addObject:userAvatarURL];

    }

    userPassAccount = [NSMutableArray arrayWithArray:(NSMutableArray *)[userDefaults objectForKey:@"userPassAccount"]];
    if (passwordText) {
        [userPassAccount addObject:passwordText];

    }
    
    [self.mainTableView reloadData];
}

#pragma mark -- 退出登录
- (void)clickSendButton:(UIButton *)sender
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"退出后不会删除任何历史数据,下次登录依然可以使用本账号!"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                         destructiveButtonTitle:@"退出登陆"
                                              otherButtonTitles:nil];
    [sheet showInView:self.view];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (userName && [userName count] >0) {
        return [userName count] + 1;

    } else{
        return 1;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"SwitchAccountCell";
    SwitchAccountCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SwitchAccountCell" owner:self options:nil] lastObject];
    }
    if (userName && [userName count] >0) {
        if (indexPath.row == [userName count]) {
            cell.addImageView.hidden = NO;
            cell.backGroupView.hidden = YES;
            
        } else{
            cell.userName.text = [userName objectAtIndex:indexPath.row];
            cell.addImageView.hidden = YES;
            if ([cell.userName.text isEqualToString:[RRTManager manager].loginManager.loginInfo.userName]) {
//                [cell.userFaceImageView setImageWithUrlStr:[RRTManager manager].loginManager.loginInfo.userAvatar placholderImage:[UIImage imageNamed:@"default"]];
                [cell.userFaceImageView setImageWithURL:[NSURL URLWithString:[RRTManager manager].loginManager.loginInfo.userAvatar] placeholderImage:[UIImage imageNamed:@"default"]];
//                NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"currentImage.png"];
//                UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
            }else{
                [cell.userFaceImageView setImageWithURL:[userAvatar objectAtIndex:indexPath.row] placeholderImage:[UIImage imageNamed:@"default.png"]];
            }
            cell.userNumber.text = [NSString stringWithFormat:@"用户名: %@",[userNumber objectAtIndex:indexPath.row]];
            
            
            cell.addImageView.hidden = YES;
            cell.backGroupView.hidden = NO;
            
        }
        
    } else{
        cell.addImageView.hidden = NO;
        cell.backGroupView.hidden = YES;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    cell.userFaceImageView.userInteractionEnabled = YES;
    [cell.userFaceImageView.layer setCornerRadius:(cell.userFaceImageView.frame.size.height/2)];
    [cell.userFaceImageView.layer setMasksToBounds:YES];
    [cell.userFaceImageView setContentMode:UIViewContentModeScaleAspectFill];
    [cell.userFaceImageView setClipsToBounds:YES];
    cell.userFaceImageView.layer.shadowColor = [UIColor blackColor].CGColor;
    cell.userFaceImageView.layer.shadowOffset = CGSizeMake(4, 4);
    cell.userFaceImageView.layer.shadowOpacity = 0.5;
    cell.userFaceImageView.layer.shadowRadius = 2.0;
    cell.userFaceImageView.layer.borderColor = [[UIColor whiteColor] CGColor];
    cell.userFaceImageView.layer.borderWidth = 2.0f;
    cell.userFaceImageView.userInteractionEnabled = YES;
    cell.userFaceImageView.backgroundColor = [UIColor clearColor];
    
    [cell.delegateButton addTarget:self action:@selector(clickDelegateButton:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.addImageView.left = 10;
    cell.addImageView.width = SCREENWIDTH - 20;
    cell.backGroupView.left = 10;
    cell.backGroupView.width = SCREENWIDTH - 20;
    cell.backGroupView.layer.cornerRadius = 8.0;
    
    cell.theNewAccountLabel.left = 100;
    
    if (indexPath.row == 0) {
        cell.backGroupView.backgroundColor = SwitchColor1;
        
    } else if (indexPath.row == 1){
        cell.backGroupView.backgroundColor = SwitchColor2;

    } else if (indexPath.row == 2){
        cell.backGroupView.backgroundColor = SwitchColor3;

    } else if (indexPath.row == 3){
        cell.backGroupView.backgroundColor = SwitchColor1;
        
    } else if (indexPath.row == 4){
        cell.backGroupView.backgroundColor = SwitchColor2;

    } else if (indexPath.row == 5){
        cell.backGroupView.backgroundColor = SwitchColor3;
        
    } else if (indexPath.row == 6){
        cell.backGroupView.backgroundColor = SwitchColor1;
        
    } else if (indexPath.row == 7){
        cell.backGroupView.backgroundColor = SwitchColor2;
        
    } else if (indexPath.row == 8){
        cell.backGroupView.backgroundColor = SwitchColor3;
        
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SwitchAccountCell *cell = (SwitchAccountCell *)[self.mainTableView cellForRowAtIndexPath:indexPath];
    cell.delegateButton.hidden = YES;
    if (userName && [userName count] > 0) {
        if (indexPath.row == [userName count]) {
            
            [self.navigationController pushViewController:IncreaseAccountVCID
                                           withStoryBoard:AboutMeStoryBoardName
                                                withBlock:^(UIViewController *viewController) {
                                                    IncreaseAccountViewController *vc = (IncreaseAccountViewController*)viewController;
                                                    vc.delegate =self;
                                                }];

        } else{
            
            [self showWithStatus:@"正在切换账号"];
            [self.netWorkManager loginWithUserName:[userNumber objectAtIndex:indexPath.row]
                                      withPassword:[userPassAccount objectAtIndex:indexPath.row]
                                           success:^(Login *login)
             {
                 [self dismiss];
                 if (login) {
                     login.account = [userNumber objectAtIndex:indexPath.row];
                     login.password = [userPassAccount objectAtIndex:indexPath.row];
                     [RRTManager manager].loginManager.loginInfo = login;
                     
                     UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:MainStoryBoardName
                                                                              bundle:nil];
                     UIViewController *mainVC = [mainStoryBoard instantiateViewControllerWithIdentifier:
                                                      MainVCID];
                     UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:mainVC];
                     UIWindow *window = ((AppDelegate*)[UIApplication sharedApplication].delegate).window;
                     window.rootViewController = nav;
                     
                     // 切换普通账号的时候将磁盘清空
                     NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
                     [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"_theImageFiles"];
                     [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"tmp_theRecord"];
                     [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"_theRecordTime"];
                     [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"myContent"];
                     [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"isSaveStrOne"];
                     [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"isSaveStrTow"];
                     [[NSUserDefaults standardUserDefaults] synchronize];
                     [defaults removeObjectForKey:@"TheCurrentUserAccount"];
                     [defaults synchronize];
                 }
             } failed:^(NSString *errorMSG) {
                 [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"亲，您输入的用户名或密码错误或者网络不可用哦!"];

             }];
        }
    } else{
        [self.navigationController pushViewController:IncreaseAccountVCID
                                       withStoryBoard:AboutMeStoryBoardName
                                            withBlock:^(UIViewController *viewController) {
                                                IncreaseAccountViewController *vc = (IncreaseAccountViewController*)viewController;
                                                vc.delegate =self;
                                            }];
    }
    
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    CFShow((__bridge CFTypeRef)(infoDic));
    NSString *appVersion = [infoDic objectForKey:@"CFBundleVersion"];
    NSString *theAppVersion = [NSString stringWithFormat:@"v%@",appVersion
                               ];
    // 新用户激活量
    [self.netWorkManager getBrowseNumber:[RRTManager manager].loginManager.loginInfo.userId
                                    ppId:D_Login
                               productId:@"5"
                                 version:theAppVersion success:^(NSString *data) {
                                     
                                 } failed:^(NSString *errorMSG) {
                                     
                                 }];
    
}

#pragma mark -- IncreaseAccountViewControllerDelegate

- (void)chooseTheUserInformation
{
    [self getLocalUserInformation];
}

#pragma mark -- 长按手势响应
- (void)handleLongpressGesture:(UIGestureRecognizer *)gestureRecognizer
{
    CGPoint tmpPointTouch = [gestureRecognizer locationInView:self.mainTableView];
    if (gestureRecognizer.state ==UIGestureRecognizerStateBegan) {
        NSIndexPath *indexPath = [self.mainTableView indexPathForRowAtPoint:tmpPointTouch];
        SwitchAccountCell *cell = (SwitchAccountCell *)[self.mainTableView cellForRowAtIndexPath:indexPath];
        if (indexPath) {
            if (indexPath.row == [userName count] - 1){
                cell.delegateButton.hidden = NO;

            } else{
                cell.delegateButton.hidden = NO;

            }
        }
        NSLog(@"----====%ld",(long)indexPath.row);
    }
}

#pragma mark -- 删除响应
- (void)clickDelegateButton:(UIButton *)sender
{
    CGPoint hitPoint = [sender convertPoint:CGPointZero toView:self.mainTableView];
    NSIndexPath *indexPath = [self.mainTableView indexPathForRowAtPoint:hitPoint];
    if (indexPath) {
        NSLog(@"-------%ld",(long)indexPath.row);
        if (indexPath.row != [userName count] - 1){
            // 取出本地数据
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSMutableArray *userName1 = [[userDefaults objectForKey:@"userName"] mutableCopy];
            NSString *userUserName = [userDefaults stringForKey:@"userUserName"];// 登录
            userName = [NSMutableArray arrayWithArray:userName1];
            if (userUserName) {
                [userName addObject:userUserName];
            }
            
            NSMutableArray *userNumber1 = [[userDefaults objectForKey:@"userNumber"] mutableCopy];
            NSString *accountText = [userDefaults stringForKey:@"accountText"];// 登录
            userNumber = [NSMutableArray arrayWithArray:userNumber1];
            if (accountText) {
                [userNumber addObject:accountText];
            }
            
            NSMutableArray *userAvatar1 = [[userDefaults objectForKey:@"userAvatar"] mutableCopy] ;
            NSString *userAvatarURL = [userDefaults stringForKey:@"userAvatarURL"];// 登录
            userAvatar = [NSMutableArray arrayWithArray:userAvatar1];
            if (userAvatarURL) {
                [userAvatar addObject:userAvatarURL];

            }
            
            NSMutableArray *userPassAccount1 = [[userDefaults objectForKey:@"userPassAccount"] mutableCopy];
            NSString *passwordText = [userDefaults stringForKey:@"passwordText"];// 登录
            userPassAccount = [NSMutableArray arrayWithArray:userPassAccount1];
            if (passwordText) {
                [userPassAccount addObject:passwordText];

                
            }
            
            [userName1 removeObjectAtIndex:indexPath.row];
            [userNumber1 removeObjectAtIndex:indexPath.row];
            [userAvatar1 removeObjectAtIndex:indexPath.row];
            [userPassAccount1 removeObjectAtIndex:indexPath.row];
            
            
            [userName removeObjectAtIndex:indexPath.row];
            [userNumber removeObjectAtIndex:indexPath.row];
            [userAvatar removeObjectAtIndex:indexPath.row];
            [userPassAccount removeObjectAtIndex:indexPath.row];
            
            [userDefaults setObject:userName1 forKey:@"userName"];
            [userDefaults setObject:userNumber1 forKey:@"userNumber"];
            [userDefaults setObject:userAvatar1 forKey:@"userAvatar"];
            [userDefaults setObject:userPassAccount1 forKey:@"userPassAccount"];
            
            
            [self.mainTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            [self.mainTableView reloadData];
            
        } else if (indexPath.row == [userName count] - 1){// 删除当前登录账户
            [self outGoin];
        }
    
    }
}

#pragma mark - UIActionSheet delegate
#pragma mark -
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self outGoin];
        
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

#pragma mark - Tap Gesture
#pragma mark -
- (void)didTappedBackground:(UIGestureRecognizer*)ges
{
    CGPoint tmpPointTouch = [ges locationInView:self.mainTableView];
    if (ges.state ==UIGestureRecognizerStateBegan) {
        NSIndexPath *indexPath = [self.mainTableView indexPathForRowAtPoint:tmpPointTouch];
        SwitchAccountCell *cell = (SwitchAccountCell *)[self.mainTableView cellForRowAtIndexPath:indexPath];
        if (indexPath) {
            cell.delegateButton.hidden = YES;
        }
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    self.hidesBottomBarWhenPushed = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.tabBarController.tabBar.hidden = YES;
    self.hidesBottomBarWhenPushed = NO;
    [self dismiss];
}


@end
