//
//  BootViewFrame.m
//  RenrenTong
//
//  Created by aedu on 15/3/30.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "BootViewFrame.h"
#import "Microblog.h"
#import "CommentView.h"

@implementation BootViewFrame
- (void)setMicroblog:(Microblog *)microblog
{
    _microblog = microblog;
    CGFloat moreBtnY = 0;
    CGFloat orginH = 0;
    if(microblog.PraiseCount > 0)
    {
        _iconF = CGRectMake(10, 10, 20, 20);
        _lineF = CGRectMake(0, 42, SCREENWIDTH, 1);
        moreBtnY = CGRectGetMaxY(_lineF) + 5;
        orginH = CGRectGetMaxY(_lineF)+ 10;
    }
    else
    {
        moreBtnY = 5;
    }
    _moreCommmentBtnF = CGRectMake(10, moreBtnY, 60, 30);
    CGSize commentSize = [CommentView sizeWithCount:microblog.CommentCentent];
    _CommmentF = (CGRect){{0, CGRectGetMaxY(_moreCommmentBtnF)+5}, commentSize};
    orginH = CGRectGetMaxY(_CommmentF)+ 10;
    
    _frame = CGRectMake(0, 0, SCREENWIDTH, orginH);
}
@end
