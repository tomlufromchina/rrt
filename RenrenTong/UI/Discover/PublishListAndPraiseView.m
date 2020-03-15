//
//  PublishCommentView.m
//  RenrenTong
//
//  Created by aedu on 15/4/15.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "PublishListAndPraiseView.h"
#import "UIimageView+Animation.h"
#define Spacing 10

@interface PublishListAndPraiseView()<MLEmojiLabelDelegate>
{
    NSInteger praiseHeadImageNum; //点赞人数
    UILabel *praiseLabel;//点赞人数多于3人显示
    NSMutableArray *praiseImageAry; //点赞头像数组
    MLEmojiLabel *commentlale; //评论列表
    UIView *lineView1;
    BOOL hasComment;
}
@end
@implementation PublishListAndPraiseView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        praiseImageAry = [[NSMutableArray alloc] init];
        [self initView];
    }
    return self;
}
-(void)initView
{
    _praiseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _praiseButton.frame = CGRectMake(SCREENWIDTH - 70 , 0, 60, 44);
    _praiseButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    _praiseButton.contentEdgeInsets = UIEdgeInsetsMake(0,0, 0, 10);
    _praiseButton.titleLabel.font = [UIFont systemFontOfSize:15];
    
    UIImageView *praiseImage = [[UIImageView alloc] initWithFrame:CGRectMake(13, 15, 17.6, 16)];
    praiseImage.image = [UIImage imageNamed:@"praise-"];
    praiseImage.tag = 2;
    [_praiseButton setTitle:@"赞" forState:UIControlStateNormal];
    [_praiseButton setTitleColor:CommentViewTextColor forState:UIControlStateNormal];
    [_praiseButton addSubview:praiseImage];
    [_praiseButton addTarget:self action:@selector(praise:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_praiseButton];
    
    _remarkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _remarkButton.frame = CGRectMake(SCREENWIDTH - 140 , 0, 60, 44);
    _remarkButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    _remarkButton.contentEdgeInsets = UIEdgeInsetsMake(0,0, 0, 10);
    [_remarkButton setTitle:@"评" forState:UIControlStateNormal];
    [_remarkButton setTitleColor:CommentViewTextColor forState:UIControlStateNormal];
    _remarkButton.titleLabel.font = _praiseButton.titleLabel.font;
    UIImageView *remarkImage = [[UIImageView alloc] initWithFrame:CGRectMake(Spacing, 14, 17.6, 16)];
    remarkImage.image = [UIImage imageNamed:@"comment-"];
    [_remarkButton addSubview:remarkImage];
    [_remarkButton addTarget:self action:@selector(remark:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_remarkButton];
    
    lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_remarkButton.frame), SCREENWIDTH, 1)];
    lineView1.backgroundColor = [UIColor clearColor];
    [self addSubview:lineView1];
    
    self.frame = CGRectMake(0, self.frame.origin.y, SCREENWIDTH, CGRectGetMaxY(_remarkButton.frame) );
}

-(void)praise:(UIButton*)sender
{
    [self.delegate praise];
}

-(void)remark:(UIButton*)sender
{
    self.isReply = NO;
    [self.delegate remark];
}

-(void)getmoreComment:(UIButton*)sender
{
    [self.delegate getMoreComment];
}

-(void)addPraiseHeadImage:(NSString*)imageUrl IsupdateView:(BOOL)isupdateView
{
    if (isupdateView) {
       UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_remarkButton.frame) , SCREENWIDTH, 1)];
        lineView.backgroundColor = LineColor;
        [self addSubview:lineView];
        
        _remark = [[UIImageView alloc] initWithFrame:CGRectMake(Spacing, CGRectGetMaxY(lineView.frame)+Spacing, 20, 20)];
        _remark.image = [UIImage imageNamed:@"praised-"];
        [self addSubview:_remark];
        
        lineView1.frame =CGRectMake(0, CGRectGetMaxY(_remark.frame)+Spacing, SCREENWIDTH, 1);
        lineView1.backgroundColor = LineColor;
        if (hasComment) {
            _moreComment.frame = CGRectMake(_moreComment.frame.origin.x, CGRectGetMaxY(lineView1.frame), _moreComment.frame.size.width, _moreComment.frame.size.height);
            commentlale.frame = CGRectMake(commentlale.frame.origin.x, CGRectGetMaxY(_moreComment.frame) , commentlale.frame.size.width, commentlale.frame.size.height);
            self.frame = CGRectMake(0, self.frame.origin.y, SCREENWIDTH, CGRectGetMaxY(commentlale.frame) + Spacing);
        }else{
            self.frame = CGRectMake(0, self.frame.origin.y, SCREENWIDTH, CGRectGetMaxY(lineView1.frame) + Spacing);
        }
        
        praiseHeadImageNum = 0;
        for (UIImageView *view in praiseImageAry) {
            [view removeFromSuperview];
        }
    }
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_remark.frame)+ 10 + praiseHeadImageNum*35, 0, 30, 30)];
    image.center = CGPointMake(image.center.x, _remark.center.y);
    image.layer.cornerRadius = 30/2;
    image.layer.masksToBounds = YES;
    [image setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"default"] options:SDWebImageRefreshCached];
    [self addSubview:image];
    [praiseImageAry addObject:image];
    praiseHeadImageNum ++;
    
}
-(void)addPraiseNumLabel:(NSString*)text
{
    if (!praiseLabel) {
        praiseLabel = [[UILabel alloc] initWithFrame:CGRectMake(155, 0, SCREENWIDTH - 155, 25)];
        praiseLabel.textColor = GrayTextColor;
        praiseLabel.font = [UIFont systemFontOfSize:14];
        praiseLabel.center = CGPointMake(praiseLabel.center.x, _remark.center.y);
        [self addSubview:praiseLabel];
    }
    praiseLabel.text = text;
}

-(void)changePraiseImage
{
    UIImageView *imag = (UIImageView*)[_praiseButton viewWithTag:2];
    _ispraised = YES;
//    [UIImageView animationMethod:imag WithString:@"praised-"];
    [imag setImage:[UIImage imageNamed:@"praised-"]];
}

-(void)addCommentList:(NSString*)comment
{
    if (comment.length > 0) {
        if (!commentlale ) {
            _moreComment = [UIButton buttonWithType:UIButtonTypeCustom];
            CGSize size = [@"更多评论" sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
            _moreComment.frame = CGRectMake(Spacing, CGRectGetMaxY(lineView1.frame) + 5, size.width, 30);
            [_moreComment setTitle:@"更多评论" forState:UIControlStateNormal];
            [_moreComment setTitleColor:CommentViewTextColor forState:UIControlStateNormal];
            [_moreComment addTarget:self action:@selector(getmoreComment:) forControlEvents:UIControlEventTouchUpInside];
            _moreComment.titleLabel.font = [UIFont systemFontOfSize:15];
            [self addSubview:_moreComment];
             hasComment = YES;
            lineView1.backgroundColor = LineColor;
            commentlale = [[MLEmojiLabel alloc] initWithUserTextColor:CommentViewTextColor];
            commentlale.numberOfLines = 0;
            commentlale.font = [UIFont systemFontOfSize:15];
            commentlale.emojiDelegate = self;
            commentlale.lineBreakMode = NSLineBreakByCharWrapping;
            commentlale.isNeedAtAndPoundSign = YES;
            [self addSubview:commentlale];
        }
        [commentlale setEmojiText:comment];
        commentlale.frame = CGRectMake(Spacing, CGRectGetMaxY(_moreComment.frame), SCREENWIDTH - 2*Spacing, 0);
        [commentlale sizeToFit];
        // 重新设置高度
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, CGRectGetMaxY(commentlale.frame) + 5);
    }
    
}

- (void)mlEmojiLabel:(MLEmojiLabel*)emojiLabel didSelectLink:(NSString*)link withType:(MLEmojiLabelLinkType)type
{
    switch(type){
        case MLEmojiLabelLinkTypeUser:
        {
            NSLog(@"点击了用户:%@",link);
            NSLog(@"用户id为:%d",[MLEmojiLabel getUserid:link]);
            NSLog(@"index为:%d",[MLEmojiLabel getIndex:link]);
            NSLog(@"CommentIndex为:%d",[MLEmojiLabel getCommentID:link]);
            self.isReply = YES;
            [self.delegate selectToReply:[NSString stringWithFormat:@"%d",[MLEmojiLabel getUserid:link]]];
        }
            break;
        case MLEmojiLabelLinkTypeURL:
            NSLog(@"点击了链接:%@",link);
            break;
        case MLEmojiLabelLinkTypePhoneNumber:
            NSLog(@"点击了电话:%@",link);
            break;
        case MLEmojiLabelLinkTypeEmail:
            NSLog(@"点击了邮箱:%@",link);
            break;
        case MLEmojiLabelLinkTypeAt:
            NSLog(@"点击了用户%@",link);
            break;
        case MLEmojiLabelLinkTypePoundSign:
            NSLog(@"点击了话题%@",link);
            break;
        default:
            NSLog(@"点击了不知道啥:%@",link);
            break;
    }
    
}

- (void)hidenPraiseView
{
    [_praiseButton removeFromSuperview];
    [_remarkButton removeFromSuperview];
    self.height = 0;
    lineView1.frame = CGRectMake(0, 0, SCREENWIDTH, 1);
}

@end
