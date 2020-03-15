//
//  LeftViewController.m
//  HLJ_Project
//
//  Created by 何丽娟 on 15/5/9.
//  Copyright (c) 2015年 何丽娟. All rights reserved.
//

#import "LeftViewController.h"
#import "UIViewExt.h"
#import "ModificationViewController.h"
#import "WebViewController.h"
#import "MyZBPhotoViewController.h"

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
//屏幕高度
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define TextFont  [UIFont systemFontOfSize:15]
@interface LeftViewController ()<ModificationVCDelegate>
@property (strong, readwrite, nonatomic) UITableView *tableView;
@property (nonatomic, strong) NetWorkManager *netWorkManager;
@property (nonatomic, strong) UIImageView *userImageView;
@property (nonatomic, strong) UILabel *userRoleLabel;
@end

@implementation LeftViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _netWorkManager = [[NetWorkManager alloc] init];
    UIImageView *backGrounpImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    backGrounpImageView.image = [UIImage imageNamed:@"cb-"];
    [self.view addSubview:backGrounpImageView];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(10, 20, self.view.frame.size.width, 150)];
    [self.view addSubview:headerView];
    
    _userImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 80, 80)];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(ModificationHeaderImageview:)
                                                 name: ModificationHeader
                                               object: nil];
    [_userImageView.layer setCornerRadius:(_userImageView.frame.size.height/2)];
    _userImageView.layer.masksToBounds = YES;
    _userImageView .contentMode = UIViewContentModeScaleAspectFit;
    _userImageView.layer.shadowColor = [UIColor grayColor].CGColor;
    _userImageView.layer.shadowOffset = CGSizeMake(8, 8);
    _userImageView.layer.shadowOpacity = 1.0f;
    _userImageView.layer.shadowRadius = 4.0f;
    _userImageView.layer.borderColor = [[UIColor whiteColor] CGColor];
    _userImageView.layer.borderWidth = 2.0f;
    _userImageView.userInteractionEnabled = YES;
    _userImageView.backgroundColor = [UIColor clearColor];
    [_userImageView setImageWithURL:[NSURL URLWithString:[RRTManager manager].loginManager.loginInfo.userAvatar] placeholderImage:[UIImage imageNamed:@"default"] options:SDWebImageRefreshCached];

    [headerView addSubview:_userImageView];
    
    UILabel *userLabel = [[UILabel alloc] initWithFrame:CGRectMake(_userImageView.right + 10, 15, 300, 50)];
    userLabel.text = [NSString stringWithFormat:@"%@",[RRTManager manager].loginManager.loginInfo.userName];
    userLabel.textColor = [UIColor whiteColor];
    userLabel.textAlignment = NSTextAlignmentLeft;
    userLabel.font = [UIFont systemFontOfSize:20];
    [headerView addSubview:userLabel];
    
    // 注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi:) name:@"RoleName" object:nil];
    _userRoleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_userImageView.right + 10, userLabel.bottom - 10, 300, 50)];
    _userRoleLabel.textColor = [UIColor whiteColor];
    _userRoleLabel.textAlignment = NSTextAlignmentLeft;
    _userRoleLabel.font = [UIFont systemFontOfSize:17];
    [headerView addSubview:_userRoleLabel];
    
    UIImageView *footerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(25, SCREEN_HEIGHT - 38, 18, 18)];
    footerImageView.image = [UIImage imageNamed:@"qh-"];
    [self.view addSubview:footerImageView];
    
    UIButton *accountButton = [UIButton buttonWithType:UIButtonTypeCustom];
    accountButton.frame = CGRectMake(footerImageView.right - 5, SCREEN_HEIGHT - 50, 100, 40);
    [accountButton setTitle:@"切换账号" forState:UIControlStateNormal];
    accountButton.titleLabel.font = TextFont;
    [accountButton addTarget:self action:@selector(clickAccountButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:accountButton];
    
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(20, headerView.bottom, self.view.frame.size.width, SCREEN_HEIGHT - 280) style:UITableViewStylePlain];
        tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.opaque = NO;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.backgroundView = nil;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.bounces = NO;
        tableView;
    });
    [self.view addSubview:self.tableView];
}

- (void)tongzhi:(NSNotification *)text
{
    _userRoleLabel.text = [NSString stringWithFormat:@"%@",text.userInfo[@"RoleName"]];
}

-(void)ModificationHeaderImageview:(NSNotification*)notefication
{
    [_userImageView setImageWithURL:[NSURL URLWithString:[RRTManager manager].loginManager.loginInfo.userAvatar] placeholderImage:[UIImage imageNamed:@"default"] options:SDWebImageRefreshCached];
//    _userImageView.image = notefication.userInfo[@"savedImage"];

}

- (void)clickAccountButton
{
    [self.navigationController pushViewController:SwitchAccountVCID
                                   withStoryBoard:AboutMeStoryBoardName
                                        withBlock:nil];
}


#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
        {
            [self.navigationController pushViewController:ModificationVCID
                                           withStoryBoard:SettingStoryBoardName
                                                withBlock:^(UIViewController *viewController) {
                                                    ModificationViewController *VC = (ModificationViewController *)viewController;
                                                    VC.delegate = self;
                                                    if ([[NSString stringWithFormat:@"%@",[RRTManager manager].loginManager.loginInfo.userRole] isEqualToString:@"1"]) {
                                                        VC.isRole = @"学生";

                                                    } else if ([[NSString stringWithFormat:@"%@",[RRTManager manager].loginManager.loginInfo.userRole] isEqualToString:@"2"]){
                                                        VC.isRole = @"家长";

                                                    } else{
                                                        VC.isRole = @"老师";

                                                    }
                                                }];
        }
            break;
        case 1:
        {
            MyZBPhotoViewController *ZBVc = [[MyZBPhotoViewController alloc]init];
            [self.navigationController pushViewController:ZBVc animated:YES];
        }
            break;
        case 2:
        {
            WebViewController *VC = [[WebViewController alloc] init];
            UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                         style:UIBarButtonItemStylePlain
                                                                        target:nil
                                                                        action:nil];
            [self.navigationItem setBackBarButtonItem:backItem];
            
            NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
            CFShow((__bridge CFTypeRef)(infoDic));
            NSString *appVersion = [infoDic objectForKey:@"CFBundleVersion"];
            NSString *theAppVersion = [NSString stringWithFormat:@"v%@",appVersion];
            
            NSString *str = [NSString stringWithFormat:@"http://dsjtj.%@/Question/index?token=%@&ProductId=5&Edition=%@",aedudomain,[RRTManager manager].loginManager.loginInfo.tokenId,theAppVersion];
            NSString *URL2 = str;
            VC.URL = URL2;
            VC.title = @"问题反馈";
            [self.navigationController pushViewController:VC animated:YES];
        }
            break;
        case 3:
        {
            NSString *webLink = @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=641431831";
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:webLink]];
        }
            break;
        case 4:
        {
            [self.navigationController pushViewController:AboutVCID
                                           withStoryBoard:SettingStoryBoardName
                                                withBlock:nil];
        }
            break;
        default:
            break;
    }
}

#pragma mark -
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (SCREEN_HEIGHT - 280) / 5;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = TextFont;
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.highlightedTextColor = [UIColor lightGrayColor];
        cell.selectedBackgroundView = [[UIView alloc] init];
    }
    NSArray *titles = @[@"个人资料", @"二维码名片", @"意见反馈", @"给我们评分", @"关于"];
    NSArray *images = @[@"r-", @"ewm-", @"fk-", @"tz-", @"gy-"];
    cell.textLabel.text = titles[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:images[indexPath.row]];
    return cell;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name: @"RoleName" object: nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ModificationHeader object:nil];

}

@end
