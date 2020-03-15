//
//  ClassHeaderView.m
//  RenrenTong
//
//  Created by aedu on 15/2/3.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "ClassHeaderView.h"
#import "IWTitleButton.h"

@interface ClassHeaderView ()

@end

@implementation ClassHeaderView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:230.0 / 255 green:230.0 / 255  blue:230.0 / 255  alpha:1.0];
        [self addButtonWithName:@"学段"];
        [self addButtonWithName:@"年级"];
        [self addButtonWithName:@"类型"];
    }
    return self;
    
}
- (void)addButtonWithName:(NSString *)buttonName
{
    {
        IWTitleButton *button = [[IWTitleButton alloc] init];
        [button setTitle:buttonName forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"navigationbar_arrow_down"] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"timeline_retweet_background_highlighted"] forState:UIControlStateNormal];
        [self addSubview:button];
        button.tag = self.subviews.count;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}
- (void)buttonClick:(IWTitleButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(didClickButton:)]) {
        [self.delegate didClickButton:btn];
    }
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
    int count = self.subviews.count;
    CGFloat margin = 1;
    CGFloat btnWidth = (self.width - margin * (count - 1))/ count;
    CGFloat btnHeight = self.height;
    
    for (int i = 0; i < count; i++) {
        IWTitleButton *btn = self.subviews[i];
        btn.width = btnWidth;
        btn.height = btnHeight;
        btn.top = 0;
        btn.left = i * btnWidth + margin * i;
    }
    
}


@end
