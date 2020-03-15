//
//  ToolView.m
//  画图
//
//  Created by mj on 14-9-4.
//  Copyright (c) 2014年 Mr.Li. All rights reserved.
//

#import "ToolView.h"
#import "ToolViewBtn.h"

#define BtnSpace 10

@interface ToolView ()
{
    ToolColorBlock _toolColorBlock;
    LineWidthBlock _lineWidthBlock;
}
@property (weak, nonatomic) ToolViewBtn *selectBtn;
@property (weak, nonatomic) ToolcolorView *colorView;
@property (weak, nonatomic) LineWidthView *lineWidthView;
@end

@implementation ToolView

- (id)initWithFrame:(CGRect)frame afterToolColor:(ToolColorBlock)toolColor afterLineWidthBlock:(LineWidthBlock)lineWidth
{
    _toolColorBlock = toolColor;
    _lineWidthBlock = lineWidth;
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor lightGrayColor];
        NSArray *BtnArray = @[@"颜色",@"线宽"];
        [self creatButton:BtnArray];
    }
    return self;
}

- (void)creatButton:(NSArray *)array
{
    CGFloat btnWidth = (self.bounds.size.width-BtnSpace*array.count+1)/array.count;
    for (NSInteger i = 0; i<array.count; i++) {
        ToolViewBtn *button = [ToolViewBtn buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(BtnSpace + i*(BtnSpace + btnWidth), 5, btnWidth, self.bounds.size.height-10);
        button.tag = 1001+i;
        [button addTarget:self action:@selector(button:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:array[i] forState:UIControlStateNormal];
        [self addSubview:button];
    }
}

- (void)button:(ToolViewBtn *)sender
{
    if (_selectBtn != nil && _selectBtn != sender) {
        if (_colorView.frame.origin.y > 0.0f || _lineWidthView.frame.origin.y > 0.0f) {
            return;
        }
        _selectBtn.isSelectBtn = NO;
    }
    sender.isSelectBtn = YES;
    _selectBtn = sender;
    switch (sender.tag) {
        case 1001:
        {
            if (_colorView == nil) {
                ToolcolorView *colorview =[[ToolcolorView alloc] initWithFrame:CGRectMake(0, 0, 320, 44) afterToolColor:^(UIColor *color) {
                    _toolColorBlock(color);
                }];
                [self.superview addSubview:colorview];
                _colorView = colorview;
            }
            CGFloat colorViewY = CGRectGetMaxY(self.frame);
            if (_colorView.frame.origin.y>0.0f) {
                colorViewY = -CGRectGetMaxY(self.frame);
            }else{
                colorViewY = CGRectGetMaxY(self.frame);
            }
            if (_lineWidthView.frame.origin.y>0.0f) {
                colorViewY = -CGRectGetMaxY(self.frame);
            }
            [UIView animateWithDuration:0.5f animations:^{
                _colorView.frame = CGRectMake(0, colorViewY, 320, 44);
            }];
        }
            break;
        case 1002:
        {
            if (_lineWidthView == nil) {
                LineWidthView *lineWidView =[[LineWidthView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)afterLineWidthBlock:^(CGFloat lineFloat) {
                    _lineWidthBlock(lineFloat);
//                    NSLog(@"%f",lineFloat);
                }];
                [self.superview addSubview:lineWidView];
                _lineWidthView = lineWidView;
            }
            CGFloat lineWidViewY = CGRectGetMaxY(self.frame);
            if (_lineWidthView.frame.origin.y>0.0f) {
                lineWidViewY = -CGRectGetMaxY(self.frame);
            }else{
                lineWidViewY = CGRectGetMaxY(self.frame);
            }
            if (_colorView.frame.origin.y>0.0f) {
                lineWidViewY = -CGRectGetMaxY(self.frame);
            }

            [UIView animateWithDuration:0.5f animations:^{
                _lineWidthView.frame = CGRectMake(0, lineWidViewY, 320, 44);
            }];

        }
            break;
        default:
            break;
    }
}
@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
