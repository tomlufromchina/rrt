//
//  SendRecordViewController.m
//  RenrenTong
//
//  Created by jeffrey on 14-7-8.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "SendRecordViewController.h"
#import "ViewControllerIdentifier.h"
#import "FaceBoard.h"

@interface SendRecordViewController ()<UITextFieldDelegate, UITextViewDelegate>
{
    BOOL isEndPublish;
}

@property (weak, nonatomic) IBOutlet UITextField *titileTextField;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;

@property (nonatomic) FaceBoard *faceBoard;

@property (nonatomic, strong) NetWorkManager *netWorkManager;




@end

@implementation SendRecordViewController

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
    isEndPublish = YES;
    self.title = @"写日志";
    
    //Add right button
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"发布"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(sendRecord)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.contentTextView.delegate = self;
    self.contentTextView.layer.borderColor = [UIColor colorWithRed:200.0/255
                                                             green:200.0/255
                                                              blue:200.0/255
                                                             alpha:1.0].CGColor;
    self.contentTextView.layer.borderWidth = 1.0;
    self.contentTextView.layer.cornerRadius = 2.0;

    self.titileTextField.delegate = self;
    self.titileTextField.layer.borderColor = [UIColor colorWithRed:200.0/255
                                                             green:200.0/255
                                                              blue:200.0/255
                                                             alpha:1.0].CGColor;
    self.titileTextField.layer.borderWidth = 1.0;
    self.titileTextField.layer.cornerRadius = 2.0;
    
    self.faceBoard = [[FaceBoard alloc] init];
    
    self.faceBoard.inputTextView = self.contentTextView;
    
    _netWorkManager = [[NetWorkManager alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)faceBtnClicked:(id)sender
{
    [self.titileTextField resignFirstResponder];
    [self.contentTextView resignFirstResponder];
    
    self.contentTextView.inputView = self.faceBoard;
    [self.contentTextView becomeFirstResponder];
}

- (void)sendRecord
{
    [self.titileTextField resignFirstResponder];
    [self.contentTextView resignFirstResponder];
    self.contentTextView.inputView = nil;
    
    //todo:
    if ([self validataTheSend] && isEndPublish) {
        [self show];
        isEndPublish = NO;
        [self.netWorkManager sendBlog:[RRTManager manager].loginManager.loginInfo.userId Subject:self.titileTextField.text Body:self.contentTextView.text success:^(NSDictionary *data) {
            
            [self updateUI];
            isEndPublish = YES;
        } failed:^(NSString *errorMSG) {
            isEndPublish = YES;
            [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:errorMSG];
        }];
    }
}

/*判断内容是否为空*/
- (BOOL)validataTheSend
{
    if (self.titileTextField.text.length <= 0) {
        [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"亲，还没输入标题哦！"];

        return NO;
    }
    if (self.contentTextView.text.length <= 0) {
        [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"亲，还没输入内容哦！"];

        return NO;
    }
    return YES;
}


- (void)updateUI
{
    [self performSelector:@selector(back) withObject:nil afterDelay:0.5f];
    self.block();
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self dismiss];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.titileTextField resignFirstResponder];
    [self.contentTextView resignFirstResponder];
    self.contentTextView.inputView = nil;
}

- (void)textViewDidEndEditing:(UITextView *)textView;
{
    [textView resignFirstResponder];
    textView.inputView = nil;
}

-(void)textViewDidChange:(UITextView *)textView
{
    [self.placeholderLabel setHidden:(textView.text.length == 0) ? NO : YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}

@end
