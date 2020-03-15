//
//  ChatViewController.m
//
//
//  Created by Liu Feng on 14-7-10.
//  Copyright (c) 2013年 Jeffrey.liu. All rights reserved.
//

#import "ChatViewController.h"
#import "ChatCell.h"
#import "FaceBoard.h"
#import "MoreMenuBoard.h"
#import "QBImagePickerController.h"
#import "ASIFormDataRequest.h"
#import "UIImage+Addition.h"
#import "FMDatabase.h"
#import "CTGrouperViewController.h"

#define Toolbar_Height  44
#define TextView_Height 33
#define AccPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"%@"]

@interface ChatViewController () <UITableViewDataSource,
UITableViewDelegate,
UITextViewDelegate,
AVAudioRecorderDelegate,
MoreMenuBoardDelegate,
QBImagePickerControllerDelegate,
UINavigationControllerDelegate,
UIImagePickerControllerDelegate,
ChatCellDelegate,AVAudioPlayerDelegate>

@property (nonatomic, strong) NSMutableArray *messages;
@property (nonatomic, strong) NSMutableArray *emjoarrays;

@property (nonatomic, strong) FaceBoard *faceBoard;
@property (nonatomic, strong) MoreMenuBoard *moreMenuBoard;

@property(nonatomic, strong)NSMutableDictionary *recordSettings;
@property(nonatomic, strong)AVAudioRecorder *audioRecorder;
@property(nonatomic, strong)NSTimer *timer;
@property(nonatomic, strong)NSTimer *sTimer;
@property(nonatomic, strong)NSString *voiceUrl;
@property(nonatomic, assign)int voiceDuration;
@property(nonatomic, assign)int seconds;

@property(nonatomic, strong)ASIFormDataRequest *request;

@property(nonatomic, strong)AVAudioPlayer *avPlayer;



@end

@implementation ChatViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = self.UserName;
    
    if (self.groupType) {
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"成员" style:UIBarButtonItemStylePlain target:self  action:@selector(lookGrouper)];
        self.navigationItem.rightBarButtonItem = rightItem;
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
        backItem.title = @"";
        [self.navigationItem setBackBarButtonItem:backItem];
    }
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ChatCell" bundle:nil]
         forCellReuseIdentifier:@"ChatCell"];
    self.tableView.showsVerticalScrollIndicator=YES;
    self.tableView.backgroundColor = [UIColor colorWithRed:235.0/255 green:235.0/255 blue:235.0/255 alpha:1];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.allowsSelection = NO;
    self.textField.delegate = self;
    self.textField.backgroundColor = [UIColor whiteColor];
    self.textField.layer.borderColor = [UIColor colorWithRed:235.0/255
                                                       green:235.0/255
                                                        blue:235.0/255
                                                       alpha:1.0].CGColor;
    self.textField.layer.borderWidth = 1.0;
    self.speekBtn.backgroundColor = appColor;
    
    //init faceboard
    self.faceBoard = [[FaceBoard alloc] init];
    self.faceBoard.inputTextView = self.textField;
    CGRect rect = self.faceBoard.frame;
    self.faceBoard.frame = CGRectMake(rect.origin.x,
                                      self.view.frame.size.height,
                                      rect.size.width,
                                      rect.size.height);
    [self.view addSubview:self.faceBoard];
    [self.faceBoard setHidden:YES];
    
    //init MoreMenuBoard
    self.moreMenuBoard = [[MoreMenuBoard alloc] init];
    self.moreMenuBoard.delegate = self;
    rect = self.moreMenuBoard.frame;
    self.moreMenuBoard.frame = CGRectMake(rect.origin.x,
                                          self.view.frame.size.height,
                                          rect.size.width,
                                          rect.size.height);
    [self.view addSubview:self.moreMenuBoard];
    [self.moreMenuBoard setHidden:YES];
    
    self.messages = [NSMutableArray array];
    self.emjoarrays = [NSMutableArray array];
    
    //record setting
    self.recordSettings = [[NSMutableDictionary alloc] initWithCapacity:10];
    
    [_recordSettings setObject:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey: AVFormatIDKey];
    [_recordSettings setObject:[NSNumber numberWithFloat:8000.0] forKey: AVSampleRateKey];
    [_recordSettings setObject:[NSNumber numberWithInt:1] forKey:AVNumberOfChannelsKey];
    [_recordSettings setObject:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    [_recordSettings setObject:[NSNumber numberWithInt:AVAudioQualityMedium]
                        forKey: AVEncoderAudioQualityKey];
    
    //register keyboard note
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(message:)
                                                 name: MESSAGE
                                               object: nil];
    
    
    
    
    //点击界面时，键盘消失的手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]
                                          initWithTarget:self
                                          action:@selector(didTappedBackground:)];
    tapGesture.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:tapGesture];
    [self updateData];
    if (self.tableView.contentSize.height>self.tableView.bounds.size.height) {
        [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentSize.height -self.tableView.bounds.size.height) animated:YES];
    }
}
- (void)lookGrouper
{
    CTGrouperViewController *groupVC = [[CTGrouperViewController alloc]init];
    groupVC.groupId = self.UserId;
    groupVC.groupType = self.groupType;
    groupVC.groupName = self.UserName;
    [self.navigationController pushViewController:groupVC animated:YES];
}
-(void)message:(NSNotification*)notefication{
    [self updateData];
}

- (void)viewDidAppear:(BOOL)animated
{
    self.hidesBottomBarWhenPushed = YES;
    if (self.tableView.contentSize.height>self.tableView.bounds.size.height) {
        [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentSize.height -self.tableView.bounds.size.height) animated:YES];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.hidesBottomBarWhenPushed = YES;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name: MESSAGE object: nil];
    
    [self.request setDelegate:nil];
    [self.request setUploadProgressDelegate:nil];
    [self.request cancel];
    
    [self dismiss];
    
    
    if (self.avPlayer) {
        [self.avPlayer pause];
    }
}

- (void)updateData
{
    NSMutableArray* array = [[NSMutableArray alloc] init];
    if (self.groupType) {
        array = [[IMCache shareIMCache] queryPacketGroupID:self.UserId userid:[RRTManager manager].loginManager.loginInfo.userId];
    }else{
        array = [[IMCache shareIMCache] queryPacketFriendID:self.UserId userid:[RRTManager manager].loginManager.loginInfo.userId];
    }
    if (array!=nil&&[array count]>0) {
        [self.messages removeAllObjects];
        [self.messages addObjectsFromArray:array];
        [self.emjoarrays removeAllObjects];
        for (Packet *p in _messages) {
            if (p.message.body.hasContent) {
                [self.emjoarrays addObject:[self createLableWithText:p.message.body.content font:[UIFont systemFontOfSize:15] width:210]];
            }else{
                [self.emjoarrays addObject:[self createLableWithText:@"点击播放语音" font:[UIFont systemFontOfSize:15] width:210]];
            }
        }
        [self.tableView reloadData];
        if (self.tableView.contentSize.height>self.tableView.bounds.size.height) {
            [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentSize.height -self.tableView.bounds.size.height) animated:YES];
        }
    }
    
    if (self.groupType) {
        NSMutableArray* unreads=[[IMCache shareIMCache] getGroupUnReadPacket:self.UserId userid:[RRTManager manager].loginManager.loginInfo.userId];
        for (Packet *p in unreads) {
            [[IMCache shareIMCache] updatePacketState:p.message.guid state:3];
        }
        if ([unreads count]>0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE object:nil];
        }
    }else{
        NSMutableArray* unreads=[[IMCache shareIMCache] getUnReadPacket:self.UserId userid:[RRTManager manager].loginManager.loginInfo.userId];
        for (Packet *p in unreads) {
            [[IMCache shareIMCache] updatePacketState:p.message.guid state:3];
        }
        if ([unreads count]>0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE object:nil];
        }
    }
}

#pragma mark - tableView datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.messages count];
}

-(NSDate*)nsstringToDate:(NSString*)string{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date=[formatter dateFromString:string];
    return date;
}

-(long)getMinuteWithDate:(NSDate*)date{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];//设置成中国阳历
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;//这句我也不明白具体时用来做什么。。。
    comps = [calendar components:unitFlags fromDate:date];
    long minute=[comps minute];//获取月对应的长整形字符串
    return minute;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChatCell"
                                                            forIndexPath:indexPath];
    
    
    ChatCell *chatCell = (ChatCell*)cell;
    chatCell.delegate = self;
    
    //是否显示时间 间隔1分钟之内不显示
    //TODO:后续实现
    if (indexPath.row >= 1) {
        chatCell.bShowTime = YES;
    } else {
        chatCell.bShowTime = YES;
    }
    Packet* pk=[self.messages objectAtIndex:indexPath.row];
    
    chatCell.timeLabel.text=pk.message.body.sendtime;
    chatCell.timeLabel.top=10;
    chatCell.name.top=chatCell.timeLabel.bottom+10;
    chatCell.contentbgbox.top=chatCell.name.bottom+5;
    chatCell.avatarImgView.top=chatCell.contentbgbox.top-chatCell.avatarImgView.height*0.2;
    
    
    if ([pk.from isEqualToString:[RRTManager manager].loginManager.loginInfo.userId]) {
        [chatCell.avatarImgView setImageWithURL:[NSURL URLWithString:[RRTManager manager].loginManager.loginInfo.userAvatar] placeholderImage:[UIImage imageNamed:@"defaultImage.png"]];
        chatCell.contentLabel.backgroundColor = [UIColor colorWithRed:104.0/255 green:213.0/255 blue:56.0/255 alpha:1];
    }else{
        if ([pk.message.body.sender isEqualToString:@"官方客服"]) {
            [chatCell.avatarImgView setImage:[UIImage imageNamed:@"好友动态-"]];
            if ([self.title containsString:@"教师"]) {
                chatCell.avatarImgView.image = [UIImage imageNamed:@"teacher_group"];
            }else if ([self.title containsString:@"学生"]) {
                chatCell.avatarImgView.image = [UIImage imageNamed:@"student_group"];
            }else if([self.title containsString:@"家长"]) {
                chatCell.avatarImgView.image = [UIImage imageNamed:@"parents_group"];
            }
        }else{
            
            if (self.groupType) {
                [chatCell.avatarImgView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://images.%@/avatars/%@.jpg",aedudomain,pk.from]] placeholderImage:[UIImage imageNamed:@"defaultImage.png"]];
            }else{
                [chatCell.avatarImgView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://images.%@/avatars/%@.jpg",aedudomain,self.UserId]] placeholderImage:[UIImage imageNamed:@"defaultImage.png"]];
            }
        }
        chatCell.contentLabel.backgroundColor = UIColorFromString(@"#FFFFFF");
    }
    chatCell.contentLabel.hidden=YES;
    chatCell.contentbgbox.hidden=YES;
    chatCell.contentbgbox.width=230+6;
    
    
    chatCell.contentLabel.numberOfLines = 0;
    chatCell.contentLabel.font = [UIFont systemFontOfSize:15];
    chatCell.contentLabel.emojiDelegate = self;
    chatCell.contentLabel.backgroundColor = [UIColor clearColor];
    chatCell.contentLabel.lineBreakMode = NSLineBreakByCharWrapping;
    chatCell.contentLabel.isNeedAtAndPoundSign = YES;
    chatCell.contentLabel.frame = CGRectMake(0, 0, 210, 0);
    
    chatCell.contentBtn.hidden=YES;
    if (pk.message.body.hasAudiouri) {
        chatCell.isaudio=YES;
        chatCell.voiceView.hidden=NO;
        chatCell.contentBtn.hidden=NO;
        chatCell.contentLabel.hidden=NO;
        chatCell.contentbgbox.hidden=NO;
        [chatCell.contentLabel setEmojiText:@"点击播放语音"];
        [chatCell.contentLabel sizeToFit];
        NSString *urlStr = pk.message.body.audiouri;
        NSArray *array = [urlStr componentsSeparatedByString:@"&&"];
        if (array.count == 2) {
            chatCell.voiceLabel.text=[NSString stringWithFormat:@"%@\"",array[1]];
        }
        chatCell.duration=0;
        [chatCell initAudioDuration:[NSString stringWithFormat:@"http://nmapi.%@%@",aedudomain,urlStr]];
        
        
        
        if (chatCell.contentLabel.width<210) {
            chatCell.contentbgbox.width=chatCell.contentLabel.width+chatCell.voiceView.width+20+6;
        }
        if ([pk.from isEqualToString:[RRTManager manager].loginManager.loginInfo.userId]) {
            chatCell.avatarImgView.right=SCREENWIDTH-10;
            chatCell.contentbgbox.image=[[UIImage imageNamed:@"sendmsgbox"] stretchableImageWithLeftCapWidth:8 topCapHeight:25];
            chatCell.contentbgbox.right=chatCell.avatarImgView.left-10;
            chatCell.voiceView.top=chatCell.contentbgbox.top+10;
            chatCell.voiceView.left=chatCell.contentbgbox.left+10;
        }else{
            chatCell.contentbgbox.image=[[UIImage imageNamed:@"recmsgbox"] stretchableImageWithLeftCapWidth:10 topCapHeight:25];
            chatCell.avatarImgView.left=10;
            chatCell.contentbgbox.left=chatCell.avatarImgView.right+10;
            chatCell.voiceView.left=chatCell.contentbgbox.left+10+6;
            chatCell.voiceView.top=chatCell.contentbgbox.top+10;
        }
        chatCell.contentLabel.top=chatCell.contentbgbox.top+10;
        chatCell.contentLabel.left=chatCell.voiceView.right;
        chatCell.contentbgbox.height=chatCell.contentLabel.height+20;
        chatCell.contentBtn.frame=chatCell.contentbgbox.frame;
        chatCell.contentLabel.userInteractionEnabled=NO;
    } else {
        chatCell.isaudio=NO;
        chatCell.voiceView.hidden=YES;
    }
    
    if (pk.message.body.hasPictureuri) {
        chatCell.contentImgView.hidden=NO;
        chatCell.contentBtn.hidden=NO;
        chatCell.contentbgbox.hidden=NO;
        chatCell.contentbgbox.width=80+10+6;
        chatCell.contentbgbox.height=120+10;
        chatCell.ispic=YES;
        if ([pk.from isEqualToString:[RRTManager manager].loginManager.loginInfo.userId]) {
            chatCell.avatarImgView.right=SCREENWIDTH-10;
            chatCell.contentbgbox.image=[[UIImage imageNamed:@"sendmsgbox"] stretchableImageWithLeftCapWidth:8 topCapHeight:25];
            chatCell.contentbgbox.right=chatCell.avatarImgView.left-10;
            CGRect rect = CGRectMake(chatCell.contentbgbox.left+5-2,
                                     chatCell.contentbgbox.top+5 -2,
                                     84,
                                     124);
            chatCell.contentBtn.frame = rect;
            chatCell.contentImgView.frame = rect;
            [chatCell.contentBtn setBackgroundImage:normal forState:UIControlStateNormal];
        }else{
            
            chatCell.contentbgbox.image=[[UIImage imageNamed:@"recmsgbox"] stretchableImageWithLeftCapWidth:10 topCapHeight:25];
            chatCell.avatarImgView.left=10;
            chatCell.contentbgbox.left=chatCell.avatarImgView.right+10;
            
            
            CGRect rect = CGRectMake(chatCell.contentbgbox.left+5+6-2, chatCell.contentbgbox.top+5-2, 84 , 124 );
            chatCell.contentBtn.frame = rect;
            
            chatCell.contentImgView.frame = rect;
            
        }
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://nmapi.%@%@",aedudomain,pk.message.body.pictureuri]];
        [chatCell.contentImgView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"defaultImage.png"]];
        
    }else{
        chatCell.ispic=NO;
        chatCell.contentImgView.hidden=YES;
    }
    
    
    if (pk.message.body.hasContent) {
        chatCell.contentLabel.userInteractionEnabled=YES;
        chatCell.contentLabel.hidden=NO;
        chatCell.contentbgbox.hidden=NO;
        [chatCell.contentLabel setEmojiText:pk.message.body.content];
        [chatCell.contentLabel sizeToFit];
        if (chatCell.contentLabel.width<210) {
            chatCell.contentbgbox.width=chatCell.contentLabel.width+20+6;
        }
        if ([pk.from isEqualToString:[RRTManager manager].loginManager.loginInfo.userId]) {
            chatCell.avatarImgView.right=SCREENWIDTH-10;
            chatCell.contentbgbox.image=[[UIImage imageNamed:@"sendmsgbox"] stretchableImageWithLeftCapWidth:8 topCapHeight:25];
            chatCell.contentbgbox.right=chatCell.avatarImgView.left-10;
            chatCell.contentLabel.left=chatCell.contentbgbox.left+10;
        }else{
            chatCell.contentbgbox.image=[[UIImage imageNamed:@"recmsgbox"] stretchableImageWithLeftCapWidth:10 topCapHeight:25];
            chatCell.avatarImgView.left=10;
            chatCell.contentbgbox.left=chatCell.avatarImgView.right+10;
            chatCell.contentLabel.left=chatCell.contentbgbox.left+10+6;
            chatCell.contentLabel.top=chatCell.contentbgbox.top+10;
        }
        chatCell.contentLabel.top=chatCell.contentbgbox.top+10;
        chatCell.contentbgbox.height=chatCell.contentLabel.height+20;
    }else{
        [chatCell.contentLabel setEmojiText:@"点击播放语音"];
    }
    
    chatCell.name.text=pk.message.body.sender;
    if ([pk.from isEqualToString:[RRTManager manager].loginManager.loginInfo.userId]) {
        chatCell.name.right=chatCell.avatarImgView.left-14;
        chatCell.name.textAlignment=NSTextAlignmentRight;
    }else{
        chatCell.name.left=chatCell.avatarImgView.right+14;
        chatCell.name.textAlignment=NSTextAlignmentLeft;
    }
    return chatCell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float height=10+20+5+27;
    Packet* pk=[self.messages objectAtIndex:indexPath.row];
    if (pk.message.body.hasContent) {
        MLEmojiLabel* mel=[self.emjoarrays objectAtIndex:indexPath.row];
        height=height+mel.height+20;
    }else if (pk.message.body.hasPictureuri) {
        height=height+120+10;
    }else if (pk.message.body.hasAudiouri) {
        height=height+40;
    }else {
        height=height+40;
    }
    return height+10;
}

#pragma mark - UIScrollView delegate
#pragma mark -
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
    [self showFaceBoard:NO];
    [self showMoreMenuBoard:NO];
}

#pragma mark - keyboard show and hide
#pragma mark -
- (void)keyBoardWillShow:(NSNotification *)note
{
    CGRect rect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat ty = - rect.size.height;
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]
                     animations:^{
                         self.tableView.transform = CGAffineTransformMakeTranslation(0, ty);
                         self.toolView.transform = CGAffineTransformMakeTranslation(0, ty);
                     }];
    
}

- (void)keyBoardWillHide:(NSNotification *)note
{
    
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]
                     animations:^{
                         self.tableView.transform = CGAffineTransformIdentity;
                         self.toolView.transform = CGAffineTransformIdentity;
                     }];
}

- (void)showFaceBoard:(BOOL)bShow
{
    if (bShow) {
        [self.faceBoard setHidden:NO];
        CGRect rect = self.faceBoard.frame;
        CGFloat ty = - rect.size.height;
        [UIView animateWithDuration:0.3f
                         animations:^{
                             self.tableView.transform = CGAffineTransformMakeTranslation(0, ty);
                             self.toolView.transform = CGAffineTransformMakeTranslation(0, ty);
                             self.faceBoard.transform = CGAffineTransformMakeTranslation(0, ty);
                         }];
    } else {
        [self.faceBoard setHidden:YES];
        [UIView animateWithDuration:0.3f
                         animations:^{
                             self.tableView.transform = CGAffineTransformIdentity;
                             self.toolView.transform = CGAffineTransformIdentity;
                             self.faceBoard.transform = CGAffineTransformIdentity;
                         }];
    }
}

- (void)showMoreMenuBoard:(BOOL)bShow
{
    if (bShow) {
        [self.moreMenuBoard setHidden:NO];
        CGRect rect = self.moreMenuBoard.frame;
        CGFloat ty = - rect.size.height;
        [UIView animateWithDuration:0.3f
                         animations:^{
                             self.tableView.transform = CGAffineTransformMakeTranslation(0, ty);
                             self.toolView.transform = CGAffineTransformMakeTranslation(0, ty);
                             self.moreMenuBoard.transform = CGAffineTransformMakeTranslation(0, ty);
                         }];
    } else {
        [self.moreMenuBoard setHidden:YES];
        [UIView animateWithDuration:0.3f
                         animations:^{
                             self.tableView.transform = CGAffineTransformIdentity;
                             self.toolView.transform = CGAffineTransformIdentity;
                             self.moreMenuBoard.transform = CGAffineTransformIdentity;
                         }];
    }
}

#pragma mark - text view delegate
#pragma mark -
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        
        if (!textView.text || [textView.text isEqualToString:@""]) {
            NSLog(@"输入内容不能为空");
            return YES;
        }
        
        PacketBuilder* packetPacketBuilder =[Packet builder];
        
        [packetPacketBuilder setFrom:[RRTManager manager].loginManager.loginInfo.userId];
        [packetPacketBuilder setTo:self.UserId];
        
        MessagePacketBuilder* messagePacketBuilder=[MessagePacket builder];
        [messagePacketBuilder setGuid:[UUID uuid]];
        [messagePacketBuilder setState:0];
        
        if (self.groupType) {
            [messagePacketBuilder setType:MessageTypeGroupChat];
        }else{
            [messagePacketBuilder setType:MessageTypeChat];
        }
        
        MessageBodyBuilder* messageBodyBuilder=[MessageBody builder];
        [messageBodyBuilder setType:MessageContentTypePlain];
        [messageBodyBuilder setContent:textView.text];
        [messageBodyBuilder setSender:[RRTManager manager].loginManager.loginInfo.userName];
        [messageBodyBuilder setReceiver:self.UserName];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
        [messageBodyBuilder setSendtime:currentDateStr];
        if (self.groupType) {
            [messageBodyBuilder setGroupid:self.UserId];
            [messageBodyBuilder setGroupname:self.UserName];
            [messageBodyBuilder setGrouptype:[NSString stringWithFormat:@"%d",self.groupType]];
        }
        [messagePacketBuilder setBodyBuilder:messageBodyBuilder];
        
        [packetPacketBuilder setMessageBuilder:messagePacketBuilder];
        
        Packet* msg =[packetPacketBuilder build];
        Connection * connection=[Connection shareConnection];
        if (connection.isLogin&&connection.connectionopen) {
            if (!self.groupType) {
                [[IMCache shareIMCache] savePacket:msg sessionid:self.UserId];
            }
            [connection sendMessage:msg];
        }else{
            [self showUploadView:@"发送失败，未连接到消息服务器"];
        }
        [self updateData];
        
        textView.text = nil;
        [textView resignFirstResponder];
        
        //判断toolbar是否变大了
        CGRect rect = self.toolView.frame;
        CGFloat ty = rect.size.height - Toolbar_Height;
        if (ty > 0.000001 || ty < -0.000001) {
            rect = self.tableView.frame;
            self.tableView.frame = CGRectMake(rect.origin.x,
                                              rect.origin.y + ty,
                                              CGRectGetWidth(rect),
                                              CGRectGetHeight(rect));
            rect = self.toolView.frame;
            self.toolView.frame = CGRectMake(rect.origin.x,
                                             rect.origin.y + ty,
                                             CGRectGetWidth(rect),
                                             CGRectGetHeight(rect) - ty);
            
            rect = self.textField.frame;
            self.textField.frame = CGRectMake(rect.origin.x,
                                              rect.origin.y,
                                              CGRectGetWidth(rect),
                                              CGRectGetHeight(rect) - ty);
        }
        
        
    }
    return YES;
}


- (BOOL)textViewShouldEndEditing:(UITextView *)textView;
{
    [textView resignFirstResponder];
    
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView;
{
    [self showFaceBoard:NO];
    [self showMoreMenuBoard:NO];
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    CGFloat fixedWidth = textView.frame.size.width;
    CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    
    if (newSize.height <= 100.0f) {
        CGRect newFrame = textView.frame;
        newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
        textView.frame = newFrame;
        
        //change the toolbar's height
        CGRect orgRect = self.toolView.frame;
        
        newFrame = self.toolView.frame;
        newFrame.size = CGSizeMake(newFrame.size.width, textView.frame.size.height + Toolbar_Height - TextView_Height);
        self.toolView.frame = newFrame;
        
        //判断是否要移动
        CGFloat ty = -(newFrame.size.height - orgRect.size.height);
        if (ty > 0.000001 || ty < -0.000001) {
            [UIView animateWithDuration:0.2f
                             animations:^{
                                 CGRect rect = self.tableView.frame;
                                 self.tableView.frame = CGRectMake(rect.origin.x,
                                                                   rect.origin.y + ty,
                                                                   CGRectGetWidth(rect),
                                                                   CGRectGetHeight(rect));
                                 rect = self.toolView.frame;
                                 self.toolView.frame = CGRectMake(rect.origin.x,
                                                                  rect.origin.y + ty,
                                                                  CGRectGetWidth(rect),
                                                                  CGRectGetHeight(rect));
                             }];
        }
    } else {
        [self.textField setContentOffset:CGPointMake(0, newSize.height - self.textField.frame.size.height)
                                animated:YES];
    }
}

#pragma mark - events
#pragma mark -
- (IBAction)voiceBtnClicked:(id)sender
{
    [self.voiceBtn setHidden:YES];
    [self.textField setHidden:YES];
    [self.textField resignFirstResponder];
    
    [self.textBtn setHidden:NO];
    [self.speekBtn setHidden:NO];
    [self.speekBtn setTitle:@"按住说话" forState:UIControlStateNormal];
    
    [self showFaceBoard:NO];
    [self showMoreMenuBoard:NO];
}

- (IBAction)textBtnClicked:(id)sender
{
    [self.textBtn setHidden:YES];
    [self.speekBtn setHidden:YES];
    [self.speekBtn setTitle:@"按住说话" forState:UIControlStateNormal];
    
    [self.voiceBtn setHidden:NO];
    [self.textField setHidden:NO];
    [self.textField becomeFirstResponder];
}

- (IBAction)faceBtnClicked:(id)sender
{
    [self.textBtn setHidden:YES];
    [self.speekBtn setHidden:YES];
    [self.speekBtn setTitle:@"按住说话" forState:UIControlStateNormal];
    
    [self.voiceBtn setHidden:NO];
    [self.textField setHidden:NO];
    
    [self.textField resignFirstResponder];
    
    [self showMoreMenuBoard:NO];
    [self showFaceBoard:YES];
    //todo:
}

- (IBAction)moreBtnClicked:(id)sender
{
    [self.textField resignFirstResponder];
    [self showFaceBoard:NO];
    
    [self showMoreMenuBoard:YES];
    //todo:
}

#pragma mark - record events   录音
#pragma mark -
- (void)reallyBeginToRecord
{
    [self.speekBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [self.speekBtn setTitle:@"松开结束" forState:UIControlStateHighlighted];
    
    NSDate *date = [NSDate date];
    NSTimeInterval name = [date timeIntervalSince1970];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString* cachesDirectory = [paths objectAtIndex:0];
    
    NSString *voicePath = [cachesDirectory stringByAppendingPathComponent:
                           [NSString stringWithFormat:ChatVoicePath]];
    [[NSFileManager defaultManager] createDirectoryAtPath:voicePath
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:nil];
    
    self.voiceUrl = [voicePath stringByAppendingPathComponent:
                     [NSString stringWithFormat:@"%f.aac", name]];
    NSURL *url = [NSURL fileURLWithPath:self.voiceUrl];
    
    
    NSError *error = nil;
    self.audioRecorder = [[AVAudioRecorder alloc] initWithURL:url
                                                     settings:self.recordSettings
                                                        error:&error];
    self.audioRecorder.delegate = self;
    
    if ([self.audioRecorder prepareToRecord]){
        self.audioRecorder.meteringEnabled = YES;
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.3
                                                      target:self
                                                    selector:@selector(levelTimerCallback)
                                                    userInfo:nil
                                                     repeats:YES];
        
        [self.audioRecorder record];
    }else {
        NSLog(@"Rrepare to record failed;");
    }
    
    NSLog(@"开始录音。。。。");
    if(!_sTimer){
        self.seconds = 20;
        //创建一个定时器，这个是直接加到当前消息循环中，注意与其他初始化方法的区别
        _sTimer=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(changeTimeAtTimedisplay) userInfo:nil repeats:YES];
        
        
    }
    
    [self.recordBoard setHidden:NO];
    [self.recordCancelImgView setHidden:YES];
    [self.recordMicImgView setHidden:NO];
    self.recordLabel.text = @"手指上滑,取消发送";
}
- (void)changeTimeAtTimedisplay
{
    self.seconds--;
    if (self.seconds < 6 && self.seconds > 0) {
        self.recordLabel.text = [NSString stringWithFormat:@"还可以录制%d秒",self.seconds];
    }
    if (self.seconds == 0) {
        [self finishRecord:nil];
        
    }
}
- (IBAction)beginToRecord:(id)sender
{
    // Init audio with record capability
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [audioSession setActive:YES error:nil];
    
    //判断麦克风是否打开
    if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
        [audioSession requestRecordPermission:^(BOOL granted) {
            if (!granted) {
                //麦克风没有打开
                NSString *tipStr = [NSString stringWithFormat:
                                    @"请在iPhone的\"设置-隐私-麦克风\"选项中，允许人人通访问你的手机麦克风"];
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"无法录音"
                                                                    message:tipStr
                                                                   delegate:nil
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles:nil];
                
                [alertView show];
            } else {
                [self reallyBeginToRecord];
            }
        }];
    }
}

- (IBAction)finishRecord:(id)sender
{
    [self.recordBoard setHidden:YES];
    
    NSLog(@"结束录音。。。。");
    if (_sTimer) {
        if ([self.sTimer isValid]) {
            [self.sTimer invalidate];
            _sTimer = nil;
            
        }
    }
    
    [self.speekBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.speekBtn setTitle:@"按住说话" forState:UIControlStateNormal];
    
    [self.timer invalidate];
    if (self.audioRecorder && [self.audioRecorder isRecording]) {
        
        self.voiceDuration = (int)self.audioRecorder.currentTime;
        
        [self.audioRecorder stop];
        
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
        
        if (self.voiceDuration < 1) {
            [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"说话时间太短"];
            
            return;
        }
        
        [self showWithStatus:nil];
        [self.request cancel];
        [self setRequest:[ASIFormDataRequest requestWithURL:
                          [NSURL URLWithString:[NSString stringWithFormat:@"http://nmapi.%@/Push/PostMessageFile",aedudomain]]]];
        [self.request setPostValue:[RRTManager manager].loginManager.loginInfo.tokenId forKey:@"Token"];
        [self.request setPostValue:[NSNumber numberWithInt:self.voiceDuration] forKey:@"playTime"];
        [self.request setTimeOutSeconds:20];
        [self.request setDelegate:self];
        [self.request setDidFailSelector:@selector(uploadFailed:)];
        [self.request setDidFinishSelector:@selector(uploadVoiceFinished:)];
        
        [self.request setFile:self.voiceUrl forKey:@"file"];
        
        [self.request startAsynchronous];
        [self showWithStatus:nil];
    }
    
}

- (IBAction)cancelRecord:(id)sender
{
    [self.recordBoard setHidden:YES];
    
    NSLog(@"取消录音。。。。");
    [self.speekBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.speekBtn setTitle:@"按住说话" forState:UIControlStateNormal];
    
    [self.timer invalidate];
    if (self.audioRecorder && [self.audioRecorder isRecording]) {
        [self.audioRecorder stop];
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
        [self.audioRecorder deleteRecording];
        self.voiceUrl = nil;
        self.voiceDuration = 0;
    }
}

- (IBAction)dragExit:(id)sender
{
    NSLog(@"手指上滑");
    [self.recordBoard setHidden:NO];
    [self.recordCancelImgView setHidden:NO];
    [self.recordMicImgView setHidden:YES];
    self.recordLabel.text = @"松开手指,取消发送";
}

- (IBAction)dragEnter:(id)sender
{
    NSLog(@"手指回到按钮");
    
    [self.recordBoard setHidden:NO];
    [self.recordCancelImgView setHidden:YES];
    [self.recordMicImgView setHidden:NO];
    self.recordLabel.text = @"手指上滑,取消发送";
}

#pragma mark - record delegate and callback
#pragma mark -
- (void)levelTimerCallback
{
    [self.audioRecorder updateMeters];
    float ave = [self.audioRecorder averagePowerForChannel:0];
    float linear = pow (10, ave / 20);
    
    float pitch = 0.0;
    if (linear > 0.03) {
        pitch = linear + 0.20;
    }
    NSLog(@"------%f----", pitch);
    //动画
    //mic_0.png,mic_1.png,mic_2.png,mic_3.png,mic_4.png,mic_5.png,mic_6.png
    if (pitch < 0.1) {
        [self.recordMicImgView setImage:[UIImage imageNamed:@"mic_1.png"]];
    } else if (pitch > 0.1 && pitch < 0.2) {
        [self.recordMicImgView setImage:[UIImage imageNamed:@"mic_2.png"]];
    } else if (pitch > 0.2 && pitch < 0.3) {
        [self.recordMicImgView setImage:[UIImage imageNamed:@"mic_3.png"]];
    } else if (pitch > 0.3 && pitch < 0.4) {
        [self.recordMicImgView setImage:[UIImage imageNamed:@"mic_4.png"]];
    } else if (pitch > 0.4 && pitch < 0.5) {
        [self.recordMicImgView setImage:[UIImage imageNamed:@"mic_5.png"]];
    } else if (pitch > 0.5) {
        [self.recordMicImgView setImage:[UIImage imageNamed:@"mic_6.png"]];
    }
}

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    //do nothing
}

- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error
{
    [self cancelRecord:nil];
}

- (void)audioRecorderBeginInterruption:(AVAudioRecorder *)recorder
{
    [self cancelRecord:nil];
}

#pragma mark - ChatDelegate
#pragma mark -
- (void)messageComming
{
    //    [self updateData:[RRTManager manager].imManager];
}

#pragma mark - MoreMenuBoardDelegate
#pragma mark -
- (void)itemClicked:(int)index
{
    NSLog(@"The item %d is clicked", index);
    if (index == 1) {
        //相册
        QBImagePickerController *imagePickerController = [[QBImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsMultipleSelection = YES;
        imagePickerController.filterType = QBImagePickerControllerFilterTypePhotos;
        imagePickerController.maximumNumberOfSelection = 1;
        
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
        [self presentViewController:navigationController animated:YES completion:NULL];
        
    } else if (index == 2) {
        //相机
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        if (![UIImagePickerController isSourceTypeAvailable: sourceType]) {
            [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"该设备不支持拍照"];
            
        } else {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = sourceType;
            [self presentViewController:picker animated:YES completion:NULL];
        }
    }else if (index == 5) {
        [self showMoreMenuBoard:NO];
        DoodleViewController* dvc=[[DoodleViewController alloc] init];
        dvc.doodledelegate=self;
        [self presentViewController:dvc animated:YES completion:nil];
        
    } else {
        [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"该功能暂不支持"];
        
    }
}
#pragma mark - 涂鸦回调
#pragma mark -
- (void)DoodleWithUIImage:(UIImage*)img{
    
    NSDate *date = [NSDate date];
    NSTimeInterval name = [date timeIntervalSince1970];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString* cachesDirectory = [paths objectAtIndex:0];
    
    NSString *imagePath = [cachesDirectory stringByAppendingPathComponent:
                           [NSString stringWithFormat:ChatImagePath]];
    [[NSFileManager defaultManager] createDirectoryAtPath:imagePath
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:nil];
    
    NSString *imgPath = [imagePath stringByAppendingPathComponent:
                         [NSString stringWithFormat:@"%f.png", name]];
    
    img = [UIImage scaleImage:img toScale:0.7];
    NSData *imgData = UIImagePNGRepresentation(img);
    [imgData writeToFile:imgPath atomically:YES];
    
    [self.request cancel];
    [self setRequest:[ASIFormDataRequest requestWithURL:
                      [NSURL URLWithString:[NSString stringWithFormat:@"http://nmapi.%@/Push/PostMessageFile",aedudomain]]]];
    [self.request setPostValue:[RRTManager manager].loginManager.loginInfo.tokenId forKey:@"Token"];
    [self.request setPostValue:[NSNumber numberWithInt:0] forKey:@"playTime"];
    [self.request setTimeOutSeconds:20];
    [self.request setDelegate:self];
    [self.request setDidFailSelector:@selector(uploadFailed:)];
    [self.request setDidFinishSelector:@selector(uploadPicFinished:)];
    
    [self.request setFile:imgPath forKey:@"file"];
    
    [self.request startAsynchronous];
    [self showWithStatus:nil];
}

#pragma mark - QBImagePickerControllerDelegate 相册
#pragma mark -
- (void)imagePickerController:(QBImagePickerController *)imagePickerController
               didSelectAsset:(ALAsset *)asset
{
    NSLog(@"*** imagePickerController:didSelectAsset:");
    NSLog(@"%@", asset);
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerController:(QBImagePickerController *)imagePickerController
              didSelectAssets:(NSArray *)assets
{
    NSLog(@"*** imagePickerController:didSelectAssets:");
    NSLog(@"%@", assets);
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    
    [self showMoreMenuBoard:NO];
    
    NSDate *date = [NSDate date];
    NSTimeInterval name = [date timeIntervalSince1970];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString* cachesDirectory = [paths objectAtIndex:0];
    
    NSString *imagePath = [cachesDirectory stringByAppendingPathComponent:
                           [NSString stringWithFormat:ChatImagePath]];
    [[NSFileManager defaultManager] createDirectoryAtPath:imagePath
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:nil];
    
    NSString *imgPath = [imagePath stringByAppendingPathComponent:
                         [NSString stringWithFormat:@"%f.png", name]];
    
    ALAsset *asset = (ALAsset*)[assets objectAtIndex:0];
    ALAssetRepresentation *assetRep = [asset defaultRepresentation];
    CGImageRef imgRef = [assetRep fullResolutionImage];
    UIImage *img = [UIImage imageWithCGImage:imgRef
                                       scale:assetRep.scale
                                 orientation:(UIImageOrientation)assetRep.orientation];
    //压缩图片
    img = [UIImage scaleImage:img toScale:0.2];
    
    NSData *imgData = UIImagePNGRepresentation(img);
    [imgData writeToFile:imgPath atomically:YES];
    
    [self.request cancel];
    [self setRequest:[ASIFormDataRequest requestWithURL:
                      [NSURL URLWithString:[NSString stringWithFormat:@"http://nmapi.%@/Push/PostMessageFile",aedudomain]]]];
    [self.request setPostValue:[RRTManager manager].loginManager.loginInfo.tokenId forKey:@"Token"];
    [self.request setPostValue:[NSNumber numberWithInt:0] forKey:@"playTime"];
    [self.request setTimeOutSeconds:20];
    [self.request setDelegate:self];
    [self.request setDidFailSelector:@selector(uploadFailed:)];
    [self.request setDidFinishSelector:@selector(uploadPicFinished:)];
    [self.request setFile:imgPath forKey:@"file"];
    
    [self.request startAsynchronous];
    [self showWithStatus:nil];
}

- (void)imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController
{
    NSLog(@"*** imagePickerControllerDidCancel:");
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - UIImagePickerControllerDelegate 相机
#pragma mark –
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:NULL];
    [self showMoreMenuBoard:NO];
    
    NSDate *date = [NSDate date];
    NSTimeInterval name = [date timeIntervalSince1970];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString* cachesDirectory = [paths objectAtIndex:0];
    
    NSString *imagePath = [cachesDirectory stringByAppendingPathComponent:
                           [NSString stringWithFormat:ChatImagePath]];
    [[NSFileManager defaultManager] createDirectoryAtPath:imagePath
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:nil];
    
    NSString *imgPath = [imagePath stringByAppendingPathComponent:
                         [NSString stringWithFormat:@"%f.png", name]];
    
    UIImage *img = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    //压缩图片
    img = [UIImage scaleImage:img toScale:0.2];
    
    NSData *imgData = UIImagePNGRepresentation(img);
    [imgData writeToFile:imgPath atomically:YES];
    
    
    
    
    
    [self.request cancel];
    [self setRequest:[ASIFormDataRequest requestWithURL:
                      [NSURL URLWithString:[NSString stringWithFormat:@"http://nmapi.%@/Push/PostMessageFile",aedudomain]]]];
    [self.request setPostValue:[RRTManager manager].loginManager.loginInfo.tokenId forKey:@"Token"];
    [self.request setPostValue:[NSNumber numberWithInt:0] forKey:@"playTime"];
    [self.request setTimeOutSeconds:20];
    [self.request setDelegate:self];
    [self.request setDidFailSelector:@selector(uploadFailed:)];
    [self.request setDidFinishSelector:@selector(uploadPicFinished:)];
    
    [self.request setFile:imgPath forKey:@"file"];
    
    [self.request startAsynchronous];
    [self showWithStatus:nil];
}



#pragma mark - ChatCellDelegate   播放音频
#pragma mark -
- (void)cellClicked:(ChatCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    Packet* pk=[self.messages objectAtIndex:indexPath.row];
    if (pk.message.body.hasAudiouri) {
        NSString *urlStr = pk.message.body.audiouri;
        
        NSArray *array = [urlStr componentsSeparatedByString:@"&&"];
        if ([array count]==2) {
            urlStr= [FileDownload download:[NSString stringWithFormat:@"http://nmapi.%@%@",aedudomain,[array objectAtIndex:0]]];
        }
        
        
        
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setCategory:AVAudioSessionCategoryPlayback error:nil];
        [session setActive:YES error:nil];
        NSURL *url = [NSURL URLWithString:urlStr];
        if ([self.avPlayer isPlaying]) {
            [self.avPlayer stop];
            cell.isAudioPlaying = NO;
            self.avPlayer=nil;
        }else{
            NSError *playerError;
            self.avPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&playerError];
            self.avPlayer.delegate=self;
            if (self.avPlayer) {
                [self.avPlayer setVolume:1];
                NSLog(@"%f",self.avPlayer.duration);
                cell.isAudioPlaying = YES;
                [self.avPlayer prepareToPlay];
                [self.avPlayer play];
                
            }else if (self.avPlayer == NULL)
            {
                [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"播放语音失败"];
                cell.isAudioPlaying = NO;
                return;
            }
        }
    }
}
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    [self playToEnd];
}
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error{
    [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"播放语音失败"];
    [self playToEnd];
}

- (void)playToEnd
{
    [self.tableView reloadData];
}

#pragma mark - upload file delegate
#pragma mark-
- (void)uploadFailed:(ASIHTTPRequest *)theRequest
{
    [self dismiss];
    [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"发送失败"];
    
    //	[resultView setText:[NSString stringWithFormat:@"Request failed:\r\n%@",[[theRequest error] localizedDescription]]];
}

//0:png  1:voice 2:other
- (void)uploadPicFinished:(ASIHTTPRequest *)theRequest
{
    [self uploadFinished:theRequest withType:0];
}

- (void)uploadVoiceFinished:(ASIHTTPRequest *)theRequest
{
    [self uploadFinished:theRequest withType:1];
}

- (void)uploadFinished:(ASIHTTPRequest *)theRequest withType:(int)type
{
    [self dismiss];
    
    NSData *deData = theRequest.responseData;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:deData
                                                         options:kNilOptions
                                                           error:nil];
    
    int result = [(NSNumber*)[dict objectForKey:@"result"] intValue];
    if (result == 0) {
        
        
        PacketBuilder* packetPacketBuilder =[Packet builder];
        
        [packetPacketBuilder setFrom:[RRTManager manager].loginManager.loginInfo.userId];
        [packetPacketBuilder setTo:self.UserId];
        
        MessagePacketBuilder* messagePacketBuilder=[MessagePacket builder];
        [messagePacketBuilder setGuid:[UUID uuid]];
        [messagePacketBuilder setState:0];
        if (self.groupType) {
            [messagePacketBuilder setType:MessageTypeGroupChat];
        }else{
            [messagePacketBuilder setType:MessageTypeChat];
        }
        
        
        MessageBodyBuilder* messageBodyBuilder=[MessageBody builder];
        if (type==0) {
            [messageBodyBuilder setType:MessageContentTypePicture];
            [messageBodyBuilder setPictureuri:[[dict objectForKey:@"msg"]objectForKey:@"filePath"]];
        }else if (type==1){
            [messageBodyBuilder setType:MessageContentTypeAudio];
            [messageBodyBuilder setAudiouri:[NSString stringWithFormat:@"%@&&%i",[[dict objectForKey:@"msg"] objectForKey:@"filePath"],[[[dict objectForKey:@"msg"] objectForKey:@"playTime"] intValue]]];
        }
        [messageBodyBuilder setSender:[RRTManager manager].loginManager.loginInfo.userName];
        [messageBodyBuilder setReceiver:self.UserName];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
        [messageBodyBuilder setSendtime:currentDateStr];
        if (self.groupType) {
            [messageBodyBuilder setGroupid:self.UserId];
            [messageBodyBuilder setGroupname:self.UserName];
            [messageBodyBuilder setGrouptype:[NSString stringWithFormat:@"%d",self.groupType]];
        }
        [messagePacketBuilder setBodyBuilder:messageBodyBuilder];
        
        [packetPacketBuilder setMessageBuilder:messagePacketBuilder];
        
        Packet* msg =[packetPacketBuilder build];
        Connection * connection=[Connection shareConnection];
        if (connection.isLogin&&connection.connectionopen) {
            if (!self.groupType) {
                [[IMCache shareIMCache] savePacket:msg sessionid:self.UserId];
            }
            [connection sendMessage:msg];
        }else{
            [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"发送失败，未连接到消息服务器"];
        }
        [self updateData];
    } else {
        [self uploadFailed:theRequest];
    }
}

#pragma mark - Tap Gesture
#pragma mark -
- (void)didTappedBackground:(UIGestureRecognizer*)ges
{
    [self.view endEditing:YES];
    [self showFaceBoard:NO];
    [self showMoreMenuBoard:NO];
}


-(MLEmojiLabel*)createLableWithText:(NSString*)text font:(UIFont*)font  width:(int)width{
    MLEmojiLabel*_emojiLabel = [[MLEmojiLabel alloc]init];
    _emojiLabel.numberOfLines = 0;
    _emojiLabel.font = font;
    _emojiLabel.emojiDelegate = self;
    _emojiLabel.lineBreakMode = NSLineBreakByCharWrapping;
    [_emojiLabel setEmojiText:text];
    _emojiLabel.frame = CGRectMake(0, 0, width, 0);
    [_emojiLabel sizeToFit];
    return _emojiLabel;
}

#pragma mark emjodelegate

- (void)mlEmojiLabel:(MLEmojiLabel*)emojiLabel didSelectLink:(NSString*)link withType:(MLEmojiLabelLinkType)type
{
    switch(type)
    {
        case MLEmojiLabelLinkTypeUser:
        {
            NSLog(@"点击了用户:%@",link);
            NSLog(@"用户id为:%d",[MLEmojiLabel getUserid:link]);
            
            NSLog(@"index为:%d",[MLEmojiLabel getIndex:link]);
            NSLog(@"CommentIndex为:%d",[MLEmojiLabel getCommentID:link]);
        }
            
            break;
        case MLEmojiLabelLinkTypeURL:
            NSLog(@"点击了链接:%@",link);
            break;
        case MLEmojiLabelLinkTypePhoneNumber:
            NSLog(@"点击了电话:%@",link);
            break;
        case MLEmojiLabelLinkTypeEmail:
            NSLog(@"点击了邮箱:%@",link);
            break;
        case MLEmojiLabelLinkTypeAt:
            NSLog(@"点击了用户%@",link);
            break;
        case MLEmojiLabelLinkTypePoundSign:
            NSLog(@"点击了话题%@",link);
            break;
        default:
            NSLog(@"点击了不知道啥:%@",link);
            break;
    }
    
}

@end
