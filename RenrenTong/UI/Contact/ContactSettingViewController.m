//
//  ContactSettingViewController.m
//  RenrenTong
//
//  Created by jeffrey on 14-6-16.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "ContactSettingViewController.h"
#import "ContactTableViewController.h"
#import "ViewControllerIdentifier.h"
#import "ContactDetailViewController.h"

@interface ContactSettingViewController ()<UIActionSheetDelegate>

@property (nonatomic, strong) NetWorkManager *netWorkManager;

@property (nonatomic, assign) BOOL visit;
@property (nonatomic, assign) BOOL shield;//屏蔽

@end

@implementation ContactSettingViewController

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
    self.title = @"资料设置";
    
    self.netWorkManager = [[NetWorkManager alloc] init];
    [self requestPermissionData];
}

/**********权限请求**********/
- (void)requestPermissionData
{
    [self show];
//    [MessageNetService GetUserSpacePower:[RRTManager manager].loginManager.loginInfo.userId OUserId:self.Id Successful:^(NSArray *model) {
//        [self dismiss];
//        [self updateTheView:[model objectAtIndex:0]];
//    } Error:^(id model) {
//        [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:model];
//    }];
    
    NSString *url = [NSString stringWithFormat:@"http://interface.%@/sjrrt/GetUserSpacePower",aedudomain];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[RRTManager manager].loginManager.loginInfo.userId,@"vuserid",self.Id,@"OUserId",nil];
    [HttpUtil GetWithUrl:url parameters:dic success:^(id json) {
        GetUserSpacePower *result = [[GetUserSpacePower alloc] initWithString:json error:nil];
        if (result.st == 0 && result.msg) {
            [self dismiss];
            [self updateTheView:[result.msg objectAtIndex:0]];
        }else{
            [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"操作失败"];
        }
    } fail:^(id errors) {
        [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"操作失败"];
    } cache:^(id cache) {
        
    }];
    
//    [self.netWorkManager backPermissionDetail:[RRTManager manager].loginManager.loginInfo.userId OUserId:self.Id success:^(NSDictionary *data) {
//        [self dismiss];
//        [self updateTheView:data];
//    } failed:^(NSString *errorMSG) {
//        [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:errorMSG];
//
//    }];

}

- (void)updateTheView:(GetUserSpacePowerMsg *)data
{
    self.visit = data.IsDisVisit;
    self.shield = data.IsPbDyn;
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 60;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, 280, 40)];
    button.backgroundColor = [UIColor redColor];
    button.layer.cornerRadius = 2.0f;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self
               action:@selector(deleteContact:)
     forControlEvents:UIControlEventTouchUpInside];
    
    [button setTitle:@"删除联系人" forState:UIControlStateNormal];
    
    [view addSubview:button];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    if (indexPath.section == 0) {
        cell= [tableView dequeueReusableCellWithIdentifier:@"ContactSettingItemCell"
                                              forIndexPath:indexPath];
        
        UILabel *label = (UILabel*)[cell viewWithTag:1];
        
        if (indexPath.row == 0) {
            label.text = @"不让他（她）访问我的空间";
            UISwitch *switchButton1 = (UISwitch *)[cell viewWithTag:2];
            [switchButton1 setOn:self.visit];
            [switchButton1 addTarget:self action:@selector(clickSwitch:) forControlEvents:UIControlEventTouchUpInside];
            
        } else {
            label.text = @"屏蔽他（她）的空间动态";
            UISwitch *switchButton2 = (UISwitch *)[cell viewWithTag:2];
            [switchButton2 setOn:self.shield];
            [switchButton2 addTarget:self action:@selector(strokeSwitch:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    return cell;
}
//不让他（她）访问我的空间
- (void)clickSwitch:(UISwitch *)sender
{
    BOOL isButtonOn = self.visit;
    [self show];
    NSString *url = [NSString stringWithFormat:@"http://interface.%@/sjrrt/SetForbidVisitSpace",aedudomain];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[RRTManager manager].loginManager.loginInfo.tokenId,@"Token",self.Id,@"OUserId",[RRTManager manager].loginManager.loginInfo.userId,@"VUserId",isButtonOn ? @"0" : @"1",@"IsForbid",nil];
    [HttpUtil PostWithUrl:url parameters:dic success:^(id json) {
        ErrorModel *erromodel = [[ErrorModel alloc] initWithString:json error:nil];
        if (erromodel.result.intValue == 1) {
            [self showImage:[UIImage imageNamed:@"confirm-ok72.png"] status:erromodel.msg];
            [self updateView];
        } else{
            [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:erromodel.msg];
        }
    } fail:^(id errors) {
        [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"操作失败"];
    } cache:^(id cache) {
    }];
}

- (void)updateView
{
//    [self showSuccessWithStatus:@""];
}

//屏蔽他（她）的空间动态
- (void)strokeSwitch:(UISwitch *)sender
{
    BOOL isButtonOnState = self.shield;
    [self show];
    NSString *url = [NSString stringWithFormat:@"http://interface.%@/sjrrt/SetPBActivities",aedudomain];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[RRTManager manager].loginManager.loginInfo.tokenId,@"Token",[RRTManager manager].loginManager.loginInfo.userId,@"OUserId",self.Id,@"VUserId",isButtonOnState ? @"0" : @"1",@"IsPb",self.name,@"OUserName",nil];
    [HttpUtil PostWithUrl:url parameters:dic success:^(id json) {
        ErrorModel *erromodel = [[ErrorModel alloc] initWithString:json error:nil];
        if (erromodel.result.intValue == 1) {
            [self showImage:[UIImage imageNamed:@"confirm-ok72.png"] status:erromodel.msg];
            [self dismiss];
            [self updateView];
        } else{
            [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:erromodel.msg];
        }
    } fail:^(id errors) {
        [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"操作失败"];
    } cache:^(id cache) {
    }];
}

- (void)updateUI
{
    [self showSuccessWithStatus:@""];

    //发送通知，告知联系人列表，联系人已删除，刷新联系人列表，不需要代理
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          self.Id, @"userId", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:kContactDeleted
                                                        object:nil
                                                      userInfo:dict];
    
    //直接退回到联系人界面
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    if ([array count] >= 2) {
        UIViewController *viewController = (UIViewController*)[array objectAtIndex:[array count] - 2];
        if ([viewController isKindOfClass:[ContactDetailViewController class]]) {
            [array removeObject:viewController];
            [self.navigationController setViewControllers:array];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}
/************删除联系人************/
- (void)deleteContact:(UIButton*)button
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:@"删除联系人", nil];
    
    [sheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self show];
//        [MessageNetService CancelFriends:[RRTManager manager].loginManager.loginInfo.tokenId FriendUserId:self.Id  Successful:^(id model) {
//            [self dismiss];
//            UIViewController *vc = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 3];
//            [self.navigationController popToViewController:vc animated:YES];
////            [self.navigationController popToRootViewControllerAnimated:YES];
////            [self updateUI];
//        } Error:^(id model) {
//            [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:model];
//        }];
        
        NSString *url = [NSString stringWithFormat:@"http://interface.%@/sjrrt/CancelFriends",aedudomain];
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[RRTManager manager].loginManager.loginInfo.tokenId,@"Token",self.Id ,@"FriendUserId",nil];
        [HttpUtil PostWithUrl:url parameters:dic success:^(id json) {
            ErrorModel *erromodel = [[ErrorModel alloc] initWithString:json error:nil];
            if (erromodel.result.integerValue == 1) {
                [self dismiss];
                UIViewController *vc = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 3];
                [self.navigationController popToViewController:vc animated:YES];
            }else{
                [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:erromodel.msg];
            }
        } fail:^(id errors) {
            [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:errors];
        } cache:^(id cache) {
        }];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self dismiss];
    
}


@end
