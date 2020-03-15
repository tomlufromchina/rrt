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
    
    self.title = @"添加备注";
    
    //Add search button
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"发送"
                                                                  style:UIBarButtonItemStylePlain
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
        [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"请输入备注内容哦!"];

    }else{
        [self showWithStatus:@"正在发送....."];
        __weak ContactSendVerificationViewController *_self = self;
        [self.netWorkManager addFriends:[RRTManager manager].loginManager.loginInfo.userId FollowUserId:self.userID GroupIds:@"0" NoteName:self.textView.text success:^(NSString *msg) {
            [_self showWithStatus:msg];
            [_self updateView];
        } failed:^(NSString *errorMSG) {
            [_self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:errorMSG];
        }];
        
    }
    [self.textView resignFirstResponder];
}
     
- (void)updateView
{
    PacketBuilder* packetPacketBuilder =[Packet builder];
    
    [packetPacketBuilder setFrom:[RRTManager manager].loginManager.loginInfo.userId];
    [packetPacketBuilder setTo:self.userID];
    
    PresencePacketBuilder* ppb=[PresencePacket builder];
    [ppb setObjecttype:PresenceObjectTypeFriend];
    [ppb setDescription:[NSString stringWithFormat:@"%@请求添加你为好友",self.userName]];
    [ppb setActiontype:PresenceAtionTypeAdd];
    
    
    
    [packetPacketBuilder setPresenceBuilder:ppb];
    
    Packet* msg =[packetPacketBuilder build];
    Connection * connection=[Connection shareConnection];
    if (connection.isLogin&&connection.connectionopen) {
        [connection sendMessage:msg];
    }else{
        
        [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"发送失败，未连接到消息服务器"];
    }
    [self performSelector:@selector(back) withObject:nil afterDelay:1.0f];

}

- (void)back
{
    [self dismiss];
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
        self.placeholderLabel.text = @"请输入备注信息";
    }else{
        self.placeholderLabel.text = @"";
    }
}


@end
