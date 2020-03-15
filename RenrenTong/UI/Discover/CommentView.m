//
//  CommentView.m
//  RenrenTong
//
//  Created by aedu on 15/3/30.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "CommentView.h"
#import "CommentCentent.h"
#import "NSString+TextSize.h"

@implementation CommentView

- (void)setCommentArray:(NSArray *)commentArray
{
    _commentArray = commentArray;
    CGFloat y = 0;
    int count = commentArray.count;
    for (int i = 0 ; i < count; i++) {
        CommentCentent *comment = commentArray[i];
         NSString *commentString = @"";
        if(comment.ParentId > 0){
            commentString = [NSString stringWithFormat:@"%@回复%@:%@", comment.Author,comment.ToUserDisplayName,[NSString flattenHTML:comment.Body]];
            commentString = [commentString stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"@%@",comment.ToUserDisplayName] withString:@""];
        }
        else
        {
           commentString = [NSString stringWithFormat:@"%@:%@", comment.Author,[NSString flattenHTML:comment.Body]];
        }
        
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:commentString];
        NSRange nameRange = [commentString rangeOfString:comment.Author];
        NSRange toUserDisplayNamerange = [commentString rangeOfString:comment.ToUserDisplayName];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:nameRange];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:toUserDisplayNamerange];
        UILabel *commentLable = [[UILabel alloc]init];
        commentLable.attributedText = str;
        commentLable.font = [UIFont systemFontOfSize:15];
        commentLable.numberOfLines = 0;
        CGSize textSize = [commentString sizeWithFont:commentLable.font MaxSize:CGSizeMake(SCREENWIDTH - 2 * 15, MAXFLOAT)];
        commentLable.frame = CGRectMake(15, y, textSize.width, textSize.height);
        [self addSubview:commentLable];
        
        CGSize nameSize = [comment.Author sizeWithFont:commentLable.font MaxSize:CGSizeMake(SCREENWIDTH - 2 * 15, MAXFLOAT)];
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(15, y, nameSize.width, nameSize.height)];
        [self addSubview:btn];
        btn.tag = i;
        [btn addTarget:self action:@selector(toUserBtn:) forControlEvents:UIControlEventTouchUpInside];
        y = y + textSize.height + 5;
    }
}

+(CGSize)sizeWithCount:(NSArray *)array
{
    CGFloat y = 0;
    int count = array.count;
    for (int i = 0 ; i < count; i++) {
        CommentCentent *comment = array[i];
        NSString *commentString = @"";
        if(comment.ToUserDisplayName.length != 0){
            commentString = [NSString stringWithFormat:@"%@回复%@:%@", comment.Author,comment.ToUserDisplayName,[NSString flattenHTML:comment.Body]];
        }
        else
        {
            commentString = [NSString stringWithFormat:@"%@:%@", comment.Author,[NSString flattenHTML:comment.Body]];
        }
        CGSize textSize = [commentString sizeWithFont:[UIFont systemFontOfSize:15] MaxSize:CGSizeMake(SCREENWIDTH - 2 * 15, MAXFLOAT)];
        y = y + textSize.height + 5;
    }
    
    return CGSizeMake(SCREENWIDTH, y);
}
- (void)toUserBtn:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(toUserBtnClick:)]) {
        [self.delegate toUserBtnClick:btn.tag];
    }
}

@end
