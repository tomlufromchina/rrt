//
//  CommunicationTeacherViewController.m
//  RenrenTong
//
//  Created by 符其彬 on 15/1/29.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "CommunicationTeacherViewController.h"
#import "SelectClassController.h"
#import "SelectGropViewController.h"
#import "SelectTeacherViewController.h"
#import "HighlLevelSettingViewController.h"
#import "CommunicationPicDetailsViewController.h"
#import "TheSendRecordViewController.h"
#import "CommunicationTeacherCell.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#import "PhotoUITapGestureRecognizer.h"
#import "QBImagePickerController.h"
#import "LCVoice.h"
#import "UIImage+Addition.h"
#import "ASIFormDataRequest.h"
#import "ClassList.h"
#import "StudentList.h"
#import "GrouperList.h"
#import "GroupList.h"
#import "TeacherList.h"
#import "PermissionList.h"
#import "MJExtension.h"

#define AccPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"%@.aac"]

#define isiPhone4               ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? \
CGSizeEqualToSize(CGSizeMake(640, 960), \
[[UIScreen mainScreen] currentMode].size) : \
NO)

@interface CommunicationTeacherViewController ()<UIActionSheetDelegate,UITextViewDelegate,QBImagePickerControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,SelectClassControllerDelegate,SelectTeacherViewControllerDelegate,SelectGropViewControllerDelegate,CommunicationPicDetailsViewControllerDelegate,TheSendRecordViewControllerDelegate,AVAudioRecorderDelegate,AVAudioPlayerDelegate>

{
    UIView *_theFoortView;
    UIView *lineView;
    UIView *theRcordView;
    UIView *_theFoortView1;
    UIImageView *hookImageView;// 短信通知图片
    UILabel *msgTitle; // 短信通知
    UIButton *drwonButton;
    AVAudioPlayer *audioPlayer;
    UIImageView *picImageViews;
    UIView *picImageViewsBackGroupView;
    UIButton *againSendButton;
    UIButton *sendButton;
    NSString *ASIImageFilePathStr;
    
    UIActionSheet *addImageViewSheet;
    UIActionSheet *chooseObjectSheet;
    UILabel *settingLabel;
    UIImageView *settingImageView;
    UIView *basicView;
    BOOL isUp;
    BOOL isClick;
    BOOL isColor;
    
    NSMutableArray *localRecordArray;// 录音文件
    NSMutableArray *_theImages;
    NSString *numberStr;// 显示短信字数
    
    // 临时数组
    NSMutableArray *classIdArray;
    NSMutableArray *studentIdArray;
    NSMutableArray *groupIdArray;
    NSMutableArray *grouperIdArray;
    NSMutableArray *teacherIdArray;
    NSMutableArray *tempNameArray;
    NSString *theClassID;
    NSString *theGroupID;
    int tmpSend;
    NSMutableArray *thePicArray;
    NSString *recordStr;// 录音拼接后的字符串
    NSString *imageString;// 图片拼接后得字符串
    // 引用图片 录音 录音时间数组
    NSMutableArray *tempPicArray;
    NSMutableArray *tempAudioArray;
    NSMutableArray *tempAudioTime;
    int teacherOrStudentStates;
    
}
@property(nonatomic,retain) LCVoice *voice;// 录音对象
@property (nonatomic) NSMutableArray *images;// 图片数组
@property (nonatomic,strong) NSMutableArray *imagesUrls;// 图片路劲
@property (nonatomic,strong) NSMutableArray *permissionArray;// 权限数组
@property (nonatomic,strong) NSMutableArray *objectArray;// 发送对象数组
@property (nonatomic, strong) NetWorkManager *netWorkManager;
@property(nonatomic, strong)ASIFormDataRequest *request;

@property (nonatomic, assign) int isPublishToClassMaster;// 给班主任发送
@property (nonatomic, assign) int isSendName;// 姓名发送
@property (nonatomic, assign) int TheIsCampus;

// 重新弄录音
@property(nonatomic, strong)NSMutableDictionary *recordSettings;
@property(nonatomic, strong)AVAudioRecorder *audioRecorder;
@property(nonatomic, strong)NSTimer *timer;
@property(nonatomic, strong)NSString *voiceUrl;
@property(nonatomic, assign)int voiceDuration;
@property(nonatomic, strong)AVAudioPlayer *avPlayer;
@property(nonatomic,retain) NSTimer *sTimer;
@property(nonatomic, assign)int seconds;
// 点击播放录音变颜色和字体相关属性：
@property(nonatomic, assign)int playFlag;
@property(nonatomic, strong)NSMutableArray *audioButtons;
@property(nonatomic, strong)NSMutableArray *audioImages;
@property(nonatomic, strong)NSMutableArray *audioViews;

@end

@implementation CommunicationTeacherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发通知";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"发送记录"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(deleteMessages)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(quotationMessage:) name:@"quotationMessage" object:nil];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]
                                          initWithTarget:self
                                          action:@selector(didTappedBackground:)];
    tapGesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGesture];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    [self.navigationItem setBackBarButtonItem:backItem];
    
    self.images = [NSMutableArray array];
    thePicArray = [[NSMutableArray alloc] init];
    self.imagesUrls = [NSMutableArray array];
    _theImages = [[NSMutableArray alloc] init];
    self.voice = [[LCVoice alloc] init];
    localRecordArray = [[NSMutableArray alloc] init];
    tempNameArray = [[NSMutableArray alloc] init];
    self.netWorkManager = [[NetWorkManager alloc] init];
    self.permissionArray = [[NSMutableArray alloc] init];
    self.objectArray = [[NSMutableArray alloc] init];
    self.audioButtons = [NSMutableArray array];
    self.audioImages = [NSMutableArray array];
    self.audioViews =  [NSMutableArray array];
    self.playFlag = -1;
    self.ZYImageView.tag = 0;
    self.TZImageView.tag = 0;
    self.CJImageView.tag = 0;
    self.BXImageView.tag = 0;
    
    // 初始化其他控件：
    [self initView];
    // 获取本地数据
    [self getCurrentData];
    
    /*
     **录音设置：
     */
    self.recordSettings = [[NSMutableDictionary alloc] initWithCapacity:10];
    
    [_recordSettings setObject:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey: AVFormatIDKey];
    [_recordSettings setObject:[NSNumber numberWithFloat:8000.0] forKey: AVSampleRateKey];
    [_recordSettings setObject:[NSNumber numberWithInt:1] forKey:AVNumberOfChannelsKey];
    [_recordSettings setObject:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    [_recordSettings setObject:[NSNumber numberWithInt:AVAudioQualityMedium]
                        forKey: AVEncoderAudioQualityKey];
    
    [self getTeacherMsgPermission];
    [self limitMessageCount];
    
    _timer =  [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(changeColor) userInfo:nil repeats:YES];
    isColor = NO;
}

- (void)changeColor
{
    if (!isColor) {
        self.CursorView.backgroundColor = [UIColor whiteColor];
        isColor = YES;
    } else{
        self.CursorView.backgroundColor = theLoginButtonColor;
        isColor = NO;
    }
}

#pragma mark -- 短信字数限制

- (void)limitMessageCount
{
    // 限制短信数量
    
    [self.netWorkManager limitMessageCount:[RRTManager manager].loginManager.loginInfo.tokenId
                                    userId:[RRTManager manager].loginManager.loginInfo.userId
                                   success:^(NSString *data) {
                                       if (data) {
                                           numberStr = data;
                                           self.limiteNumberLabel.text = [NSString stringWithFormat:@"还可以输入%d个字",[numberStr intValue] - [self.mainTextView.text length]];
                                       }
                                   } failed:^(NSString *errorMSG) {
                                       [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:errorMSG];
                                       
                                   }];
}
#pragma mark -- 获取教师权限

- (void)getTeacherMsgPermission
{
    [self.netWorkManager getTeacherMsgPermission:[RRTManager manager].loginManager.loginInfo.tokenId
                                       teacherId:[RRTManager manager].loginManager.loginInfo.userId
                                         success:^(NSMutableArray *data) {
                                             self.permissionArray = (NSMutableArray *)[PermissionList objectArrayWithKeyValuesArray:data];
                                             NSMutableArray *array = [[NSMutableArray alloc]init];
                                             for (PermissionList *permissionList in self.permissionArray) {
                                                 if ([permissionList.FeatureId intValue] == 8002) {
                                                     permissionList.FeatureName = @"班级";
                                                     [array addObject:permissionList];
                                                 }
                                                 if ([permissionList.FeatureId intValue] == 8004) {
                                                     permissionList.FeatureName = @"教师";
                                                     [array addObject:permissionList];
                                                 }
                                                 if ([permissionList.FeatureId intValue] == 8005) {
                                                     permissionList.FeatureName = @"群组";
                                                     [array addObject:permissionList];
                                                 }
                                                 self.objectArray = array;
                                             }
                                         } failed:^(NSString *errorMSG) {
    
                                         }];
}

#pragma mark - 引用消息内容(通知回调)
- (void)quotationMessage:(NSNotification*)noti
{
    NSDictionary *dic = [noti userInfo];
    NSLog(@"%@",dic);
    if (dic) {
        // 内容
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"_theImageFiles"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"tmp_theRecord"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"_theRecordTime"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"myContent"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSString *context = [dic objectForKey:@"content"];
        if (context.length > [numberStr intValue]) {
            context = @"";
            self.mainTextView.text = context;
            self.waterMarkTitleLabel.hidden = NO;
            [self showImage:[UIImage imageNamed:@"confirm-err72"] status:@"引用文字超过字数限制"];
            self.limiteNumberLabel.text = [NSString stringWithFormat:@"还可以输入%d个字",[numberStr intValue] - [self.mainTextView.text length]];
        }
        else
        {
        self.mainTextView.text = [dic objectForKey:@"content"];
        self.limiteNumberLabel.text = [NSString stringWithFormat:@"还可以输入%d个字",[numberStr intValue] - [self.mainTextView.text length]];
        self.waterMarkTitleLabel.hidden = YES;
        }
        // 保存文字：
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:self.mainTextView.text forKey:@"myContent"];
        [userDefaults synchronize];
        // 图片
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"_theImageFiles"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        NSArray *picArry = [[dic objectForKey:@"pic"] componentsSeparatedByString:@"|"];
        tempPicArray = [[NSMutableArray alloc] init];
        if (picArry && [picArry count] > 0) {
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            // 保存图片文件到本地
            NSMutableArray *_theImageFiles = [[NSMutableArray arrayWithArray:[userDefaults objectForKey:@"_theImageFiles"]] mutableCopy];
            for (NSString *picStr in picArry) {
                if(![picStr isEqualToString:@""])
                {
                [tempPicArray addObject:picStr];
                [_theImageFiles addObject:picStr];
                }

            }
            [userDefaults setObject:_theImageFiles forKey:@"_theImageFiles"];
            [userDefaults synchronize];
            [self showImages:tempPicArray];
        }
        // 录音
        NSArray *audioArray = [[dic objectForKey:@"audio"] componentsSeparatedByString:@"|"];
        tempAudioArray = [[NSMutableArray alloc] init];
        tempAudioTime = [[NSMutableArray alloc] init];
        if (audioArray && [audioArray count] > 0) {
            for (int i = 0; i < audioArray.count; i ++) {
                NSString *audioStr = audioArray[i];
                NSRange range = [audioStr rangeOfString:@"&&"];
                if(range.length != 0){
                    NSString *auStr = [audioStr substringToIndex:range.location];
                    [tempAudioArray addObject:auStr];
                    NSString *timeStr = [NSString stringWithFormat:@"%@",[audioStr substringFromIndex:(range.location + range.length)]];
                    [tempAudioTime addObject:timeStr];
                    
                    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                    // 保存录音时间到本地
                    NSMutableArray *_theRecordTime = [[NSMutableArray arrayWithArray:[userDefaults objectForKey:@"_theRecordTime"]] mutableCopy];
                    [_theRecordTime addObject:timeStr];// 保存录音时间文件
                    [userDefaults setObject:_theRecordTime forKey:@"_theRecordTime"];
                    [userDefaults synchronize];
                    // 保存录音到本地
                    NSMutableArray *_theRecord = [[NSMutableArray arrayWithArray:[userDefaults objectForKey:@"tmp_theRecord"]] mutableCopy];
                    [_theRecord addObject:auStr];// 保存录音文件
                    [userDefaults setObject:_theRecord forKey:@"tmp_theRecord"];
                    [userDefaults synchronize];
                }
            }
            [self showRecordView:tempAudioArray recordTimeArray:tempAudioTime];
        }
    } else{
        [self showImage:[UIImage imageNamed:@""] status:@"引用失败"];
    }
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"quotationMessage" object:nil];
}

#pragma mark -- 取出本地数据

- (void)getCurrentData
{
    NSString * documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];

    NSArray *file = [[[NSFileManager alloc] init] subpathsAtPath:documentsDirectoryPath];
    NSLog(@"沙盒下所有的保存文件：%@",file);

    // 图片
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    NSString *filePath = [docDir stringByAppendingPathComponent:@"images"];
    NSMutableArray *array = [[NSMutableArray alloc]initWithContentsOfFile:filePath];
    NSMutableArray *tmpImagesArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [array count]; i ++) {
        [tmpImagesArray addObject:[UIImage imageWithData:array[i]]];// data转image
    }
    if (tmpImagesArray && [tmpImagesArray count]>0) {
        [self.images removeAllObjects];
        self.images = tmpImagesArray;
//        [self showImages:tmpImagesArray];
    }
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    // 图片路径
    
//    NSMutableArray *_theImagesPaths = [[NSMutableArray arrayWithArray:[userDefaults objectForKey:@"_theImagesPaths"]] mutableCopy];
    
    NSMutableArray *_theImageFiles = [[NSMutableArray arrayWithArray:[userDefaults objectForKey:@"_theImageFiles"]] mutableCopy];
    [self showImages:_theImageFiles];
    // 录音：
    NSMutableArray *theRecord = [[NSMutableArray arrayWithArray:[userDefaults objectForKey:@"tmp_theRecord"]] mutableCopy];
    // 录音时间：
    NSMutableArray *theRecordTime = [[NSMutableArray arrayWithArray:[userDefaults objectForKey:@"_theRecordTime"]] mutableCopy];

    NSString *myContentText = [userDefaults stringForKey:@"myContent"];
    if ((theRecord && [theRecord count] > 0) || myContentText != nil) {
        [self showRecordView:theRecord recordTimeArray:theRecordTime];
        self.mainTextView.text = myContentText;
        [self.waterMarkTitleLabel setHidden:(self.mainTextView.text.length == 0) ? NO : YES];
    }
}

#pragma mark -- 显示所有录音方法

- (void)showRecordView:(NSMutableArray *)recordArray recordTimeArray:(NSMutableArray *)recordTimeArray
{
    [localRecordArray removeAllObjects];
    [self.audioButtons removeAllObjects];
    [self.audioImages removeAllObjects];
    [self.audioViews removeAllObjects];
    
    if (recordArray && [recordArray count] > 0) {
        [localRecordArray addObjectsFromArray:recordArray];
        CGFloat width = 290;
        CGFloat height = 44;
        CGFloat margin = 10;
        CGFloat startY = 0;
        // 移除录音
        for (UIView *subView in [self.theRecoedBackGroupView subviews]) {
            if ([subView isKindOfClass:[UIView class]]) {
                [subView removeFromSuperview];
            }
        }
        for (int i = 0; i < [recordArray count]; i ++) {
            UIView *View = [[UIView alloc] init];
            View.backgroundColor = theLoginButtonColor;
            View.layer.cornerRadius = 2.0f;
            [self.theRecoedBackGroupView addSubview:View];
            [self.audioViews addObject:View];
            // 计算位置
            int row = i/1;
            CGFloat y = startY + row * (height + margin) + 27;
            View.frame = CGRectMake(7, y, width, height);
            View.tag = i;
            View.userInteractionEnabled = YES;
            
            UIButton *bofangButton = [UIButton buttonWithType:UIButtonTypeCustom];
            bofangButton.frame = CGRectMake(15, 12, 150, 21);
            [bofangButton setTitle:@"点击播放录音" forState:UIControlStateNormal];
            [bofangButton setTitleColor:[UIColor lightTextColor]forState:UIControlStateNormal];
            [bofangButton addTarget:self action:@selector(clickRecord:) forControlEvents:UIControlEventTouchUpInside];
            bofangButton.tag = i;
            [View addSubview:bofangButton];
            [self.audioButtons addObject:bofangButton];

            UIImageView *boFangImage = [[UIImageView alloc] init];
            boFangImage.frame = CGRectMake(8, 12, 16, 19);
            [boFangImage setImage:[UIImage imageNamed:@"bofang"]];
            [View addSubview:boFangImage];
            [self.audioImages addObject:boFangImage];

            UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
            deleteButton.frame = CGRectMake(250, 8, 30, 30);
            [deleteButton addTarget:self action:@selector(clickDeleteButton:) forControlEvents:UIControlEventTouchUpInside];
            [deleteButton setImage:[UIImage imageNamed:@"msgdel"] forState:UIControlStateNormal];
            deleteButton.tag = i;
            
            UILabel *recordTime = [[UILabel alloc] init];
            recordTime.frame = CGRectMake(deleteButton.left - 50, 12, 50, 21);
            recordTime.text = [NSString stringWithFormat:@"%@\"",[recordTimeArray objectAtIndex:i]];
            recordTime.textColor = [UIColor whiteColor];
            [View addSubview:recordTime];
            NSLog(@"%f",self.voice.recordTime);
            self.theRecoedBackGroupView.frame = CGRectMake(8, 92, 304, y + 50);
            [View addSubview:deleteButton];
        }
        //
        self.addImageView.top = self.theRecoedBackGroupView.height + 92;
        if (isiPhone4) {
            if (localRecordArray && [localRecordArray count] > 0) {
                self.addImageView.top = self.theRecoedBackGroupView.height + 92;
                self.mainScrollView.contentSize = CGSizeMake(0, self.mainTextView.height + self.theRecoedBackGroupView.height + 200 + self.addImageView.height + 25);
                
                
            } else{
                self.mainScrollView.contentSize = CGSizeMake(0, self.mainTextView.height + 300 + self.addImageView.height);
                
            }
        } else{
            if (localRecordArray && [localRecordArray count] > 0) {
                self.addImageView.top = self.theRecoedBackGroupView.height + 92;
                self.mainScrollView.contentSize = CGSizeMake(0, self.mainTextView.height + self.theRecoedBackGroupView.height + 150 + self.addImageView.height + 20);
                
            } else{
                self.mainScrollView.contentSize = CGSizeMake(0, self.mainTextView.height + 150 + self.addImageView.height);
            }
        }
    } else if ([recordArray count] == 0){
        for (UIView *subView in [self.theRecoedBackGroupView subviews]) {
            if ([subView isKindOfClass:[UIView class]]) {
                [subView removeFromSuperview];
            }
        }
    }
}

#pragma mark -- 点击播放录音

- (void)clickRecord:(UIButton *)sender
{
    if (localRecordArray && [localRecordArray count] > 0) {
        
        NSString* urlstr=[FileDownload download:[NSString stringWithFormat:@"http://nmapi.%@%@",aedudomain,[localRecordArray objectAtIndex:sender.tag]]];
        NSLog(@"---%@",urlstr);
        NSLog(@"%@",[localRecordArray objectAtIndex:sender.tag]);
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setCategory:AVAudioSessionCategoryPlayback error:nil];
        [session setActive:YES error:nil];
        NSURL *url = [NSURL URLWithString:urlstr];
//        if (audioPlayer) {
//            [audioPlayer stop];
//            audioPlayer=nil;
//        }
//        NSError *playerError;
//        audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&playerError];
//        audioPlayer.delegate = self;
//        if (audioPlayer) {
//            [audioPlayer setVolume:1];
//            NSLog(@"%f",audioPlayer.duration);
//            [audioPlayer prepareToPlay];
//            [audioPlayer play];
//        }else if (audioPlayer == NULL)
//        {
//            [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"播放语音失败"];
//            return;
//        }
//    }
        if ([audioPlayer isPlaying] && self.playFlag == sender.tag) {
            [audioPlayer stop];
            audioPlayer=nil;
            [self.audioViews[sender.tag] setBackgroundColor:theLoginButtonColor];
            [self.audioImages[sender.tag] setImage:[UIImage imageNamed:@"bofang"]];
            [sender setTitle:@"点击播放语音" forState:UIControlStateNormal];
        }else{
            if (self.playFlag != -1) {
                for (int i = 0; i < self.audioButtons.count; i++) {
                    if (i == self.playFlag) {
                        UIButton *btn = self.audioButtons[i];
                        [self.audioViews[self.playFlag] setBackgroundColor:theLoginButtonColor];
                        [self.audioImages[self.playFlag] setImage:[UIImage imageNamed:@"bofang"]];
                        [btn setTitle:@"点击播放语音" forState:UIControlStateNormal];
                        break;
                    }
                }
            }
            self.playFlag = sender.tag;
            NSError *playerError;
            audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&playerError];
            audioPlayer.delegate = self;
            if (audioPlayer) {
                [audioPlayer setVolume:1];
                [audioPlayer prepareToPlay];
                [audioPlayer play];
                
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
                [UIView setAnimationDelegate:self];
                [UIView setAnimationDuration:0.3];
                [self.audioViews[sender.tag] setBackgroundColor:[UIColor colorWithRed:255.0/255 green:170.0/255 blue:23.0/255 alpha:1]];
                [UIView commitAnimations];
                
                [self.audioImages[sender.tag] setImage:[UIImage imageNamed:@"baofangluyin"]];
                [sender setTitle:@"正在播放语音..." forState:UIControlStateNormal];
            }else if (audioPlayer == NULL)
            {
                [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"播放语音失败"];
                return;
            }
        }
    }
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    for (int i = 0; i < self.audioButtons.count; i++) {
        if (i == self.playFlag) {
            UIButton *btn = self.audioButtons[i];
            [self.audioViews[i] setBackgroundColor:theLoginButtonColor];
            [self.audioImages[i] setImage:[UIImage imageNamed:@"bofang"]];
            [btn setTitle:@"点击播放语音" forState:UIControlStateNormal];
            break;
        }
    }
}
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error{
    [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"播放语音失败"];
}

#pragma mark -- 删除本地录音按钮响应（包含本地录音时间）

- (void)clickDeleteButton:(UIButton *)sender
{
    // 录音文件
    NSUserDefaults *tmpUserDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *tmplocalRecordArray = [[NSMutableArray arrayWithArray:[tmpUserDefaults objectForKey:@"tmp_theRecord"]] mutableCopy];
    // 录音时间
    NSMutableArray *tmplocalRecordTimeArray = [[NSMutableArray arrayWithArray:[tmpUserDefaults objectForKey:@"_theRecordTime"]] mutableCopy];
    if ((tmplocalRecordArray && [tmplocalRecordArray count] > 0 && tmplocalRecordTimeArray && [tmplocalRecordTimeArray count] > 0) || [tempAudioArray count] > 0) {
        [tempAudioArray removeObjectAtIndex:sender.tag];
        [tmplocalRecordArray removeObjectAtIndex:sender.tag];
        [tmplocalRecordTimeArray removeObjectAtIndex:sender.tag];
        [tmpUserDefaults setObject:tmplocalRecordTimeArray forKey:@"_theRecordTime"];
        [tmpUserDefaults setObject:tmplocalRecordArray forKey:@"tmp_theRecord"];
        [tmpUserDefaults synchronize];
        [audioPlayer stop];
        // 重新展示录音到UI界面：
        [self showRecordView:tmplocalRecordArray recordTimeArray:tmplocalRecordTimeArray];
    }
    
}

#pragma mark -- 初始化其他控件

- (void)initView
{
    // 录音背景
    self.recordBackGroupView.backgroundColor = [UIColor colorWithRed:50/255.0f
                                                               green:39/255.0f
                                                                blue:65/255.0f
                                                               alpha:0.4];
    // textview
    self.mainTextView.font = [UIFont systemFontOfSize:17.0f];
    self.mainTextView.delegate = self;
    self.mainTextView.tintColor = theLoginButtonColor;
    self.mainTextView.returnKeyType = UIReturnKeyDone;
    self.limiteNumberLabel.textColor = [UIColor grayColor];
    
    self.mainScrollView.contentOffset = CGPointMake(0, 0);
    self.mainScrollView.showsVerticalScrollIndicator = FALSE;
    self.mainScrollView.showsHorizontalScrollIndicator = NO;

    lineView = [[UIView alloc] init];
    lineView.top = SCREENHEIGHT - 65 - 50;
    lineView.height = 1;
    lineView.left = 0;
    lineView.width = SCREENWIDTH;
    lineView.backgroundColor = [UIColor colorWithRed:208/255.0f
                                               green:208/255.0f
                                                blue:208/255.0f
                                               alpha:0.5];
    [self.view addSubview:lineView];
    
    // 工具栏View
    _theFoortView = [[UIView alloc] init];
    _theFoortView.top = SCREENHEIGHT - 50 - 64;
    _theFoortView.height = 50;
    _theFoortView.left = 0;
    _theFoortView.width = SCREENWIDTH;
    _theFoortView.backgroundColor = [UIColor colorWithRed:242/255.0f
                                                    green:242/255.0f
                                                     blue:242/255.0f
                                                    alpha:1];
    [self.view addSubview:_theFoortView];
    
    UIImageView *CameraImageView = [[UIImageView alloc] init];
    CameraImageView.left = 7;
    CameraImageView.top = 5;
    CameraImageView.width = 40;
    CameraImageView.height = 37;
    [CameraImageView setImage:[UIImage imageNamed:@"camera"]];
    [_theFoortView addSubview:CameraImageView];
    
    // 相机图片按钮
    UIButton *cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cameraButton.left = 0;
    cameraButton.top = 0;
    cameraButton.width = 50;
    cameraButton.height = 50;
    [cameraButton addTarget:self action:@selector(clickCameraButton:) forControlEvents:UIControlEventTouchUpInside];
    [_theFoortView addSubview:cameraButton];
    
    UIImageView *recordImageView = [[UIImageView alloc] init];
    recordImageView.left = CameraImageView.right + 15;
    recordImageView.top = 5;
    recordImageView.width = 30;
    recordImageView.height = 37;
    [recordImageView setImage:[UIImage imageNamed:@"mic"]];
    [_theFoortView addSubview:recordImageView];
    
    //录音图片按钮
    UIButton *recordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    recordButton.left = CameraImageView.right;
    recordButton.top = 0;
    recordButton.width = 50;
    recordButton.height = 50;
    [recordButton addTarget:self action:@selector(clickRecordingButton:) forControlEvents:UIControlEventTouchUpInside];
    [_theFoortView addSubview:recordButton];

    drwonButton = [UIButton buttonWithType:UIButtonTypeCustom];
    drwonButton.left = recordButton.right + 46;
    drwonButton.top = 20;
    drwonButton.width = 29;
    drwonButton.height = 14;
    drwonButton.hidden = YES;
    [drwonButton setImage:[UIImage imageNamed:@"shrink"] forState:UIControlStateNormal];
    [drwonButton addTarget:self action:@selector(clickDrownButton:) forControlEvents:UIControlEventTouchUpInside];
    [_theFoortView addSubview:drwonButton];
    
    // 发送按钮
    sendButton = [UIButton  buttonWithType:UIButtonTypeCustom];
    sendButton.width = 90;
    sendButton.height = 40;
    sendButton.top = 5;
    sendButton.left = SCREENWIDTH - 100;
    [sendButton setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
    [sendButton setTitle:@"发送" forState:UIControlStateNormal];
    sendButton.layer.cornerRadius = 3;
    sendButton.titleLabel.font = [UIFont systemFontOfSize:18.0f];
    [sendButton setBackgroundColor:theLoginButtonColor];
    
    [sendButton addTarget:self action:@selector(clickSendButton:) forControlEvents:UIControlEventTouchUpInside];
    [_theFoortView addSubview:sendButton];
    
    basicView = [[UIView alloc] init];
    basicView.top = SCREENHEIGHT - 50 - 64 - 30;
    basicView.left = 0;
    basicView.width = SCREENWIDTH;
    basicView.height = 30;
    basicView.backgroundColor = [UIColor redColor];
//    [self.view addSubview:basicView];
    
    hookImageView = [[UIImageView alloc] init];
    hookImageView.top = SCREENHEIGHT - 50 - 64 - 30;
    hookImageView.left = 10;
    hookImageView.width = 21;
    hookImageView.height = 21;
    [hookImageView setImage:[UIImage imageNamed:@"check_un"]];
    hookImageView.hidden=YES;
    [self.view addSubview:hookImageView];
    
    msgTitle = [[UILabel alloc] init];
    msgTitle.left = hookImageView.right + 5;
    msgTitle.top = hookImageView.top - 5;
    msgTitle.width = 100;
    msgTitle.height = 30;
    msgTitle.text = @"短信通知";
    msgTitle.font = [UIFont systemFontOfSize:17.0f];
    msgTitle.textColor = [UIColor grayColor];
    msgTitle.hidden=YES;
    [self.view addSubview:msgTitle];
    
    UIButton *msgButton = [UIButton  buttonWithType:UIButtonTypeCustom];
    msgButton.width = hookImageView.width + msgTitle.width;
    msgButton.height = 30;
    msgButton.top = msgTitle.top;
    msgButton.left = 0;
    [msgButton setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
    [msgButton addTarget:self action:@selector(clickMsgButton:) forControlEvents:UIControlEventTouchUpInside];
    msgButton.hidden=YES;
    [self.view addSubview:msgButton];

    settingLabel = [[UILabel alloc] init];
    settingLabel.left = msgTitle.right + 100;
    settingLabel.top = hookImageView.top - 2;
    settingLabel.width = 100;
    settingLabel.height = 30;
    settingLabel.text = @"高级设置";
    settingLabel.font = [UIFont systemFontOfSize:17.0f];
    settingLabel.textColor = [UIColor grayColor];
    
    [self.view addSubview:settingLabel];
    
    settingImageView = [[UIImageView alloc] init];
    settingImageView.top = hookImageView.top + 2;
    settingImageView.left = msgTitle.right + 75;
    settingImageView.width = 21;
    settingImageView.height = 21;
    [settingImageView setImage:[UIImage imageNamed:@"setgj"]];
    [self.view addSubview:settingImageView];
    
    UIButton *settingButton = [UIButton  buttonWithType:UIButtonTypeCustom];
    settingButton.width = settingImageView.width + settingLabel.width;
    settingButton.height = 30;
    settingButton.top = msgTitle.top;
    settingButton.left = msgTitle.right + 60;
    [settingButton setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
    [settingButton addTarget:self action:@selector(clickSettingButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:settingButton];
    
    // 最底部的录音View
    _theFoortView1 = [[UIView alloc] init];
    _theFoortView1.top = SCREENHEIGHT;
    _theFoortView1.left = 0;
    _theFoortView1.width = SCREENWIDTH;
    _theFoortView1.height = 100;
    _theFoortView1.backgroundColor = [UIColor colorWithRed:242/255.0f green:242/255.0f blue:242/255.0f alpha:1];
    [self.view addSubview:_theFoortView1];

    // 开始录音按钮
    UIButton *noMessageIMG = [UIButton buttonWithType:UIButtonTypeCustom];
    noMessageIMG.left = 120;
    noMessageIMG.top = 0;
    noMessageIMG.width = 75;
    noMessageIMG.height = 75;
    [noMessageIMG setImage:[UIImage imageNamed:@"mic_up"] forState:UIControlStateNormal];
    [noMessageIMG setImage:[UIImage imageNamed:@"mic_down"] forState:UIControlStateSelected];

    [noMessageIMG addTarget:self action:@selector(recordStart) forControlEvents:UIControlEventTouchDown];
    [noMessageIMG addTarget:self action:@selector(recordEnd) forControlEvents:UIControlEventTouchUpInside];
    [noMessageIMG addTarget:self action:@selector(recordCancel) forControlEvents:UIControlEventTouchUpOutside];
    
    [_theFoortView1 addSubview:noMessageIMG];
    
    UILabel *label = [[UILabel alloc] init];
    label.left = 120;
    label.top = noMessageIMG.bottom - 3;
    label.width = 75;
    label.height = 30;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = theLoginButtonColor;
    label.text = @"按住录音";
    [_theFoortView1 addSubview:label];

}

#pragma mark -- record events   重新写得录音
#pragma mark -
- (void)reallyBeginToRecord
{
    // 取出本地录音
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *theRecord = [[NSMutableArray arrayWithArray:[userDefaults objectForKey:@"tmp_theRecord"]] mutableCopy];
    if ([theRecord count] <= 2) {
        NSDate *date = [NSDate date];
        NSTimeInterval name = [date timeIntervalSince1970];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString* cachesDirectory = [paths objectAtIndex:0];
        
        NSString *voicePath = [cachesDirectory stringByAppendingPathComponent:
                               [NSString stringWithFormat:CommunicationVoicePath]];
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
            self.seconds = 60;
            //创建一个定时器，这个是直接加到当前消息循环中，注意与其他初始化方法的区别
            _sTimer=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(changeTimeAtTimedisplay) userInfo:nil repeats:YES];

            
        }
        [self.recordBoard setHidden:NO];
        [self.recoedMicImgView setHidden:NO];
        [self.recordBackGroupView setHidden:NO];
        
        
    } else{
        [self showImage:[UIImage imageNamed:@""] status:@"最多可以录制三条语音"];
    }
}
- (void)changeTimeAtTimedisplay
{
    self.seconds--;
    if (self.seconds < 10 && self.seconds > 0) {
        self.limiteNumLabel.text = [NSString stringWithFormat:@"还可以录制%d秒",self.seconds];
    }
    if (self.seconds == 0) {
        [self recordEnd];
        
    }
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
        [self.recoedMicImgView setImage:[UIImage imageNamed:@"mic_1.png"]];
    } else if (pitch > 0.1 && pitch < 0.2) {
        [self.recoedMicImgView setImage:[UIImage imageNamed:@"mic_2.png"]];
    } else if (pitch > 0.2 && pitch < 0.3) {
        [self.recoedMicImgView setImage:[UIImage imageNamed:@"mic_3.png"]];
    } else if (pitch > 0.3 && pitch < 0.4) {
        [self.recoedMicImgView setImage:[UIImage imageNamed:@"mic_4.png"]];
    } else if (pitch > 0.4 && pitch < 0.5) {
        [self.recoedMicImgView setImage:[UIImage imageNamed:@"mic_5.png"]];
    } else if (pitch > 0.5) {
        [self.recoedMicImgView setImage:[UIImage imageNamed:@"mic_6.png"]];
    }
}

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    //do nothing
}

- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error
{
    [self recordCancel];
}

- (void)audioRecorderBeginInterruption:(AVAudioRecorder *)recorder
{
    [self recordCancel];
}

#pragma mark -- 开始录音

- (void)recordStart
{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
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

- (void)recordEnd
{
    [self.recordBoard setHidden:YES];
    [self.recordBackGroupView setHidden:YES];
    self.limiteNumLabel.text = @"说话即可录音";
    NSLog(@"结束录音。。。。");
    if (_sTimer) {
        if ([self.sTimer isValid]) {
            [self.sTimer invalidate];
            _sTimer = nil;
            
        }
    }
    
    [self.timer invalidate];
    if (self.audioRecorder && [self.audioRecorder isRecording]) {
        
        self.voiceDuration = (int)self.audioRecorder.currentTime;
        
        [self.audioRecorder stop];
        
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
        
        if (self.voiceDuration < 2.0f) {
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
        [self showWithStatus:@"正在上传录音..."];
        
        [UIView animateWithDuration:0.5f animations:^{
            hookImageView.top = SCREENHEIGHT - 50 - 90;
            msgTitle.top = SCREENHEIGHT - 50 - 64 - 30;
            settingLabel.top = SCREENHEIGHT - 50 - 64 - 30;
            settingImageView.top = SCREENHEIGHT - 50 - 64 - 25;
            _theFoortView.top = SCREENHEIGHT - 50 - 64;
            _theFoortView1.top = SCREENHEIGHT;
            lineView.top = SCREENHEIGHT - 65 - 50;
            drwonButton.hidden = YES;
            
        } completion:^(BOOL finished) {
            isUp = NO;
        }];
    }
}

- (void)recordCancel
{
    [self.recordBoard setHidden:YES];
    [self.recordBackGroupView setHidden:YES];

    NSLog(@"取消录音。。。。");
    
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

#pragma mark -- 发送记录

- (void)deleteMessages
{
    [self.navigationController pushViewController:HighLevelSetting
                                   withStoryBoard:DeskStoryBoardName
                                        withBlock:^(UIViewController *viewController) {
                                       
                                   }];
}

#pragma mark -- 短信通知

- (void)clickMsgButton:(UIButton *)sender
{
    if (!isClick) {
        msgTitle.textColor = theLoginButtonColor;
        [hookImageView setImage:[UIImage imageNamed:@"check_yes"]];
        isClick = YES;
        hookImageView.tag = 1;
    } else {
        msgTitle.textColor = [UIColor lightGrayColor];
        [hookImageView setImage:[UIImage imageNamed:@"check_un"]];
        isClick = NO;
        hookImageView.tag = 0;
    }

}

#pragma mark -- 高级设置
- (void)clickSettingButton:(UIButton *)sender
{
    [self.navigationController pushViewController:TheSendRecord
                                   withStoryBoard:DeskStoryBoardName
                                        withBlock:^(UIViewController *viewController) {
                                            TheSendRecordViewController *vc = (TheSendRecordViewController*)viewController;
                                            vc.delegate = self;
                                   }];
}

#pragma mark -- TheSendRecordViewControllerDelegate

- (void)clickTableViewCell:(int)isSendName WithIsPublishToClassMaster:(int)isPublishToClassMaster
{
    self.isSendName = isSendName;
    self.isPublishToClassMaster = isPublishToClassMaster;
}

#pragma mark -- 添加图片按钮响应

- (void)clickAddImageButton:(UIButton *)sender
{
    addImageViewSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                    delegate:self
                                           cancelButtonTitle:@"取消"
                                      destructiveButtonTitle:nil
                                           otherButtonTitles:@"从相册选取", @"拍照", nil];
    
    [addImageViewSheet showInView:self.view];
}

#pragma mark -- 添加图片按钮

- (IBAction)clickAddTheImageButton:(UIButton *)sender
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *_theImageFiles = [[NSMutableArray arrayWithArray:[userDefaults objectForKey:@"_theImageFiles"]] mutableCopy];
    if ([_theImageFiles count] >= 4) {
        [self showImage:[UIImage imageNamed:@""] status:@"最多只能添加四张相片"];
        
    } else{
        addImageViewSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                        delegate:self
                                               cancelButtonTitle:@"取消"
                                          destructiveButtonTitle:nil
                                               otherButtonTitles:@"从相册选取", @"拍照", nil];
        
        [addImageViewSheet showInView:self.view];
    }
}
#pragma mark -- 选择发送对象

- (IBAction)clickAddObjectsButton:(UIButton *)sender
{
    [self ChooseObject];
}

#pragma mark -- 选择发送对象

- (IBAction)clickChooseObjectButton:(UIButton *)sender
{
    [self ChooseObject];
}
- (void)ChooseObject
{
    if (self.objectArray.count > 0) {
        chooseObjectSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                        delegate:self
                                               cancelButtonTitle:nil
                                          destructiveButtonTitle:nil
                                               otherButtonTitles:nil];
        for (PermissionList *permissionList in self.objectArray) {
            [chooseObjectSheet addButtonWithTitle:permissionList.FeatureName];
        }
        [chooseObjectSheet addButtonWithTitle:@"取消"];
        chooseObjectSheet.cancelButtonIndex = chooseObjectSheet.numberOfButtons-1;
        [chooseObjectSheet showInView:self.view];
    }else
    {
        [self showImage:[UIImage imageNamed:@"confirm-err72"] status:@"没有发送权限"];
    }
}

#pragma mark -- 通知

- (IBAction)clickZBButon:(UIButton *)sender
{
    [self.ZYImageView setImage:[UIImage imageNamed:@"radio_yes"]];
    self.ZYImageView.tag = 1;
    [self.TZImageView setImage:[UIImage imageNamed:@"radio_un"]];
    self.TZImageView.tag = 0;
    [self.CJImageView setImage:[UIImage imageNamed:@"radio_un"]];
    self.CJImageView.tag = 0;
    [self.BXImageView setImage:[UIImage imageNamed:@"radio_un"]];
    self.BXImageView.tag = 0;
}

#pragma mark -- 作业

- (IBAction)clickTZButton:(UIButton *)sender
{
    [self.ZYImageView setImage:[UIImage imageNamed:@"radio_un"]];
    self.ZYImageView.tag = 0;
    [self.TZImageView setImage:[UIImage imageNamed:@"radio_yes"]];
    self.TZImageView.tag = 1;
    [self.CJImageView setImage:[UIImage imageNamed:@"radio_un"]];
    self.CJImageView.tag = 0;
    [self.BXImageView setImage:[UIImage imageNamed:@"radio_un"]];
    self.BXImageView.tag = 0;
}

#pragma mark -- 表现

- (IBAction)clickCJButton:(UIButton *)sender
{
    [self.ZYImageView setImage:[UIImage imageNamed:@"radio_un"]];
    self.ZYImageView.tag = 0;
    [self.TZImageView setImage:[UIImage imageNamed:@"radio_un"]];
    self.TZImageView.tag = 0;
    [self.CJImageView setImage:[UIImage imageNamed:@"radio_yes"]];
    self.CJImageView.tag = 1;
    [self.BXImageView setImage:[UIImage imageNamed:@"radio_un"]];
    self.BXImageView.tag = 0;
}

#pragma mark -- 祝福

- (IBAction)clickBXButton:(UIButton *)sender
{
    [self.ZYImageView setImage:[UIImage imageNamed:@"radio_un"]];
    self.ZYImageView.tag = 0;
    [self.TZImageView setImage:[UIImage imageNamed:@"radio_un"]];
    self.TZImageView.tag = 0;
    [self.CJImageView setImage:[UIImage imageNamed:@"radio_un"]];
    self.CJImageView.tag = 0;
    [self.BXImageView setImage:[UIImage imageNamed:@"radio_yes"]];
    self.BXImageView.tag = 1;
}

#pragma mark -- 删除选择对象

- (IBAction)clickTitleConmentLabel:(UIButton *)sender
{
    self.titleConmentLabel.text = @"";
    self.titleConmentLabel.hidden = YES;
    self.chooseObjectsLabel.hidden = NO;
    self.addObjectsImage.hidden = NO;
    self.deleteConmentButton.hidden = YES;
}

#pragma mark -- 相机

- (void)clickCameraButton:(UIButton *)sender
{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *_theImageFiles = [[NSMutableArray arrayWithArray:[userDefaults objectForKey:@"_theImageFiles"]] mutableCopy];
    if ([_theImageFiles count] >= 4) {
        [self showImage:[UIImage imageNamed:@""] status:@"最多只能添加四张相片"];
        
    } else{
        addImageViewSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                        delegate:self
                                               cancelButtonTitle:@"取消"
                                          destructiveButtonTitle:nil
                                               otherButtonTitles:@"从相册选取", @"拍照", nil];
        
        [addImageViewSheet showInView:self.view];
    }
}

#pragma mark -- 工具栏向下移动

- (void)clickDrownButton:(UIButton *)sender
{
    [UIView animateWithDuration:0.5f animations:^{
        hookImageView.top = SCREENHEIGHT - 50 - 90;
        msgTitle.top = SCREENHEIGHT - 50 - 64 - 30;
        settingLabel.top = SCREENHEIGHT - 50 - 64 - 30;
        settingImageView.top = SCREENHEIGHT - 50 - 64 - 25;
        _theFoortView.top = SCREENHEIGHT - 50 - 64;
        _theFoortView1.top = SCREENHEIGHT;
        lineView.top = SCREENHEIGHT - 65 - 50;
        drwonButton.hidden = YES;
    } completion:^(BOOL finished) {
        isUp = NO;
    }];
}

#pragma mark -- 录音图片按钮响应

- (void)clickRecordingButton:(UIButton *)sender
{
    if (!isUp) {
        [UIView animateWithDuration:0.5f animations:^{
            hookImageView.top = SCREENHEIGHT - 50 - 64 - 130;
            msgTitle.top = SCREENHEIGHT - 50 - 64 - 135;
            settingLabel.top = SCREENHEIGHT - 50 - 64 - 135;
            settingImageView.top = SCREENHEIGHT - 50 - 64 - 130;
            _theFoortView.top = SCREENHEIGHT - 50 - 64 - 100;
            _theFoortView1.top = SCREENHEIGHT - 50 - 64 - 50;
            drwonButton.hidden = NO;
            lineView.top = SCREENHEIGHT - 65 - 50 - 100;
        } completion:^(BOOL finished) {
            isUp = YES;
        }];
        
    } else{
        [UIView animateWithDuration:0.5f animations:^{
            hookImageView.top = SCREENHEIGHT - 50 - 90;
            msgTitle.top = SCREENHEIGHT - 50 - 64 - 30;
            settingLabel.top = SCREENHEIGHT - 50 - 64 - 30;
            settingImageView.top = SCREENHEIGHT - 50 - 64 - 25;
            _theFoortView.top = SCREENHEIGHT - 50 - 64;
            _theFoortView1.top = SCREENHEIGHT;
            drwonButton.hidden = YES;
            lineView.top = SCREENHEIGHT - 65 - 50;
        } completion:^(BOOL finished) {
            isUp = NO;
        }];
        
    }
}

#pragma mark -- 发送

- (void)clickSendButton:(UIButton *)sender
{
    if ([self validateTheSend]) {
        // 发送类型：
        int messageType = 0;
        if (self.ZYImageView.tag == 1) {
            messageType = 11;
        } else if (self.TZImageView.tag == 1){
            messageType = 8;
        } else if (self.CJImageView.tag == 1){
            messageType = 11;
        } else if (self.BXImageView.tag == 1){
            messageType = 11;
        }
        // 短信、网页：
        int sendType = 2;
        //            if (hookImageView.tag == 1) {
        //                sendType = 2;// 短信
        //            } else if (hookImageView.tag == 0){
        //                sendType = 1;// 网页
        //            }
        // 以姓名发送、给班主任发送？
        int tempIsSendName = 10;
        int tempIsPublishToClassMaster = 10;
        if (self.isSendName || self.isPublishToClassMaster) {
            tempIsSendName = self.isSendName;
            tempIsPublishToClassMaster = self.isPublishToClassMaster;
        } else{
            tempIsSendName = 10;
            tempIsPublishToClassMaster = 10;
            
        }
        
        // 图片拼接
        // 判断是引用还是本地？
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        if (tempPicArray && [tempPicArray count] > 0) {
            imageString = tempPicArray[0];
            for (int i = 1; i < [tempPicArray count]; i ++) {
                NSString *tempStr = [NSString stringWithFormat:@"|%@",tempPicArray[i]];
                imageString = [imageString stringByAppendingString:tempStr];
            }
            
        } else{
            NSMutableArray *_theImageFiles = [[NSMutableArray arrayWithArray:[userDefaults objectForKey:@"_theImageFiles"]] mutableCopy];
            if (_theImageFiles && [_theImageFiles count] > 0) {
                imageString = _theImageFiles[0];
                for (int i = 1; i < [_theImageFiles count]; i ++) {
                    NSString *tempStr = [NSString stringWithFormat:@"|%@",_theImageFiles[i]];
                    imageString = [imageString stringByAppendingString:tempStr];
                }
            }
            if (!imageString) {
                imageString = @"";
            }
        }
        
        // 录音和录音时间拼接
        // 判断是不是引用还是本地？
        if (tempAudioArray && [tempAudioArray count] && tempAudioTime && [tempAudioTime count]) {
            recordStr = [NSString stringWithFormat:@"%@&&%@",tempAudioArray[0],tempAudioTime[0]];
            for (int i = 1; i < [tempAudioArray count]; i ++) {
                NSString *tempRecordStr = [NSString stringWithFormat:@"|%@&&%@",tempAudioArray[i],tempAudioTime[i]];
                recordStr = [recordStr stringByAppendingString:tempRecordStr];
            }
            if (!recordStr) {
                recordStr = @"";
            }
            
        } else{
            // 录音：
            NSMutableArray *theRecord = [[NSMutableArray arrayWithArray:[userDefaults objectForKey:@"tmp_theRecord"]] mutableCopy];
            // 录音时间：
            NSMutableArray *theRecordTime = [[NSMutableArray arrayWithArray:[userDefaults objectForKey:@"_theRecordTime"]] mutableCopy];
            if (theRecord && [theRecord count] > 0) {
                recordStr = [NSString stringWithFormat:@"%@&&%@",theRecord[0],theRecordTime[0]];
                for (int i = 1; i < [theRecord count]; i ++) {
                    NSString *tempRecordStr = [NSString stringWithFormat:@"|%@&&%@",theRecord[i],theRecordTime[i]];
                    recordStr = [recordStr stringByAppendingString:tempRecordStr];
                }
            }
            if (!recordStr) {
                recordStr = @"";
            }
        }
        /**
         调用发送接口：
         */
        if (tmpSend == 1) {// 班级发送
            self.request = [[ASIFormDataRequest alloc] init];
            [self setRequest:[ASIFormDataRequest requestWithURL:
                              [NSURL URLWithString:[NSString stringWithFormat:@"http://vv.%@/TeacherApi/PostPublishToClass",aedudomain]]]];
            [self.request setPostValue:[RRTManager manager].loginManager.loginInfo.tokenId forKey:@"toKen"];
            if (self.mainTextView.text.length == 0) {
                [self.request setPostValue:[NSString stringWithFormat:@"%@老师给你发了一条图片（语音）信息，请在客户端查收",[RRTManager manager].loginManager.loginInfo.userName] forKey:@"message"];
            } else{
                [self.request setPostValue:self.mainTextView.text forKey:@"message"];
            }
            for (int i = 0; i < [classIdArray count]; i++) {
                NSString *classId = [NSString stringWithFormat:@"%@",classIdArray[i]];
                [self.request addPostValue:classId forKey:@"classId"];
            }
            [self.request setPostValue:[NSNumber numberWithInt:messageType] forKey:@"messageType"];
            [self.request setPostValue:[NSNumber numberWithInt:tempIsSendName] forKey:@"isSendName"];
            [self.request setPostValue:[NSNumber numberWithInt:sendType] forKey:@"sendType"];
            [self.request setPostValue:[NSNumber numberWithInt:tempIsPublishToClassMaster] forKey:@"isPublishToClassMaster"];
            [self.request setPostValue:[NSNumber numberWithInt:self.TheIsCampus] forKey:@"studentType"];
            
            
            if (recordStr && recordStr!= nil) {
                [self.request setPostValue:recordStr forKey:@"audioes"];
                
            }
            
            if (imageString && imageString!= nil) {
                [self.request setPostValue:imageString forKey:@"pictures"];
                
            }
            [self.request setTimeOutSeconds:20];
            [self.request setDelegate:self];
            [self.request setDidFailSelector:@selector(uploadFailed:)];
            [self.request setDidFinishSelector:@selector(uploadSendFinished:)];
            [self.request startAsynchronous];
            [self showWithStatus:@"正在发送..."];
        } else if (tmpSend == 2){// 学生
            
            self.request = [[ASIFormDataRequest alloc] init];
            [self setRequest:[ASIFormDataRequest requestWithURL:
                              [NSURL URLWithString:[NSString stringWithFormat:@"http://vv.%@/TeacherApi/PostPublishToClassSome",aedudomain]]]];
            [self show];
            [self.request setPostValue:[RRTManager manager].loginManager.loginInfo.tokenId forKey:@"toKen"];
            if (self.mainTextView.text.length == 0) {
                [self.request setPostValue:[NSString stringWithFormat:@"%@老师给你发了一条图片（语音）信息，请在客户端查收",[RRTManager manager].loginManager.loginInfo.userName] forKey:@"message"];
            } else{
                [self.request setPostValue:self.mainTextView.text forKey:@"message"];
            }
            [self.request setPostValue:theClassID forKey:@"classId"];
            for (int i = 0; i < [studentIdArray count]; i++) {
                NSString *studentId = [NSString stringWithFormat:@"%@",studentIdArray[i]];
                [self.request addPostValue:studentId forKey:@"objectIdList"];
            }
            [self.request setPostValue:[NSNumber numberWithInt:messageType] forKey:@"messageType"];
            [self.request setPostValue:[NSNumber numberWithInt:tempIsSendName] forKey:@"isSendName"];
            [self.request setPostValue:[NSNumber numberWithInt:sendType] forKey:@"sendType"];
            [self.request setPostValue:[NSNumber numberWithInt:tempIsPublishToClassMaster] forKey:@"isPublishToClassMaster"];
            if (recordStr && recordStr!= nil) {
                [self.request setPostValue:recordStr forKey:@"audioes"];
                
            }
            
            if (imageString && imageString!= nil) {
                [self.request setPostValue:imageString forKey:@"pictures"];
                
            }
            [self.request setTimeOutSeconds:20];
            [self.request setDelegate:self];
            [self.request setDidFailSelector:@selector(uploadFailed:)];
            [self.request setDidFinishSelector:@selector(uploadSendFinished:)];
            [self.request startAsynchronous];
            [self showWithStatus:@"正在发送..."];
            
        } else if (tmpSend == 3){// 群组
            
            self.request = [[ASIFormDataRequest alloc] init];
            [self setRequest:[ASIFormDataRequest requestWithURL:
                              [NSURL URLWithString:[NSString stringWithFormat:@"http://vv.%@/TeacherApi/PostPublishToGroup",aedudomain]]]];
            
            [self show];
            [self.request setPostValue:[RRTManager manager].loginManager.loginInfo.tokenId forKey:@"toKen"];
            if (self.mainTextView.text.length == 0) {
                [self.request setPostValue:[NSString stringWithFormat:@"%@老师给你发了一条图片（语音）信息，请在客户端查收",[RRTManager manager].loginManager.loginInfo.userName] forKey:@"message"];
            } else{
                [self.request setPostValue:self.mainTextView.text forKey:@"message"];
            }
            for (int i = 0; i < [groupIdArray count]; i++) {
                NSString *groupId = [NSString stringWithFormat:@"%@",groupIdArray[i]];
                [self.request addPostValue:groupId forKey:@"groupId"];
            }
            if (teacherOrStudentStates == 1) {
                [self.request setPostValue:[NSNumber numberWithInt:11] forKey:@"messageType"];
                
            } else{
                [self.request setPostValue:[NSNumber numberWithInt:messageType] forKey:@"messageType"];
                
            }
            [self.request setPostValue:[NSNumber numberWithInt:tempIsSendName] forKey:@"isSendName"];
            [self.request setPostValue:[NSNumber numberWithInt:sendType] forKey:@"sendType"];
            
            if (recordStr && recordStr!= nil) {
                [self.request setPostValue:recordStr forKey:@"audioes"];
                
            }
            
            if (imageString && imageString!= nil) {
                [self.request setPostValue:imageString forKey:@"pictures"];
                
            }
            [self.request setTimeOutSeconds:20];
            [self.request setDelegate:self];
            [self.request setDidFailSelector:@selector(uploadFailed:)];
            [self.request setDidFinishSelector:@selector(uploadSendFinished:)];
            [self.request startAsynchronous];
            [self showWithStatus:@"正在发送..."];
            
        } else if (tmpSend == 4){// 群组成员
            self.request = [[ASIFormDataRequest alloc] init];
            [self setRequest:[ASIFormDataRequest requestWithURL:
                              [NSURL URLWithString:[NSString stringWithFormat:@"http://vv.%@/TeacherApi/PostPublishToGroupSome",aedudomain]]]];
            [self show];
            [self.request setPostValue:[RRTManager manager].loginManager.loginInfo.tokenId forKey:@"toKen"];
            if (self.mainTextView.text.length == 0) {
                [self.request setPostValue:[NSString stringWithFormat:@"%@老师给你发了一条图片（语音）信息，请在客户端查收",[RRTManager manager].loginManager.loginInfo.userName] forKey:@"message"];
            } else{
                [self.request setPostValue:self.mainTextView.text forKey:@"message"];
            }
            [self.request setPostValue:theGroupID forKey:@"groupId"];
            for (int i = 0; i < [grouperIdArray count]; i++) {
                NSString *grouperId = [NSString stringWithFormat:@"%@",grouperIdArray[i]];
                [self.request addPostValue:grouperId forKey:@"objectIdList"];
            }
            if (teacherOrStudentStates == 1) {
                [self.request setPostValue:[NSNumber numberWithInt:11] forKey:@"messageType"];
                
            } else{
                [self.request setPostValue:[NSNumber numberWithInt:messageType] forKey:@"messageType"];
                
            }
            [self.request setPostValue:[NSNumber numberWithInt:tempIsSendName] forKey:@"isSendName"];
            [self.request setPostValue:[NSNumber numberWithInt:sendType] forKey:@"sendType"];
            if (recordStr && recordStr!= nil) {
                [self.request setPostValue:recordStr forKey:@"audioes"];
                
            }
            
            if (imageString && imageString!= nil) {
                [self.request setPostValue:imageString forKey:@"pictures"];
                
            }
            [self.request setTimeOutSeconds:20];
            [self.request setDelegate:self];
            [self.request setDidFailSelector:@selector(uploadFailed:)];
            [self.request setDidFinishSelector:@selector(uploadSendFinished:)];
            [self.request startAsynchronous];
            [self showWithStatus:@"正在发送..."];
            
            
        } else if (tmpSend == 5){// 老师
            
            self.request = [[ASIFormDataRequest alloc] init];
            [self setRequest:[ASIFormDataRequest requestWithURL:
                              [NSURL URLWithString:[NSString stringWithFormat:@"http://vv.%@/TeacherApi/PostPublishToTeacher",aedudomain]]]];
            [self show];
            [self.request setPostValue:[RRTManager manager].loginManager.loginInfo.tokenId forKey:@"toKen"];
            if (self.mainTextView.text.length == 0) {
                [self.request setPostValue:[NSString stringWithFormat:@"%@老师给你发了一条图片（语音）信息，请在客户端查收",[RRTManager manager].loginManager.loginInfo.userName] forKey:@"message"];
            } else{
                [self.request setPostValue:self.mainTextView.text forKey:@"message"];
            }
            for (int i = 0; i < [teacherIdArray count]; i++) {
                NSString *teacherId = [NSString stringWithFormat:@"%@",teacherIdArray[i]];
                [self.request addPostValue:teacherId forKey:@"objectIdList"];
            }
            [self.request setPostValue:[NSNumber numberWithInt:11] forKey:@"messageType"];// 全部类型为通知
            [self.request setPostValue:[NSNumber numberWithInt:tempIsSendName] forKey:@"isSendName"];
            [self.request setPostValue:[NSNumber numberWithInt:sendType] forKey:@"sendType"];
            if (recordStr && recordStr!= nil) {
                [self.request setPostValue:recordStr forKey:@"audioes"];
                
            }
            
            if (imageString && imageString!= nil) {
                [self.request setPostValue:imageString forKey:@"pictures"];
                
            }
            [self.request setTimeOutSeconds:20];
            [self.request setDelegate:self];
            [self.request setDidFailSelector:@selector(uploadFailed:)];
            [self.request setDidFinishSelector:@selector(uploadSendFinished:)];
            [self.request startAsynchronous];
            [self showWithStatus:@"正在发送..."];
            
        }

    }
}

#pragma mark -- 发送成功回调

- (void)uploadSendFinished:(ASIHTTPRequest *)theRequest
{

    [self uploadTheSendFinished:theRequest];
}

- (void)uploadTheSendFinished:(ASIHTTPRequest *)theRequest
{
    NSData *deData = theRequest.responseData;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:deData
                                                         options:kNilOptions
                                                           error:nil];
    if (dict) {
        BOOL result = [[dict objectForKey:@"Result"] boolValue];
        if (result == 1) {
            // 发送成功后将本地图片、录音、文本内容删除
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"_theImageFiles"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"tmp_theRecord"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"_theRecordTime"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"myContent"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"isSaveStrOne"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"isSaveStrTow"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self showImages:nil];
            [self showRecordView:nil recordTimeArray:nil];
            [self deleteImageFilePath];
            [self deleteFile];
            self.mainTextView.text = @"";//文本内容
            self.titleConmentLabel.text = @"";
            imageString = @"";// 图片链接
            recordStr = @"";// 录音链接
            self.isSendName = 10;
            self.isPublishToClassMaster = 10;
            hookImageView.tag = 0;
            [hookImageView setImage:[UIImage imageNamed:@"check_un"]];
            msgTitle.textColor = [UIColor grayColor];
            
            self.titleConmentLabel.hidden = YES;
            self.deleteConmentButton.hidden = YES;
            self.chooseObjectsLabel.hidden = NO;
            self.addObjectsImage.hidden = NO;
            self.waterMarkTitleLabel.hidden = NO;
            self.limiteNumberLabel.text = [NSString stringWithFormat:@"还可以输入%@个字",numberStr];
            
            [self.ZYImageView setImage:[UIImage imageNamed:@"radio_un"]];
            self.ZYImageView.tag = 0;
            [self.TZImageView setImage:[UIImage imageNamed:@"radio_un"]];
            self.TZImageView.tag = 0;
            [self.CJImageView setImage:[UIImage imageNamed:@"radio_un"]];
            self.CJImageView.tag = 0;
            [self.BXImageView setImage:[UIImage imageNamed:@"radio_un"]];
            self.BXImageView.tag = 0;
            
            [self showImage:[UIImage imageNamed:@"confirm-ok72.png"] status:@"发送成功"];
            
            [self performSelector:@selector(popVC) withObject:self afterDelay:1.0f];

        } else{
            [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:[dict objectForKey:@"Message"]];
        }
    } else{
        [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:[dict objectForKey:@"Message"]];
    }
    [self performSelector:@selector(dismissUI) withObject:self afterDelay:1.5f];
    sendButton.enabled = YES;
    sendButton.backgroundColor = theLoginButtonColor;
}

- (void)popVC
{
    [self.navigationController pushViewController:HighLevelSetting
                                   withStoryBoard:DeskStoryBoardName
                                        withBlock:^(UIViewController *viewController) {
                                        }];
}
- (void)dismissUI
{
    [self dismiss];

    
}

#pragma mark -- 发送前做判断
- (BOOL)validateTheSend
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *_theImageFiles = [[NSMutableArray arrayWithArray:[userDefaults objectForKey:@"_theImageFiles"]] mutableCopy];
    // 保存录音到本地
    NSMutableArray *_theRecord = [[NSMutableArray arrayWithArray:[userDefaults objectForKey:@"tmp_theRecord"]] mutableCopy];
    
    if (self.mainTextView.text.length <= 0 && [_theImageFiles count] <= 0 && [_theRecord count] <= 0) {
        
        [self showImage:[UIImage imageNamed:@""] status:@"请输入文字内容"];
        return NO;
    }
    if (self.titleConmentLabel.text.length <= 0) {
        [self showImage:[UIImage imageNamed:@""] status:@"请选择发送对象"];
        return NO;
    }
    if (self.ZYImageView.tag == 0 && self.CJImageView.tag == 0 && self.BXImageView.tag == 0 && self.TZImageView.tag == 0) {
        [self showImage:[UIImage imageNamed:@""] status:@"请选择发送类型"];
        return NO;
    }
    return YES;
}

#pragma mark -- Techer Group Class_Delegate
/**
 *
 *
 *  @param array      选中的学生或班级
 *  @param isOnCampus 2 住校生  0 走读生  -1 不限
 */
- (void)selectStudentArray:(NSMutableArray *)array IsOnCampus:(int)isOnCampus
{
    self.TheIsCampus = isOnCampus;
    if (array && [array count] >0) {
        id obj = [array firstObject];
        //给班级发
        if ([obj isKindOfClass:[ClassList class]]) {
            [tempNameArray removeAllObjects];
            classIdArray = [NSMutableArray array];
            for (ClassList *class in array) {
                [classIdArray addObject:class.ClassId];
                [tempNameArray addObject:class.ClassAlias];
            }
            tmpSend = 1;
            self.titleConmentLabel.hidden = NO;
            self.deleteConmentButton.hidden = NO;
            self.chooseObjectsLabel.hidden = YES;
            self.addObjectsImage.hidden = YES;
            self.titleConmentLabel.layer.cornerRadius = 3.0f;
            if (tempNameArray && [tempNameArray count] > 1) {
                self.titleConmentLabel.text = [NSString stringWithFormat:@"已选择:%@...等(%d)个班级",tempNameArray[0],[array count]];
            } else if (tempNameArray && [tempNameArray count] == 1){
                self.titleConmentLabel.text = [NSString stringWithFormat:@"已选择:%@",tempNameArray[0]];
            }
            
        }
        
        //给学生发
        if ([obj isKindOfClass:[StudentList class]]) {
            [tempNameArray removeAllObjects];
            studentIdArray = [NSMutableArray array];
            for (StudentList *class in array) {
                [studentIdArray addObject:class.StudentId];
                [tempNameArray addObject:class.StudentName];
                theClassID = [NSString stringWithFormat:@"%@",class.ClassId];
            }
            tmpSend = 2;
            self.titleConmentLabel.hidden = NO;
            self.deleteConmentButton.hidden = NO;
            self.chooseObjectsLabel.hidden = YES;
            self.addObjectsImage.hidden = YES;
            self.titleConmentLabel.layer.cornerRadius = 3.0f;
            if (tempNameArray && [tempNameArray count] > 1) {
                self.titleConmentLabel.text = [NSString stringWithFormat:@"已选择:%@...等(%d)个班级",tempNameArray[0],[array count]];
            } else if (tempNameArray && [tempNameArray count] == 1){
                self.titleConmentLabel.text = [NSString stringWithFormat:@"已选择:%@",tempNameArray[0]];
            }
        }
    }
}
- (void)selectTeacherArray:(NSMutableArray *)array
{
    if (array && [array count] >0) {
        [tempNameArray removeAllObjects];
        //给老师发
        teacherIdArray = [NSMutableArray array];
        for (TeacherList *class in array) {
            [teacherIdArray addObject:class.TeacherId];
            [tempNameArray addObject:class.TeacherName];
        }
        tmpSend = 5;
        self.titleConmentLabel.hidden = NO;
        self.deleteConmentButton.hidden = NO;
        self.chooseObjectsLabel.hidden = YES;
        self.addObjectsImage.hidden = YES;
        self.titleConmentLabel.layer.cornerRadius = 3.0f;
        if (tempNameArray && [tempNameArray count] > 1) {
            self.titleConmentLabel.text = [NSString stringWithFormat:@"已选择:%@...等(%d)个班级",tempNameArray[0],[array count]];
        } else if (tempNameArray && [tempNameArray count] == 1){
            self.titleConmentLabel.text = [NSString stringWithFormat:@"已选择:%@",tempNameArray[0]];
        }
    }
}
/**

 *  @param states 1 教师    2 学生
 */
- (void)selectGroupArray:(NSMutableArray *)array states:(int)states
{
    NSLog(@"%d",states);
    if (array && [array count] >0 && states) {
        teacherOrStudentStates = states;
        id obj = [array firstObject];
        //给群组发
        if ([obj isKindOfClass:[GroupList class]]) {
            [tempNameArray removeAllObjects];
            groupIdArray = [NSMutableArray array];
            for (GroupList *class in array) {
                [groupIdArray addObject:class.GroupId];
                [tempNameArray addObject:class.GroupName];
                
            }
            tmpSend = 3;
            self.titleConmentLabel.hidden = NO;
            self.deleteConmentButton.hidden = NO;
            self.chooseObjectsLabel.hidden = YES;
            self.addObjectsImage.hidden = YES;
            self.titleConmentLabel.layer.cornerRadius = 3.0f;
            if (tempNameArray && [tempNameArray count] > 1) {
                self.titleConmentLabel.text = [NSString stringWithFormat:@"已选择:%@...等(%d)个班级",tempNameArray[0],[array count]];
            } else if (tempNameArray && [tempNameArray count] == 1){
                self.titleConmentLabel.text = [NSString stringWithFormat:@"已选择:%@",tempNameArray[0]];
            }
        }
        
        //给群成员发
        if ([obj isKindOfClass:[GrouperList class]]) {
            [tempNameArray removeAllObjects];
            grouperIdArray = [NSMutableArray array];
            for (GrouperList *class in array) {
                [grouperIdArray addObject:class.UserId];
                [tempNameArray addObject:class.UserName];
                theGroupID = [NSString stringWithFormat:@"%@",class.GroupId];
            }
            tmpSend = 4;
            self.titleConmentLabel.hidden = NO;
            self.deleteConmentButton.hidden = NO;
            self.chooseObjectsLabel.hidden = YES;
            self.addObjectsImage.hidden = YES;
            self.titleConmentLabel.layer.cornerRadius = 3.0f;
            if (tempNameArray && [tempNameArray count] > 1) {
                self.titleConmentLabel.text = [NSString stringWithFormat:@"已选择:%@...等(%d)个班级",tempNameArray[0],[array count]];
            } else if (tempNameArray && [tempNameArray count] == 1){
                self.titleConmentLabel.text = [NSString stringWithFormat:@"已选择:%@",tempNameArray[0]];
            }
        }
    }
}
#pragma mark - 选择界面跳转
- (void)selectViewController:(NSInteger)buttonIndex
{
    if ([[chooseObjectSheet buttonTitleAtIndex:buttonIndex]isEqualToString:@"班级"]) {
        SelectClassController *classVC = [[SelectClassController alloc]init];
        classVC.delegate = self;
        [self.navigationController pushViewController:classVC animated:YES];
    }else if ([[chooseObjectSheet buttonTitleAtIndex:buttonIndex]isEqualToString:@"教师"]){
        
        SelectTeacherViewController *teacherVC = [[SelectTeacherViewController alloc]init];
        teacherVC.delegate = self;
        [self.navigationController pushViewController:teacherVC animated:YES];
    }else if ([[chooseObjectSheet buttonTitleAtIndex:buttonIndex]isEqualToString:@"群组"]){
        SelectGropViewController *groupVC = [[SelectGropViewController alloc]init];
        groupVC.delegate = self;
        [self.navigationController pushViewController:groupVC animated:YES];
    }
}

#pragma mark - UIActionSheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet == chooseObjectSheet) {
        if (buttonIndex == 0) {
            [self selectViewController:buttonIndex];
        } else if (buttonIndex == 1){
            [self selectViewController:buttonIndex];
        } else if (buttonIndex == 2){
            [self selectViewController:buttonIndex];
        }
        
    } else if (actionSheet == addImageViewSheet){
        if (buttonIndex == 0) {
            //从相册中选择
            QBImagePickerController *imagePickerController = [[QBImagePickerController alloc] init];
            imagePickerController.delegate = self;
            imagePickerController.allowsMultipleSelection = YES;
            imagePickerController.filterType = QBImagePickerControllerFilterTypePhotos;
            NSMutableArray *theImageURLArray = [[NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"_theImageFiles"]] mutableCopy];
            if ([theImageURLArray count] == 0) {
                imagePickerController.maximumNumberOfSelection = 4;

            } else if ([theImageURLArray count] == 1){
                imagePickerController.maximumNumberOfSelection = 3;

            } else if ([theImageURLArray count] == 2){
                imagePickerController.maximumNumberOfSelection = 2;

            } else if ([theImageURLArray count] == 3){
                imagePickerController.maximumNumberOfSelection = 1;

            }
            
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
            [self presentViewController:navigationController animated:YES completion:NULL];
        } else if (buttonIndex == 1){
            //拍照
            UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
            if (![UIImagePickerController isSourceTypeAvailable: sourceType]) {
                [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"该设备不支持拍照" ];
                
            } else {
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.delegate = self;
                picker.allowsEditing = YES;
                picker.sourceType = sourceType;
                [self presentViewController:picker animated:YES completion:NULL];
            }
        }
    }
}

#pragma mark - QBImagePickerControllerDelegate 相册
#pragma mark -
- (void)imagePickerController:(QBImagePickerController *)imagePickerController didSelectAsset:(ALAsset *)asset
{
    NSLog(@"*** imagePickerController:didSelectAsset:");
    NSLog(@"%@", asset);
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerController:(QBImagePickerController *)imagePickerController didSelectAssets:(NSArray *)assets
{
    NSLog(@"*** imagePickerController:didSelectAssets:");
    [self dismissViewControllerAnimated:YES completion:NULL];
    [self.images removeAllObjects];
//    for (UIView *subView in [self.addImageView subviews]) {
//        if ([subView isKindOfClass:[UIImageView class]]) {
//            [subView removeFromSuperview];
//        }
//    }
    [self deleteFile];
    NSMutableArray *tmpImagesArray = [NSMutableArray array];
    // 沙盒路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    if (!docDir) {
        NSLog(@"Documents 目录未找到");
    }
    NSString *imagePath = [docDir stringByAppendingPathComponent:
                           [NSString stringWithFormat:ActivityPath]];
    [[NSFileManager defaultManager] createDirectoryAtPath:imagePath
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:nil];
    NSMutableArray *imageUrls = [[NSMutableArray alloc] init];
    
    [self.images removeAllObjects];
    for (int i = 0; i < [assets count]; i++) {
        ALAsset *asset = (ALAsset*)[assets objectAtIndex:i];
        ALAssetRepresentation *assetRep = [asset defaultRepresentation];
        CGImageRef imgRef = [assetRep fullResolutionImage];
        UIImage *img = [UIImage imageWithCGImage:imgRef
                                           scale:assetRep.scale
                                     orientation:(UIImageOrientation)assetRep.orientation];
        NSString *imgPath = [imagePath stringByAppendingPathComponent:
                             [NSString stringWithFormat:@"%d.jpg", i]];
        img = [UIImage scaleImage:img toScale:0.2];
        
        NSData *imageData = UIImagePNGRepresentation(img);
        [imageData writeToFile:imgPath atomically:YES];

        [tmpImagesArray addObject:img];
        [_theImages addObject:imageData];
        [self.images addObject:imgPath];
        [imageUrls addObject:imgPath];
    }
    // 图片保沙盒
    NSString *filePath = [docDir stringByAppendingPathComponent:@"images"];
    [_theImages writeToFile:filePath atomically:YES];
    [self.request cancel];
    for (int j = 0; j < [imageUrls count]; j ++) {
        self.request = [[ASIFormDataRequest alloc] init];
        //上传图片至服务器
        [self setRequest:[ASIFormDataRequest requestWithURL:
                          [NSURL URLWithString:[NSString stringWithFormat:@"http://nmapi.%@/Push/PostMessageFile",aedudomain]]]];
        [self.request setPostValue:[RRTManager manager].loginManager.loginInfo.tokenId forKey:@"token"];
        [self.request setFile:imageUrls[j] forKey:@"file"];
        [self.request setTimeOutSeconds:20];
        [self.request setDelegate:self];
        [self.request setDidFailSelector:@selector(uploadFailed:)];
        [self.request setDidFinishSelector:@selector(uploadPicFinished:)];
        [self.request startAsynchronous];
        [self showWithStatus:@"正在上传图片..."];
    }
}


- (void)imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController
{
    NSLog(@"*** imagePickerControllerDidCancel:");
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark -- 删除沙盒图片文件夹

- (void)deleteFile {
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    //文件名
    NSString *uniquePath=[[paths objectAtIndex:0] stringByAppendingPathComponent:@"images"];
    
    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:uniquePath];
    if (!blHave) {
        NSLog(@" no  have");
        return ;
    }else {
        NSLog(@" have");
        BOOL blDele= [fileManager removeItemAtPath:uniquePath error:nil];

        if (blDele) {
            NSLog(@"dele success");
        }else {
            NSLog(@"dele fail");
        }
    }
}

#pragma mark -- 删除沙盒图片文件路劲
- (void)deleteImageFilePath{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"_theImagesPaths"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - UIImagePickerControllerDelegate 相机
#pragma mark -
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{

    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    // 沙盒路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    if (!docDir) {
        NSLog(@"Documents 目录未找到");
    }
    NSString *imagePath = [docDir stringByAppendingPathComponent:
                           [NSString stringWithFormat:ActivityPath]];// 改
    [[NSFileManager defaultManager] createDirectoryAtPath:imagePath
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:nil];// 改
    NSMutableArray *imageUrls = [[NSMutableArray alloc] init];
    UIImage *img = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    NSString *imgPath = [imagePath stringByAppendingPathComponent:
                         [NSString stringWithFormat:@"%@.jpg", @"aedu"]];// 改
    img = [UIImage scaleImage:img toScale:0.2];
    NSData *imgData = UIImagePNGRepresentation(img);
    [imgData writeToFile:imgPath atomically:YES];
    [imageUrls addObject:imgPath];
    [self.images removeAllObjects];
    [self.images addObject:imgPath];
//    for (UIView *subView in [self.addImageView subviews]) {
//        if ([subView isKindOfClass:[UIImageView class]]) {
//            [subView removeFromSuperview];
//        }
//    }
    [self.request cancel];
    self.request = [[ASIFormDataRequest alloc] init];
    //上传图片至服务器
    [self setRequest:[ASIFormDataRequest requestWithURL:
                      [NSURL URLWithString:[NSString stringWithFormat:@"http://nmapi.%@/Push/PostMessageFile",aedudomain]]]];
    [self.request setPostValue:[RRTManager manager].loginManager.loginInfo.tokenId forKey:@"token"];
    [self.request setFile:imageUrls[0] forKey:@"file"];
    [self.request setTimeOutSeconds:20];
    [self.request setDelegate:self];
    [self.request setDidFailSelector:@selector(uploadFailed:)];
    [self.request setDidFinishSelector:@selector(uploadPicFinished:)];
    [self.request startAsynchronous];
    [self showWithStatus:@"正在上传照片..."];
}

#pragma mark -- 展示图片到界面上

- (void)showImages:(NSMutableArray *)imagesArray
{
    if (imagesArray && [imagesArray count] > 0) {
        self.addImageButton.hidden = NO;
        self.addImageButton.frame = CGRectMake(10, 10, 90, 90);
        CGRect rect = self.addImageView.frame;
        int num = [imagesArray count] + 1;
        int lines = num / 3 + ((num % 3 == 0) ? 0 : 1);
        rect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, 90 * lines);
        self.addImageView.frame = rect;
        
        for (UIView *subView in [self.addImageView subviews]) {
            if ([subView isKindOfClass:[UIImageView class]]) {
                [subView removeFromSuperview];
            }
        }
        CGFloat width = 90;
        CGFloat height = 90;
        CGFloat margin = 10;
        CGFloat startX = 15;
        CGFloat startY = 0;
        self.addImageView.userInteractionEnabled = YES;
        for (int i = 0; i < imagesArray.count; i ++) {
            
            picImageViews = [[UIImageView alloc] init];
            // 计算位置
            int row = i / 3;
            int column = i % 3;
            CGFloat x = startX + column * (width + margin);
            CGFloat y = startY + row * (height + margin);
            picImageViews.frame = CGRectMake(x, y, width, height);
            [self.addImageView addSubview:picImageViews];
            // 事件监听
            picImageViews.tag = i + 1000;
            picImageViews.userInteractionEnabled = YES;
            [picImageViews addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTheImage:)]];
            
            [picImageViews setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://nmapi.%@%@",aedudomain,imagesArray[i]]]
                          placeholderImage:[UIImage imageNamed:@"defaultImage.png"]];
            
            // 内容模式
            picImageViews.clipsToBounds = YES;
            picImageViews.contentMode = UIViewContentModeScaleAspectFill;
        }
        int imageCount = [imagesArray count];
        self.addImageButton.frame = CGRectMake(15 + (imageCount % 3) * 100,(imageCount / 3) * 100, 90, 90);
        [self.addImageButton setImage:[UIImage imageNamed:@"addpic"] forState:UIControlStateNormal];
        
        if (isiPhone4) {
            if (localRecordArray && [localRecordArray count] > 0) {
                self.addImageView.top = self.theRecoedBackGroupView.height + 92;
                self.mainScrollView.contentSize = CGSizeMake(0, self.mainTextView.height + self.theRecoedBackGroupView.height + 230 + self.addImageView.height);
            } else{
                self.mainScrollView.contentSize = CGSizeMake(0, self.mainTextView.height + 300 + self.addImageView.height);
            }
        } else{
            if (localRecordArray && [localRecordArray count] > 0) {
                self.addImageView.top = self.theRecoedBackGroupView.height + 92;
                self.mainScrollView.contentSize = CGSizeMake(0, self.mainTextView.height + self.theRecoedBackGroupView.height + 150 + self.addImageView.height);
            } else{
                self.mainScrollView.contentSize = CGSizeMake(0, self.mainTextView.height + 170 + self.addImageView.height);
            }
        }
        
        [self deleteImageFilePath];
        //UIImage 对象转换成本地url
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *docDir = [paths objectAtIndex:0];
        NSString *imagePath = [docDir stringByAppendingPathComponent:
                               [NSString stringWithFormat:@"Aedu.SchoolAndGuardian"]];
        [[NSFileManager defaultManager] createDirectoryAtPath:imagePath
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:nil];
        NSMutableArray *imageUrls = [[NSMutableArray alloc] init];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        for (int i = 0; i < [imagesArray count]; i++) {
            NSString *imgPath = [imagePath stringByAppendingPathComponent:
                                 [NSString stringWithFormat:@"%d.png",i]];
            [imageUrls addObject:imgPath];
            NSMutableArray *_theImagesPaths = [[NSMutableArray arrayWithArray:[userDefaults objectForKey:@"_theImagesPaths"]] mutableCopy];
            [_theImagesPaths addObject:imgPath];
            [userDefaults setObject:_theImagesPaths forKey:@"_theImagesPaths"];
            [userDefaults synchronize];
        }
        [self.imagesUrls removeAllObjects];
        self.imagesUrls = imageUrls;
    } else{
        self.addImageButton.hidden = YES;
        for (UIView *subView in [self.addImageView subviews]) {
            if ([subView isKindOfClass:[UIImageView class]]) {
                [subView removeFromSuperview];
            }
        }
    }
}

#pragma mark -- 重发

- (void)clickAgainSendButton
{
    [self setRequest:[ASIFormDataRequest requestWithURL:
                      [NSURL URLWithString:[NSString stringWithFormat:@"http://nmapi.%@/Push/PostMessageFile",aedudomain]]]];
    [self.request setPostValue:[RRTManager manager].loginManager.loginInfo.tokenId forKey:@"token"];
    [self.request setFile:ASIImageFilePathStr forKey:@"file"];
    [self.request setTimeOutSeconds:20];
    [self.request setDelegate:self];
    [self.request setDidFailSelector:@selector(uploadFailed:)];
    [self.request setDidFinishSelector:@selector(uploadPicFinished:)];
    [self.request startAsynchronous];
    [self showWithStatus:nil];
}
#pragma mark - upload file delegate
#pragma mark-
- (void)uploadFailed:(ASIHTTPRequest *)theRequest
{
    if ([theRequest isKindOfClass:[ASIFormDataRequest class]]) {
        NSLog(@"%@",[((ASIFormDataRequest*)theRequest).fileData[0] objectForKey:@"data"]
              );
        ASIImageFilePathStr = [((ASIFormDataRequest*)theRequest).fileData[0] objectForKey:@"data"];
//        for (int i = 0; i < [self.imagesUrls count]; i ++) {
//            if ([ASIImageFilePathStr isEqualToString:self.imagesUrls[i]]) {
//                for (int i = 0; i < [self.imagesUrls count]; i ++) {
//                    // 背景
//                    picImageViewsBackGroupView = [[UIView alloc] init];
//                    picImageViewsBackGroupView.backgroundColor = [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:0.7f];
//                    picImageViewsBackGroupView.frame = CGRectMake(30 + (i % 3) * 90, 5 + (i / 3) * 90, 80, 80);
//                    [self.addImageView addSubview:picImageViewsBackGroupView];
//                    // 尝试刷新
//                    againSendButton = [UIButton buttonWithType:UIButtonTypeCustom];
//                    againSendButton.frame = CGRectMake(0, 0, 80, 80);
//                    [againSendButton setImage:[UIImage imageNamed:@"retry"] forState:UIControlStateNormal];
//                    againSendButton.tag = i;
//                    [againSendButton addTarget:self action:@selector(clickAgainSendButton) forControlEvents:UIControlEventTouchUpInside];
//                    [picImageViewsBackGroupView addSubview:againSendButton];
//                }
//                NSLog(@"ddd");
//            } else{
//                NSLog(@"ghjk");
//            }
//        }
    }
    [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"上传失败！"];
}

//0:图片  1:录音
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
    NSData *deData = theRequest.responseData;
    if (type == 0) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:deData
                                                             options:kNilOptions
                                                               error:nil];
        
        int result = [(NSNumber*)[dict objectForKey:@"result"] intValue];
        if (result == 0) {
            NSDictionary *msgDict = [dict objectForKey:@"msg"];
            if (msgDict) {
                NSString *recordFilePath = (NSString *)[msgDict objectForKey:@"filePath"];
                
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                // 保存图片文件到本地
                NSMutableArray *_theImageFiles = [[NSMutableArray arrayWithArray:[userDefaults objectForKey:@"_theImageFiles"]] mutableCopy];
                [_theImageFiles addObject:recordFilePath];
                [userDefaults setObject:_theImageFiles forKey:@"_theImageFiles"];
                [userDefaults synchronize];
                [thePicArray removeAllObjects];
                [thePicArray addObject:recordFilePath];
                [self showImages:_theImageFiles];
                [self showImage:[UIImage imageNamed:@"confirm-ok72.png"] status:@"上传成功"];
            } else{
                [self uploadFailed:theRequest];
            }
        } else {
            [self uploadFailed:theRequest];
        }
        
    } else if (type == 1){
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:deData
                                                             options:kNilOptions
                                                               error:nil];
        
        int result = [(NSNumber*)[dict objectForKey:@"result"] intValue];
        if (result == 0) {
            NSDictionary *msgDict = [dict objectForKey:@"msg"];
            if (msgDict) {
                NSString *recordFilePath = (NSString *)[msgDict objectForKey:@"filePath"];
                NSString *recordPlayTime = (NSString *)[msgDict objectForKey:@"playTime"];
                
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                // 保存录音时间到本地
                NSMutableArray *_theRecordTime = [[NSMutableArray arrayWithArray:[userDefaults objectForKey:@"_theRecordTime"]] mutableCopy];
                [_theRecordTime addObject:recordPlayTime];// 保存录音时间文件
                [userDefaults setObject:_theRecordTime forKey:@"_theRecordTime"];
                [userDefaults synchronize];
                // 保存录音到本地
                NSMutableArray *_theRecord = [[NSMutableArray arrayWithArray:[userDefaults objectForKey:@"tmp_theRecord"]] mutableCopy];
                [_theRecord addObject:recordFilePath];// 保存录音文件
                [userDefaults setObject:_theRecord forKey:@"tmp_theRecord"];
                [userDefaults synchronize];
                
                [self showRecordView:_theRecord recordTimeArray:_theRecordTime];
                [self showImage:[UIImage imageNamed:@"confirm-ok72.png"] status:@"上传成功"];
            } else{
                [self uploadFailed:theRequest];
            }
        } else{
            [self uploadFailed:theRequest];
        }
        
    }
}

#pragma mark -- 点击图片预览

- (void)tapTheImage:(UITapGestureRecognizer *)tap
{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *_theImageFiles = [[NSMutableArray arrayWithArray:[userDefaults objectForKey:@"_theImageFiles"]] mutableCopy];
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:DeskStoryBoardName
                                                             bundle:nil];
    CommunicationPicDetailsViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:
                  CommunicationPicDetailsVCID];
    vc.delegate = self;
    UINavigationController* nav=[[UINavigationController alloc] initWithRootViewController:vc];
    vc.picArry = _theImageFiles;

    vc.curentDex = tap.view.tag - 1000;
    [self presentViewController:nav animated: YES completion:nil];
}

#pragma mark -- CommunicationPicDetailsViewControllerDelegate

- (void)deleteTheImage:(NSMutableArray *)imagesArry WithCurrentIndex:(NSInteger)CurrentIndex;
{
    if (tempPicArray && [tempPicArray count] > 0) {
        [tempPicArray removeObjectAtIndex:CurrentIndex];
    }
    [self showImages:imagesArry];
}

#pragma mark - UITextView Delegate Methods

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView;
{
    self.waterMarkTitleLabel.hidden = YES;
    self.CursorView.backgroundColor = [UIColor whiteColor];
    [_timer invalidate];
    _timer = nil;
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView;
{
    [self.waterMarkTitleLabel setHidden:(textView.text.length == 0) ? NO : YES];
    if (textView.text.length == 0) {
        _timer =  [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(changeColor) userInfo:nil repeats:YES];
        isColor = NO;
    } else{
        [_timer invalidate];
        _timer = nil;
    }
    [textView resignFirstResponder];
    textView.inputView = nil;
    // 保存文字：
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:textView.text forKey:@"myContent"];
    [userDefaults synchronize];
}

// 短信字数限制
-(void)textViewDidChange:(UITextView *)textView
{
    [self.waterMarkTitleLabel setHidden:(textView.text.length == 0) ? NO : YES];
    NSInteger number = [textView.text length];
    int tmpNum = [numberStr intValue];
    if (number > tmpNum) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:[NSString stringWithFormat:@"输入字数不能大于%d个字",tmpNum]
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        textView.text = [textView.text substringToIndex:tmpNum];
        number = tmpNum;
    }
    self.limiteNumberLabel.text = [NSString stringWithFormat:@"还可以输入%d个字",tmpNum-number];
}

#pragma mark - Tap Gesture
#pragma mark -
- (void)didTappedBackground:(UIGestureRecognizer*)ges
{
    [self.view endEditing:YES];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    self.hidesBottomBarWhenPushed = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.hidesBottomBarWhenPushed = YES;
    [self dismiss];
}
@end
