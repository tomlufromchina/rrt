//
//  TopViewFrame.m
//  RenrenTong
//
//  Created by aedu on 15/3/30.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "TopViewFrame.h"
#import "NSString+TextSize.h"
#import "Microblog.h"
#import "IWPhotosView.h"

#define CellPadding 10
#define NameFont [UIFont systemFontOfSize:15]

#define contextFont [UIFont systemFontOfSize:16]


@implementation TopViewFrame
- (void)setMicroblog:(Microblog *)microblog
{
    _microblog = microblog;
    // 1.计算顶部视图的frame
    // 1.1头像
    CGFloat iconViewX = CellPadding;
    CGFloat iconViewY = CellPadding;
    CGFloat iconViewW = 40;
    CGFloat iconViewH = 40;
    _iconViewF = CGRectMake(iconViewX, iconViewY, iconViewW, iconViewH);
    
    // 1.2昵称
    CGFloat nameLabelX = CGRectGetMaxX(_iconViewF) + CellPadding;
    CGFloat nameLabelY = iconViewY;
    // 获取用户
    
    // 获取用户昵称, 计算昵称的size
    CGSize nameSize = [microblog.UserName sizeWithFont:NameFont MaxSize:CGSizeMake(SCREENWIDTH - 50, 20)];
    _nameLabelF  = (CGRect){{nameLabelX, nameLabelY}, nameSize};
    
    _timeLableF = CGRectMake(nameLabelX, CGRectGetMaxY(_nameLabelF)+3, SCREENWIDTH - 50, 20);
    
    
    // 1.6正文
    CGFloat textLabelX = iconViewX;
    CGFloat textLabelY = CGRectGetMaxY(_iconViewF) + CellPadding;
    // 获取正文文本, 计算size
    CGSize textSize = [microblog.Body sizeWithFont:contextFont MaxSize:CGSizeMake(SCREENWIDTH - 2*CellPadding, MAXFLOAT)];
    _contentLabelF = (CGRect){{textLabelX, textLabelY}, textSize};
    
    
    // 1.7计算配图
    int count = microblog.ImagesUrl.count;
    // 原创微博的高度
    CGFloat line1H = 0;
    if (count != 0) {
        
        CGFloat photosViewX = textLabelX;
        CGFloat photosViewY = CGRectGetMaxY(_contentLabelF) + CellPadding;
        CGSize photosViewSize = [IWPhotosView sizeWithCount:count];
        _photosViewF = (CGRect){{photosViewX, photosViewY}, photosViewSize};
        line1H = CGRectGetMaxY(_photosViewF) + CellPadding;
        
    }else
    {
        // 没配图
        line1H = CGRectGetMaxY(_contentLabelF) + CellPadding;
    }
    
    _commentBtnF = CGRectMake(SCREENWIDTH / 2 + 2, line1H + 2, SCREENWIDTH / 4 - 2, 40);
    _prasieBtnF = CGRectMake(CGRectGetMaxX(_commentBtnF)+2 , line1H + 2, SCREENWIDTH / 4 - 4, 40);
    _lineF = CGRectMake(0, CGRectGetMaxY(_commentBtnF) + 1, SCREENWIDTH, 1);
    CGFloat originalX = 0;
    CGFloat originalY = 10;
    CGFloat originalW = SCREENWIDTH;
    _frame = CGRectMake(originalX, originalY, originalW, CGRectGetMaxY(_lineF)+2);
}
@end
