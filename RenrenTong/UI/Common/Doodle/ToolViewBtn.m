//
//  ToolViewBtn.m
//  画图
//
//  Created by mj on 14-9-4.
//  Copyright (c) 2014年 Mr.Li. All rights reserved.
//

#import "ToolViewBtn.h"

@implementation ToolViewBtn

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setNeedsDisplay];
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    if (_isSelectBtn) {
        CGRect btnRect = CGRectMake(0, self.bounds.size.height-2, self.bounds.size.width, 2);
        [[UIColor redColor]set];
        UIRectFill(btnRect);
    }
}
- (void)setIsSelectBtn:(BOOL)isSelectBtn
{
    _isSelectBtn = isSelectBtn;
    [self setNeedsDisplay];
}
@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
