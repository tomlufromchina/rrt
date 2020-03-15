//
//  GoodFriendCircleViewController.m
//  RenrenTong
//
//  Created by 符其彬 on 15/4/8.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "GoodFriendCircleViewController.h"
#import "TheCommunityViewController.h"
#import "GoodFriendTendencyViewController.h"
#import "MyselfTendencyViewController.h"
#import "DetectionView.h"
#import "SendWeiboViewController.h"
#import "SendPicViewController.h"
#import "SendRecordViewController.h"

@interface GoodFriendCircleViewController ()<DetectionViewDelegate>
{
    UIViewController *_currentViewController;
    UIViewController *oldViewController;
    TheCommunityViewController *theCommunityVC;
    GoodFriendTendencyViewController *goodFriendVC;
    MyselfTendencyViewController *myselfTendencyVC;
}
@property (nonatomic, strong) DetectionView *cover;

@end

@implementation GoodFriendCircleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"好友圈";
    [self initView];
    [self segmentAction:0];
    self.automaticallyAdjustsScrollViewInsets = NO;
    //right button
    UIButton*rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,24,24)];
    [rightButton setImage:[UIImage imageNamed:@"normaltitle_plus"]forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(addActions)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;

}

- (void)addActions
{
    DetectionView *cover = [[DetectionView alloc] init];
    self.cover = cover;
    cover.delegate = self;
    [self.cover show];
}

- (void)compsoeView:(DetectionView *)compsoeView didClickType:(IWComposeButtonType)type;
{
    if (type == IWComposeButtonTypeSendWeiBo) {
        CommonSuccessBlock block = ^(void){
            [goodFriendVC headerReresh];
            [myselfTendencyVC headerReresh];
        };
        [self.navigationController pushViewController:SendWeiboVCID
                                       withStoryBoard:ActivityStoryBoardName
                                            withBlock:^(UIViewController *viewController) {
                                                SendWeiboViewController *vc = (SendWeiboViewController*)viewController;
                                                vc.block = block;
                                            }];
    } else if (type == IWComposeButtonTypeSendPhotos){
        CommonSuccessBlock block = ^(void){
            [goodFriendVC headerReresh];
            [myselfTendencyVC headerReresh];
        };
        [self.navigationController pushViewController:SendPicVCID
                                       withStoryBoard:ActivityStoryBoardName
                                            withBlock:^(UIViewController *viewController) {
                                                SendPicViewController *vc = (SendPicViewController*)viewController;
                                                vc.block = block;
                                            }];
        
    } else if (type == IWComposeButtonTypeSendRecod){
        CommonSuccessBlock block = ^(void){
            [goodFriendVC headerReresh];
            [myselfTendencyVC headerReresh];
        };
        [self.navigationController pushViewController:SendRecordVCID
                                       withStoryBoard:ActivityStoryBoardName
                                            withBlock:^(UIViewController *viewController) {
                                                SendRecordViewController *vc = (SendRecordViewController*)viewController;
                                                vc.block = block;
                                            }];
    }
}

- (void)initView
{
    NSArray *segmentedArray = [[NSArray alloc]initWithObjects:@"社区",@"好友",@"我",nil];
    //初始化UISegmentedControl
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:segmentedArray];
    segmentedControl.frame = CGRectMake(20, 70, SCREENWIDTH - 40, 35.0);
    segmentedControl.selectedSegmentIndex = 0;//设置默认选择项索引
    segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;//设置样式
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:theLoginButtonColor,UITextAttributeTextColor,  [UIFont fontWithName:@"SnellRoundhand-Bold"size:16],NSFontAttributeName ,[UIColor whiteColor],UITextAttributeTextShadowColor ,nil];
    [segmentedControl setTitleTextAttributes:dic forState:UIControlStateNormal];
    segmentedControl.tintColor = theLoginButtonColor;
    [segmentedControl addTarget:self action:@selector(segmentAction:)forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segmentedControl];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, segmentedControl.bottom + 10, SCREENWIDTH, 1)];
    lineView.backgroundColor = LineColor;
    [self.view addSubview:lineView];
    
    // 添加社区VC
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:ActivityStoryBoardName
                                                             bundle:nil];
    theCommunityVC = [mainStoryBoard instantiateViewControllerWithIdentifier:TheCommunityVCID];
    theCommunityVC.navigationController.navigationBar.hidden = YES;
    theCommunityVC.view.top = lineView.bottom;
    theCommunityVC.view.left = 0;
    theCommunityVC.view.width = SCREENWIDTH;
    theCommunityVC.view.height = SCREENHEIGHT - lineView.bottom;
    theCommunityVC.mainTableVIew.frame = theCommunityVC.view.bounds;
    theCommunityVC.theCommunityViewController = self;
    theCommunityVC.view.backgroundColor = [UIColor redColor];
    [self addChildViewController:theCommunityVC];
    
    // 添加好友VC
    goodFriendVC = [mainStoryBoard instantiateViewControllerWithIdentifier:GoodFriendTendency];
    goodFriendVC.navigationController.navigationBar.hidden = YES;
    goodFriendVC.view.backgroundColor = [UIColor purpleColor];
    goodFriendVC.view.top = lineView.bottom;
    goodFriendVC.view.left = SCREENWIDTH;
    goodFriendVC.view.width = SCREENWIDTH;
    goodFriendVC.view.height = SCREENHEIGHT - lineView.bottom;
    goodFriendVC.goodFriendTendencyViewController = self;
    [self addChildViewController:goodFriendVC];
    
    // 添加我VC
    myselfTendencyVC = [mainStoryBoard instantiateViewControllerWithIdentifier:MyselfTendency];
    myselfTendencyVC.navigationController.navigationBar.hidden = YES;
    myselfTendencyVC.view.backgroundColor = [UIColor greenColor];
    myselfTendencyVC.view.top = lineView.bottom;
    myselfTendencyVC.view.left = 2*SCREENWIDTH;
    myselfTendencyVC.view.width = SCREENWIDTH;
    myselfTendencyVC.view.height = SCREENHEIGHT - lineView.bottom;
    myselfTendencyVC.myselfTendencyViewController = self;
    [self addChildViewController:myselfTendencyVC];
    
    // 显示添加社区VC
    [self.view addSubview:theCommunityVC.view];
    _currentViewController = theCommunityVC;
    

}

#pragma mark -- 选项卡响应事件
#pragma mark --

- (void)segmentAction:(UISegmentedControl *)Seg
{
    NSInteger Index = Seg.selectedSegmentIndex;
    if (Index == 0) {
        self.title = @"社区";
        if (_currentViewController == theCommunityVC) {
            
            return;
            
        }
        oldViewController = _currentViewController;
        [self transitionFromViewController:_currentViewController
                          toViewController:theCommunityVC
                                  duration:0.5f
                                   options:UIViewAnimationOptionTransitionNone
                                animations:^{
                                    goodFriendVC.view.left = SCREENWIDTH;
                                    myselfTendencyVC.view.left = 2*SCREENWIDTH;
                                    theCommunityVC.view.left = 0;
                                }
                                completion:^(BOOL finished) {
                                    if (finished) {
                                        _currentViewController = theCommunityVC;
                                    }else{
                                        _currentViewController = oldViewController;
                                    }
                                    
                                }];
        
    } else if (Index == 1){
        self.title = @"好友";
        if (_currentViewController == goodFriendVC) {
            
            return;
            
        }
        oldViewController = _currentViewController;
        [self transitionFromViewController:_currentViewController
                          toViewController:goodFriendVC
                                  duration:0.5f
                                   options:UIViewAnimationOptionTransitionNone
                                animations:^{
                                    goodFriendVC.view.left = 0;
                                    theCommunityVC.view.left = -SCREENWIDTH;
                                    myselfTendencyVC.view.left = SCREENWIDTH;
                                    
                                }
                                completion:^(BOOL finished) {
                                    if (finished) {
                                        _currentViewController = goodFriendVC;
                                    }else{
                                        _currentViewController = oldViewController;
                                    }
                                }];

    } else if (Index == 2){
        self.title = @"我";
        oldViewController = _currentViewController;
        [self transitionFromViewController:_currentViewController
                          toViewController:myselfTendencyVC
                                  duration:0.5f
                                   options:UIViewAnimationOptionTransitionNone
                                animations:^{
                                    myselfTendencyVC.view.left = 0;
                                    theCommunityVC.view.left = -2*SCREENWIDTH;
                                    goodFriendVC.view.left = -SCREENWIDTH;
                                    
                                }
                                completion:^(BOOL finished) {
                                    if (finished) {
                                        _currentViewController = myselfTendencyVC;
                                    }else{
                                        _currentViewController = oldViewController;
                                    }
                                }];

    }
}

@end
