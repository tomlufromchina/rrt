//
//  EditViewController.m
//  RenrenTong
//
//  Created by 符其彬 on 14-11-3.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "EditViewController.h"

@interface EditViewController ()<UITextViewDelegate>
@property (nonatomic, strong) NetWorkManager *netWorkManager;

@end

@implementation EditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.netWorkManager = [[NetWorkManager alloc] init];
//    self.textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;//自适应高度
    self.textView.layer.borderColor = appColor.CGColor;
    self.textView.layer.borderWidth = 0.5;
    self.textView.layer.cornerRadius = 5.0;
    self.textView.text = self.content;
    self.textView.delegate = self;
    
    self.titileLabel.text = self.titleUI;
    self.titileLabel.textColor = [UIColor lightGrayColor];
    self.title = self.titleName;
    
    //Add search button
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"保存"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(clickSendButton)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"取消"
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(clickBackButton)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]
                                          initWithTarget:self
                                          action:@selector(didTappedBackground:)];
    tapGesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGesture];
    
}

#pragma mark -- 判断邮箱格式

-(BOOL)CheckInput:(NSString *)_text{
    NSString *Regex=@"[A-Z0-9a-z._%+-]+@[A-Z0-9a-z._]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",Regex];
    return [emailTest evaluateWithObject:_text];
    
}
#pragma mark -- 判断QQ

//判断是否为整形：
- (BOOL)isPureInt:(NSString*)string{
    
    NSScanner* scan = [NSScanner scannerWithString:string];
    
    int val;
    
    return[scan scanInt:&val] && [scan isAtEnd];
    
}

//判断是否为浮点形：
- (BOOL)isPureFloat:(NSString*)string{
    
    NSScanner* scan = [NSScanner scannerWithString:string];
    
    float val;
    
    return[scan scanFloat:&val] && [scan isAtEnd];
    
}

#pragma mark -- 判断手机
-(BOOL) isValidateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    //    NSLog(@"phoneTest is %@",phoneTest);
    return [phoneTest evaluateWithObject:mobile];
}

#pragma mark -- 保存
- (void)clickSendButton
{
    if ([self.title isEqualToString:@"编辑邮箱"]) {
        
        if(![self CheckInput:self.textView.text]){
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"您的邮箱格式不正确，请检查" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
            [alert show];
        } else {
            NSString *str = [NSString stringWithFormat:@"AccountEmail=%@",self.textView.text];
            [self dismiss];
            [self.netWorkManager modificationMyselfDetails:[RRTManager manager].loginManager.loginInfo.userId
                                          modificationType:str
                                                   success:^(NSDictionary *friendDynamic) {
                                                       [self dismiss];
                                                       [self gotoMainUI:friendDynamic];
                                                       
                                                   } failed:^(NSString *errorMSG) {
                                                       [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:errorMSG];
                                                       
                                                   }];
            
        }
        
        
    } else if ([self.title isEqualToString:@"编辑QQ"]){
        if( ![self isPureInt:self.textView.text] || ![self isPureFloat:self.textView.text])
            
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"请输入纯数字！" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
            [alert show];
            return;
            
        } else{
            NSString *str = [NSString stringWithFormat:@"QQ=%@",self.textView.text];
            [self dismiss];
            [self.netWorkManager modificationMyselfDetails:[RRTManager manager].loginManager.loginInfo.userId
                                          modificationType:str
                                                   success:^(NSDictionary *friendDynamic) {
                                                       [self dismiss];
                                                       [self gotoMainUI:friendDynamic];
                                                       
                                                   } failed:^(NSString *errorMSG) {
                                                       [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:errorMSG];
                                                       
                                                   }];
        }
    } else if ([self.title isEqualToString:@"编辑手机"]){
        if (![self isValidateMobile:self.textView.text]) {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"您的手机格式不正确，请检查" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
            [alert show];
            
        } else {
            NSString *str = [NSString stringWithFormat:@"Mobile=%@",self.textView.text];
            [self dismiss];
            [self.netWorkManager modificationMyselfDetails:[RRTManager manager].loginManager.loginInfo.userId
                                          modificationType:str
                                                   success:^(NSDictionary *friendDynamic) {
                                                       [self dismiss];
                                                       [self gotoMainUI:friendDynamic];
                                                       
                                                   } failed:^(NSString *errorMSG) {
                                                       [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:errorMSG];
                                                       
                                                   }];
        }
    } else if ([self.title isEqualToString:@"编辑简介"]){
        NSString *str = [NSString stringWithFormat:@"Introduction=%@",self.textView.text];
        [self dismiss];
        [self.netWorkManager modificationMyselfDetails:[RRTManager manager].loginManager.loginInfo.userId
                                      modificationType:str
                                               success:^(NSDictionary *friendDynamic) {
                                                   [self dismiss];
                                                   [self gotoMainUI:friendDynamic];
                                                   
                                               } failed:^(NSString *errorMSG) {
                                                   [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:errorMSG];
                                                   
                                               }];
    } else if ([self.title isEqualToString:@"编辑昵称"]){
        NSString *str = [NSString stringWithFormat:@"NickName=%@",self.textView.text];
        [self dismiss];
        [self.netWorkManager modificationMyselfDetails:[RRTManager manager].loginManager.loginInfo.userId
                                      modificationType:str
                                               success:^(NSDictionary *friendDynamic) {
                                                   [self dismiss];
                                                   [self gotoMainUI:friendDynamic];
                                                   
                                               } failed:^(NSString *errorMSG) {
                                                   [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:errorMSG];
                                                   
                                               }];
        
    }
    
}

- (void)gotoMainUI:(NSDictionary *)data
{
    [self showImage:[UIImage imageNamed:@"confirm-ok72.png"] status:@"修改成功"];

    [self performSelector:@selector(back) withObject:nil afterDelay:0.5f];
    self.block();
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickBackButton
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark -- 字数限制
-(void)textViewDidChange:(UITextView *)textView
{
    if ([self.title isEqualToString:@"编辑简介"]) {
        NSInteger number = [textView.text length];
        if (number > 140) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"输入字数不能大于140哦！" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
            [alert show];
            textView.text = [textView.text substringToIndex:140];
            number = 140;
        }
    } else if ([self.title isEqualToString:@"编辑昵称"]){
        NSInteger number = [textView.text length];
        if (number > 40) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"输入字数不能大于40哦！" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
            [alert show];
            textView.text = [textView.text substringToIndex:40];
            number = 40;
        }
    } else if ([self.title isEqualToString:@"编辑手机"]){
        NSInteger number = [textView.text length];
        if (number > 11) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"输入字数不能大于11哦！" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
            [alert show];
            textView.text = [textView.text substringToIndex:11];
            number = 11;
        }
    }

}

#pragma mark - Tap Gesture
#pragma mark -
- (void)didTappedBackground:(UIGestureRecognizer*)ges
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self dismiss];
}
@end
