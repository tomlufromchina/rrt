//
//  IncreaseAccountViewController.m
//  RenrenTong
//
//  Created by 符其彬 on 14/12/11.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "IncreaseAccountViewController.h"

@interface IncreaseAccountViewController ()<UITextFieldDelegate>
{
    NSUserDefaults *userDefaults;
    NSMutableArray* userName;
    NSMutableArray *theUserNumber;
    NSMutableArray *userPassAccount;
    NSMutableArray *userAvatar;
    
    UITextField *_checkText;
}

@property (nonatomic, strong) NetWorkManager *netWorkManager;


@end

@implementation IncreaseAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加新账号";
    
    self.userView.left = 10;
    self.userView.width = SCREENWIDTH - 20;

    self.passAccountView.left = 10;
    self.passAccountView.width = SCREENWIDTH - 20;
    self.passAccount.left = 10;
    self.passAccount.width = SCREENWIDTH - 30;
    self.userNumber.left = 10;
    self.userNumber.width = SCREENWIDTH - 30;
    self.addButton.layer.cornerRadius = 25;
    self.addButton.backgroundColor = homeHeaderColor;
    self.userView.layer.cornerRadius = 10;
    self.passAccountView.layer.cornerRadius = 10;
    // 手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]
                                          initWithTarget:self
                                          action:@selector(didTappedBackground:)];
    tapGesture.cancelsTouchesInView = NO;
    self.userNumber.delegate = self;
    self.passAccount.delegate = self;
    [self.view addGestureRecognizer:tapGesture];
    _netWorkManager = [[NetWorkManager alloc] init];

}
- (IBAction)clickAddButton:(UIButton *)sender
{
    if ([self validateTheLogin]) {
        
        [self showWithStatus:@"正在验证"];
        
        __weak IncreaseAccountViewController *_self = self;
        [self.netWorkManager loginWithUserName:_self.userNumber.text
                                  withPassword:_self.passAccount.text
                                       success:^(Login *login)
         {
             [self dismiss];
             
             [self popToVC:login];
         } failed:^(NSString *errorMSG) {
             
             [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"账号或密码错误！"];

             
         }];
    }
}

- (void)popToVC:(Login *)login
{
    // 这个地方让我醉了。。。NSUserDefaults 取出来是NSArray
    userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *accountText = [userDefaults stringForKey:@"accountText"];

    NSMutableArray *tmpuserNumberArray = [NSMutableArray arrayWithArray:(NSMutableArray *)[userDefaults objectForKey:@"userNumber"]];
    if (tmpuserNumberArray && [tmpuserNumberArray count] > 0) {
            if (![tmpuserNumberArray containsObject:self.userNumber.text] && ![self.userNumber.text isEqualToString:accountText]) {
                    if (!userName && !theUserNumber && !userAvatar && !userPassAccount) {
                        userName = [NSMutableArray arrayWithArray:(NSMutableArray *)[userDefaults objectForKey:@"userName"]];
                        theUserNumber = [NSMutableArray arrayWithArray:(NSMutableArray *)[userDefaults objectForKey:@"userNumber"]];
                        userAvatar = [NSMutableArray arrayWithArray:(NSMutableArray *)[userDefaults objectForKey:@"userAvatar"]];
                        userPassAccount = [NSMutableArray arrayWithArray:(NSMutableArray *)[userDefaults objectForKey:@"userPassAccount"]];
                    }
                    [userName addObject:login.userName];
                    [theUserNumber addObject:self.userNumber.text];
                    [userAvatar addObject:login.userAvatar];
                    [userPassAccount addObject:self.passAccount.text];
                    
                    [userDefaults setObject:userName forKey:@"userName"];
                    [userDefaults setObject:theUserNumber forKey:@"userNumber"];
                    [userDefaults setObject:userAvatar forKey:@"userAvatar"];
                    [userDefaults setObject:userPassAccount forKey:@"userPassAccount"];
                    
                    [userDefaults synchronize];
                    
                    [self.navigationController popViewControllerAnimated:YES];
                    [self.delegate chooseTheUserInformation];
            } else{
                [self performSelector:@selector(showError) withObject:self afterDelay:0.5];
                
            }
    } else{
        if (![self.userNumber.text isEqualToString:accountText]) {
            if (!userName && !theUserNumber && !userAvatar && !userPassAccount) {
                userName = [NSMutableArray arrayWithArray:(NSMutableArray *)[userDefaults objectForKey:@"userName"]];
                theUserNumber = [NSMutableArray arrayWithArray:(NSMutableArray *)[userDefaults objectForKey:@"userNumber"]];
                userAvatar = [NSMutableArray arrayWithArray:(NSMutableArray *)[userDefaults objectForKey:@"userAvatar"]];
                userPassAccount = [NSMutableArray arrayWithArray:(NSMutableArray *)[userDefaults objectForKey:@"userPassAccount"]];
                
            }
            [userName addObject:login.userName];
            [theUserNumber addObject:self.userNumber.text];
            [userAvatar addObject:login.userAvatar];
            [userPassAccount addObject:self.passAccount.text];
            
            [userDefaults setObject:userName forKey:@"userName"];
            [userDefaults setObject:theUserNumber forKey:@"userNumber"];
            [userDefaults setObject:userAvatar forKey:@"userAvatar"];
            [userDefaults setObject:userPassAccount forKey:@"userPassAccount"];
            [userDefaults synchronize];
            
            [self.navigationController popViewControllerAnimated:YES];
            [self.delegate chooseTheUserInformation];
            
        } else{
            [self performSelector:@selector(showError) withObject:self afterDelay:0.5];
            
        }
        
    }
   
}

- (void)showError
{
    [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"此账号已存在，不能重复添加哦！"];

}

- (BOOL)validateTheLogin
{
    if (self.userNumber.text.length <= 0) {
        [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"请输入用户名"];

        return NO;
    }
    if (self.passAccount.text.length <= 0) {
        [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"请输入密码"];

        return NO;
    }
    return YES;
}

#pragma mark
#pragma mark触摸隐藏键盘

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [_checkText resignFirstResponder];
}

#pragma mark
#pragma mark UITextField代理方法
-(void)textFieldDidBeginEditing:(UITextField*)textField{
    _checkText = textField;//设置被点击的对象
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (_checkText) {
        [_checkText resignFirstResponder];
    }
    if (textField.returnKeyType==UIReturnKeyNext) {
        [self.passAccount becomeFirstResponder];
    }else if(textField.returnKeyType==UIReturnKeyDone){
        [textField resignFirstResponder];
        
        __weak IncreaseAccountViewController *_self = self;
        [self.netWorkManager loginWithUserName:_self.userNumber.text
                                  withPassword:_self.passAccount.text
                                       success:^(Login *login)
         {
             [self dismiss];
             
             [self popToVC:login];
         } failed:^(NSString *errorMSG) {
             
             [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"此账号不存在！"];

             
         }];
    }
    return YES;
}

#pragma mark
#pragma mark -键盘弹出、隐藏时调用的方法
- (void)keyboardWillShow:(NSNotification*)notification {
    if (nil == _checkText) {
        return;
    }
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    CGRect textFrame = _checkText.frame;//当前UITextField的位置
    float textY = textFrame.origin.y + textFrame.size.height;//得到UITextField下边框距离顶部的高度
    float bottomY = self.view.frame.size.height - textY;//得到下边框到底部的距离
    if(bottomY >=keyboardRect.size.height ){//键盘默认高度,如果大于此高度，则直接返回
        return;
    }
    float moveY = keyboardRect.size.height - bottomY;
    [self moveInputBarWithKeyboardHeight:moveY withDuration:animationDuration];
    
}

-(void)keyboardWillHide:(NSNotification*)notification {
    NSDictionary* userInfo = [notification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [self moveInputBarWithKeyboardHeight:0.0 withDuration:animationDuration];
}


#pragma mark 移动view
-(void)moveInputBarWithKeyboardHeight:(float)_CGRectHeight withDuration:(NSTimeInterval)_NSTimeInterval{
    CGRect rect = self.view.frame;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:_NSTimeInterval];
    rect.origin.y = -_CGRectHeight;//view往上移动
    self.view.frame = rect;
    [UIView commitAnimations];
}

-(void)dealloc{
    //在视图控制器消除时，移除键盘事件的通知
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Tap Gesture
#pragma mark -
- (void)didTappedBackground:(UIGestureRecognizer*)ges
{
    [self.view endEditing:YES];
}
@end
