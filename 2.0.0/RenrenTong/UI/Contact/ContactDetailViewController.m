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


#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

@interface ContactDetailViewController ()
{
    NdividualData *dataDetails;

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
//    self.tableView.separatorStyle = NO;
//    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
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
    [self showWithStatus:@""];
    [self.netWorkManager personalDataWithDetail:[RRTManager manager].loginManager.loginInfo.userId OUserId:self.OUserId success:^(NdividualData *ndividual) {
        [self dismiss];
        [self updateView:ndividual];
        
    } failed:^(NSString *errorMSG) {
        [self showErrorWithStatus:errorMSG];
    }];
}
//刷新界面
- (void)updateView:(NdividualData *)data
{
    self.dadtaSuorce = [NSArray arrayWithObject:data];
    dataDetails = [self.dadtaSuorce objectAtIndex:0];
//    dataDetails.isFriend = 1;
    self.bMyFirend = dataDetails.isFriend;
    
    NSLog(@"%hhd",dataDetails.isFriend);
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
        return 60;
    } else {
        return 0;
    }
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, 280, 40)];
        button.backgroundColor = appColor;
        button.layer.cornerRadius = 2.0f;
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self
                   action:@selector(sendMessage:)
         forControlEvents:UIControlEventTouchUpInside];
        if (self.bMyFirend) {
            [button setTitle:@"发消息" forState:UIControlStateNormal];
        } else {
            [button setTitle:@"添加到通信录" forState:UIControlStateNormal];
        }

        [view addSubview:button];
        return view;
    } else {
        return nil;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
        case 1:
            return self.bMyFirend ? 5 : 2;
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
        NSString *avatarUrl = [NSString stringWithFormat:@"%@%@%@?lq=123456",appHeadImage,self.OUserId,@".jpg"];
        [self.avatarImgView setImageWithUrlStr:avatarUrl placholderImage:[UIImage imageNamed:@"default"]];

        UIButton *button = (UIButton*)[cell viewWithTag:5];
        [button addTarget:self
                   action:@selector(headerClicked:)
         forControlEvents:UIControlEventTouchUpInside];
        //二维码按钮
//        self.QRImgView = (UIImageView*)[cell viewWithTag:4];
//        UIButton *QRButton = (UIButton *)[cell viewWithTag:7];
//        [QRButton addTarget:self action:@selector(QRClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        /*************数据展示************/
        //名字
        UILabel *name = (UILabel *)[cell viewWithTag:2];
        name.text = dataDetails.TrueName;
        //账号
        UILabel *ID = (UILabel *)[cell viewWithTag:3];
        if (!dataDetails.UserAccount) {
            ID.text = [NSString stringWithFormat:@"%@%@",@"账号:",@"暂无信息"];
            
            
        }else{
            ID.text = [NSString stringWithFormat:@"%@%@",@"账号：",dataDetails.UserAccount];
            
        }
        
    } else if (indexPath.section == 1 && indexPath.row == 3) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"ContactDetailImageCell" forIndexPath:indexPath];
        UIImageView *image1 = (UIImageView *)[cell viewWithTag:2];
        UIImageView *image2 = (UIImageView *)[cell viewWithTag:3];
        UIImageView *image3 = (UIImageView *)[cell viewWithTag:4];
        UIImageView *image4 = (UIImageView *)[cell viewWithTag:5];
        UILabel *title = (UILabel *)[cell viewWithTag:6];
        
        if (!dataDetails.photoAddress) {
            title.hidden = NO;
        }else{
            if ([dataDetails.photoAddress count] == 1) {
                [image1 setImageWithURL:[NSURL URLWithString:dataDetails.photoAddress[0]] placeholderImage:[UIImage imageNamed:@"defaultAlbum.png"]];
            }else if ([dataDetails.photoAddress count] == 2){
                [image1 setImageWithURL:[NSURL URLWithString:dataDetails.photoAddress[0]] placeholderImage:[UIImage imageNamed:@"defaultAlbum.png"]];
                [image2 setImageWithURL:[NSURL URLWithString:dataDetails.photoAddress[1]] placeholderImage:[UIImage imageNamed:@"defaultAlbum.png"]];
            }else if ([dataDetails.photoAddress count] == 3){
                [image1 setImageWithURL:[NSURL URLWithString:dataDetails.photoAddress[0]] placeholderImage:[UIImage imageNamed:@"defaultAlbum.png"]];
                [image2 setImageWithURL:[NSURL URLWithString:dataDetails.photoAddress[1]] placeholderImage:[UIImage imageNamed:@"defaultAlbum.png"]];
                [image3 setImageWithURL:[NSURL URLWithString:dataDetails.photoAddress[2]] placeholderImage:[UIImage imageNamed:@"defaultAlbum.png"]];
            }else{
                [image1 setImageWithURL:[NSURL URLWithString:dataDetails.photoAddress[0]] placeholderImage:[UIImage imageNamed:@"defaultAlbum.png"]];
                [image2 setImageWithURL:[NSURL URLWithString:dataDetails.photoAddress[1]] placeholderImage:[UIImage imageNamed:@"defaultAlbum.png"]];
                [image3 setImageWithURL:[NSURL URLWithString:dataDetails.photoAddress[2]] placeholderImage:[UIImage imageNamed:@"defaultAlbum.png"]];
                [image4 setImageWithURL:[NSURL URLWithString:dataDetails.photoAddress[3]] placeholderImage:[UIImage imageNamed:@"defaultAlbum.png"]];
            }
            
        }
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"ContactDetailTextCell" forIndexPath:indexPath];
        //1,2,3,5
        
        UILabel *label1 = (UILabel*)[cell viewWithTag:1];
        UILabel *label2 = (UILabel*)[cell viewWithTag:2];
        
        
        switch (indexPath.row) {
            case 0:
                label1.text = @"地区";
                if (!dataDetails.NowAreaName || dataDetails.NowAreaName.length == 0) {
                    label2.text = @"暂无信息";
                }else{
                    label2.text = dataDetails.NowAreaName;
                    
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
            case 2:
                label1.text = @"云空间";
                if ([dataDetails.LatestNews isEqualToString:@"Microblog"]) {
                    label2.text = @"更新了微博动态";
                }else if ([dataDetails.LatestNews isEqualToString:@"Photo"]){
                    label2.text = @"更新了相册信息";
                }else if([dataDetails.LatestNews isEqualToString:@"Blog"]){
                    label2.text = @"更新了日志动态";
                }else{
                    label2.text = @"最近没有动态哦！";
                }
                
                break;
            case 4:
                label1.text = @"家长";
                if (!dataDetails.parentName) {
                    label2.text =@"暂无消息";
                }else{
                    label2.text = dataDetails.parentName;
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
    if (dataDetails.isFriend) {
        [self.navigationController pushViewController:ContactSettingVCID
                                       withStoryBoard:ContactStoryBoardName
                                            withBlock:^(UIViewController *viewController) {
            ContactSettingViewController *vc = (ContactSettingViewController*)viewController;
            vc.Id = dataDetails.UserId;
            vc.name = dataDetails.TrueName;
        }];
    }else{
        [self showWithTitle:@"先加好友才能设置权限哦" defaultStr:nil];
    }
}

- (void)sendMessage:(UIButton*)button
{
    if (self.bMyFirend) {
        [self.navigationController pushViewController:ChatVCID
                                       withStoryBoard:MessageStoryBoardName
                                            withBlock:^(UIViewController *viewController) {
            ChatViewController *vc = (ChatViewController*)viewController;
            vc.toStr = [NSString stringWithFormat:@"%@",dataDetails.UserId];
        }];

//        [self performSelector:@selector(removeView:) withObject:vc afterDelay:0.8f];
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
    MJPhoto *photo = [[MJPhoto alloc] init];
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:1];

    photo.srcImageView = self.avatarImgView;
    photo.image = self.avatarImgView.image;
    [photos addObject:photo];
    
    // 2.显示相册
    browser.currentPhotoIndex = 0; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    [browser show];
}

//- (void)QRClicked:(UIButton *)sender
//{
//    photo.srcImageView = self.QRImgView;
//    photo.image = self.QRImgView.image;
//    [photos addObject:photo];
//    
//    // 2.显示相册
//    browser.currentPhotoIndex = 0; // 弹出相册时显示的第一张图片是？
//    browser.photos = photos; // 设置所有的图片
//    [browser show];
//
//}

@end
