//
//  MenuView.m
//  RenrenTong
//
//  Created by 符其彬 on 15/3/24.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "MenuView.h"

@implementation MenuView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addMenus];
    }
    return self;
}

- (void)addMenus
{
    for (int i = 0; i < 6; i ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.top = i * 50 + 12.5;
        button.left = 50;
        button.width = SCREENWIDTH * 0.5 - 10;
        button.height = 60;
        button.tag = i;
        [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitle:[NSString stringWithFormat:@"%@",@""] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickOtherButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        UIImageView *titleImageView = [[UIImageView alloc] init];
        titleImageView.top = i * 50 + 27;
        titleImageView.left = 10;
        titleImageView.width = 29;
        titleImageView.height = 29;
        [titleImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d",i]]];
        [self addSubview:titleImageView];
        
        UIView *lineView1 = [[UIView alloc] init];
        lineView1.top = i * 50 + 15;
        lineView1.left = 0;
        lineView1.width = SCREENWIDTH * 0.5;
        lineView1.height = 1;
        lineView1.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self addSubview:lineView1];
    }
    // 切换账号按钮
    UIButton *switchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    switchButton.top = SCREENHEIGHT - 50;
    switchButton.left = 45;
    switchButton.width = SCREENWIDTH * 0.5 - 10;
    switchButton.height = 40;
    [switchButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [switchButton setTitle:@"切换账号" forState:UIControlStateNormal];
    [switchButton addTarget:self action:@selector(clickSwitchButton:) forControlEvents:UIControlEventTouchUpInside];
    [switchButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [self addSubview:switchButton];
    
    UIImageView *titleImageView1 = [[UIImageView alloc] init];
    titleImageView1.top = SCREENHEIGHT - 40;
    titleImageView1.left = 10;
    titleImageView1.width = 25;
    titleImageView1.height = 25;
    [titleImageView1 setImage:[UIImage imageNamed:@"side-exit"]];
    [self addSubview:titleImageView1];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.top = SCREENHEIGHT - 55;
    lineView.left = 0;
    lineView.width = SCREENWIDTH * 0.5;
    lineView.height = 1;
    lineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self addSubview:lineView];
}

@end
