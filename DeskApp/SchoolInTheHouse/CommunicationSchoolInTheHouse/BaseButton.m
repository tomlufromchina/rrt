//
//  BaseButton.m
//  RenrenTong
//
//  Created by aedu on 15/1/31.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "BaseButton.h"

@implementation BaseButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        // 1.设置图片居中
        self.imageView.contentMode = UIViewContentModeCenter;
        // 2.设置文字居中
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        // 3.设置文字大小
        self.titleLabel.font = [UIFont systemFontOfSize:13];
        // 4.设置文字颜色
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    return self;
}
// 告诉系统按钮的图片显示在什么位置
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageW = self.width*0.3;
    CGFloat imageH = self.height;
    CGFloat imageX = 0;
    CGFloat imageY = 0;
    
    return CGRectMake(imageX, imageY, imageW, imageH);
}

// 告诉系统按钮的标题显示在什么位置
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleX = self.width * 0.3;
    CGFloat titleY = 0;
    CGFloat titleW = self.width - titleX;
    CGFloat titleH = self.height;
    return CGRectMake(titleX, titleY, titleW, titleH);
}
- (void)setHighlighted:(BOOL)highlighted
{
    
}


@end
