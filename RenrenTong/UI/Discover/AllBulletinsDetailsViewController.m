//
//  AllBulletinsDetailsViewController.m
//  RenrenTong
//
//  Created by 符其彬 on 15/4/1.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "AllBulletinsDetailsViewController.h"
#import "IWCompsoeView.h"
#import "UMSocial.h"

@interface AllBulletinsDetailsViewController ()<IWCompsoeViewDelegate,UMSocialUIDelegate>
@property (nonatomic, strong) IWCompsoeView *cover;
@property (nonatomic, strong) NetWorkManager *netWorkManager;

@end

@implementation AllBulletinsDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"公告详情";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self.mainScrollView addSubview:self.emojiLabel];
    self.emojiLabel.frame = CGRectMake(10, self.readingLabel.bottom + 10, SCREENWIDTH - 20, 100);
    [_emojiLabel sizeToFit];

    self.titleLabel.text = self.titleStr;
    self.readingLabel.text = [NSString stringWithFormat:@"阅读(%@)",self.readingStr];
    self.timeLabel.text = self.timeStr;
    // 初始化短信
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn setFrame:CGRectMake(0, 2, 43, 14)];
    [shareBtn setBackgroundImage:[UIImage imageNamed:@"FXXX-"] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(clickShareBtn) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:shareBtn];
//    self.navigationItem.rightBarButtonItem = barButton;
    
    self.mainScrollView.contentSize = CGSizeMake(0,  _emojiLabel.height + 74 + 20);
}

- (MLEmojiLabel *)emojiLabel
{
    if (!_emojiLabel) {
        _emojiLabel = [[MLEmojiLabel alloc]init];
        _emojiLabel.numberOfLines = 0;
        _emojiLabel.font = [UIFont systemFontOfSize:14.0f];
        NSLog(@"%f",_emojiLabel.font.lineHeight);
        _emojiLabel.emojiDelegate = self;
        _emojiLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _emojiLabel.isNeedAtAndPoundSign = YES;
        
        [_emojiLabel setEmojiText:self.commentStr];
    }

    return _emojiLabel;
}

#pragma mark -- 分享按钮
#pragma mark --

- (void)clickShareBtn
{
    IWCompsoeView *cover = [[IWCompsoeView alloc] init];
    self.cover = cover;
    cover.delegate = self;
    [self.cover show];
}

- (void)compsoeView:(IWCompsoeView *)compsoeView didClickType:(IWComposeButtonType)type
{
    if (type == IWComposeButtonTypeSina) {
        [[UMSocialControllerService defaultControllerService] setShareText:@"分享内嵌文字   http://war.chinairn.com/news/20150319/162845802.shtml" shareImage:[UIImage imageNamed:@"10000.png"] socialUIDelegate:self];        //设置分享内容和回调对象
        [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
        
    }else if (type == IWComposeButtonTypeQzone)
    {
        [UMSocialData defaultData].extConfig.title = @"标题";
        [UMSocialData defaultData].extConfig.qzoneData.url = @"http://war.chinairn.com/news/20150319/162845802.shtml";
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQzone]
                                                            content:@"分享内嵌文字"
                                                              image:[UIImage imageNamed:@"10000.png"]
                                                           location:nil
                                                        urlResource:nil
                                                presentedController:self
                                                         completion:^(UMSocialResponseEntity *shareResponse){
                                                             if (shareResponse.responseCode == UMSResponseCodeSuccess) {
                                                                 [self showImage:nil status:@"分享成功"];
                                                             }
                                                         }];
        
    }else if (type == IWComposeButtonTypeWenXin)
    {
        [UMSocialData defaultData].extConfig.title = @"标题";
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = @"http://war.chinairn.com/news/20150319/162845802.shtml";
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline]
                                                            content:@"分享内嵌文字"
                                                              image:[UIImage imageNamed:@"10000.png"]
                                                           location:nil
                                                        urlResource:nil
                                                presentedController:self
                                                         completion:^(UMSocialResponseEntity *shareResponse){
                                                             if (shareResponse.responseCode == UMSResponseCodeSuccess) {
                                                                 [self showImage:nil status:@"分享成功"];
                                                             }
                                                         }];
    }
}

@end
