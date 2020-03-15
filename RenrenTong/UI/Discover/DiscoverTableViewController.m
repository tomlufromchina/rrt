//
//  DiscoverTableViewController.m
//  RenrenTong
//
//  Created by jeffrey on 14-6-10.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "DiscoverTableViewController.h"
#import "ViewControllerIdentifier.h"
#import "FriendTendencyViewController.h"
#import "MyTendencyViewController.h"
#import "MyZBPhotoViewController.h"
#import "ContactDetailViewController.h"
#import "RootViewController.h"
#import "FriendDetailViewContriller.h"


@interface DiscoverTableViewController ()<RootViewControllerDelegate>

@property (nonatomic, strong) NSString *ZBurl;

@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *images;

@property (nonatomic, strong) NetWorkManager *netWorkManager;

@end

@implementation DiscoverTableViewController

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
    
    self.title = @"发现";
    self.tableView.backgroundColor = [UIColor colorWithRed:245 / 255.0 green:245 / 255.0 blue:245 / 255.0 alpha:1];
    
    self.titles = [NSArray arrayWithObjects:@"好友圈", @"扫一扫",
                   @"二维码名片", @"备考食谱", @"教育咨询", @"微课件", nil];
    
    self.images = [NSArray arrayWithObjects:@"好友动态-",
                   @"扫一扫-",
                   @"zb.png",
                   @"find_recipe.png",
                   @"find_consult.png",
                   @"find_courseware.png", nil];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    [self.navigationItem setBackBarButtonItem:backItem];
    
    //right button
//    UIButton*rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,20,20)];
//    [rightButton setImage:[UIImage imageNamed:@"f1-white"]forState:UIControlStateNormal];
//    [rightButton addTarget:self action:@selector(search)forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
//    self.navigationItem.rightBarButtonItem= rightItem;;
}

- (void)search
{
    [self.navigationController pushViewController:SeacherVCID
                                   withStoryBoard:DiscoverStoryBoardName
                                        withBlock:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    self.hidesBottomBarWhenPushed = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.hidesBottomBarWhenPushed = NO;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 3;
        case 1:
            return 0;
        case 2:
            return 0;
        case 3:
            return 0;
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DiscoverCell"
                                                            forIndexPath:indexPath];
    
    int index = 2 * indexPath.section + indexPath.row;
    
    UILabel *label = (UILabel*)[cell viewWithTag:1];
    label.text = (NSString*)[self.titles objectAtIndex:index];
    
    UIImageView *imgView = (UIImageView*)[cell viewWithTag:2];
    [imgView setImage:[UIImage imageNamed:(NSString*)[self.images objectAtIndex:index]]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0 && indexPath.row == 0) {
        [self.navigationController pushViewController:FriendTendencyVCID
                                       withStoryBoard:ActivityStoryBoardName
                                            withBlock:nil];
    } else if (indexPath.section == 0 && indexPath.row == 1) {
     if(is_IOS_7)
        {
            RootViewController * rt = [[RootViewController alloc]init];
            rt.delegate = self;
            [self presentViewController:rt animated:YES completion:^{
            }];
        }
        else
        {
            [self showImage:[UIImage imageNamed:@"confirm-err72"] status:@"该功能只支持IOS7以上设备!"];
        }
  
      
    } else if (indexPath.section == 0 && indexPath.row == 2){
        
        MyZBPhotoViewController *ZBVc = [[MyZBPhotoViewController alloc]init];
        [self.navigationController pushViewController:ZBVc animated:YES];
        
    }
}
- (void)stringData:(NSString *)string
{
    //用户userID匹配
    NSString *ZBRegex = @"^\\d{5,9}$";
    NSPredicate *ZBTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",ZBRegex];
    
    //网址匹配
    NSString *regex = @"http+:[^\\s]*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    
    if([ZBTest evaluateWithObject:string])
    {
        [self.navigationController pushViewController:ContactDetailVCID
                                   withStoryBoard:ContactStoryBoardName
                                        withBlock:^(UIViewController *viewController) {
                                            ContactDetailViewController *vc = (ContactDetailViewController*)viewController;
                                            vc.OUserId = string;
                                            
                                        }];
//        FriendDetailViewContriller *detailVC = [[FriendDetailViewContriller alloc]init];
//        detailVC.userId =string;
//        [self.navigationController pushViewController:detailVC animated:YES];
    }
    else if([predicate evaluateWithObject:string])
    {
        self.ZBurl = string;
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil
                                                        message:@"你将打开这个网址!"
                                                       delegate:nil
                                              cancelButtonTitle:@"关闭"
                                              otherButtonTitles:@"好", nil];
        alert.tag = 10000;
        alert.delegate = self;
        [alert show];
    }else
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil
                                                       message:@"扫描结果无效"
                                                      delegate:nil
                                             cancelButtonTitle:@"关闭"
                                             otherButtonTitles:nil];
        alert.tag = 10001;
        alert.delegate = self;
        [alert show];
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==10000) {
        if (buttonIndex==1) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.ZBurl]];
        }
    }
}


@end
