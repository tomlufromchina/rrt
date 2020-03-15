//
//  MsgDetailHeader.m
//  RenrenTong
//
//  Created by aedu on 15/2/9.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "MsgDetailHeader.h"

@implementation MsgDetailHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.msgLabel = [[UILabel alloc] init];
        self.msgLabel.font = [UIFont systemFontOfSize:16];
        self.msgLabel.text =@"你好";
        [self addSubview:self.msgLabel];
        
        
        self.timeLabel = [[UILabel alloc] init];
        self.timeLabel.font = [UIFont systemFontOfSize:14];
        self.timeLabel.text = @"20102-34-5";
        [self.timeLabel setTextColor:[UIColor lightGrayColor]];
        [self addSubview:self.timeLabel];
        
        self.msgIcon = [[UIImageView alloc] init];
        self.msgIcon.image = [UIImage imageNamed:@"mainicon-msg"];
        [self addSubview:self.msgIcon];
        
        self.consultTeacher = [[UIButton alloc]init];
        [self.consultTeacher setTitle:@"咨询老师" forState:UIControlStateNormal];
        self.consultTeacher.layer.cornerRadius = 2.0;
        self.consultTeacher.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.consultTeacher addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        self.consultTeacher.backgroundColor = theLoginButtonColor;
        [self addSubview:self.consultTeacher];
        
        self.line = [[UIView alloc]init];
        self.line.backgroundColor =  [UIColor colorWithRed:240/255.0f
                                                     green:240/255.0f
                                                      blue:240/255.0f
                                                     alpha:1];;
        [self addSubview:self.line];
        
    }
    return self;
}
- (void)btnClick:(UIButton *)btn
{
    if ([self.delagate respondsToSelector:@selector(consultTeacher)]) {
        [self.delagate consultTeacher];
    }
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.msgIcon.frame = CGRectMake(5, 5, 50, 50);
    self.msgLabel.frame = CGRectMake(70, 8, 100, 30);
    self.timeLabel.frame = CGRectMake(70, 28, 140, 30);
    self.consultTeacher.frame = CGRectMake(SCREENWIDTH - 80 - 15, 10, 80, 40);
    self.line.frame = CGRectMake(0, 59, SCREENWIDTH, 1);
}
@end
