//
//  ContactDetailViewController.m
//  RenrenTong
//
//  Created by jeffrey on 14-6-16.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "ContactDetailViewController.h"
#import "ContactSettingViewController.h"
#import "ViewControllerIdentifier.h"
#import "ContactSendVerificationViewController.h"
#import "ChatViewController.h"
#import "QRCodeGenerator.h"
#import "SJAvatarBrowser.h"
#import "FriendDetailViewContriller.h"
#import "MessageNetService.h"

@interface ContactDetailViewController ()
{
    GetUserByIdMsgList *dataDetails;

}
@property (nonatomic, strong) UIImageView *avatarImgView;
@property (nonatomic, strong) UIImageView *QRImgView;
@property (nonatomic, strong) NetWorkManager *netWorkManager;
@property (nonatomic, strong) NSArray *dadtaSuorce;//数据源

@end

@implementation ContactDetailViewController

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

    _netWorkManager = [[NetWorkManager alloc] init];
    [self requestNetWorkData];
    
    self.title = @"详细资料";
    
    UIButton*rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,24,24)];
    [rightButton setImage:[UIImage imageNamed:@"normaltitle_more"]forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(setInfo)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem= rightItem;
    

}
//请求
- (void)requestNetWorkData
{
    [self show];
//    [MessageNetService GetUserById:[RRTManager manager].loginManager.loginInfo.tokenId
//                            UserId:self.OUserId
//                        Successful:^(id model) {
//                            [self dismiss];
//                            [self updateView:model];
//                        } Error:^(id model) {
//                            [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:model];
//
//                        } Cache:^(id model) {
//                            
//                        }];
    
    NSString *url = [NSString stringWithFormat:@"http://home.%@/api/GetUserById",aedudomain];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[RRTManager manager].loginManager.loginInfo.tokenId,@"toKen",self.OUserId,@"UserId",nil];
    [HttpUtil GetWithUrl:url parameters:dic success:^(id json) {
        GetUserById *result = [[GetUserById alloc] initWithString:json error:nil];
        if (result.st == 0 && result.msg.list) {
            [self dismiss];
            [self updateView:result.msg.list];
        }else{
            [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"获取详情失败"];
        }
    } fail:^(id errors) {
        [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"获取详情失败"];
    } cache:^(id cache) {
    }];

}
//刷新界面
- (void)updateView:(GetUserByIdMsgList *)data
{
    self.dadtaSuorce = [NSArray arrayWithObject:data];
    dataDetails = [self.dadtaSuorce objectAtIndex:0];
    //dataDetails.isFriend = 1;
    self.bMyFirend = dataDetails.IsFollowed.boolValue;
    [self.tableView reloadData];
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
    [self dismiss];
}

#pragma mark - Table view data source
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        return 120;
    } else {
        return 0;
    }
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
        view.userInteractionEnabled = YES;
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, 280, 40)];
        button.backgroundColor = appColor;
        button.layer.cornerRadius = 2.0f;
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(sendMessage:)
         forControlEvents:UIControlEventTouchUpInside];
        UIButton *phoneBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 70, 280, 40)];
        phoneBtn.backgroundColor = [UIColor colorWithRed:73/255.0 green:211/255.0 blue:242/255.0 alpha:1.0];
        phoneBtn.layer.cornerRadius = 2.0f;
        [phoneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [phoneBtn setTitle:@"打电话" forState:UIControlStateNormal];
        [phoneBtn addTarget:self action:@selector(callPhone:)
           forControlEvents:UIControlEventTouchUpInside];
        if (self.bMyFirend) {
            [button setTitle:@"发消息" forState:UIControlStateNormal];
            if (dataDetails.AccountMobile.length != 0) {
                [view addSubview:phoneBtn];
            }
        } else {
            [button setTitle:@"添加到通信录" forState:UIControlStateNormal];

        }

        [view addSubview:button];
        return view;
    } else {
        return nil;
    }
    
}
- (void)callPhone:(UIButton*)button
{
    UIWebView *phoneCallWebView = nil;
    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",dataDetails.AccountMobile]];
    if ( !phoneCallWebView ) {
        phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
        [self.view addSubview:phoneCallWebView];
    }
    [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
        case 1:
            return self.bMyFirend ? 3 : 2;
        default:
            return 0;
    }
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float height = 40.0f;
    
    if (indexPath.section == 0) {
        height = 60.0f;
    } else if (indexPath.section == 1) {
        if (indexPath.row == 3) {
            height = 60.0f;
        }
    }
    
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;

    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"ContactDetailHeaderCell" forIndexPath:indexPath];
        self.avatarImgView = (UIImageView*)[cell viewWithTag:1];
        [self.avatarImgView setImageWithUrlStr:dataDetails.PictureUrl placholderImage:[UIImage imageNamed:@"default"]];
        self.QRImgView = (UIImageView*)[cell viewWithTag:102];
        UIImage *image  = [QRCodeGenerator qrImageForString:self.OUserId imageSize:280];
        [self.QRImgView setImage:image];
        
        
        UIButton *QRbutton = (UIButton*)[cell viewWithTag:101];
        [QRbutton addTarget:self
                   action:@selector(QRbtnClicked:)
         forControlEvents:UIControlEventTouchUpInside];
        

        UIButton *button = (UIButton*)[cell viewWithTag:5];
        [button addTarget:self
                   action:@selector(headerClicked:)
         forControlEvents:UIControlEventTouchUpInside];
        
        /*************数据展示************/
        //名字
        UILabel *name = (UILabel *)[cell viewWithTag:2];
        name.text = dataDetails.TrueName;
        //账号
        UILabel *ID = (UILabel *)[cell viewWithTag:3];
        if (!dataDetails.UserId) {
            ID.text = [NSString stringWithFormat:@"%@%@",@"账号:",@"暂无信息"];
            
            
        }else{
            ID.text = [NSString stringWithFormat:@"%@%@",@"账号：",dataDetails.UserId];
            
        }
        
    } else if (indexPath.section == 1 && indexPath.row == 3) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"ContactDetailImageCell" forIndexPath:indexPath];
        UIImageView *image1 = (UIImageView *)[cell viewWithTag:2];
        UIImageView *image2 = (UIImageView *)[cell viewWithTag:3];
        UIImageView *image3 = (UIImageView *)[cell viewWithTag:4];
        UIImageView *image4 = (UIImageView *)[cell viewWithTag:5];
        UILabel *title = (UILabel *)[cell viewWithTag:6];
        
        if (!dataDetails.PictureUrl) {
            title.hidden = NO;
        }else{
//            if ([dataDetails.photoAddress count] == 1) {
//                [image1 setImageWithURL:[NSURL URLWithString:dataDetails.photoAddress[0]] placeholderImage:[UIImage imageNamed:@"defaultAlbum.png"]];
//            }else if ([dataDetails.photoAddress count] == 2){
//                [image1 setImageWithURL:[NSURL URLWithString:dataDetails.photoAddress[0]] placeholderImage:[UIImage imageNamed:@"defaultAlbum.png"]];
//                [image2 setImageWithURL:[NSURL URLWithString:dataDetails.photoAddress[1]] placeholderImage:[UIImage imageNamed:@"defaultAlbum.png"]];
//            }else if ([dataDetails.photoAddress count] == 3){
//                [image1 setImageWithURL:[NSURL URLWithString:dataDetails.photoAddress[0]] placeholderImage:[UIImage imageNamed:@"defaultAlbum.png"]];
//                [image2 setImageWithURL:[NSURL URLWithString:dataDetails.photoAddress[1]] placeholderImage:[UIImage imageNamed:@"defaultAlbum.png"]];
//                [image3 setImageWithURL:[NSURL URLWithString:dataDetails.photoAddress[2]] placeholderImage:[UIImage imageNamed:@"defaultAlbum.png"]];
//            }else{
//                [image1 setImageWithURL:[NSURL URLWithString:dataDetails.photoAddress[0]] placeholderImage:[UIImage imageNamed:@"defaultAlbum.png"]];
//                [image2 setImageWithURL:[NSURL URLWithString:dataDetails.photoAddress[1]] placeholderImage:[UIImage imageNamed:@"defaultAlbum.png"]];
//                [image3 setImageWithURL:[NSURL URLWithString:dataDetails.photoAddress[2]] placeholderImage:[UIImage imageNamed:@"defaultAlbum.png"]];
//                [image4 setImageWithURL:[NSURL URLWithString:dataDetails.photoAddress[3]] placeholderImage:[UIImage imageNamed:@"defaultAlbum.png"]];
//            }
            
        }
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"ContactDetailTextCell" forIndexPath:indexPath];
        //1,2,3,5
        
        UILabel *label1 = (UILabel*)[cell viewWithTag:1];
        UILabel *label2 = (UILabel*)[cell viewWithTag:2];
        
        
        switch (indexPath.row) {
            case 0:
                label1.text = @"地区";
                if (!dataDetails.NowAreaCode || dataDetails.NowAreaCode.length == 0) {
                    label2.text = @"暂无信息";
                }else{
                    label2.text = dataDetails.NowAreaCode;
                    
                }
                
                break;
            case 1:
                label1.text = @"学校";
                if (!dataDetails.SchoolName) {
                    label2.text = @"暂无信息";
                }else{
                    label2.text = dataDetails.SchoolName;
                }
                
                break;
//            case 2:
//                label1.text = @"云空间";
//                if ([dataDetails.LatestNews isEqualToString:@"Microblog"]) {
//                    label2.text = @"更新了微博动态";
//                }else if ([dataDetails.LatestNews isEqualToString:@"Photo"]){
//                    label2.text = @"更新了相册信息";
//                }else if([dataDetails.LatestNews isEqualToString:@"Blog"]){
//                    label2.text = @"更新了日志动态";
//                }else{
//                    label2.text = @"最近没有动态哦！";
//                }
//                
//                break;
            case 2:
                label1.text = @"电话";
                if (!dataDetails.AccountMobile) {
                    label2.text =@"暂无消息";
                }else{
                    label2.text = dataDetails.AccountMobile;
                }
                break;
                
            default:
                break;
        }
        
        
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)setInfo
{
    if (dataDetails.IsFollowed) {
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

- (void)sendMessage:(UIButton*)button
{
    if (self.bMyFirend) {
        [self.navigationController pushViewController:ChatVCID
                                       withStoryBoard:MessageStoryBoardName
                                            withBlock:^(UIViewController *viewController) {
            ChatViewController *vc = (ChatViewController*)viewController;
            vc.UserId = [NSString stringWithFormat:@"%@",dataDetails.UserId];
            vc.UserName = dataDetails.TrueName;
        }];

    } else {
        [self.navigationController pushViewController:ContactSendVerVCID
                                       withStoryBoard:ContactStoryBoardName
                                            withBlock:^(UIViewController *viewController) {
            ContactSendVerificationViewController *vc =
                                        (ContactSendVerificationViewController*)viewController;
            vc.userID = self.OUserId;
        }];
    }
}

- (void)removeView:(ChatViewController*)chatVC
{
    //        //进入聊天界面之后，后退直接回到沟通界面
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    if ([array count] >= 2) {
        UIViewController *viewController = (UIViewController*)[array objectAtIndex:[array count] - 2];
        if ([viewController isKindOfClass:[ContactDetailViewController class]]) {
            [array removeObject:viewController];
            [self.navigationController setViewControllers:array];
            UIViewController *rootVC = (UIViewController*)[array objectAtIndex:0];
            if (rootVC.tabBarController) {
//                rootVC.tabBarController.selectedIndex = 1;
                
                UIViewController *vc = [rootVC.tabBarController.viewControllers objectAtIndex:1];
                [array replaceObjectAtIndex:0 withObject:vc];
                
            }
        }
    }
}

- (void)headerClicked:(UIButton*)button
{
    [SJAvatarBrowser showImage:self.avatarImgView];

}

- (void)QRbtnClicked:(UIButton*)button
{
    [SJAvatarBrowser showImage:self.QRImgView];
    
}

@end
