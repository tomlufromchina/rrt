//
//  BarBaseViewController.m
//  HLJ_Project
//
//  Created by 何丽娟 on 15/5/9.
//  Copyright (c) 2015年 何丽娟. All rights reserved.
//

#import "BarBaseViewController.h"


@interface BarBaseViewController ()<UIScrollViewDelegate,RESideMenuDelegate>{
    UIView *tabBarBackView;
    UIButton *currentButton;//标签按钮
    UIView *budgeView;
    UILabel *budgelabel;
    // tabBarViewControllers
    UIScrollView *scrollView;
    UIViewController *myselfVC;
    
    UIViewController *contactVC;
    UIViewController *discoverVC;
    UIViewController *applicationVC;
    NSInteger currentIndex;
    
    
    CurrentTeacherViewController *currentTeacherVC;
    CurrentGuarDianViewController *currentGuarDianVC;
    CurrentStudiesViewController *currentStudiesVC;
    UIViewController *currentVC;
}

@end

@implementation BarBaseViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
//    将tabBarViewController添加至当前self的ChirldViewContrlls里

    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:MainStoryBoardName
                                                             bundle:nil];
    NSString *role = [NSString stringWithFormat:@"%@",[RRTManager manager].loginManager.loginInfo.userRole];
    if ([role isEqualToString:@"1"]) {
        currentStudiesVC = [[CurrentStudiesViewController alloc] init];
        currentVC = currentStudiesVC;
    } else if ([role isEqualToString:@"2"]){
        currentGuarDianVC = [[CurrentGuarDianViewController alloc] init];
        currentVC = currentGuarDianVC;
    } else if ([role isEqualToString:@"3"] || [role isEqualToString:@"4"] || [role isEqualToString:@"5"] || [role isEqualToString:@"6"]){
        currentTeacherVC = [[CurrentTeacherViewController alloc] init];
        currentVC = currentTeacherVC;
    }
//    myselfVC = currentVC;
    myselfVC = [mainStoryBoard instantiateViewControllerWithIdentifier:
                AboutMeViewControllerVCID];
    contactVC = [mainStoryBoard instantiateViewControllerWithIdentifier:
                MessageTableViewControllerVCID];
    discoverVC = [mainStoryBoard instantiateViewControllerWithIdentifier:
                DiscoverViewControllerVCID];
    applicationVC = [mainStoryBoard instantiateViewControllerWithIdentifier:
                 DeskViewControllerVCID];
    [self addChildViewController:myselfVC];
    [myselfVC didMoveToParentViewController:self];
    [self addChildViewController:contactVC];
    [contactVC didMoveToParentViewController:self];
    [self addChildViewController:discoverVC];
    [discoverVC didMoveToParentViewController:self];
    [self addChildViewController:applicationVC];
    [applicationVC didMoveToParentViewController:self];
    [self scrollView];
    
//    初始化tabBarView布局视图
    [self addTabBar];
    
    self.view.backgroundColor = [UIColor whiteColor];
}
-(void)scrollView
{
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - 49)];
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.bounces = NO;
    scrollView.contentSize = CGSizeMake(SCREENWIDTH*4, 0);
    [self.view addSubview:scrollView];
    myselfVC.view.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - 49);
    [scrollView addSubview:myselfVC.view];
    contactVC.view.frame = CGRectMake(SCREENWIDTH, 0, SCREENWIDTH, SCREENHEIGHT - 49);
    [scrollView addSubview:contactVC.view];
    discoverVC.view.frame = CGRectMake(SCREENWIDTH*2, 0, SCREENWIDTH, SCREENHEIGHT - 49);
    [scrollView addSubview:discoverVC.view];
    applicationVC.view.frame = CGRectMake(SCREENWIDTH*3, 0, SCREENWIDTH, SCREENHEIGHT - 49);
    [scrollView addSubview:applicationVC.view];
}
-(void)addTabBar
{
    tabBarBackView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT - 49, SCREENWIDTH, 49)];
    tabBarBackView.backgroundColor = [UIColor whiteColor];
    tabBarBackView.layer.masksToBounds = NO;
    tabBarBackView.layer.shadowColor = [UIColor grayColor].CGColor;
    tabBarBackView.layer.shadowOffset = CGSizeMake(0, 0);
    tabBarBackView.layer.shadowRadius = 1;
    tabBarBackView.layer.shadowOpacity = 1;
    [tabBarBackView addSubview:[self setUpButton:@"tab-wo-press" Title:@"我" Position:0]];
    [tabBarBackView addSubview:[self setUpButton:@"tab-msg" Title:@"聊天" Position:1]];
    [tabBarBackView addSubview:[self setUpButton:@"tab-finde" Title:@"发现" Position:2]];
    [tabBarBackView addSubview:[self setUpButton:@"tab-yy" Title:@"应用" Position:3]];
    [self.view addSubview:tabBarBackView];
}
-(UIButton*)setUpButton:(NSString*)imageString Title:(NSString*)title Position:(NSInteger)position
{
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame = CGRectMake(SCREENWIDTH/4*position, 0, SCREENWIDTH/4, 49);
    button1.tag = position;
    UIImageView *image1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, 30, 30)];
    image1.image = [UIImage imageNamed:imageString];
    image1.center = CGPointMake(button1.frame.size.width/2, image1.center.y);
    image1.tag = 11;
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, button1.frame.size.width, 19)];
    label1.text = title;
    label1.textColor = [UIColor grayColor];
    label1.font = [UIFont systemFontOfSize:10];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.tag = 22;
    button1.highlighted = YES;
    [button1 addTarget:self action:@selector(tabBar:) forControlEvents:UIControlEventTouchUpInside];
    [button1 setTintColor:[UIColor redColor]];
    [button1 addSubview:image1];
    [button1 addSubview:label1];
    if (position == 0) {
        label1.textColor = theLoginButtonColor;
        currentButton = button1;
    }
    button1.tag = position;
    return button1;
}
- (void)tabBar:(UIButton*)item
{
    [self changeTabBarItemColorToSelect:item];
    scrollView.contentOffset = CGPointMake(item.tag * SCREENWIDTH, 0);
  
}
-(void)changeTabBarItemColorToSelect:(UIButton*)btn
{
    UIImageView *image = (UIImageView*)[btn viewWithTag:11];
    switch (btn.tag) {
        case 0:
            image.image = [UIImage imageNamed:@"tab-wo-press"];
            break;
        case 1:
            image.image = [UIImage imageNamed:@"tab-msgpress"];
            break;
        case 2:
            image.image = [UIImage imageNamed:@"tab-findepress"];
            break;
        case 3:
            image.image = [UIImage imageNamed:@"tab-yy-press"];
            break;
        default:
            break;
    }
    UILabel *label = (UILabel*)[btn viewWithTag:22];
    label.textColor = theLoginButtonColor;
    label = (UILabel*)[currentButton viewWithTag:22];
    label.textColor = [UIColor grayColor];
    image = (UIImageView*)[currentButton viewWithTag:11];
    switch (currentButton.tag) {
        case 0:
            image.image = [UIImage imageNamed:@"tab-wo"];
            break;
        case 1:
            image.image = [UIImage imageNamed:@"tab-msg"];
            break;
        case 2:
            image.image = [UIImage imageNamed:@"tab-finde"];
            break;
        case 3:
            image.image = [UIImage imageNamed:@"tab-yy"];
            break;
        default:
            break;
    }
    currentButton = btn;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollcview //移动一页的宽度后调用此方法
{
        CGFloat floatWidth = scrollView.frame.size.width;
        NSInteger currentPage = floor((scrollView.contentOffset.x-floatWidth/2)/floatWidth)+1; //返回小于或者等于指定表达式的最大整数
        if (currentIndex != currentPage) {
            currentIndex = currentPage;
            UIButton *btn = (UIButton*)[tabBarBackView viewWithTag:currentIndex];
            [self tabBar:btn];
        }
    
}
-(void)addBudge:(NSInteger)budgeNum
{
    if (budgeNum > 0) {
        if (!budgeView) {
            budgeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
            budgelabel = [[UILabel alloc] initWithFrame:budgeView.frame];
            budgelabel.textColor = [UIColor whiteColor];
            budgelabel.textAlignment = NSTextAlignmentCenter;
            budgelabel.font = [UIFont systemFontOfSize:10];
            [budgeView addSubview:budgelabel];
            budgeView.layer.masksToBounds = YES;
            budgeView.backgroundColor = [UIColor redColor];
            budgeView.layer.borderColor = [UIColor whiteColor].CGColor;
            budgeView.layer.cornerRadius = budgeView.frame.size.height/2;
            UIButton *btn = (UIButton*)[tabBarBackView viewWithTag:1];
            budgeView.center = CGPointMake(btn.frame.size.width/2 + 15, budgeView.center.y + 3);
            [btn addSubview:budgeView];
        }
        budgelabel.text = [NSString stringWithFormat:@"%d",budgeNum];
    }else{
        [budgeView removeFromSuperview];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
