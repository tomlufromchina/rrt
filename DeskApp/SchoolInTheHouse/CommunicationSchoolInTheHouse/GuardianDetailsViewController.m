//
//  GuardianDetailsViewController.m
//  RenrenTong
//
//  Created by 符其彬 on 15/2/6.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "GuardianDetailsViewController.h"
#import "MsgDetailHeader.h"
#import "NSString+TextSize.h"
#import "UIButton+WebCache.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#import "FileDownload.h"
#import "IMCache.h"
#import "ChatViewController.h"

#define AccPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"%@"]


@interface GuardianDetailsViewController ()<MsgDetailHeaderDelegate,AVAudioPlayerDelegate>
@property (nonatomic, weak) MsgDetailHeader *headerView;

@property (nonatomic, weak) UIScrollView *scrollView;

/**
 *  正文
 */
@property(nonatomic, weak)UILabel *context;
/**
 *  音频
 */
@property(nonatomic, weak)UIView *audioView;
/**
 *  图片
 */
@property(nonatomic, weak)UIView *picView;

@property(nonatomic, strong)NSMutableArray *audioButtons;
@property(nonatomic, strong)NSMutableArray *timeLabels;

@property(nonatomic, strong)AVPlayer *avPlayer;
@property(nonatomic, strong)AVPlayerItem *avPlayerItem;

@property(nonatomic, strong)AVAudioPlayer *audioPlayer;
@property(nonatomic, assign)int playFlag;



@end

@implementation GuardianDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.playFlag = -1;
    self.title = @"信息详情";
    self.view.backgroundColor = [UIColor whiteColor];
    self.audioButtons = [NSMutableArray array];
    self.timeLabels = [NSMutableArray array];
    
    MsgDetailHeader *headerView = [[MsgDetailHeader alloc]initWithFrame:CGRectMake(0, 64, SCREENWIDTH, 60)];
    if (self.PubUser) {
        headerView.msgLabel.text = self.PubUser;
    }else{
        headerView.msgLabel.text = [NSString stringWithFormat:@"%@(老师)",[self.message.PubUser objectForKey:@"UserName"]];
    }
    headerView.timeLabel.text = self.message.PubTime;
    if (self.PubUserID) {
        [headerView.msgIcon setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://images.%@/avatars/%@.jpg",aedudomain,self.PubUserID]] placeholderImage:[UIImage imageNamed:@"default"]];
    }else{
        [headerView.msgIcon setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://images.%@/avatars/%@.jpg",aedudomain,[self.message.PubUser objectForKey:@"UserId"]]] placeholderImage:[UIImage imageNamed:@"default"]];
    }
    headerView.msgIcon.layer.cornerRadius = 25.0;
    headerView.msgIcon.clipsToBounds = YES;
    headerView.delagate = self;
    self.headerView = headerView;
    headerView.userInteractionEnabled = YES;
    [self.view addSubview:headerView];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headerView.frame),SCREENWIDTH, SCREENHEIGHT - CGRectGetMaxY(self.headerView.frame))];
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.bounces = NO;
    self.scrollView = scrollView;
    [self.view addSubview:scrollView];
    [self createContentView];
    
}

#pragma mark - 创建消息内容
- (void)createContentView
{
    UILabel *context = [[UILabel alloc]init];
    context.text = self.message.MessageContent;
    context.numberOfLines = 0;
    context.font = [UIFont systemFontOfSize:16];
    CGSize textSize = [context.text sizeWithFont:context.font MaxSize:CGSizeMake(SCREENWIDTH - 2 * 15, MAXFLOAT)];
    context.frame = CGRectMake(15, 10, textSize.width, textSize.height);
    self.context = context;
    [self.scrollView addSubview:context];
    [self createAudio];
}
#pragma mark 创建音频视图
- (void)createAudio
{
    if (self.message.Audio) {
        UIView *audioView = [[UIView alloc]init];
        audioView.userInteractionEnabled = YES;
        self.audioView = audioView;
        CGFloat audioViewH = 0.0;
        NSArray *audioArray = [self.message.Audio[0] componentsSeparatedByString:@"|"];
        for (NSString *audioStr in audioArray) {
            NSRange range = [audioStr rangeOfString:@"&&"];
            if(range.length != 0){
                NSString *timeStr = [audioStr substringFromIndex:(range.location + range.length)];
                NSString *recordTime = [NSString stringWithFormat:@"%@\"",timeStr];
                [self addAudioButton:recordTime];
            }
        }if (![audioArray[0] isEqualToString:@""])
        {
            audioViewH = [self setAudioFrame:audioArray.count];
        }
        audioView.frame = CGRectMake(15, CGRectGetMaxY(self.context.frame), SCREENWIDTH - 2 * 15, audioViewH) ;
        [self.scrollView addSubview:audioView];
    }
    [self createPicView];
    
}
- (void)addAudioButton:(NSString *)time
{
    UIButton *button = [[UIButton alloc] init];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    [button setImage:[UIImage imageNamed:@"bofang"] forState:UIControlStateNormal];
    [button setTitle:@"点击播放语音" forState:UIControlStateNormal];
    button.backgroundColor = theLoginButtonColor;
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    button.imageEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0);
    [button setTitleColor:[UIColor lightTextColor] forState:UIControlStateNormal];
    [self.audioView addSubview:button];
    [self.audioButtons addObject:button];
    button.tag = self.audioButtons.count;
    [button addTarget:self action:@selector(audioClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel *timeLabel = [[UILabel alloc]init];
    timeLabel.text = time;
    [timeLabel setTextColor:[UIColor whiteColor]];
    timeLabel.font = [UIFont systemFontOfSize:15];
    [self.timeLabels addObject:timeLabel];
    [self.audioView addSubview:timeLabel];
    
}
#pragma mark - 设置音频按钮的frame
- (CGFloat)setAudioFrame:(int)count
{
    CGFloat margin = 15;
    CGFloat btnWidth = SCREENWIDTH - 2 * margin;
    CGFloat btnHeight = 40;
    
    CGFloat popH = count * (btnHeight + margin);
    for (int i = 0; i < count; i++) {
        CGFloat btnX = 0;
        CGFloat btnY = margin + (margin + btnHeight) * i;
        
        UIButton *btn = self.audioButtons[i];
        btn.frame = CGRectMake(btnX, btnY, btnWidth, btnHeight);
        
        
        UILabel *label = self.timeLabels[i];
        label.frame = CGRectMake(240, btnY, 50, btnHeight);
    }
    return popH;
    
}
- (void)audioClick:(UIButton *)btn
{
    NSArray *audioArray = [self.message.Audio[0] componentsSeparatedByString:@"|"];
    NSString *audioStr = audioArray[btn.tag - 1];
    NSRange range = [audioStr rangeOfString:@"&&"];
    if (range.length != 0) {
        NSString *auStr = [audioStr substringToIndex:range.location];
        NSString *str = [NSString stringWithFormat:@"http://nmapi.%@",aedudomain];
        NSString* urlstr = [FileDownload download:[str stringByAppendingString:auStr]];
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setCategory:AVAudioSessionCategoryPlayback error:nil];
        [session setActive:YES error:nil];
        NSURL *url = [NSURL URLWithString:urlstr];
        if ([self.audioPlayer isPlaying] && self.playFlag == btn.tag - 1) {
            [self.audioPlayer stop];
            self.audioPlayer=nil;
            btn.backgroundColor = theLoginButtonColor;
            [btn setImage:[UIImage imageNamed:@"bofang"] forState:UIControlStateNormal];
            [btn setTitle:@"点击播放语音" forState:UIControlStateNormal];
        }else{
        if (self.playFlag != -1) {
                for (int i = 0; i < self.audioButtons.count; i++) {
                    if (i == self.playFlag) {
                        UIButton *btn = self.audioButtons[i];
                        btn.backgroundColor = theLoginButtonColor;
                        [btn setImage:[UIImage imageNamed:@"bofang"] forState:UIControlStateNormal];
                        [btn setTitle:@"点击播放语音" forState:UIControlStateNormal];
                        break;
                    }
                }
        }
        self.playFlag = btn.tag - 1;
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
            [btn setBackgroundColor:[UIColor colorWithRed:255.0/255 green:170.0/255 blue:23.0/255 alpha:1]];
            [UIView commitAnimations];
            [btn setImage:[UIImage imageNamed:@"baofangluyin"] forState:UIControlStateNormal];
            [btn setTitle:@"正在播放语音..." forState:UIControlStateNormal];
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
            btn.backgroundColor = theLoginButtonColor;
            [btn setImage:[UIImage imageNamed:@"bofang"] forState:UIControlStateNormal];
            [btn setTitle:@"点击播放语音" forState:UIControlStateNormal];
            break;
        }
    }
}
- (void)createPicView
{
    if (self.message.Pic) {
        UIView *picView = [[UIView alloc]init];
        picView.userInteractionEnabled = YES;
        self.picView = picView;
        CGFloat picViewH = 0.0;
        NSArray *picArray =[self.message.Pic[0] componentsSeparatedByString:@"|"];
        for (NSString *str in picArray) {
            if (![str isEqualToString:@""])
            {
                NSString *str1 = [NSString stringWithFormat:@"http://nmapi.%@",aedudomain];
                NSString *UrlStr = [str1 stringByAppendingString:str];
                [self addPicImageView:UrlStr];
            }
        }
        if (![picArray[0] isEqualToString:@""])
        {
            picViewH = [self setPicViewFrame:picArray.count];
        }
        picView.frame = CGRectMake(15, CGRectGetMaxY(self.audioView.frame), SCREENWIDTH - 2 * 15, picViewH) ;
        [self.scrollView addSubview:picView];
        self.scrollView.contentSize = CGSizeMake(SCREENWIDTH, CGRectGetMaxY(self.picView.frame));
    }
}
#pragma mark - 创建图片视图
- (void)addPicImageView:(NSString *)picUrl
{
    UIImageView *iv = [[UIImageView alloc] init];
    iv.userInteractionEnabled = YES;
    [iv setImageWithURL:[NSURL URLWithString:picUrl] placeholderImage:[UIImage imageNamed:@"defaultImage"]];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClick:)];
    [iv addGestureRecognizer:tap];
    [self.picView addSubview:iv];
    iv.tag = self.picView.subviews.count;
}


#pragma mark - 设置图片按钮的frame
- (CGFloat)setPicViewFrame:(int)count
{
    int totalloc = 3;
    int m = count / totalloc;
    int n = count % 3;
    if (n != 0) {
        m = m + 1;
    }
    CGFloat margin = 15;
    CGFloat btnWidth = (SCREENWIDTH - (totalloc + 1) * margin) / totalloc;
    CGFloat btnHeight = btnWidth;
    CGFloat popH = m * btnHeight + (m + 1) * margin + 10;
    for (int i = 0; i < count; i++) {
        
        int row = i / totalloc;//行号
        int loc = i % totalloc;//列号
        CGFloat btnX = (margin + btnWidth) * loc;
        CGFloat btnY = margin + (margin + btnHeight) * row;
        
        UIImageView *iv = self.picView.subviews[i];
        iv.frame = CGRectMake(btnX, btnY, btnWidth, btnHeight);
    }
    return popH;
    
}
- (void)imageClick:(UITapGestureRecognizer *)iv
{
    int count = self.picView.subviews.count;
        // 1.封装图片数据
        NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
        for (int i = 0; i < count; i ++) {
            MJPhoto *photo = [[MJPhoto alloc] init];
            UIImageView *imageView = self.picView.subviews[i];
            photo.srcImageView = imageView;
            [photos addObject:photo];
        }
        // 2.显示相册
        MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
        browser.currentPhotoIndex = iv.view.tag - 1; // 弹出相册时显示的第一张图片是？
        browser.photos = photos; // 设置所有的图片
        [browser show];
    
}
- (void)consultTeacher
{
    [self.navigationController pushViewController:ChatVCID
                                   withStoryBoard:MessageStoryBoardName
                                        withBlock:^(UIViewController *viewController) {
                                            ChatViewController *vc = (ChatViewController*)viewController;
                                            if (self.PubUserID) {
                                                vc.UserId=[NSString stringWithFormat:@"%@",self.PubUserID];
                                                vc.UserName = self.PubUser;
                                            }else{
                                                vc.UserId = [NSString stringWithFormat:@"%@",[self.message.PubUser objectForKey:@"UserId"]];
                                                vc.UserName = [self.message.PubUser objectForKey:@"UserName"];
                                            }
                                        }];
}


@end
