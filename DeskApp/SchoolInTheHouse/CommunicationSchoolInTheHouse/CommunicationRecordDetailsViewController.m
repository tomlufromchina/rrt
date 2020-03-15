//
//  CommunicationRecordDetailsViewController.m
//  RenrenTong
//
//  Created by 符其彬 on 15/2/6.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "CommunicationRecordDetailsViewController.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#import "NetWorkManager+SchoolAndHouse.h"
#import "UIImageView+WebCache.h"
#import "FileDownload.h"

@interface CommunicationRecordDetailsViewController ()<AVAudioPlayerDelegate>
{
    UIButton *_quotationButton;
    
    int recpageIndex;
    int recpageSize;
}
@property (nonatomic, strong) NetWorkManager *netWorkManager;
@property (nonatomic, strong) NSMutableArray *imagesDataSource;
@property (nonatomic, strong) NSMutableArray *recordDataSource;
@property(nonatomic, strong)AVAudioPlayer *audioPlayer;
@property(nonatomic, assign)int playFlag;
@property(nonatomic, strong)NSMutableArray *audioButtons;
@property(nonatomic, strong)NSMutableArray *audioImages;
@property(nonatomic, strong)NSMutableArray *audioViews;

@end

@implementation CommunicationRecordDetailsViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    recpageIndex = 1;
    recpageSize = 10;
    self.playFlag = -1;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = @"详情";
    self.audioButtons = [NSMutableArray array];
    self.audioImages = [NSMutableArray array];
    self.audioViews =  [NSMutableArray array];
    
    [self.mainScrollView addSubview:self.emojiLabel];
    self.emojiLabel.frame = CGRectMake(10, 10, SCREENWIDTH - 20, 100);
    [_emojiLabel sizeToFit];
    
    self.headerImageView.layer.masksToBounds = YES;
    self.headerImageView.layer.cornerRadius = self.headerImageView.width * 0.5;
    [self.headerImageView setImageWithURL:[NSURL URLWithString:[RRTManager manager].loginManager.loginInfo.userAvatar] placeholderImage:[UIImage imageNamed:@""]];
    self.recordBackGroupView.top = _emojiLabel.bottom + 10;
    self.addImageView.top = self.recordBackGroupView.bottom + 10;
    
    self.mainScrollView.contentOffset = CGPointMake(0, 0);
    self.mainScrollView.frame = CGRectMake(0, self.headerImageView.bottom + 10, SCREENWIDTH, SCREENHEIGHT - self.headerImageView.bottom -  10);
    self.mainScrollView.bounces = NO;
    self.mainScrollView.showsVerticalScrollIndicator = FALSE;
    self.mainScrollView.showsHorizontalScrollIndicator = NO;
    
    // 引用按钮：
    _quotationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _quotationButton.top = SCREENHEIGHT - 110;
    _quotationButton.left = 10;
    _quotationButton.width = SCREENWIDTH - 20;
    _quotationButton.height = 40;
    _quotationButton.layer.cornerRadius = 5;
    _quotationButton.backgroundColor = theLoginButtonColor;
    [_quotationButton setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
    [_quotationButton setTitle: @"引用内容" forState: UIControlStateNormal];
    [_quotationButton addTarget:self action:@selector(clickQuotationButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_quotationButton];
    [_quotationButton bringSubviewToFront:self.mainScrollView];
    
    self.netWorkManager = [[NetWorkManager alloc] init];
    self.imagesDataSource = [[NSMutableArray alloc] init];
    self.recordDataSource = [[NSMutableArray alloc] init];
    
    // 初始化短信
    [self initEmojiLabel];
    // 初始化录音录音
    [self initRecords];
    // 初始化图片
    [self initImageViews];
    // 数据请求
    self.nameLabel.text = self.theTeacherSendRecordObj.PubUserName;
    self.timeLabel.text = self.theTeacherSendRecordObj.CreateTimeFormat;
    
}


- (MLEmojiLabel *)emojiLabel
{
    if (!_emojiLabel) {
        _emojiLabel = [[MLEmojiLabel alloc]init];
        _emojiLabel.numberOfLines = 0;
        _emojiLabel.font = [UIFont systemFontOfSize:17.0f];
        NSLog(@"%f",_emojiLabel.font.lineHeight);
        _emojiLabel.emojiDelegate = self;
        _emojiLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _emojiLabel.isNeedAtAndPoundSign = YES;
        
        _emojiLabel.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
        _emojiLabel.customEmojiPlistName = @"expression.plist";
        [_emojiLabel setEmojiText:@""];
    }
    else{
        _emojiLabel.frame = CGRectMake(10, 10, SCREENWIDTH - 20, 30);
    }
    return _emojiLabel;
}

#pragma mark -- 展示短信

-(void)initEmojiLabel{
    
    [self emojiLabel];
    [_emojiLabel setEmojiText:self.theTeacherSendRecordObj.MsgContent];
    [_emojiLabel sizeToFit];
}

#pragma mark -- 展示图片

- (void)initImageViews
{
    CGFloat width = 90;
    CGFloat height = 90;
    CGFloat margin = 15;
    CGFloat startX = 0;
    CGFloat startY = 0;
    NSString *str = [NSString stringWithFormat:@"http://nmapi.%@",aedudomain];
    NSArray *picArray =[self.theTeacherSendRecordObj.Pictures componentsSeparatedByString:@"|"];
    self.addImageView.userInteractionEnabled = YES;
    for (int i = 0; i < picArray.count; i ++) {
        NSString *picUrl = [str stringByAppendingString:picArray[i]];
        if (![picArray[i] isEqualToString:@""]) {
        UIImageView *imageView = [[UIImageView alloc] init];
        [self.addImageView addSubview:imageView];
        // 计算位置
        int row = i / 3;
        int column = i % 3;
        CGFloat x = startX + column * (width + margin);
        CGFloat y = startY + row * (height + margin);
        imageView.frame = CGRectMake(x, y, width, height);
        
        // 事件监听
        imageView.tag = i + 1000;
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)]];
        [imageView setImageWithURL:[NSURL URLWithString:picUrl] placeholderImage:[UIImage imageNamed:@"defaultImage"]];
        
        // 内容模式
        imageView.clipsToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.addImageView.frame = CGRectMake(8, self.recordBackGroupView.bottom + 10, 304, y + 80);
        }
    }
    self.mainScrollView.contentSize = CGSizeMake(0, self.addImageView.bottom + 50 + 64 + 10);

}

#pragma mark -- 点击图片全屏放大

- (void)tapImage:(UITapGestureRecognizer *)tap
{
    NSArray *picArray =[self.theTeacherSendRecordObj.Pictures componentsSeparatedByString:@"|"];
    NSUInteger count = picArray.count;
    
    if (count && count > 0) {
        // 1.封装图片数据
        NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
        for (int i = 0; i < count; i ++) {
            MJPhoto *photo = [[MJPhoto alloc] init];
            photo.srcImageView = (UIImageView*)[self.addImageView viewWithTag:(i+ 1000)]; // 来源于哪个UIImageView
            [photos addObject:photo];
        }
        // 2.显示相册
        MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
        browser.currentPhotoIndex = tap.view.tag - 1000; // 弹出相册时显示的第一张图片是？
        browser.photos = photos; // 设置所有的图片
        [browser show];
    }
}

#pragma mark -- 展示录音

- (void)initRecords
{
    CGFloat width = SCREENWIDTH - 20;
    CGFloat height = 44;
    CGFloat margin = 10;
    CGFloat startY = 0;
    
    for (UIView *subView in [self.recordBackGroupView subviews]) {
        if ([subView isKindOfClass:[UIView class]]) {
            [subView removeFromSuperview];
        }
    }
    NSArray *audioArray = [self.theTeacherSendRecordObj.Audioes componentsSeparatedByString:@"|"];
    self.recordBackGroupView.userInteractionEnabled = YES;
    for (int i = 0; i < audioArray.count; i ++) {
        NSString *audioStr = audioArray[i];
        NSRange range =[audioStr rangeOfString:@"&&"];
        if(range.length != 0){
            UIView *View = [[UIView alloc] init];
            View.backgroundColor = theLoginButtonColor;
            View.layer.cornerRadius = 2.0f;
            [self.recordBackGroupView addSubview:View];
            [self.audioViews addObject:View];
            // 计算位置
            int row = i/1;
            CGFloat y = startY + row * (height + margin) + 10;
            View.frame = CGRectMake(0, y, width, height);
            View.tag = i;
            View.userInteractionEnabled = YES;
            
            UIButton *bofangButton = [UIButton buttonWithType:UIButtonTypeCustom];
            bofangButton.frame = CGRectMake(25, 5, 130, 34);
            [bofangButton setTitle:@"点击播放语音" forState:UIControlStateNormal];
            bofangButton.tag = i;
            [bofangButton addTarget:self action:@selector(clickRecord:) forControlEvents:UIControlEventTouchUpInside];
            [View addSubview:bofangButton];
            [self.audioButtons addObject:bofangButton];
            
            UIImageView *boFangImage = [[UIImageView alloc] init];
            boFangImage.frame = CGRectMake(8, 12, 16, 19);
            [boFangImage setImage:[UIImage imageNamed:@"bofang"]];
            [View addSubview:boFangImage];
            [self.audioImages addObject:boFangImage];
            
            
            UILabel *recordTime = [[UILabel alloc] init];
            recordTime.frame = CGRectMake(SCREENWIDTH - 50, 12, 50, 21);

            NSString *timeStr = [audioStr substringFromIndex:(range.location + range.length)];
            recordTime.text = [NSString stringWithFormat:@"%@\"",timeStr];
            recordTime.textColor = [UIColor whiteColor];
            [View addSubview:recordTime];
            self.recordBackGroupView.frame = CGRectMake(8, _emojiLabel.bottom + 10, 304, y + 50);
        }
       
    }
    self.addImageView.top = self.recordBackGroupView.height + 92;
}

#pragma mark -- 点击播放

- (void)clickRecord:(UIButton *)sender
{
    
    NSArray *audioArray = [self.theTeacherSendRecordObj.Audioes componentsSeparatedByString:@"|"];
    NSString *audioStr = audioArray[sender.tag];
    NSRange range = [audioStr rangeOfString:@"&&"];
    if (range.length != 0) {
        NSString *auStr = [audioStr substringToIndex:range.location];
        NSString *str = [NSString stringWithFormat:@"http://nmapi.%@",aedudomain];
        NSString* urlstr = [FileDownload download:[str stringByAppendingString:auStr]];
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setCategory:AVAudioSessionCategoryPlayback error:nil];
        [session setActive:YES error:nil];
        NSURL *url = [NSURL URLWithString:urlstr];
        if ([self.audioPlayer isPlaying] && self.playFlag == sender.tag) {
            [self.audioPlayer stop];
            self.audioPlayer=nil;
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
            self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&playerError];
            self.audioPlayer.delegate = self;
            if (self.audioPlayer) {
                [self.audioPlayer setVolume:1];
                [self.audioPlayer prepareToPlay];
                [self.audioPlayer play];
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
                [UIView setAnimationDelegate:self];
                [UIView setAnimationDuration:0.3];
                [self.audioViews[sender.tag] setBackgroundColor:[UIColor colorWithRed:255.0/255 green:170.0/255 blue:23.0/255 alpha:1]];
                [UIView commitAnimations];
                [self.audioImages[sender.tag] setImage:[UIImage imageNamed:@"baofangluyin"]];
                [sender setTitle:@"正在播放语音..." forState:UIControlStateNormal];
            }else if (self.audioPlayer == NULL)
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
#pragma mark -- 引用内容
- (void)clickQuotationButton
{
     NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    if (self.theTeacherSendRecordObj.MsgContent) {
        [dic setObject:self.theTeacherSendRecordObj.MsgContent forKey:@"content"];
    }
    if (self.theTeacherSendRecordObj.Audioes) {
        [dic setObject:self.theTeacherSendRecordObj.Audioes forKey:@"audio"];
    }
    if (self.theTeacherSendRecordObj.Pictures) {
        [dic setObject:self.theTeacherSendRecordObj.Pictures forKey:@"pic"];
    }
   [[NSNotificationCenter defaultCenter]postNotificationName:@"quotationMessage" object:nil userInfo:dic];
   [self.navigationController popToViewController: [self.navigationController.viewControllers objectAtIndex: ([self.navigationController.viewControllers count] - 3)] animated:YES];
}

@end
