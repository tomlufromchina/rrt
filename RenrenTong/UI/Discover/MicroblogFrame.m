//
//  MicroblogFrame.m
//  RenrenTong
//
//  Created by aedu on 15/3/27.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "MicroblogFrame.h"
#import "Microblog.h"
#import "TopViewFrame.h"
#import "BootViewFrame.h"

@implementation MicroblogFrame
- (void)setMicBlog:(Microblog *)micBlog
{
    _micBlog = micBlog;
    _topViewFrame = [[TopViewFrame alloc] init];
    _topViewFrame.microblog = _micBlog;
    
    // 2.计算底部视图Frame
    _bootViewFrame = [[BootViewFrame alloc] init];
    _bootViewFrame.microblog = _micBlog;;
    
    // 重新设置底部的Y
    CGRect tempFrame = _bootViewFrame.frame;
    tempFrame.origin.y = CGRectGetMaxY(_topViewFrame.frame);
    _bootViewFrame.frame = tempFrame;
    
    
    _cellHeight = CGRectGetMaxY(_bootViewFrame.frame);
}

@end
