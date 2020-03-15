//
//  TopView.m
//  RenrenTong
//
//  Created by aedu on 15/3/27.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "TopView.h"
#import "Microblog.h"
#import "IWPhotosView.h"
#import "NSString+TextSize.h"
#import "TopViewFrame.h"

// 昵称字体
#define NameFont [UIFont systemFontOfSize:15]
// 时间
#define TimeFont [UIFont systemFontOfSize:13]
// 正文
#define TextFont [UIFont systemFontOfSize:16]

@interface TopView()
@property(nonatomic, weak)UIImageView *iconView;
@property(nonatomic, weak)UILabel *nameLabel;
@property(nonatomic, weak)UILabel *timeLabel;
@property(nonatomic, weak)UILabel *contentLabel;


@property (nonatomic, weak) IWPhotosView *photosView;
@property (nonatomic, weak) UIView *line;
@end

@implementation TopView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        
        
        /** 1.头像 */
        UIImageView *iconView = [[UIImageView alloc] init];
        [self addSubview:iconView];
        self.iconView = iconView;
        self.iconView.layer.cornerRadius = 20.0;
        self.iconView.clipsToBounds = YES;

        
        /** 2.昵称 */
        UILabel *nameLabel = [[UILabel alloc] init];
        [self addSubview:nameLabel];
        self.nameLabel = nameLabel;
        nameLabel.font = NameFont;
        
        
        /** 3.时间 */
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.textColor = [UIColor lightGrayColor];
        [self addSubview:timeLabel];
        self.timeLabel = timeLabel;
        timeLabel.font = TimeFont;
        
        /** 4.正文\内容 */
        UILabel *contentLabel = [[UILabel alloc] init];
        contentLabel.font = TextFont;
        contentLabel.numberOfLines = 0;
        [self addSubview:contentLabel];
        self.contentLabel = contentLabel;
        
        /** 5.配图容器*/
        IWPhotosView *photosView = [[IWPhotosView alloc] init];
        [self addSubview:photosView];
        self.photosView = photosView;
        
        /** 7.评论*/
        UIButton *commentBtn = [[UIButton alloc] init];
        [commentBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:commentBtn];
        self.commentBtn = commentBtn;
        [commentBtn setImage:[UIImage imageNamed:@"pl-"] forState:UIControlStateNormal];

        
        /** 9.点赞*/
        UIButton *praiseBtn = [[UIButton alloc] init];
        [praiseBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:praiseBtn];
        self.praiseBtn = praiseBtn;
        [praiseBtn setImage:[UIImage imageNamed:@"zz-"] forState:UIControlStateNormal];
        
        
        
        
        /** 10.线*/
        UIView *line = [[UIView alloc] init];
        [self addSubview:line];
        self.line = line;
        line.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];;
        

    }
    return self;
}
- (void)btnClick:(UIButton *)btn
{
    if (btn.tag >= 1000) {
        [btn setImage:[UIImage imageNamed:@"dz-"] forState:UIControlStateNormal];
        btn.userInteractionEnabled = NO;
    }
    if ([self.delegate respondsToSelector:@selector(btnClick:)]) {
        [self.delegate btnClick:btn.tag];
    }
}
- (void)setTopViewFrame:(TopViewFrame *)topViewFrame
{
    _topViewFrame = topViewFrame;
    // 1.设置数据
    [self setupData];
    // 2.设置frame
    [self setupFrame];
}
/**
 *  设置数据
 */
-  (void)setupData
{
    // 1.获取微博模型
    Microblog *micriblog = self.topViewFrame.microblog;
    
    // 1.设置头像
    NSURL *url = [NSURL URLWithString:micriblog.PictureUrl];
    [self.iconView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"default"]];
    // 2.设置昵称
    self.nameLabel.text = micriblog.UserName;
    
    // 3.设置时间
    self.timeLabel.text = micriblog.DateTime;
    // 5.设置正文
    self.contentLabel.text = micriblog.Body;
    if(micriblog.IsPraise)
    {
        [self.praiseBtn setImage:[UIImage imageNamed:@"dz-"] forState:UIControlStateNormal];
        self.praiseBtn.userInteractionEnabled = NO;
    }
    
    // 6.设置配图数据
    self.photosView.picUrls =  micriblog.ImagesUrl;
    
}
/**
 *  设置frame
 */
-  (void)setupFrame
{
    Microblog *micriblog = self.topViewFrame.microblog;
    // 1.设置自己的frame
    self.frame = self.topViewFrame.frame;
    
    // 1.设置头像
    self.iconView.frame = self.topViewFrame.iconViewF;
    // 2.设置昵称
    self.nameLabel.frame = self.topViewFrame.nameLabelF;
    
    self.timeLabel.frame = self.topViewFrame.timeLableF;
    
    
    // 6.设置正文
    self.contentLabel.frame = self.topViewFrame.contentLabelF;
    
    // 7.设置配图的frame
    self.photosView.frame = self.topViewFrame.photosViewF;

    self.commentBtn.frame = self.topViewFrame.commentBtnF;
    self.praiseBtn.frame = self.topViewFrame.prasieBtnF;
    if (micriblog.PraiseCount > 0 || micriblog.CommentCount > 0) {
        self.line.frame = self.topViewFrame.lineF;
    }
    
    
}
@end
