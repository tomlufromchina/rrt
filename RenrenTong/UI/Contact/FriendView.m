//
//  FriendView.m
//  RenrenTong
//
//  Created by aedu on 15/3/24.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "FriendView.h"

@implementation FriendView

- (instancetype)init
{
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        [self setup];
    }
    return self;
}
- (void)setup
{
    UIImageView *friendIv = [[UIImageView alloc]initWithFrame:CGRectMake(20, 20, 50, 50)];
    friendIv.layer.cornerRadius = 25.0;
    friendIv.clipsToBounds = YES;
    friendIv.image = [UIImage imageNamed:@"180"];
    self.friendIv = friendIv;
    [self addSubview:friendIv];
    UILabel *friendLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 30, 150, 30)];
    friendLabel.text = @"123";
    [self addSubview:friendLabel];
    self.friendLabel = friendLabel;
    UIButton *ZbButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREENWIDTH - 60, 20, 50, 50)];
    [ZbButton setBackgroundImage:[UIImage imageNamed:@"180"] forState:UIControlStateNormal];
    [self addSubview:ZbButton];
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(70, 80, SCREENWIDTH - 75, 1)];
    line1.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:line1];
    
    
    UIImageView *classIv = [[UIImageView alloc]initWithFrame:CGRectMake(20, 90, 50, 50)];
    classIv.layer.cornerRadius = 25.0;
    classIv.clipsToBounds = YES;
    classIv.image = [UIImage imageNamed:@"180"];
    [self addSubview:classIv];
    UILabel *classLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 100, 150, 30)];
    classLabel.text = @"123";
    [self addSubview:classLabel];
    self.classLabel = classLabel;
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(70, 150, SCREENWIDTH - 75, 1)];
    line2.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:line2];
    
    
    UIImageView *schoolIv = [[UIImageView alloc]initWithFrame:CGRectMake(20, 160, 50, 50)];
    schoolIv.layer.cornerRadius = 25.0;
    schoolIv.clipsToBounds = YES;
    schoolIv.image = [UIImage imageNamed:@"180"];
    [self addSubview:schoolIv];
    UILabel *schoolLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 170, SCREENWIDTH - 80, 30)];
    schoolLabel.text = @"123";
    self.schoolLabel = schoolLabel;
    [self addSubview:schoolLabel];
    UIView *line3 = [[UIView alloc]initWithFrame:CGRectMake(70, 220, SCREENWIDTH - 75, 1)];
    line3.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:line3];
    
   

}
- (void)setIsFollowed:(BOOL)IsFollowed
{
    _IsFollowed = IsFollowed;
    if (!self.IsFollowed) {
        UIButton *addButton = [[UIButton alloc]initWithFrame:CGRectMake(20, 240, SCREENWIDTH - 40, 40)];
        [addButton setTitle:@"添加到通讯录" forState:UIControlStateNormal];
        addButton.backgroundColor = theLoginButtonColor;
        [addButton addTarget:self action:@selector(addButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        addButton.layer.cornerRadius = 2.0;
        [self addSubview:addButton];
    }else if (self.IsFollowed) {
        UIButton *addButton = [[UIButton alloc]initWithFrame:CGRectMake(20, 240, SCREENWIDTH - 40, 40)];
        [addButton setTitle:@"发送消息" forState:UIControlStateNormal];
        addButton.backgroundColor = theLoginButtonColor;
        [addButton addTarget:self action:@selector(addButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        addButton.layer.cornerRadius = 2.0;
        [self addSubview:addButton];
        
        UIButton *phoneButton = [[UIButton alloc]initWithFrame:CGRectMake(20, 300, SCREENWIDTH - 40, 40)];
        [phoneButton setTitle:@"给他打电话" forState:UIControlStateNormal];
        phoneButton.backgroundColor = [UIColor colorWithRed:73/255.0 green:211/255.0 blue:242/255.0 alpha:1.0];
        [phoneButton addTarget:self action:@selector(phoneButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        phoneButton.layer.cornerRadius = 2.0;
        [self addSubview:phoneButton];
    }
}
- (void)addButtonClick:(UIButton *)btn
{
    
}
- (void)phoneButtonClick:(UIButton *)btn
{
    NSLog(@"phone");
}

@end
