//
//  AccountNumberViewController.m
//  RenrenTong
//
//  Created by 符其彬 on 14/12/19.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "AccountNumberViewController.h"
#import "MainLoginViewController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"

@interface AccountNumberViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NetWorkManager *netWorkManager;
@property (nonatomic, strong) NSMutableArray *userInformationArray;
@property (nonatomic, strong) NSMutableString *phoneNumber;

@end

@implementation AccountNumberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;

    self.title = @"登录";
    self.netWorkManager = [[NetWorkManager alloc] init];
    self.userInformationArray = [[NSMutableArray alloc] init];
    [self requestUserListData];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _phoneNumber = [[NSMutableString alloc] init];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(clickSendButton)];
    self.navigationItem.leftBarButtonItem = rightItem;

}

- (void)clickSendButton
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark -- 通过验证码获取用户列表请求

- (void)requestUserListData
{
    [self showWithStatus:@"获取用户信息中"];
    
    [self.netWorkManager AccordingPhoneGetUser:self.thePhoneNumber
                                          code:self.currentDynamicPassword
                                       success:^(NSMutableArray *data) {
                                           
                                           [self dismiss];
                                           [self getUserList:data];
                                           
                                          } failed:^(NSString *errorMSG) {
                                              [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:errorMSG];

                                              [self performSelector:@selector(gotoTheLoginUI) withObject:nil afterDelay:2.5f];
                                              
                                          }];
}

- (void)gotoTheLoginUI
{
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:LoginStoryBoardName
                                                             bundle:nil];
    LoginViewController *loginVC = [mainStoryBoard instantiateViewControllerWithIdentifier:
                                    LoginVCID];
    loginVC.bFromLaunch = YES;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
    UIWindow *window = ((AppDelegate *)[UIApplication sharedApplication].delegate).window;
    window.rootViewController = nav;
}

#pragma mark -- 获取用户列表

- (void)getUserList:(NSMutableArray *)userList

{
    NSLog(@"%@",userList);
    if (userList && [userList count] > 0) {
        self.userInformationArray = userList;
        [self.mainTableView reloadData];
    } else{
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:LoginStoryBoardName
                                                                 bundle:nil];
        LoginViewController *loginVC = [mainStoryBoard instantiateViewControllerWithIdentifier:
                                        LoginVCID];
        loginVC.bFromLaunch = YES;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
        UIWindow *window = ((AppDelegate *)[UIApplication sharedApplication].delegate).window;
        window.rootViewController = nav;
    }
    
}

#pragma mark - Table view data source
#pragma mark -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    } else{
        if (self.userInformationArray && [self.userInformationArray count] > 0) {
            return [self.userInformationArray count];

        } else{
            return 1;
        }
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 100;
    } else{
        return 80;

    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TheAccountNumberHeader"
                                                                forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *thePhoneLabel = (UILabel *)[cell viewWithTag:888];
        UILabel *thePromptLabel = (UILabel *)[cell viewWithTag:999];

        thePhoneLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:23];

        if (self.userInformationArray && [self.userInformationArray count] > 0) {
        _phoneNumber = [NSMutableString stringWithFormat:@"%@",[[self.userInformationArray objectAtIndex:0] objectForKey:@"Phone"]];
            [_phoneNumber replaceCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
            thePhoneLabel.text = _phoneNumber;
        }
        thePhoneLabel.left = 10;
        thePhoneLabel.top = 15;
        thePhoneLabel.width = SCREENWIDTH - 20;
        thePromptLabel.left = 10;
        thePromptLabel.top = thePhoneLabel.bottom + 10;
        thePromptLabel.width = SCREENWIDTH - 20;
        
        return cell;
        
    } else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TheAccountNumberCell"
                                                                forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *view = (UIView *)[cell viewWithTag:101];
        view.left = 10;
        view.top = 0;
        view.width = SCREENWIDTH - 20;
        UIImageView *userHeaderIMG = (UIImageView *)[cell viewWithTag:103];
        userHeaderIMG.left = 8;
        userHeaderIMG.top = 4;
        UILabel *userName = (UILabel *)[cell viewWithTag:104];
        userName.top = 8;
        userName.left = userHeaderIMG.right + 5;
        UILabel *userAccount = (UILabel *)[cell viewWithTag:105];
        userAccount.top = userName.bottom + 5;
        userAccount.left = userHeaderIMG.right + 5;
        view.layer.cornerRadius = 10.0f;
        
        if (indexPath.row == 0) {
            view.backgroundColor = SwitchColor1;
        } else if (indexPath.row == 1){
            view.backgroundColor = SwitchColor2;
        } else if (indexPath.row == 2){
            view.backgroundColor = SwitchColor3;
        }else if (indexPath.row == 3){
            view.backgroundColor = SwitchColor1;
        }else if (indexPath.row == 4){
            view.backgroundColor = SwitchColor2;
        }else if (indexPath.row == 5){
            view.backgroundColor = SwitchColor3;
        }
        
        if (self.userInformationArray && [self.userInformationArray count] > 0) {
            userName.text = [NSString stringWithFormat:@"%@(%@)",[[self.userInformationArray objectAtIndex:indexPath.row] objectForKey:@"UserName"],[[self.userInformationArray objectAtIndex:indexPath.row] objectForKey:@"UserRole"]];
            userAccount.text = [NSString stringWithFormat:@"用户名：%@",[[self.userInformationArray objectAtIndex:indexPath.row] objectForKey:@"UserAccount"]];
            NSString *headerUEL = [[self.userInformationArray objectAtIndex:indexPath.row] objectForKey:@"Photo"];
            [userHeaderIMG setImageWithURL:[NSURL URLWithString:headerUEL]
                          placeholderImage:[UIImage imageNamed:@"default"]];
            
            userHeaderIMG.userInteractionEnabled = YES;
            [userHeaderIMG.layer setCornerRadius:(userHeaderIMG.frame.size.height/2)];
            [userHeaderIMG.layer setMasksToBounds:YES];
            [userHeaderIMG setContentMode:UIViewContentModeScaleAspectFill];
            [userHeaderIMG setClipsToBounds:YES];
            userHeaderIMG.layer.shadowColor = [UIColor blackColor].CGColor;
            userHeaderIMG.layer.shadowOffset = CGSizeMake(4, 4);
            userHeaderIMG.layer.shadowOpacity = 0.5;
            userHeaderIMG.layer.shadowRadius = 3.0;
            userHeaderIMG.layer.borderColor = [[UIColor whiteColor] CGColor];
            userHeaderIMG.layer.borderWidth = 2.0f;
            userHeaderIMG.userInteractionEnabled = YES;
            userHeaderIMG.backgroundColor = [UIColor clearColor];
        }
        return cell;
        
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    // 作为判断正常登录和手机登录的标示
    [defaults setObject:[[self.userInformationArray objectAtIndex:indexPath.row] objectForKey:@"UserAccount"] forKey:@"TheCurrentUserAccount"];
    [defaults synchronize];
    
    if (indexPath.section == 1) {
        
        [self showWithStatus:@"正在登陆"];
        
        if (self.userInformationArray && [self.userInformationArray count] > 0) {
            [self.netWorkManager AccordingAccountDebarkation:[[self.userInformationArray objectAtIndex:indexPath.row] objectForKey:@"UserAccount"]
             
                                                         pwd:@"3D2e3E2539d6474B95f9943F1d372a9F"
                                                     success:^(Login *data) {
                                                         if (data) {
                                                             
                                                             [RRTManager manager].loginManager.loginInfo = data;
                                                             UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:MainStoryBoardName
                                                                                                                      bundle:nil];
                                                             UIViewController *mainVC = [mainStoryBoard instantiateViewControllerWithIdentifier:
                                                                                              MainVCID];
                                                             UINavigationController *VC = [[UINavigationController alloc] initWithRootViewController:mainVC];
                                                             UIWindow *window = ((AppDelegate *)[UIApplication sharedApplication].delegate).window;
                                                             window.rootViewController = VC;
                                                             
                                                            }
                                                         } failed:^(NSString *errorMSG) {
                                                             [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"亲，您输入的用户名或密码错误或者网络不可用哦!"];

                                                         }];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self dismiss];
}
@end
