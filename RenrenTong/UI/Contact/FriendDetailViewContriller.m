//
//  FriendDetailViewContriller.m
//  RenrenTong
//
//  Created by aedu on 15/3/24.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "FriendDetailViewContriller.h"
#import "FriendView.h"
#import "SJAvatarBrowser.h"
#import "ChatViewController.h"
#import "ContactSendVerificationViewController.h"
#import "ContactSettingViewController.h"

@interface FriendDetailViewContriller ()
{
    NdividualData *dataDetails;
    
}

@property (nonatomic, strong) NetWorkManager *netWorkManager;
@property(nonatomic, strong)FriendView *friendView;

@end

@implementation FriendDetailViewContriller

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"详细资料";
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton*rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,24,24)];
    [rightButton setImage:[UIImage imageNamed:@"normaltitle_more"]forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(setInfo)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem= rightItem;
    _netWorkManager = [[NetWorkManager alloc] init];
    [self requestNetWorkData];
}

- (void)setInfo
{
    if (dataDetails.isFriend) {
        [self.navigationController pushViewController:ContactSettingVCID
                                       withStoryBoard:ContactStoryBoardName
                                            withBlock:^(UIViewController *viewController) {
                                                ContactSettingViewController *vc = (ContactSettingViewController*)viewController;
                                                vc.Id = dataDetails.UserId;
                                                vc.name = dataDetails.TrueName;
                                            }];
    }else{
        [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"先加好友才能设置权限哦"];
        
    }
}
- (void)requestNetWorkData
{
    [self.netWorkManager personalDataWithDetailToken:[RRTManager manager].loginManager.loginInfo.tokenId UserId:self.userId
                                             success:^(NdividualData *ndividual) {
                                                 
                                                 [self updateView:ndividual];
                                                 
                                             } failed:^(NSString *errorMSG) {
                                                 [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:errorMSG];
                                             }];
    
}
//刷新界面
- (void)updateView:(NdividualData *)data
{
    dataDetails = data;
    FriendView *friendView = [[FriendView alloc]init];
    friendView.frame = CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT - 64);
    self.friendView = friendView;
    friendView.IsFollowed = dataDetails.isFriend;
    [friendView.friendIv setImageWithUrlStr:dataDetails.PicInfo placholderImage:[UIImage imageNamed:@"default"]];
    friendView.friendLabel.text = dataDetails.TrueName;
    friendView.schoolLabel.text = dataDetails.SchoolName;
    [self.view addSubview:friendView];
    
}

@end
