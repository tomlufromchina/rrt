//
//  MainLoginViewController.m
//  RenrenTong
//
//  Created by 符其彬 on 15/1/27.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "MainLoginViewController.h"
#import "LoginViewController.h"
#import "TelephoneRegisteringViewController.h"
#import "WebViewController.h"
#import "AdverView.h"
#import "AlbumList.h"

@interface MainLoginViewController ()<UIScrollViewDelegate,AdverViewDelegate>
{
    UIView *_curView;
    UIViewController *_currentViewController;
    UIViewController *oldViewController;
    UIScrollView *_scrollView2;
    UIPageControl *_pageControl;
    NSInteger _currentIndex;
    NSTimer *_timer;// 定时器
    TelephoneRegisteringViewController *ordinaryVC;
    LoginViewController *loginVC;
    NSMutableArray *imageArray;//存放图片
    NSMutableArray *webArray;
    NSMutableArray *imageNameArray;
    
    UIActivityIndicatorView *activityIndicator;

    
}

@property (nonatomic, strong) NetWorkManager *netWorkManger;
@property (nonatomic, strong) AdverView *adView;
@end

@implementation MainLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
    //Add search button
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"访客模式"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(clickSendButton)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.netWorkManger = [[NetWorkManager alloc] init];
    webArray = [[NSMutableArray alloc] init];
    imageArray = [[NSMutableArray alloc] init];
    imageNameArray = [[NSMutableArray alloc] init];
    
    // add手机号登陆VC
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:LoginStoryBoardName
                                                             bundle:nil];
    ordinaryVC = [mainStoryBoard instantiateViewControllerWithIdentifier:
                  TelephoneRegisteringVCID];
    ordinaryVC.view.top = self.theLeftButton.bottom + 30;
    ordinaryVC.view.left = 0;
    ordinaryVC.view.width = SCREENWIDTH;
    ordinaryVC.view.height = SCREENHEIGHT - self.theLeftButton.bottom;
    ordinaryVC.theTelePhoneViewController = self;
    [self addChildViewController:ordinaryVC];
    
    // add普通登陆VC
    loginVC = [mainStoryBoard instantiateViewControllerWithIdentifier:
               LoginVCID];
    loginVC.view.top = self.theLeftButton.bottom + 30;
    loginVC.view.left = SCREENWIDTH;
    loginVC.view.width = SCREENWIDTH;
    loginVC.view.height = SCREENHEIGHT - self.theLeftButton.bottom;
    loginVC.theLoginViewController = self;
    [self addChildViewController:loginVC];
    
    // 显示ordinaryVC
    [self.view addSubview:ordinaryVC.view];
    _currentViewController = ordinaryVC;
    
//    self.grayColorView1.hidden = YES;
    self.greedColorView1.hidden = NO;
//    self.grayColorView2.hidden = NO;
    self.greedColorView2.hidden = YES;
    
    [self initView];
}

#pragma mark -- 访客模式

- (void)clickSendButton
{
    [self.navigationController pushViewController:VisitorModelVCID
                                   withStoryBoard:LoginStoryBoardName
                                        withBlock:nil];
    [self.view endEditing:YES];
}

#pragma mark -- 初始化广告页

- (void)initView
{
    // 广告请求
    NSString *url = [NSString stringWithFormat:@"http://dsjtj.%@/Api/GetAdvert",aedudomain];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"4",@"advertType",[RRTManager manager].loginManager.loginInfo.tokenId,@"toKen",nil];
    [HttpUtil GetWithUrl:url parameters:dic success:^(id json) {
        Adver *result = [[Adver alloc] initWithString:json error:nil];
        if (result.Status == 1 && result.Data.count > 0) {
            NSMutableArray *array = [[NSMutableArray alloc] init];
            NSMutableArray *adNameArray = [[NSMutableArray alloc] init];
            NSMutableArray *linkUrlArray = [[NSMutableArray alloc] init];
            for (AdverData *data in result.Data) {
                [array addObject:data.ImageURL];
                [adNameArray addObject:data.AdName];
                [linkUrlArray addObject:data.LinkUrl];
            }
            // 初始化广告页
            self.adView = [[AdverView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 90) AdverType:HomePageTopAdver];
            self.adView.delegate = self;
            [self.adView setPicArray:array];
            [self.adView setLinkUrlArray:linkUrlArray];
            [self.adView setAdNameArray:adNameArray];
            [self.view addSubview:self.adView];
        }else{
            [self removeAdverView];
        }
    } fail:^(id errors) {
        [self removeAdverView];
    } cache:^(id cache) {
        Adver *result = [[Adver alloc] initWithString:cache error:nil];
        if (result.Status == 1 && result.Data.count > 0) {
            NSMutableArray *array = [[NSMutableArray alloc] init];
            NSMutableArray *adNameArray = [[NSMutableArray alloc] init];
            NSMutableArray *linkUrlArray = [[NSMutableArray alloc] init];
            for (AdverData *data in result.Data) {
                [array addObject:data.ImageURL];
                [adNameArray addObject:data.AdName];
                [linkUrlArray addObject:data.LinkUrl];
            }
            // 初始化广告页
            self.adView = [[AdverView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 90) AdverType:HomePageTopAdver];
            self.adView.delegate = self;
            [self.adView setPicArray:array];
            [self.adView setLinkUrlArray:linkUrlArray];
            [self.adView setAdNameArray:adNameArray];
            [self.view addSubview:self.adView];
        }
    }];

    self.theLeftButton.top = self.adView.bottom + 10;
    self.theRightButton.top = self.adView.bottom + 10;
    self.greedColorView1.top = self.theLeftButton.bottom + 10;
    self.greedColorView2.top = self.theLeftButton.bottom + 10;
    
    ordinaryVC.view.top = self.theLeftButton.bottom + 30;
    ordinaryVC.view.left = 0;
    
    loginVC.view.top = self.theLeftButton.bottom + 30;
    loginVC.view.left = SCREENWIDTH;
    
}

#pragma mark --
-(void)clickTheImages:(int)tag andWithAdNameArray:(NSMutableArray *)adNameArray andWithLinkUrlArray:(NSMutableArray *)linkUrlArry
{
    WebViewController *VC = [[WebViewController alloc] init];
    NSString *URL0 = [linkUrlArry objectAtIndex:tag];
    VC.URL = URL0;
    VC.title = [adNameArray objectAtIndex:tag];
    [self.navigationController pushViewController:VC animated:YES];
}

-(void)removeAdverView
{
    self.theLeftButton.top = 74;
    self.theRightButton.top = 74;
    self.greedColorView1.top = self.theLeftButton.bottom + 10;
    self.greedColorView2.top = self.theLeftButton.bottom + 10;
    
    ordinaryVC.view.top = self.theLeftButton.bottom + 30;
    ordinaryVC.view.left = 0;
    
    loginVC.view.top = self.theLeftButton.bottom + 30;
    loginVC.view.left = SCREENWIDTH;
    [self.adView removeFromSuperview];
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
#pragma mark -- 手机号登陆
- (IBAction)clickTheLeftButton:(UIButton *)sender
{
    
    if (_currentViewController == ordinaryVC) {
        
        return;
        
    }
    oldViewController = _currentViewController;
    [self transitionFromViewController:_currentViewController
                      toViewController:ordinaryVC
                              duration:0.7f
                               options:UIViewAnimationOptionTransitionNone
                            animations:^{
                                loginVC.view.left = SCREENWIDTH;
                                ordinaryVC.view.left = 0;
                            }
                            completion:^(BOOL finished) {
                                if (finished) {
                                    _currentViewController = ordinaryVC;
                                }else{
                                    _currentViewController = oldViewController;
                                    
                                }
                                
                            }];
    [self.theRightButton setTitleColor:[UIColor lightGrayColor]forState:UIControlStateNormal];
    [self.theLeftButton setTitleColor:theLoginButtonColor forState:UIControlStateNormal];
    
//    self.grayColorView1.hidden = YES;
    self.greedColorView1.hidden = NO;
//    self.grayColorView2.hidden = NO;
    self.greedColorView2.hidden = YES;

}

#pragma mark -- 账号登陆
- (IBAction)clickTheRightButton:(UIButton *)sender
{
    
    if (_currentViewController == loginVC) {
        
        return;
        
    }
    oldViewController = _currentViewController;
    [self transitionFromViewController:_currentViewController
                      toViewController:loginVC
                              duration:0.7f
                               options:UIViewAnimationOptionTransitionNone
                            animations:^{
                                loginVC.view.left = 0;
                                ordinaryVC.view.left = -SCREENWIDTH;

                            }
                            completion:^(BOOL finished) {
                                if (finished) {
                                    _currentViewController = loginVC;
                                }else{
                                    _currentViewController = oldViewController;
                                }
                            }];
    [self.theRightButton setTitleColor:theLoginButtonColor forState:UIControlStateNormal];
    [self.theLeftButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
//    self.grayColorView1.hidden = NO;
    self.greedColorView1.hidden = YES;
//    self.grayColorView2.hidden = YES;
    self.greedColorView2.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;

}
@end
