//
//  CommentCell.m
//  TableInTable
//
//  Created by jeffrey on 14-6-18.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "CommentCell.h"

@implementation CommentCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellContent:(Comment *)comment
{
    _comment = comment;
    
    //change the position
    
    CGRect rect = self.commentLabel.frame;
    self.commentLabel.frame = CGRectMake(rect.origin.x,
                                         rect.origin.y,
                                         rect.size.width,
                                         comment.match.height);
    
    
    //设置内容
//    [self.commentLabel registerCopyAction];
    
    __weak HBCoreLabel * wcontent=self.commentLabel;
    MatchParser* match=[_comment getMatch:^(MatchParser *parser,id data) {
        if (wcontent) {
                       Comment * weibo=(Comment*)data;
                      if (weibo.willDisplay) {
            dispatch_async(dispatch_get_main_queue(), ^{
                wcontent.match = parser;
            });
        }
        }
    } data:_comment];
    
    self.commentLabel.match = match;
    
}


+ (float)height:(Comment*)comment;
{
    return 5 + comment.match.height + 5;
}

@end
