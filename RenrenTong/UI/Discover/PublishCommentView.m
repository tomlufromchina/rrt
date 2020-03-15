//
//  PublishCommentView.m
//  RenrenTong
//
//  Created by aedu on 15/4/15.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "PublishCommentView.h"
@interface PublishCommentView()
{
    UITextView *commentText;
    UILabel *commentLabel;
    BOOL isShow;
}
@end

@implementation PublishCommentView
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}
-(id)init
{
    self = [super init];
    if (self) {
        [self initView];
    }
    return self;
}


-(void)initView
{
    self.frame = CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, 50);
    self.backgroundColor = [UIColor whiteColor];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 1)];
    lineView.backgroundColor = [UIColor grayColor];
    lineView.alpha = 0.4;
    [self addSubview:lineView];
    
    UIImageView *commentNumImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 50, 30)];
    commentNumImage.image = [UIImage imageNamed:@"dialogue_b"];
    [self addSubview:commentNumImage];
    commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    commentLabel.center = CGPointMake(commentNumImage.center.x - 10, commentNumImage.center.y);
    commentLabel.textAlignment = NSTextAlignmentCenter;
    commentLabel.textColor = [UIColor whiteColor];
    commentLabel.font = [UIFont systemFontOfSize:13];
    [self addSubview:commentLabel];
    
    
    
    commentText = [[UITextView alloc] initWithFrame:CGRectMake(80, 10, SCREENWIDTH - CGRectGetMaxX(commentNumImage.frame) - 110, 30)];
    commentText.delegate = self;
    commentText.font = [UIFont systemFontOfSize:15];
    commentText.text = @"发表评论";
    [self addSubview:commentText];
    
    UIImageView *inputLinImage = [[UIImageView alloc] initWithFrame:CGRectMake(commentText.frame.origin.x - 5, CGRectGetMaxY(commentText.frame), commentText.frame.size.width + 10, 3)];
    inputLinImage.image = [UIImage imageNamed:@"line"];
    [self insertSubview:inputLinImage belowSubview:commentText];
    
    
    UIButton *publishButton = [UIButton buttonWithType:UIButtonTypeCustom];
    publishButton.frame = CGRectMake(SCREENWIDTH - 90, 10, 70, 30);
    publishButton.backgroundColor = theLoginButtonColor;
    [publishButton setTitle:@"发表" forState:UIControlStateNormal];
    [publishButton addTarget:self action:@selector(publish) forControlEvents:UIControlEventTouchUpInside];
    publishButton.layer.masksToBounds = YES;
    publishButton.layer.cornerRadius = 3;
    [self addSubview:publishButton];
}
-(void)show{
    if (!isShow) {
        [UIView animateWithDuration:0.35 animations:^{
            self.center = CGPointMake(self.center.x, self.center.y - self.frame.size.height);
            isShow = YES;
        } completion:^(BOOL finished) {
            
        }];
    }
    
}
-(void)dismiss
{
    if (isShow) {
        [UIView animateWithDuration:0.35 animations:^{
            self.center = CGPointMake(self.center.x, self.center.y + self.frame.size.height);
            
        } completion:^(BOOL finished) {
            
        }];
    }
}
-(void)publish
{
    
}
-(void)updateCommentNumLabel:(NSString*)numString
{
    commentLabel.text = numString;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
