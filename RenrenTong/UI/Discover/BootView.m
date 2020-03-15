//
//  BootView.m
//  RenrenTong
//
//  Created by aedu on 15/3/30.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "BootView.h"
#import "NSString+TextSize.h"
#import "BootViewFrame.h"
#import "PraiseUsers.h"
#import "Microblog.h"
#import "CommentView.h"


@interface BootView()
@property(nonatomic, weak)UIImageView *iconView;
@property (nonatomic, weak) UIView *line;



@end

@implementation BootView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        UIImageView *iconView = [[UIImageView alloc]init];
        [self addSubview:iconView];
        self.iconView = iconView;
        self.iconView.image = [UIImage imageNamed:@"zz-"];
        
        UIView *line = [[UIView alloc] init];
        [self addSubview:line];
        self.line = line;
        line.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
        
        UIButton *moreBtn = [[UIButton alloc] init];
        [self addSubview:moreBtn];
        self.moreBtn = moreBtn;
        [moreBtn addTarget:self action:@selector(more:) forControlEvents:UIControlEventTouchUpInside];
        [moreBtn setTitle:@"更多评论" forState:UIControlStateNormal];
        [moreBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        moreBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        
        CommentView *commentView = [[CommentView alloc] init];
        [self addSubview:commentView];
        self.commentView = commentView;
    }
    return self;
}
-(void)setBootViewFrame:(BootViewFrame *)bootViewFrame
{
    _bootViewFrame = bootViewFrame;
    
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
    Microblog *micriblog = self.bootViewFrame.microblog;
    NSArray *array = [NSArray array];
    CGFloat iconW = 35;
    int count = micriblog.PraiseCount;
    if (count > 3) {
        NSRange range = NSMakeRange(0, 3);
        array = [micriblog.PraiseUsers subarrayWithRange:range];
        UILabel *lable = [[UILabel alloc]init];
        lable.text = [NSString stringWithFormat:@"等%d人觉得很赞",micriblog.PraiseCount];
        lable.frame = CGRectMake(3 * iconW + 50, 10, 100, 20);
        lable.font = [UIFont systemFontOfSize:15];
        [self addSubview:lable];
    }else if(count > 0 & count <= 3)
    {
        array = micriblog.PraiseUsers;
    }
    else if(count == 0)
    {
        array = nil;
    }
    for (int i = 0; i < array.count; i++) {
        PraiseUsers *praiseUser = array[i];
        UIImageView *icon = [[UIImageView alloc]init];
        icon.layer.cornerRadius = 17.0;
        icon.clipsToBounds = YES;
        [icon setImageWithURL:[NSURL URLWithString:praiseUser.PictureUrl] placeholderImage:[UIImage imageNamed:@"default"]];
        CGFloat iconX = (iconW + 5) * i + 35;
        icon.frame = CGRectMake(iconX, 3, iconW, iconW);
        [self addSubview:icon];
    }
    self.commentView.commentArray = micriblog.CommentCentent;
    
}
/**
 *  设置frame
 */
-  (void)setupFrame
{
    // 1.设置自己的frame
    self.frame = self.bootViewFrame.frame;
    
    // 1.设置头像
    self.iconView.frame = self.bootViewFrame.iconF;
    self.line.frame = self.bootViewFrame.lineF;
    if(self.bootViewFrame.microblog.CommentCentent.count > 0)
    self.moreBtn.frame = self.bootViewFrame.moreCommmentBtnF;
    self.commentView.frame = self.bootViewFrame.CommmentF;
    
}
- (void)more:(UIButton *)btn
{
    if ([self.delagete respondsToSelector:@selector(moreComment:)]) {
        [self.delagete moreComment:btn.tag];
    }
}



@end
