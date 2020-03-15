//
//  AddFriendViewController.m
//  RenrenTong
//
//  Created by jeffrey on 14-7-18.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "AddFriendViewController.h"
#import "ContactDetailViewController.h"
#import "BindFamilyViewController.h"
#import "MoileContactTableViewController.h"
#import "FriendDetailViewContriller.h"
#import "MessageNetService.h"

@interface AddFriendViewController () <UITextFieldDelegate>
{
    GetUserInfoBySJ_SearchMsg *_detail;
    
}

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (nonatomic, strong) NetWorkManager *netWorkManager;

@end

@implementation AddFriendViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"添加朋友";
    self.netWorkManager = [[NetWorkManager alloc]init];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    [self.navigationItem setBackBarButtonItem:backItem];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - button events
#pragma mark -
- (IBAction)searchBtnClicked:(id)sender
{
    if (self.textField.text.length <= 0) {
        [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"请输入用户名哦!"];

    } else{
        __block AddFriendViewController *_self = self;
        NSString *url = [NSString stringWithFormat:@"http://interface.%@/sjrrt/GetUserInfoBySJ_Search",aedudomain];
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[RRTManager manager].loginManager.loginInfo.tokenId,@"Token",self.textField.text,@"UserOrEmailName",nil];
        [HttpUtil GetWithUrl:url parameters:dic success:^(id json) {
            GetUserInfoBySJ_Search *loginModel = [[GetUserInfoBySJ_Search alloc] initWithString:json error:nil];
            if (loginModel.st == 0) {
                [_self dismiss];
                [_self updateUI:loginModel.msg];
            }else{
                [_self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"没有找到用户，请输入正确的账号哦!"];
            }
        } fail:^(id errors) {
        } cache:^(id cache) {
        }];
    }
}
- (void)updateUI:(NSArray *)data
{
    _detail = [data objectAtIndex:0];
    [self.navigationController pushViewController:ContactDetailVCID
                                   withStoryBoard:ContactStoryBoardName
                                        withBlock:^(UIViewController *viewController) {
                                            ContactDetailViewController *vc = (ContactDetailViewController*)viewController;
                                            vc.OUserId =[NSString stringWithFormat:@"%@",_detail.UserId];
                                        }];
    
//    FriendDetailViewContriller *detailVC = [[FriendDetailViewContriller alloc]init];
//    detailVC.userId =[NSString stringWithFormat:@"%@",_detail.UserId];
//    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.textField resignFirstResponder];
}

@end
