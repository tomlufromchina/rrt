//
//  RegisterViewController.m
//  RenrenTong
//
//  Created by jeffrey on 14-9-12.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()<UIActionSheetDelegate, UITextFieldDelegate>

@property (nonatomic, strong) NetWorkManager *netWorkMananger;

@property (nonatomic, weak) UITextField *identityTextField;
@property (nonatomic, weak) UITextField *accountTextField;
@property (nonatomic, weak) UITextField *nameTextField;
@property (nonatomic, weak) UITextField *pwdTextField;
@property (nonatomic, weak) UITextField *surePwdTextField;

@property (nonatomic, strong) NSArray *identities;

@end

@implementation RegisterViewController

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
    
    self.title = @"注册";
    
    self.identities = [[NSArray alloc] initWithObjects:@"老师",@"学生",@"家长" ,nil];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]
                                          initWithTarget:self
                                          action:@selector(didTappedBackground:)];
    tapGesture.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:tapGesture];
    
    self.netWorkMananger = [[NetWorkManager alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    
}

#pragma mark - Table view data source
#pragma mark -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count = 0;
    switch (section) {
        case 0:
            count = 1;
            break;
        case 1:
            count = 2;
            break;
        case 2:
            count = 2;
            break;
            
        default:
            break;
    }
    
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 2) {
        return 60;
    } else {
        return 0;
    }
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 2) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, 280, 40)];
        button.backgroundColor = appColor;
        [button setTitle:@"注册" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(registerClicked:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        return view;
    } else {
        return nil;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RegisterCell"
                                                            forIndexPath:indexPath];
    UILabel *title = (UILabel*)[cell viewWithTag:1];
    UITextField *textField = (UITextField*)[cell viewWithTag:2];
    
    
    if (indexPath.section == 0) {
        title.text = @"您是";
        self.identityTextField = textField;
        self.identityTextField.placeholder = @"请选择您的身份";
        self.identityTextField.userInteractionEnabled = NO;
        self.identityTextField.delegate = self;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        UIButton *identityBtn = [[UIButton alloc] initWithFrame:self.identityTextField.frame];
        identityBtn.backgroundColor = [UIColor clearColor];
        [identityBtn addTarget:self action:@selector(selectIdentity:)
              forControlEvents:UIControlEventTouchUpInside];
        [self.identityTextField.superview addSubview:identityBtn];
        
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            title.text = @"用户名";
            self.accountTextField = textField;
            self.accountTextField.placeholder = @"请输入您的邮箱";
            self.accountTextField.delegate = self;
        } else {
            title.text = @"姓名";
            self.nameTextField = textField;
            self.nameTextField.placeholder = @"请输入您的真实姓名";
            self.nameTextField.delegate = self;
        }
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            title.text = @"密码";
            self.pwdTextField = textField;
            self.pwdTextField.placeholder = @"限制6-16位";
            self.pwdTextField.secureTextEntry = YES;
            self.pwdTextField.delegate = self;
        } else {
            title.text = @"确认密码";
            self.surePwdTextField = textField;
            self.surePwdTextField.placeholder = @"请重复输入密码";
            self.surePwdTextField.secureTextEntry = YES;
            self.surePwdTextField.delegate = self;
        }
    }
    
    return cell;
}

- (void)registerClicked:(UIButton*)button
{
    [self.view endEditing:YES];
    
    NSString *userType = nil;
    if ([self.identityTextField.text isEqualToString:@"老师"]) {
        userType = @"3";
    }else if ([self.identityTextField.text isEqualToString:@"学生"]){
        userType = @"1";
    }else if ([self.identityTextField.text isEqualToString:@"家长"]){
        userType = @"2";
    }
    
    if ([self validateTheLogin]) {
        [self showWithStatus:nil];
        [self.netWorkMananger registerWithUserName:self.accountTextField.text
                                      withPassword:self.pwdTextField.text
                                          username:self.nameTextField.text
                                          usertype:userType
                                           success:^(NSDictionary *data) {
            [self dismiss];
            [self updateUI];
        } failed:^(NSString *errorMSG) {
            NSLog(@"The error is:%@", errorMSG);
            [self showErrorWithStatus:@"注册失败"];
        }];
    }
}

- (void)updateUI
{
    [self showWithTitle:@"注册成功" withTime:1.5f];
    [self performSelector:@selector(goBack) withObject:nil afterDelay:1.5f];
}


- (void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)selectIdentity:(UIButton*)button
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:[self.identities objectAtIndex:0],
                            [self.identities objectAtIndex:1],
                            [self.identities objectAtIndex:2], nil];
    
    [sheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex <= 2) {
        self.identityTextField.text = [self.identities objectAtIndex:buttonIndex];
    }
}

#pragma mark - Tap Gesture
#pragma mark -
- (void)didTappedBackground:(UIGestureRecognizer*)ges
{
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}

#pragma mark - Ubility
#pragma mark -
- (BOOL)validateTheLogin
{
    if (self.identityTextField.text.length <= 0) {
        [self showWithTitle:@"请选择身份哦！" defaultStr:nil];
        return NO;
    }
    
    if (self.accountTextField.text.length <= 0) {
        [self showWithTitle:@"请输入您的邮箱哦！" defaultStr:nil];
        return NO;
    }
    
    if (self.nameTextField.text.length <= 0) {
        [self showWithTitle:@"请填写真实姓名哦！" defaultStr:nil];
        return NO;
    }

    if (self.pwdTextField.text.length < 6 || self.pwdTextField.text.length > 16) {
        [self showWithTitle:@"密码最少要6位,最多16位哦！" defaultStr:nil];
        return NO;
    }

    if (![self.surePwdTextField.text isEqualToString:self.pwdTextField.text]) {
        [self showWithTitle:@"两次输入的密码不一致哦！" defaultStr:nil];
        return NO;
    }
    
    return YES;
}
@end
