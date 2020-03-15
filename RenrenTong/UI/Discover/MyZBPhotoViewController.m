//
//  MyZBPhotoViewController.m
//  RenrenTong
//
//  Created by aedu on 15/1/16.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "MyZBPhotoViewController.h"
#import "QRCodeGenerator.h"

@interface MyZBPhotoViewController ()

@end

@implementation MyZBPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的二维码";
    UIImageView *ZBimageView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREENWIDTH - 280) / 2, 100, 280, 280)];
    self.view.backgroundColor = [UIColor whiteColor];
    UIImage *image  = [QRCodeGenerator qrImageForString:[RRTManager manager].loginManager.loginInfo.userId imageSize:280];
    [ZBimageView setImage:image];
    [self.view addSubview:ZBimageView];
    
     UIImageView *iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake((280 - 40) / 2, 120, 40, 40)];
    [iconImageView setImage:[UIImage imageNamed:@"180"]];
    [ZBimageView addSubview:iconImageView];
    
    UIImageView *headerImageView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREENWIDTH - 280) / 2 +25, ZBimageView.bottom - 20, 50, 50)];
    [headerImageView setImageWithURL:[NSURL URLWithString:[RRTManager manager].loginManager.loginInfo.userAvatar] placeholderImage:[UIImage imageNamed:@"default"]];
    
    [headerImageView.layer setCornerRadius:(headerImageView.frame.size.height/2)];
    headerImageView.layer.masksToBounds = YES;
    headerImageView .contentMode = UIViewContentModeScaleAspectFit;
    headerImageView.layer.shadowColor = [UIColor grayColor].CGColor;
    headerImageView.layer.shadowOffset = CGSizeMake(8, 8);
    headerImageView.layer.shadowOpacity = 1.0f;
    headerImageView.layer.shadowRadius = 4.0f;
    headerImageView.layer.borderColor = [[UIColor whiteColor] CGColor];
    headerImageView.layer.borderWidth = 2.0f;
    headerImageView.userInteractionEnabled = YES;
    headerImageView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:headerImageView];
    
    UILabel *userName = [[UILabel alloc] initWithFrame:CGRectMake(headerImageView.right + 10, ZBimageView.bottom - 20, 200, 30)];
    userName.text = [NSString stringWithFormat:@"%@",[RRTManager manager].loginManager.loginInfo.userName];
    userName.font = [UIFont systemFontOfSize:15];
    userName.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:userName];
    
    UILabel *dicName = [[UILabel alloc] initWithFrame:CGRectMake(headerImageView.right + 10, userName.bottom - 5 , 200, 30)];
    dicName.text = @"扫一扫二维码，加我好友吧。";
    dicName.textColor = [UIColor lightGrayColor];
    dicName.textAlignment = NSTextAlignmentLeft;
    dicName.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:dicName];

}


@end
