//
//  IWComposeSelectButton.m
//  9期微博
//
//  Created by teacher on 14-10-14.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "IWCustomBaseButton.h"

@implementation IWCustomBaseButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        // 1.设置图片居中
        self.imageView.contentMode = UIViewContentModeCenter;
        // 2.设置文字居中
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        // 3.设置文字大小
        self.titleLabel.font = [UIFont systemFontOfSize:13];
        // 4.设置文字颜色
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
    }
    return self;
}
// 告诉系统按钮的图片显示在什么位置
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageW = self.width;
    CGFloat imageH = self.height * 0.6;
    CGFloat imageX = 0;
    CGFloat imageY = 0;
    
    return CGRectMake(imageX, imageY, imageW, imageH);
}

// 告诉系统按钮的标题显示在什么位置
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleX = 0;
    CGFloat titleY = self.height * 0.6;
    CGFloat titleW = self.width;
    CGFloat titleH = self.height - titleY;
    return CGRectMake(titleX, titleY, titleW, titleH);
}

@end
