//
//  BindFamilyValidationViewController.m
//  RenrenTong
//
//  Created by 符其彬 on 14-8-21.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "BindFamilyValidationViewController.h"
#import "ViewControllerIdentifier.h"

@interface BindFamilyValidationViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *hidenLabel;
@property (nonatomic, strong) NetWorkManager *netWorkManager;

@end

@implementation BindFamilyValidationViewController

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
    self.textView.delegate = self;
    self.textView.layer.borderColor = [UIColor colorWithRed:200.0/255 green:200.0/255 blue:200.0/255 alpha:1.0].CGColor;
    self.textView.layer.borderWidth = 1.0;
    //    self.textView.layer.cornerRadius = 5.0;
    
    self.title = @"发送验证";
    
    //Add search button
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"发送"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(sendVerification)];
    self.navigationItem.rightBarButtonItem = rightItem;
    _netWorkManager = [[NetWorkManager alloc] init];
}

- (void)viewWillDisappear
{
    [self dismiss];
}

- (void) sendVerification
{
    if (self.textView.text.length <= 0) {
        [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"请输入验证内容哦!"];
    }else{
        [self showWithStatus:@"正在发送....."];
        [self.netWorkManager FamilySendValidation:[RRTManager manager].loginManager.loginInfo.tokenId
                                   ParUserAccount:self.Account
                                         ValidTxt:self.textView.text
                                          success:^(NSDictionary *data) {
            [self dismiss];
            [self updateUI];
        } failed:^(NSString *errorMSG) {
            [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"你已经绑定了该账号或已经绑定其他账号了哦!"];

        }];
        
    }
    [self.textView resignFirstResponder];
}

- (void)updateUI
{
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.textView resignFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView;
{
    [textView resignFirstResponder];
}

-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0) {
        self.hidenLabel.text = @"请输入验证信息";
    }else{
        self.hidenLabel.text = @"";
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
