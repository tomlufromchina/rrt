//
//  GroupViewController.m
//  RenrenTong
//
//  Created by 符其彬 on 14-10-22.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "GroupViewController.h"
#import "GroupCell.h"
#import "NextGroupCell.h"
#import "NetWorkManager+SchoolAndHouse.h"
#import "XYAlertViewHeader.h"

@interface GroupViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>
{
    NSString *numberStr;
    
}
@property (nonatomic, strong) UILabel *placeholderLabel;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UILabel *label1;
@property (nonatomic, strong) NetWorkManager *netWorkManager;
@property (nonatomic, strong) UIBarButtonItem *rightItem;

@end

@implementation GroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"给班级发送";
    self.mainTableView.dataSource = self;
    self.mainTableView.delegate = self;
    self.netWorkManager = [[NetWorkManager alloc] init];
    
    //Add search button
    _rightItem = [[UIBarButtonItem alloc] initWithTitle:@"发送"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(clickSendButton)];
    _rightItem.enabled = YES;
    self.navigationItem.rightBarButtonItem = _rightItem;
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(clickBackButton)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    // 限制短信数量
    
    [self.netWorkManager limitMessageCount:[RRTManager manager].loginManager.loginInfo.tokenId
                                    userId:[RRTManager manager].loginManager.loginInfo.userId
                                   success:^(NSString *data) {
                                       if (data) {
                                           numberStr = data;
                                       }
                                       [self.mainTableView reloadData];
                                       
                                   } failed:^(NSString *errorMSG) {
                                       [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:errorMSG];
                                       
                                   }];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]
                                          initWithTarget:self
                                          action:@selector(didTappedBackground:)];
    tapGesture.cancelsTouchesInView = NO;
    [self.mainTableView addGestureRecognizer:tapGesture];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

}

- (void)clickBackButton
{
    if (self.textView.text.length >0) {
        // create an alertView
        XYAlertView *alertView = [XYAlertView alertViewWithTitle:@"家校沟通"
                                                         message:@"编辑的消息还未发送，是否要返回？"
                                                         buttons:[NSArray arrayWithObjects:@"是", @"否", nil]
                                                    afterDismiss:^(int buttonIndex) {
                                                        
                                                        if (buttonIndex == 0) {
                                                            [self.navigationController popViewControllerAnimated:YES];
                                                        }
                                                        
                                                        
                                                    }];
        // set the second button as gray style
        [alertView setButtonStyle:XYButtonStyleGray atIndex:1];
        // display
        [alertView show];
        
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark -- 网络请求
- (void)requestData
{
    NSIndexPath *cellPath1 = [NSIndexPath indexPathForItem:0 inSection:1];
    GroupCell *cell1 = (GroupCell *)[self.mainTableView cellForRowAtIndexPath:cellPath1];
    cell1 = (GroupCell *)[self.mainTableView cellForRowAtIndexPath:cellPath1];
    
    
    NSIndexPath *cellPath = [NSIndexPath indexPathForItem:0 inSection:0];
    NextGroupCell *cell = (NextGroupCell*)[self.mainTableView cellForRowAtIndexPath:cellPath];
    
    cell = (NextGroupCell*)[self.mainTableView cellForRowAtIndexPath:cellPath];
    
    // 以短信形式发送
    if (cell1.messgeButton.tag == 1) {
        int messageType = 0;
        if (cell.noticeButton.tag == 1) {
            messageType = 11;
        } else if (cell.taskButton.tag == 1){
            messageType = 8;
        } else if (cell.presentationButton.tag == 1){
            messageType = 10;
        } else if (cell.wishButton.tag == 1){
            messageType = 9;
        }
        for (int i = 0; i < [self.classIdInfo count]; i ++){
            NSString *classId = [NSString stringWithFormat:@"%@",self.classIdInfo[i]];
            [self show];
            [self.netWorkManager teacherSendNextMessageForClass:[RRTManager manager].loginManager.loginInfo.tokenId
                                                    messageType:messageType
                                                        message:self.textView.text
                                                        classId:classId success:^(NSMutableArray *data) {
                                                            [self dismiss];
                                                            [self gotoUpdataUI:data];
                                                            
                                                        } failed:^(NSString *errorMSG) {
                                                            _rightItem.enabled = YES;
                                                            [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:errorMSG];
                                                        }];
        }
        
     // 以网页形式发送
    } else if (cell1.netButton.tag == 1){
        int messageType = 0;
        if (cell.noticeButton.tag == 1) {
            messageType = 11;
        } else if (cell.taskButton.tag == 1){
            messageType = 8;
        } else if (cell.presentationButton.tag == 1){
            messageType = 10;
        } else if (cell.wishButton.tag == 1){
            messageType = 9;
        }
        
        for (int i = 0; i < [self.classIdInfo count]; i ++){
            NSString *objectIdList = [NSString stringWithFormat:@"objectIdList=%@",self.classIdInfo[i]];
            [self show];
            [self.netWorkManager teacherSendMessageForClass:[RRTManager manager].loginManager.loginInfo.tokenId
                                                  teacherId:[RRTManager manager].loginManager.loginInfo.userId
                                                messageType:messageType
                                                    message:self.textView.text
                                               objectIdList:objectIdList
                                                    success:^(NSMutableArray *data) {
                                                        [self dismiss];
                                                        [self gotoUpdataUI:data];
                                                        
                                                    } failed:^(NSString *errorMSG) {
                                                        _rightItem.enabled = YES;
                                                        [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:errorMSG];
                                                    }];
            
            
        }
        
    }
}

#pragma mark -- 发送前做判断
- (BOOL)validateTheSend
{
    if (self.textView.text.length <= 0) {
        [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"还没有输入你要发的文字哦..." ];

        return NO;
    }
    return YES;
}

#pragma mark -- 刷新数据
- (void)gotoUpdataUI:(NSMutableArray *)data
{
    [self showImage:[UIImage imageNamed:@"confirm-ok72.png"] status:@"发送信息成功" ];

    [self performSelector:@selector(back) withObject:nil afterDelay:0.5f];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - keyboard show and hide
#pragma mark -
- (void)keyboardWillShow:(NSNotification *)note
{
    CGRect rect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat ty = rect.size.height-70;
    
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]
                     animations:^{
                         self.textView.transform=CGAffineTransformMakeTranslation(0, -ty);
                     }];
    
}

- (void)keyboardWillHide:(NSNotification *)note
{
    
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]
                     animations:^{
                         self.placeholderLabel.hidden = NO;
                         self.textView.transform = CGAffineTransformIdentity;
                     }];
}
#pragma mark -- XYAlertViewDelegate

- (void)clickSendButton
{
    if ([self validateTheSend]) {
        _rightItem.enabled = NO;

        // create an alertView
        XYAlertView *alertView = [XYAlertView alertViewWithTitle:@"家校沟通"
                                                         message:@"消息发送不可以回收，是否确认发送？"
                                                         buttons:[NSArray arrayWithObjects:@"是", @"否", nil]
                                                    afterDismiss:^(int buttonIndex) {
                                                        
                                                        if (buttonIndex == 0) {
                                                            [self requestData];
                                                            
                                                        } else{
                                                            _rightItem.enabled = YES;
                                                        }
                                                        
                                                        
                                                    }];
        // set the second button as gray style
        [alertView setButtonStyle:XYButtonStyleGray atIndex:1];
        // display
        [alertView show];
    }
    
}

#pragma mark - Table view data source And Delegete

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 80;
    } else{
        return 40;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"信息类型";
    } else{
        return @"发送方式";
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *cellIdentifier = @"NextGroupCell";
        NextGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"NextGroupCell" owner:self options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
        
    } else {
        static NSString *cellIdentifier = @"GroupCell";
        GroupCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"GroupCell" owner:self options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.1;
    } else{
        return 200;
    }
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 200)];
    if (section == 1) {
        UILabel *label = [[UILabel alloc] init];
        label.top = 10;
        label.left = 15;
        label.width = 100;
        label.height = 20;
        label.text = @"信息内容";
        label.textColor = [UIColor grayColor];
        label.font = [UIFont systemFontOfSize:13];
        label.textAlignment = NSTextAlignmentLeft;
        [view addSubview:label];
        
        _label1 = [[UILabel alloc] init];
        _label1.top = label.top;
        _label1.left = label.right + 80;
        _label1.width = 200;
        _label1.height = 20;
        _label1.text = [NSString stringWithFormat:@"可以输入0/%@个字",numberStr];
        _label1.textColor = [UIColor grayColor];
        _label1.font = [UIFont systemFontOfSize:13];
        _label1.textAlignment = NSTextAlignmentLeft;
        [view addSubview:_label1];
        
        self.textView = [[UITextView alloc] init];
        self.textView.top = label.bottom + 10;
        self.textView.left = label.left - 5;
        self.textView.width = 300;
        self.textView.height = 150;
        self.textView.delegate = self;
        self.textView.scrollEnabled = YES;//是否可以拖动
        self.textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;//自适应高度
        self.textView.layer.borderColor = appColor.CGColor;
        self.textView.layer.borderWidth = 0.5;
        self.textView.layer.cornerRadius = 5.0;
        self.textView.font = [UIFont fontWithName:@"Arial" size:15.0];
        [view addSubview:self.textView];
        
        self.placeholderLabel = [[UILabel alloc] init];
        self.placeholderLabel.text = @"输入你要发得文字...";
        self.placeholderLabel.top = self.textView.top + 5;
        self.placeholderLabel.left = self.textView.left + 3;
        self.placeholderLabel.width = 200;
        self.placeholderLabel.height = 20;
        self.placeholderLabel.textAlignment = NSTextAlignmentLeft;
        self.placeholderLabel.textColor = [UIColor grayColor];
        self.placeholderLabel.font = [UIFont systemFontOfSize:13];
        [view addSubview:self.placeholderLabel];
        
        return view;
    } else if (section == 0){
        return view;
    }
    return view;
}

#pragma mark - UITextView Delegate Methods

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView;
{
    self.placeholderLabel.hidden = YES;
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView
{
    [self.placeholderLabel setHidden:(textView.text.length == 0) ? NO : YES];
    
    NSInteger number = [textView.text length];
    int tmpNum = [numberStr intValue];
    if (number > tmpNum) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"输入字数不能大于%d个字",tmpNum] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        textView.text = [textView.text substringToIndex:tmpNum];
        number = tmpNum;
    }
    _label1.text = [NSString stringWithFormat:@"可以输入%d/189个字",number];
}

- (void)textViewDidEndEditing:(UITextView *)textView;
{
    self.placeholderLabel.hidden = YES;
    [textView resignFirstResponder];
    textView.inputView = nil;
}

#pragma mark - Tap Gesture
#pragma mark -
- (void)didTappedBackground:(UIGestureRecognizer*)ges
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    NSLog(@"%@ %@",NSStringFromClass([self class]),NSStringFromSelector(_cmd));
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
