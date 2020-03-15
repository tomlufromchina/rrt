//
//  AboutMeViewController.m
//  RenrenTong
//
//  Created by 符其彬 on 14/12/5.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "AboutMeViewController.h"
#import "WebViewController.h"

@interface AboutMeViewController ()
{
    UIView* backGrounpView;
    UIView *tabarView;
    UIView *tabarView1;
    UIView *rewardView;
    UIView *advertisementView;
    UIImageView *advertisementImageView;
    UIButton *vanishingButton;

    GuardianViewController *gurDianVC;
    TheTeacherViewController *techerVC;
    StudiesStirsViewController *studiesStirsVC;
    CurrentTeacherViewController *currentTeacherVC;
    CurrentGuarDianViewController *currentGuarDianVC;
    CurrentStudiesViewController *currentStudiesVC;
    
    int integralNumber;
    
    UIAlertView *alert;
    UIAlertView *alert1;
    NSString *AdNameStr;

}

@property (nonatomic, strong) NetWorkManager *netWorkManager;

@end

@implementation AboutMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.netWorkManager = [[NetWorkManager alloc] init];
    
    isOpenAdvert=NO;
    NSString *role = [NSString stringWithFormat:@"%@",[RRTManager manager].loginManager.loginInfo.userRole];
    //统计登陆
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    CFShow((__bridge CFTypeRef)(infoDic));
    NSString *appVersion = [infoDic objectForKey:@"CFBundleVersion"];
    NSString *theAppVersion = [NSString stringWithFormat:@"v%@",appVersion];
    [self.netWorkManager getBrowseNumber:[RRTManager manager].loginManager.loginInfo.userId ppId:D_Login productId:@"5" version:theAppVersion success:^(NSString *data) {
        
    } failed:^(NSString *errorMSG) {
        
    }];
    if ([role isEqualToString:@"2"]) {// 家长
        
        currentGuarDianVC = [[CurrentGuarDianViewController alloc] init];
        [self addChildViewController:currentGuarDianVC];
        [currentGuarDianVC didMoveToParentViewController:self];
        currentGuarDianVC.view.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);

        [self.view addSubview:currentGuarDianVC.view];
//        [currentGuarDianVC requestServicerData];

    } else  if ([role isEqualToString:@"3" ] || [role isEqualToString:@"4"] || [role isEqualToString:@"5"] || [role isEqualToString:@"6"]){// 老师、班主任、年级组长、学校领导
        
        currentTeacherVC = [[CurrentTeacherViewController alloc] init];
        [self addChildViewController:currentTeacherVC];
        [currentTeacherVC didMoveToParentViewController:self];
        currentTeacherVC.view.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
        [self.view addSubview:currentTeacherVC.view];
//        [techerVC requestServicerData];
        
    } else if ([role isEqualToString:@"1"]){// 学生
        
        currentStudiesVC = [[CurrentStudiesViewController alloc] init];
        [self addChildViewController:currentStudiesVC];
        [currentStudiesVC didMoveToParentViewController:self];
        currentStudiesVC.view.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
        [self.view addSubview:currentStudiesVC.view];
//        [studiesStirsVC requestServicerData];
        
    }
    
    // 安装量统计：
    NSUserDefaults* nud=[NSUserDefaults standardUserDefaults];
    BOOL isPrompt = [[nud objectForKey:[NSString stringWithFormat:@"isFirst%@",[RRTManager manager].loginManager.loginInfo.userId]] boolValue];
    [nud synchronize];
    
    if (!isPrompt) {
        NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
        CFShow((__bridge CFTypeRef)(infoDic));
        NSString *appVersion = [infoDic objectForKey:@"CFBundleVersion"];
        NSString *theAppVersion = [NSString stringWithFormat:@"v%@",appVersion
                                   ];
        [self.netWorkManager getInstallmentNumber:@"5" version:theAppVersion success:^(NSString *data) {
            
        } failed:^(NSString *errorMSG) {
            
        }];

    }
    
    [nud setObject:[NSNumber numberWithBool:YES] forKey:[NSString stringWithFormat:@"isFirst%@",[RRTManager manager].loginManager.loginInfo.userId]];
    
    [nud synchronize];
    
    // 新用户激活量
    [self.netWorkManager getBrowseNumber:[RRTManager manager].loginManager.loginInfo.userId
                                    ppId:D_Login
                               productId:@"5"
                                 version:theAppVersion
                                 success:^(NSString *data) {
        
    } failed:^(NSString *errorMSG) {
        
    }];
    
    
    [self requestAdvertismentIsToday];
    [self requestData];
}

#pragma mark -- 判断出现一次广告页面

- (void)requestAdvertismentIsToday
{
    [self.netWorkManager isTodayAppears:[RRTManager manager].loginManager.loginInfo.tokenId
                                success:^(NSString *data) {
                                    NSLog(@"%@",data);
                                    if ([data isEqualToString:@"1"]) {
                                        [self requestAdvertisementData];

                                    }
                                } failed:^(NSString *errorMSG) {
                                    
                                }];
}

#pragma mark -- 广告请求

- (void)requestAdvertisementData
{
//    [self.netWorkManager getAdvertisementsuccess:^(NSArray *data) {
//        [self dismiss];
//        
//        Advert* advert = [Advert shareAdvert];
//        // 放到后台下载图片
//        [advert performSelectorInBackground:@selector(getImageFromURL1:) withObject:[[data objectAtIndex:0] objectForKey:@"ImageURL"]];
//        isOpenAdvert=YES;
//        adverturl=[[data objectAtIndex:0] objectForKey:@"LinkUrl"];
//        [self initAdvertisement];
//        
//    } failed:^(NSString *errorMSG) {
//        isOpenAdvert=NO;
//    }];
    [self.netWorkManager getAdvertisement:2
                                    toKen:[RRTManager manager].loginManager.loginInfo.tokenId
                                  success:^(NSArray *data) {
                                      Advert* advert = [Advert shareAdvert];
                                      // 放到后台下载图片
                                      [advert performSelectorInBackground:@selector(getImageFromURL1:) withObject:[[data objectAtIndex:0] objectForKey:@"ImageURL"]];
                                      isOpenAdvert = YES;
                                      adverturl = [[data objectAtIndex:0] objectForKey:@"LinkUrl"];
                                      [self initAdvertisement];
                                      AdNameStr = [[data objectAtIndex:0] objectForKey:@"AdName"];
                                  } failed:^(NSString *errorMSG) {
                                      isOpenAdvert = NO;
                                  }];
}

//读取本地保存的图片
-(UIImage *) loadImage:(NSString *)fileName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath {
    UIImage * result = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.%@", directoryPath, fileName, extension]];
    
    return result;
}

#pragma mark -- 初始化广告页
- (void)initAdvertisement
{
    if (isOpenAdvert) {
        advertisementView = [[UIView alloc] init];
        advertisementView.left = 0;
        advertisementView.top = 0;
        advertisementView.width = SCREENWIDTH;
        advertisementView.height = SCREENHEIGHT;
        
        advertisementView.backgroundColor = [UIColor blackColor];
        advertisementView.alpha = 0.7f;
        [self.view addSubview:advertisementView];
        
        advertisementImageView = [[UIImageView alloc] init];
        advertisementImageView.top = SCREENHEIGHT/5 - 50;
        advertisementImageView.left = 30;
        advertisementImageView.width = SCREENWIDTH - 60;
        advertisementImageView.height = 3*SCREENHEIGHT/5 + 50;
        advertisementImageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer* singleRecognizer= [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTheHearder:)];
        singleRecognizer.numberOfTapsRequired = 1;
        [advertisementImageView addGestureRecognizer:singleRecognizer];
        
        // 读取本地广告
        NSString * documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        UIImage * imageFromWeb = [self loadImage:@"TheMyImage" ofType:@"png" inDirectory:documentsDirectoryPath];
        if (imageFromWeb != nil) {
            [advertisementImageView setImage:imageFromWeb];
            
        } else{
            [advertisementImageView setImage:[UIImage imageNamed:@"dynamic_bg"]];
            
        }
        [self.view addSubview:advertisementImageView];
        
        vanishingButton = [UIButton buttonWithType:UIButtonTypeCustom];
        vanishingButton.top = SCREENHEIGHT/5 - 70;
        vanishingButton.left = SCREENWIDTH - 45;
        vanishingButton.width = 40;
        vanishingButton.height = 40;
        [vanishingButton setImage:[UIImage imageNamed:@"accountdel"] forState:UIControlStateNormal];
        [vanishingButton addTarget:self action:@selector(clickVanishingButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:vanishingButton];
        
        tabarView1 = [[UIView alloc] init];
        tabarView1.top = 0;
        tabarView1.left = 0;
        tabarView1.width = SCREENWIDTH;
        tabarView1.height = 49;
        tabarView1.backgroundColor = [UIColor blackColor];
        tabarView1.alpha = 0.7f;
//        [self.tabBarController.tabBar addSubview:tabarView1];
    }
    
}
#pragma mark -- 广告点击事件

- (void)clickTheHearder:(UIGestureRecognizer *)ges
{
    
    if (adverturl) {
        WebViewController *VC = [[WebViewController alloc] init];
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:nil
                                                                    action:nil];
        [self.navigationItem setBackBarButtonItem:backItem];
        VC.URL = [self validateTokenStr:adverturl];
        VC.title = AdNameStr;
        [self.navigationController pushViewController:VC animated:YES];
        
        [advertisementView removeFromSuperview];
        [tabarView1 removeFromSuperview];
        [advertisementImageView removeFromSuperview];
        [vanishingButton removeFromSuperview];
            
    }
}

#pragma mark -- 判断红包链接是否含有Token字段

- (NSString *)validateTokenStr:(NSString *)theAdverturl
{

   NSMutableDictionary* dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setObject:[RRTManager manager].loginManager.loginInfo.tokenId forKey:@"[TOKEN]"];

    return [self replaceWithString:theAdverturl dic:dictionary];
}

-(NSString*) replaceWithString:(NSString*)soucrestr dic:(NSMutableDictionary*)dic{
    NSString* temp=soucrestr;
    if (dic&&[dic count]>0) {
        for (id key in [dic allKeys]) {
            id val=[dic objectForKey:key];
            // 替代
            temp=[temp stringByReplacingOccurrencesOfString:key withString:val];
        }
    }
    return temp;
}


#pragma mark -- 移除广告页面

- (void)clickVanishingButton:(UIButton *)sender
{
    [UIView animateWithDuration:1.0f animations:^{
        advertisementView.alpha = 0;
        tabarView1.alpha = 0;
        advertisementImageView.alpha = 0;
        vanishingButton.alpha = 0;
    } completion:^(BOOL finished) {
        [advertisementView removeFromSuperview];
        [tabarView1 removeFromSuperview];
        [advertisementImageView removeFromSuperview];
        [vanishingButton removeFromSuperview];
        
    }];
}

#pragma mark -- 获取用户信息请求

- (void)requestData
{
    // 数据量小不做model，节约时间
    __weak AboutMeViewController *_self = self;
    [self.netWorkManager getUIData:[RRTManager manager].loginManager.loginInfo.tokenId
                           success:^(NSMutableArray *data) {
                               if (data) {
                                   [self dismiss];
                                   [_self gotoTheUI:data];
                                   
                               }
                           } failed:^(NSString *errorMSG) {
//                               [_self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:errorMSG];
                               
                           }];
}

#pragma mark -- 获取用户信息

- (void)gotoTheUI:(NSMutableArray *) data
{
    if (data && [data count] > 0) {
        integralNumber = [[data[0] objectForKey:@"Point"] intValue];
        if (integralNumber > 0) {
            [self initAbountRewardView];
        }
    }
}

#pragma mark -- 初始化领积分相关控件

- (void)initAbountRewardView
{
    backGrounpView = [[UIView alloc] init];
    backGrounpView.frame = self.view.bounds;
    backGrounpView.backgroundColor = [UIColor blackColor];
    backGrounpView.alpha = 0.7f;
    
    [self.view addSubview:backGrounpView];
    
    tabarView = [[UIView alloc] init];
    tabarView.frame = self.view.bounds;
    tabarView.top = 0;
    tabarView.left = 0;
    tabarView.width = SCREENWIDTH;
    tabarView.height = 49;
    tabarView.tag = 102;
    tabarView.backgroundColor = [UIColor blackColor];
    tabarView.alpha = 0.7f;
    
//    [self.tabBarController.tabBar addSubview:tabarView];
    
    rewardView = [[UIView alloc] init];
    rewardView.top = SCREENHEIGHT - 165;
    rewardView.left = SCREENWIDTH/6;
    rewardView.width = 4*SCREENWIDTH/6;
    rewardView.height = 100;
    rewardView.right = 5*SCREENWIDTH/6;
    rewardView.backgroundColor = [UIColor whiteColor];
    rewardView.layer.cornerRadius = 10.0f;
    [self.view addSubview:rewardView];
    
    UIImageView *rewardImageView = [[UIImageView alloc] init];
    rewardImageView.top = 15;
    rewardImageView.width = 75;
    rewardImageView.left = 10;
    rewardImageView.height = 75;
    [rewardImageView setImage:[UIImage imageNamed:@"score"]];
    [rewardView addSubview:rewardImageView];
    
    UILabel *socreLabel = [[UILabel alloc] init];
    socreLabel.top = rewardImageView.bottom - 55;
    socreLabel.left = rewardImageView.right +10;
    socreLabel.height = 20;
    socreLabel.width = 200;
    socreLabel.textColor = [UIColor colorWithRed:255.0/255 green:201.0/255 blue:64.0/255 alpha:1];
    socreLabel.text = [NSString stringWithFormat:@" +%d",integralNumber];
    socreLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:23];
    socreLabel.textAlignment = NSTextAlignmentLeft;
    [rewardView addSubview:socreLabel];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.top = rewardImageView.bottom - 25;
    titleLabel.left = rewardImageView.right + 10;
    titleLabel.height = 20;
    titleLabel.width = 200;
    titleLabel.textColor = [UIColor lightGrayColor];
    titleLabel.text = @"登录就是关爱~";
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [rewardView addSubview:titleLabel];
    
    [self performSelector:@selector(removeTheRewardView) withObject:nil afterDelay:1.0f];
}

#pragma mark -- 移除积分框
- (void)removeTheRewardView
{
    [UIView animateWithDuration:2.0f animations:^{
        rewardView.alpha = 0;
        backGrounpView.alpha = 0;
        tabarView.alpha = 0;
    } completion:^(BOOL finished) {
        [backGrounpView removeFromSuperview];
        [rewardView removeFromSuperview];
        [tabarView removeFromSuperview];
        // 调用刷新界面接口
        [currentTeacherVC requestData];
        [currentGuarDianVC requestData];
        [currentStudiesVC requestData];
        
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    self.hidesBottomBarWhenPushed = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.hidesBottomBarWhenPushed = NO;
    [self dismiss];
}

@end
