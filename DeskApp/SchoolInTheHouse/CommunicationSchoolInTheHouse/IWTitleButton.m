//
//  IWTitleButton.m
//  9期微博
//
//  Created by teacher on 14-9-29.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "IWTitleButton.h"

// 图片的高度
#define IWTilteButtonImageWidth 30

@implementation IWTitleButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 1.设置按钮文本的颜色
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        // 2.设置按钮上的图片高亮不自动调整
        self.adjustsImageWhenHighlighted = NO;
        // 3.设置图片居中显示
        self.imageView.contentMode = UIViewContentModeCenter;
        // 4.设置文本居中显示
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        // 3.设置文字大小
        self.titleLabel.font = [UIFont systemFontOfSize:13];
    }
    return self;
}


- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleX = 0;
    CGFloat titleY = 0;
    CGFloat titleW = self.width - IWTilteButtonImageWidth;
    CGFloat titleH = self.height;
    return CGRectMake(titleX, titleY, titleW, titleH);
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageX = self.width - IWTilteButtonImageWidth - 8;
    CGFloat imageY = 0;
    CGFloat imageW = IWTilteButtonImageWidth;
    CGFloat imageH = self.height;
    return CGRectMake(imageX, imageY, imageW, imageH);
}

@end
