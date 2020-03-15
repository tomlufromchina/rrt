//
//  TopicView.m
//  RenrenTong
//
//  Created by aedu on 15/4/23.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "TopicView.h"
#define HeadImageWight 40 //头像宽度
#define ViewSpaceing 10 //间隔
#define kStatusTableViewCellTitleFont ADAPTER_FONTSIZE(44)
#define kStatusTableViewCellOtherFont ADAPTER_FONTSIZE(36)
#define kStatusTableVievCellButtonFont ADAPTER_FONTSIZE(36)

@interface TopicView(){
    UIImageView *headImageView;
    UILabel *nameLabel;
    UILabel *dateLabel;
    MLEmojiLabel *messageLabel;
    
}
@end

@implementation TopicView
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initSubviews];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
    }
    return self;
}
-(id)init
{
    self = [super init];
    if (self) {
        [self initSubviews];
    }
    return self;
}

-(void)initSubviews
{
        //    头像
    headImageView =[[UIImageView alloc] initWithFrame:CGRectMake(ViewSpaceing, ViewSpaceing, HeadImageWight, HeadImageWight)];
    [self addSubview:headImageView];
    
    //    姓名
    nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(headImageView.frame) +ViewSpaceing, CGRectGetMinY(headImageView.frame), SCREENWIDTH - 60, HeadImageWight/2)];
    nameLabel.font = [UIFont systemFontOfSize:15];
    nameLabel.textColor = MainTextColor;
    nameLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:nameLabel];
    
    //    日期
    dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(headImageView.frame) +ViewSpaceing, CGRectGetMaxY(nameLabel.frame), SCREENWIDTH - 60, HeadImageWight/2)];
    dateLabel.textColor = GrayTextColor;
    dateLabel.font = [UIFont systemFontOfSize:13];
    dateLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:dateLabel];
    
    
    //内容
    messageLabel = [[MLEmojiLabel alloc] init];
    messageLabel.numberOfLines = 0;
    messageLabel.textColor = nameLabel.textColor;
    messageLabel.font = [UIFont systemFontOfSize:15];
    messageLabel.backgroundColor = [UIColor clearColor];
    messageLabel.lineBreakMode = NSLineBreakByCharWrapping;
    messageLabel.isNeedAtAndPoundSign = YES;
    [self addSubview:messageLabel];
}

-(void)setModel:(TheMyTendencyList *)model
{
    [headImageView setImageWithUrlStr:model.PictureUrl placholderImage:[UIImage imageNamed:@"defaultImage"]];
    nameLabel.text = model.UserName;
    dateLabel.text = model.DateTime;
    [messageLabel setEmojiText:model.Body];
    messageLabel.frame = CGRectMake(ViewSpaceing, CGRectGetMaxY(headImageView.frame) + ViewSpaceing, SCREENWIDTH - 2*ViewSpaceing, 0);
    [messageLabel sizeToFit];
    messageLabel.frame = CGRectMake(ViewSpaceing, CGRectGetMaxY(headImageView.frame) + ViewSpaceing, SCREENWIDTH - 2*ViewSpaceing, messageLabel.height);
    _hight = CGRectGetMaxY(messageLabel.frame) + ViewSpaceing;
    CGFloat startX = 0;
    CGFloat startY = 0;
    for (NSInteger i = 0; i < model.ImagesUrl.count; i++) {
        startX = (i%3)*(ViewSpaceing+ 90) +ViewSpaceing;
        startY = (i/3)*(ViewSpaceing+ 90) + CGRectGetMaxY(messageLabel.frame) + ViewSpaceing;
        UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(startX , startY, 90, 90)];
        [view setImageWithUrlStr:[model.ImagesUrl objectAtIndex:i] placholderImage:[UIImage imageNamed:@"defaultImage"]];

        [self addSubview:view];
        if (i == model.ImagesUrl.count-1) {
            _hight = CGRectGetMaxY(view.frame) + ViewSpaceing;
        }
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
