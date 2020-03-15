//
//  GroupHeaderView.m
//  RenrenTong
//
//  Created by aedu on 15/2/4.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "GroupHeaderView.h"
#import "IWTitleButton.h"

@interface GroupHeaderView ()

@end

@implementation GroupHeaderView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addButtonWithName:@"来源"];
        [self addButtonWithName:@"分类"];
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
    CGFloat margin = 5;
    CGFloat btnWidth = (self.width - margin * (count + 1))/ count;
    CGFloat btnHeight = self.height;
    
    for (int i = 0; i < count; i++) {
        IWTitleButton *btn = self.subviews[i];
        btn.width = btnWidth;
        btn.height = btnHeight;
        btn.top = 0;
        btn.left = i * btnWidth + margin * (i + 1);
    }
    
}
@end
