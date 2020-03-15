//
//  AboutViewController.m
//  RenrenTong
//
//  Created by 符其彬 on 14-10-20.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
@property (nonatomic, strong)NetWorkManager *netWorkManger;
@property (nonatomic, strong) UIAlertView *alert;
@property (nonatomic, strong) NSDictionary *infoDict;

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.title = @"关于";
    
    self.mainTableView.dataSource = self;
    self.mainTableView.delegate = self;
    self.mainTableView.showsVerticalScrollIndicator = NO;
    self.netWorkManger = [[NetWorkManager alloc] init];
    
    UIView *backView = (UIView *)[self.view viewWithTag:101];
    backView.layer.borderColor = [UIColor grayColor].CGColor;
    backView.userInteractionEnabled = YES;
    backView.layer.borderWidth = 0.5;
    backView.layer.cornerRadius = 3;
    
    [self requestData];

}

#pragma mark -- 请求版本数据

- (void)requestData
{
    // 检测有无新版本（解析数据）
    [self.netWorkManger checkingVersion:@"641431831"
                                success:^(NSDictionary *data) {
                                    [self dismiss];
                                    self.infoDict = data;
                                } failed:^(NSString *errorMSG) {
                                    [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:errorMSG];
                                }];
}

#pragma mark - Table view data source
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 0.1;
    }else{
        return 5;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 110;
    } else {
        return 45;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
        case 1:
            return 1;
        case 2:
            return 1;
        default:
            return 0;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"AboutHeaderCell" forIndexPath:indexPath];
        
        return cell;
        
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"AboutCell" forIndexPath:indexPath];
        UILabel *menuLabel = (UILabel *)[cell viewWithTag:1];
        UIImageView *goImageView = (UIImageView *)[cell viewWithTag:2];
        UILabel *label = (UILabel *)[cell viewWithTag:3];
        label.textColor = [UIColor lightGrayColor];
        NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
        CFShow((__bridge CFTypeRef)(infoDic));
        NSString *appVersion = [infoDic objectForKey:@"CFBundleVersion"];
        label.text = [NSString stringWithFormat:@"当前版本:%@",appVersion];
        if (indexPath.section == 1) {
            menuLabel.text = @"版本";
            goImageView.hidden = YES;
        } else{
            label.hidden = YES;
            menuLabel.text = @"检查新版本";
        }
        
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 2) {
        [self gotoUpdataVersion:self.infoDict];
    }
}

#pragma mark -- 判断APP版本是否相同

- (void)gotoUpdataVersion:(NSDictionary *)Msg
{
    // 获取老版本型号
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    CFShow((__bridge CFTypeRef)(infoDic));
    NSString *appVersion = [infoDic objectForKey:@"CFBundleVersion"];
    NSArray *infoArray = [Msg objectForKey:@"results"];
    NSString *releaseNotes = [infoArray[0] objectForKey:@"releaseNotes"];
    if ([infoArray count]) {
        NSDictionary *releaseInfo = [infoArray objectAtIndex:0];
        NSString *lastVersion = [releaseInfo objectForKey:@"version"];
        if (![lastVersion isEqualToString:appVersion]) {
            self.alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"智慧云人人通%@",lastVersion]
                                                            message:releaseNotes
                                                           delegate:self
                                                  cancelButtonTitle:@"稍后再说"
                                                  otherButtonTitles:@"立即更新",nil];
            [self.alert show];
        } else{
            self.alert = [[UIAlertView alloc] initWithTitle:@"已经是最新版本啦~"
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            [self.alert show];
        }
    }
    
}

#pragma mark -- UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"clickButtonAtIndex:%d",buttonIndex);
    
    if (buttonIndex == 1) {
        NSString *webLink = @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=641431831";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:webLink]];
    }
}

//AlertView已经消失时执行的事件
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
}

//ALertView即将消失时的事件
-(void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
}

//AlertView的取消按钮的事件
-(void)alertViewCancel:(UIAlertView *)alertView
{
}

//AlertView已经显示时的事件
-(void)didPresentAlertView:(UIAlertView *)alertView
{
    
}

//AlertView即将显示时
-(void)willPresentAlertView:(UIAlertView *)alertView
{
    
}

- (void)viewDidAppear:(BOOL)animated
{
    self.hidesBottomBarWhenPushed = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.hidesBottomBarWhenPushed = NO;
}
- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.tabBarController.tabBar.hidden = YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
