//
//  ToolcolorView.m
//  画图
//
//  Created by mj on 14-9-4.
//  Copyright (c) 2014年 Mr.Li. All rights reserved.
//

#import "ToolcolorView.h"

#define kButtonSpace 10

@interface ToolcolorView ()
{
    ToolColorBlock _toolColorBlock;
}
@property (strong, nonatomic) NSArray *colorArray;

@end

@implementation ToolcolorView

- (id)initWithFrame:(CGRect)frame afterToolColor:(ToolColorBlock)toolcolor
{
    _toolColorBlock = toolcolor;
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor lightGrayColor];
        _colorArray = [NSArray array];
        NSArray *array = @[[UIColor darkGrayColor],
                           [UIColor redColor],
                           [UIColor greenColor],
                           [UIColor blueColor],
                           [UIColor yellowColor],
                           [UIColor orangeColor],
                           [UIColor purpleColor],
                           [UIColor brownColor],
                           [UIColor blackColor]];

        _colorArray = array;
        [self creatColorButtons:array];
    }
    return self;
}

- (void)creatColorButtons:(NSArray *)array
{
    NSInteger count = array.count;
    CGFloat buttonW = (self.bounds.size.width - (array.count+1)*kButtonSpace)/count;
    CGFloat buttonH = self.bounds.size.height;
    for (NSInteger i = 0; i<array.count; i++) {
        UIColor *color = array[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        [button addTarget:self action:@selector(tagButton:) forControlEvents:UIControlEventTouchUpInside];
        CGFloat buttonX = kButtonSpace + i * (buttonW +kButtonSpace);
        button.frame = CGRectMake(buttonX, 5, buttonW, buttonH-10);
        [button setBackgroundColor:color];
        [self addSubview:button];
    }
}

- (void)tagButton:(UIButton *)button
{

    [UIView animateWithDuration:0.5f animations:^{
    self.frame = CGRectMake(0, -self.bounds.size.height, 320, 44);        
    }];
    _toolColorBlock(_colorArray[button.tag]);
//    NSLog(@"%@",_colorArray[button.tag]);
}
@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
