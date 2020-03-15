//
//  FeedbackViewController.m
//  RenrenTong
//
//  Created by 符其彬 on 14/12/10.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "FeedbackViewController.h"

@interface FeedbackViewController ()<UITextViewDelegate>
@property (strong, nonatomic) UMFeedback *feedback;

@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"意见反馈";
    self.textView.delegate = self;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"发送"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(clickSendButton:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    // 手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]
                                          initWithTarget:self
                                          action:@selector(didTappedBackground:)];
    tapGesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGesture];
    
//    [UMFeedback setAppkey:APPKEY];
//    self.feedback = [UMFeedback sharedInstance];
    self.feedback.delegate = self;
}
#pragma mark -- 发送
- (void)clickSendButton:(UIButton *)sender
{
//    [UMFeedback showFeedback:self withAppkey:APPKEY];
    if ([self validataTheSend]) {
        [self showWithStatus:@"正在发送"];
        
//        NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:@"1",@"UMengFeedbackGender",@"2",@"UMengFeedbackAge",@"test",@"UMengFeedbackContent", nil];
//        
//        [self.feedback feedbackWithDictionary:dic];
        
        [self performSelector:@selector(success) withObject:nil afterDelay:2.0f];

    }
}

- (void)success
{
//    [UMFeedback showFeedback:self withAppkey:APPKEY];

    [self performSelector:@selector(back) withObject:nil afterDelay:1.0f];

}
- (void)back
{
    [self dismiss];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UMFeedback Delegate

//- (void)getFinishedWithError:(NSError *)error {
//    if (error != nil) {
//        NSLog(@"%@", error);
//    } else {
//        NSLog(@"%@", self.feedback.topicAndReplies);
//    }
//}
//
//- (void)postFinishedWithError:(NSError *)error {
//    if (error != nil) {
//        NSLog(@"%@", error);
//    } else {
//        NSLog(@"%@", self.feedback.topicAndReplies);
//    }
//}

#pragma mark - ubility
#pragma mark -
/*判断内容是否为空*/
- (BOOL)validataTheSend
{
    if (self.textFiled.text.length <= 0) {
        [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"请输入联系方式！" ];

        return NO;
    }
    if (![self isPureInt:self.textFiled.text] && ![self isPureFloat:self.textFiled.text] && ![self CheckInput:self.textFiled.text]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"您的邮箱/QQ格式不正确，请检查！" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    if (self.textView.text.length <= 0) {
        [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"请输入您的宝贵得意见！" ];

        return NO;
    }
    return YES;
}

#pragma mark -- 邮箱
-(BOOL)CheckInput:(NSString *)_text{
    NSString *Regex=@"[A-Z0-9a-z._%+-]+@[A-Z0-9a-z._]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",Regex];
    return [emailTest evaluateWithObject:_text];
    
}

#pragma mark -- 判断QQ
- (BOOL)isPureInt:(NSString*)string{
    
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
    
}

- (BOOL)isPureFloat:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
    
}

#pragma mark - TextView Delegate
#pragma mark -
- (void)textViewDidEndEditing:(UITextView *)textView;
{
    [textView resignFirstResponder];
    textView.inputView = nil;
}

-(void)textViewDidChange:(UITextView *)textView
{
    [self.shuiYinLabel setHidden:(textView.text.length == 0) ? NO : YES];
}

#pragma mark - Tap Gesture
#pragma mark -
- (void)didTappedBackground:(UIGestureRecognizer*)ges
{
    [self.view endEditing:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.tabBarController.tabBar.hidden = YES;
    
}

@end
