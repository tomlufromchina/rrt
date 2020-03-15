//
//  LineWidthView.m
//  画图
//
//  Created by mj on 14-9-4.
//  Copyright (c) 2014年 Mr.Li. All rights reserved.
//

#import "LineWidthView.h"
#define kButtonSpace 10

@interface LineWidthView ()
{
    LineWidthBlock _lineWidthBlock;
}
@property (strong, nonatomic) NSArray *lineArray;

@end

@implementation LineWidthView

- (id)initWithFrame:(CGRect)frame afterLineWidthBlock:(LineWidthBlock)lineWidth
{
    _lineWidthBlock = lineWidth;
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor lightGrayColor];
        NSArray *array = @[[NSNumber numberWithFloat:3],
                           [NSNumber numberWithFloat:8],
                           [NSNumber numberWithFloat:15],
                           [NSNumber numberWithFloat:20],
                           [NSNumber numberWithFloat:27],
                           [NSNumber numberWithFloat:32],
                           [NSNumber numberWithFloat:39],
                           [NSNumber numberWithFloat:44],
                           [NSNumber numberWithFloat:50],];
        _lineArray = array;
        [self creatButtons:array];
    }
    return self;
}

- (void)creatButtons:(NSArray *)array
{
    NSInteger count = array.count;
    CGFloat buttonW = (self.bounds.size.width - (array.count+1)*kButtonSpace)/count;
    CGFloat buttonH = self.bounds.size.height;
    for (NSInteger i = 0; i<array.count; i++) {
        NSString *text = [array[i]stringValue];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        [button addTarget:self action:@selector(tagButton:) forControlEvents:UIControlEventTouchUpInside];
        CGFloat buttonX = kButtonSpace + i * (buttonW +kButtonSpace);
        button.frame = CGRectMake(buttonX, 5, buttonW, buttonH-10);
        [button setTitle:text forState:UIControlStateNormal];
        [self addSubview:button];
    }

}
- (void)tagButton:(UIButton *)button
{
    [UIView animateWithDuration:0.5f animations:^{
        self.frame = CGRectMake(0, -self.bounds.size.height, 320, 44);
    }];
    _lineWidthBlock([_lineArray[button.tag]floatValue]);
//    NSLog(@"%f",[_lineArray[button.tag]floatValue]);
}
@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
