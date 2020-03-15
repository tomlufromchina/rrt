//
//  TeacherHeaderView.m
//  RenrenTong
//
//  Created by aedu on 15/2/4.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "TeacherHeaderView.h"


@interface TeacherHeaderView ()
@property(nonatomic, weak)UIView *iv1;
@property(nonatomic, weak)UIView *iv2;
@property(nonatomic, strong)NSMutableArray *buttons;


@end
@implementation TeacherHeaderView

- (NSMutableArray *)buttons
{
    if (!_buttons) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addButtonWithName:@"按教师角色"];
        [self addButtonWithName:@"按教研组"];
        UIView *iv1 = [[UIView alloc]init];
        iv1.backgroundColor = [UIColor greenColor];
        self.iv1 = iv1;
        [self addSubview:iv1];
        
        UIView *iv2 = [[UIView alloc]init];
        iv2.backgroundColor = [UIColor grayColor];
        self.iv2 = iv2;
        [self addSubview:iv2];
    }
    return self;
    
}
- (void)addButtonWithName:(NSString *)buttonName
{
    {
        UIButton *button = [[UIButton alloc] init];
        [button setTitle:buttonName forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"timeline_retweet_background_highlighted"] forState:UIControlStateNormal];
        [self addSubview:button];
        [self.buttons addObject:button];
        button.tag = self.buttons.count;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}
- (void)buttonClick:(UIButton *)btn
{
    if (btn.tag == 1) {
        self.iv1.left = 0;
    }
    if (btn.tag == 2) {
        self.iv1.left = self.iv1.width;
    }
    if ([self.delegate respondsToSelector:@selector(didClickButton:)]) {
        [self.delegate didClickButton:btn];
    }
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
    int count = self.buttons.count;
    CGFloat btnWidth = SCREENWIDTH / count;
    CGFloat btnHeight = self.height;
    
    for (int i = 0; i < count; i++) {
        UIButton *btn = self.buttons[i];
        btn.width = btnWidth;
        btn.height = btnHeight;
        btn.top = 0;
        btn.left = i * btnWidth;
    }
    self.iv1.width = btnWidth;
    self.iv1.height = 2;
    self.iv1.top = btnHeight - 2;
    self.iv1.left = 0;
    
    self.iv2.width = 1;
    self.iv2.height = btnHeight;
    self.iv2.top = 0;
    self.iv2.left = btnWidth;
    
}



@end
