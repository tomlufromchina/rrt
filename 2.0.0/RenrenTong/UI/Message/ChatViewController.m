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

#define Toolbar_Height  44
#define TextView_Height 33

@interface ChatViewController () <UITableViewDataSource,
                                    UITableViewDelegate,
                                    UITextViewDelegate,
                                    AVAudioRecorderDelegate,
                                    MoreMenuBoardDelegate,
                                    QBImagePickerControllerDelegate,
                                    UINavigationControllerDelegate,
                                    UIImagePickerControllerDelegate,
                                    ChatCellDelegate>

@property (nonatomic, strong) NSMutableArray *messages;

@property (nonatomic, strong) FaceBoard *faceBoard;
@property (nonatomic, strong) MoreMenuBoard *moreMenuBoard;

@property(nonatomic, strong)NSMutableDictionary *recordSettings;
@property(nonatomic, strong)AVAudioRecorder *audioRecorder;
@property(nonatomic, strong)NSTimer *timer;
@property(nonatomic, strong)NSString *voiceUrl;
@property(nonatomic, assign)int voiceDuration;

@property(nonatomic, strong)ASIFormDataRequest *request;

@property(nonatomic, strong)AVPlayer *avPlayer;
@property(nonatomic, strong)AVPlayerItem *avPlayerItem;

//保存当前正在播放的音频Cell中的message，之所以不保存cell，因为可能滑出去被销毁重用等。但是message对象不会被销毁。
//text chat,image,vedio都不会用到该对象
@property(nonatomic, strong)XMPPMessageArchiving_Message_CoreDataObject *curPlayingMessage;

@end

@implementation ChatViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //title
    Contact *contact = [DataManager contactForId:self.toStr];
    if (contact) {
        self.title = contact.name;
    } else {
        self.title = self.toStr;
    }
    
    //ui
    [self.tableView registerNib:[UINib nibWithNibName:@"ChatCell" bundle:nil]
         forCellReuseIdentifier:@"ChatCell"];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.allowsSelection = NO;
    self.textField.delegate = self;
    self.textField.layer.borderColor = [UIColor colorWithRed:150.0/255
                                                       green:150.0/255
                                                        blue:150.0/255
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
    
    //register avplayer note
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playToEnd)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playToEnd)
                                                 name:AVPlayerItemFailedToPlayToEndTimeNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playToEnd)
                                                 name:AVPlayerItemFailedToPlayToEndTimeErrorKey
                                               object:nil];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]
                                          initWithTarget:self
                                          action:@selector(didTappedBackground:)];
    tapGesture.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:tapGesture];
}

- (void)viewDidAppear:(BOOL)animated
{
    self.hidesBottomBarWhenPushed = YES;
    
    IMManager *imManager = [RRTManager manager].imManager;
    imManager.chatDelegate = self;
    
    [self updateData:imManager];
}

- (void)viewWillDisappear:(BOOL)animated
{
    //self.hidesBottomBarWhenPushed = NO;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemFailedToPlayToEndTimeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemFailedToPlayToEndTimeErrorKey object:nil];
    
    [self.request setDelegate:nil];
	[self.request setUploadProgressDelegate:nil];
	[self.request cancel];
    
    [self dismiss];
    
    
    if (self.avPlayer) {
        [self.avPlayer pause];
    }
}

- (void)updateData:(IMManager*)imManager
{
    NSManagedObjectContext *context = [imManager.xmppMessageArchivingStorage
                                       mainThreadManagedObjectContext];
    
    NSEntityDescription *entity = [imManager.xmppMessageArchivingStorage messageEntity:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
    @"(bareJidStr CONTAINS[cd] %@ && streamBareJidStr CONTAINS[cd] %@)",
                              [[RRTManager manager].imManager jidStrFromUserId:self.toStr],
                              [[RRTManager manager].imManager jidStrFromUserId:[RRTManager manager].imManager.userId]];

    [request setPredicate:predicate];
    
    NSArray *array = [context executeFetchRequest:request error:nil];
    
    [self.messages removeAllObjects];
    [self.messages addObjectsFromArray:array];
    
    for (int i = [self.messages count] - 1; i >= 0; i--) {
        XMPPMessageArchiving_Message_CoreDataObject *message =
        (XMPPMessageArchiving_Message_CoreDataObject*)[self.messages objectAtIndex:i];

        if ([message.bRead boolValue] == NO) {
            message.bRead = [NSNumber numberWithBool:YES];
        } else {
//            break;
        }

        if (!message.message.subject ) {
            message.match = nil;
            [message setMatch];
        }
        
    }
    
    if ([context hasChanges]) {
        [context save:nil];
    }
    
    [self.tableView reloadData];
    
    CGSize size = self.tableView.contentSize;
    if (size.height > self.tableView.frame.size.height) {
        [self.tableView setContentOffset:CGPointMake(0, size.height - self.tableView.frame.size.height)
                                animated:YES];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChatCell"
                                                            forIndexPath:indexPath];
    
    
    ChatCell *chatCell = (ChatCell*)cell;
    
    chatCell.delegate = self;
    
    //是否显示时间 间隔1分钟之内不显示
    if (indexPath.row >= 1) {
//        XMPPMessageArchiving_Message_CoreDataObject *curMessage = [self.messages objectAtIndex:indexPath.row];
//        XMPPMessageArchiving_Message_CoreDataObject *preMessage = [self.messages objectAtIndex:indexPath.row - 1];
//        if (curMessage.timestamp.timeIntervalSince1970 - preMessage.timestamp.timeIntervalSince1970 > 60) {
//            chatCell.bShowTime = YES;
//        } else {
//            chatCell.bShowTime = NO;
//        }
        chatCell.bShowTime = YES;
    } else {
        chatCell.bShowTime = YES;
    }
    
    
    [chatCell setChatCell:[self.messages objectAtIndex:indexPath.row]];
    
    if (self.curPlayingMessage) {
        if (self.curPlayingMessage.objectID == chatCell.xmppMessage.objectID) {
            chatCell.isAudioPlaying = YES;
        } else {
            chatCell.isAudioPlaying = NO;
        }
    }
    
    
    return chatCell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [ChatCell height:[self.messages objectAtIndex:indexPath.row]];
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
        [[RRTManager manager].imManager sendMessage:textView.text
                                                 to:self.toStr
                                        withSubject:nil
                                       withNickName:self.title];
        
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
    //change the text view's height
    CGFloat fixedWidth = textView.frame.size.width;
    CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    NSLog(@"The height is:%f", newSize.height);
    
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

#pragma mark - record events
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
    
    [self.recordBoard setHidden:NO];
    [self.recordCancelImgView setHidden:YES];
    [self.recordMicImgView setHidden:NO];
    self.recordLabel.text = @"手指上滑,取消发送";
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
    [self.speekBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.speekBtn setTitle:@"按住说话" forState:UIControlStateNormal];
    
    [self.timer invalidate];
    if (self.audioRecorder && [self.audioRecorder isRecording]) {
        
        self.voiceDuration = (int)self.audioRecorder.currentTime;
        
        [self.audioRecorder stop];
        
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
        
        if (self.voiceDuration <= 1) {
            [self showWithTitle:@"说话时间太短" withTime:1.0f];
            return;
        }

        [self showWithStatus:nil];
        //1. upload the file to http servce
        [self.request cancel];
        [self setRequest:[ASIFormDataRequest requestWithURL:
                          [NSURL URLWithString:@"http://nmapi.aedu.cn/MobilePush/PostMessageFileForSJ"]]];
        [self.request setPostValue:[RRTManager manager].loginManager.loginInfo.tokenId forKey:@"token"];
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
    [self updateData:[RRTManager manager].imManager];
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
            [self showWithTitle:@"该设备不支持拍照" withTime:1.0f];
        } else {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = sourceType;
            [self presentViewController:picker animated:YES completion:NULL];
        }
    } else {
        [self showWithTitle:@"该功能暂不支持" withTime:1.0f];
    }
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
    
    //send image
    //1. upload the file to http servce
    [self.request cancel];
    [self setRequest:[ASIFormDataRequest requestWithURL:
                      [NSURL URLWithString:@"http://nmapi.aedu.cn/MobilePush/PostMessageFileForSJ"]]];
    [self.request setPostValue:[RRTManager manager].loginManager.loginInfo.tokenId forKey:@"token"];
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
    
    
    
    
    
    //send image
    
    //1. upload the file to http servce
    [self.request cancel];
    [self setRequest:[ASIFormDataRequest requestWithURL:
                      [NSURL URLWithString:@"http://nmapi.aedu.cn/MobilePush/PostMessageFileForSJ"]]];
    [self.request setPostValue:[RRTManager manager].loginManager.loginInfo.tokenId forKey:@"token"];
    [self.request setTimeOutSeconds:20];
    [self.request setDelegate:self];
    [self.request setDidFailSelector:@selector(uploadFailed:)];
    [self.request setDidFinishSelector:@selector(uploadPicFinished:)];
    
    [self.request setFile:imgPath forKey:@"file"];
    
    [self.request startAsynchronous];
    [self showWithStatus:nil];
}

#pragma mark - ChatCellDelegate
#pragma mark -
- (void)cellClicked:(ChatCell *)cell
{
    XMPPMessageArchiving_Message_CoreDataObject *message = cell.xmppMessage;
    
    if ([message.message.subject isEqualToString:Message_Subject_Voice]) {
        NSString *urlStr = [cell urlForVoice];
        
        if (self.avPlayer && self.avPlayer.rate > 0.0f) {
            [self.avPlayer pause];
            
            //如果点击的是另外一个cell，重新播放新的cell
            if (self.curPlayingMessage.objectID != message.objectID) {
                NSURL *url = [NSURL URLWithString:urlStr];
                
                if (url) {
                    self.avPlayerItem = [AVPlayerItem playerItemWithURL:url];
                    self.avPlayer = [[AVPlayer alloc] initWithPlayerItem:self.avPlayerItem];
                    if (self.avPlayer) {
                        [self.avPlayer play];
                        
                        cell.isAudioPlaying = YES;
                        self.curPlayingMessage = message;
                    }
                }
                
                //停止当前在播放的那个cell的动画，如何找到当前的那个cell，可以刷新一下界面
                [self.tableView reloadData];
            } else {
                //点击的是自己，停止动画
                self.curPlayingMessage = nil;
                cell.isAudioPlaying = NO;
            }
            
        } else {
            NSURL *url = [NSURL URLWithString:urlStr];
            
            if (url) {
                self.avPlayerItem = [AVPlayerItem playerItemWithURL:url];
                self.avPlayer = [[AVPlayer alloc] initWithPlayerItem:self.avPlayerItem];
                if (self.avPlayer) {
                    [self.avPlayer play];
                    
                    cell.isAudioPlaying = YES;
                    self.curPlayingMessage = message;
                }
            }
        }
    }
}

- (void)playToEnd
{
    NSLog(@"播放停止：失败或者播放完毕或者点击停止");
    self.curPlayingMessage = nil;
    //停止当前在播放的那个cell的动画，如何找到当前的那个cell，可以刷新一下界面
    [self.tableView reloadData];
}

#pragma mark - upload file delegate
#pragma mark-
- (void)uploadFailed:(ASIHTTPRequest *)theRequest
{
    [self dismiss];
    [self showWithTitle:@"发送失败" withTime:2.0f];
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
    if (result == 1) {
        NSString *url = [NSString stringWithFormat:@"http://nmapi.aedu.cn%@",
                         (NSString*)[dict objectForKey:@"messageId"]];
        
        NSString *subject = type == 0 ? Message_Subject_Pic : Message_Subject_Voice;
        
        NSString *sendUrl = type == 0 ? url : [NSString stringWithFormat:@"%@&&%d", url, self.voiceDuration];
        
        
        [[RRTManager manager].imManager sendMessage:sendUrl
                                                 to:self.toStr
                                        withSubject:subject
                                       withNickName:self.title];
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

@end
