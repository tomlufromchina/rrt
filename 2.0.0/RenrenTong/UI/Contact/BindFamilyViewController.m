//
//  BindFamilyViewController.m
//  RenrenTong
//
//  Created by jeffrey on 14-7-18.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "BindFamilyViewController.h"
#import "ViewControllerIdentifier.h"
#import "BindFamilyValidationViewController.h"

@interface BindFamilyViewController () <UITextFieldDelegate>
{
    SendParentsDetail *_parentsDetail;

}

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIView *subView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *schoolLabel;
@property (weak, nonatomic) IBOutlet UIButton *bindButton;
@property (nonatomic, strong) NetWorkManager *netWorkManager;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, assign) BOOL isBinding;

@end

@implementation BindFamilyViewController

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
    self.bindButton.layer.cornerRadius = 2.0f;
    self.netWorkManager = [[NetWorkManager alloc] init];
    self.title = @"绑定家人";
    
    self.textField.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear
{
    [self dismiss];
}
/*
 * {"result":-7,"msg":"要绑定的账号不存在"}
 * {"result":-6,"msg":"绑定的账号只能是家长"}
 */
- (IBAction)searchBtnClicked:(id)sender
{
    int role = [[RRTManager manager].loginManager.loginInfo.userRole intValue];
    if (role == 1) {
        if (self.textField.text.length <= 0) {
            [self showWithTitle:@"请输入用户名哦!" defaultStr:nil];
        }else{
            [self showWithStatus:@""];
            [self.netWorkManager bindFamilySearch:[RRTManager manager].loginManager.loginInfo.tokenId ParUserAccount:self.textField.text success:^(NSArray *data) {
                [self dismiss];
                [self updateUI:data];
            } failed:^(NSString *errorMSG) {
                [self showErrorWithStatus:@"没有找到用户，请输入正确的账号哦!"];
            }];
            
        }
        
    }else{
        [self showWithTitle:@"只有学生用户才能绑定家长哦！" defaultStr:nil];
    }
}

- (void)updateUI:(NSArray *)data
{
    _parentsDetail = data[0];
    self.isBinding = _parentsDetail.CanBinding;
    if (self.isBinding == 0) {
        [self.subView setHidden:NO];
        self.nameLabel.text = _parentsDetail.TrueName;
        self.addressLabel.text = _parentsDetail.NowAreaName;
        self.schoolLabel.text = _parentsDetail.SchoolName;
        [self.bindButton setTitle:@"申请绑定为我的家长" forState:UIControlStateNormal];
        [self.bindButton setEnabled:YES];
        [self.bindButton setBackgroundColor:appColor];
    }else if (self.isBinding == 1){
        [self.subView setHidden:NO];
        self.nameLabel.text = _parentsDetail.TrueName;
        self.addressLabel.text = _parentsDetail.NowAreaName;
        self.schoolLabel.text = _parentsDetail.SchoolName;
        [self.bindButton setTitle:@"此用户已是您的家长" forState:UIControlStateNormal];
        [self.bindButton setEnabled:NO];
        [self.bindButton setBackgroundColor:[UIColor grayColor]];
        
    }else{
        [self.subView setHidden:YES];
    }
    [self.textField resignFirstResponder];
    
}

- (IBAction)bindBtnClicked:(id)sender
{
    [self.navigationController pushViewController:BindFamilyValidationVCID
                                   withStoryBoard:ContactStoryBoardName
                                        withBlock:^(UIViewController *viewController) {
        BindFamilyValidationViewController *vc = (BindFamilyValidationViewController*)viewController;
        vc.Account = self.textField.text;
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.textField resignFirstResponder];
}

@end
