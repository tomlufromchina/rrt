//
//  ContactSendVerificationViewController.m
//  RenrenTong
//
//  Created by jeffrey on 14-6-11.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "ContactSendVerificationViewController.h"
#import "NetWorkManager.h"
#import "ViewControllerIdentifier.h"

@interface ContactSendVerificationViewController () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;

@property (nonatomic, strong) NetWorkManager *netWorkManager;



@end

@implementation ContactSendVerificationViewController

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
                                                                  style:UIBarButtonItemStyleBordered
                                                                 target:self
                                                                 action:@selector(sendVerification)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    _netWorkManager = [[NetWorkManager alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    self.hidesBottomBarWhenPushed = YES;
    [self dismiss];
}

- (void)viewWillDisappear:(BOOL)animated
{
    //self.hidesBottomBarWhenPushed = NO;
}

- (void) sendVerification
{
    if (self.textView.text.length <= 0) {
        [self showErrorWithStatus:@"请输入验证内容哦!"];
    }else{
        [self showWithStatus:@"正在发送....."];
        __weak ContactSendVerificationViewController *_self = self;
        [self.netWorkManager addFriends:[RRTManager manager].loginManager.loginInfo.tokenId UserId:self.userID SenderUserId:[RRTManager manager].loginManager.loginInfo.userId Sender:[RRTManager manager].loginManager.loginInfo.userName InviteTxt:self.textView.text success:^(NSDictionary *data) {
            [_self dismiss];
            [_self updateView];
            
        } failed:^(NSString *errorMSG) {
            [_self showErrorWithStatus:errorMSG];
        }];
        
    }
    [self.textView resignFirstResponder];
}
     
- (void)updateView
{
    [self showSuccessWithStatus:@"发送成功"];
    [self performSelector:@selector(back) withObject:nil afterDelay:1.0f];

}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
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
        self.placeholderLabel.text = @"请输入验证信息";
    }else{
        self.placeholderLabel.text = @"";
    }
}


@end
