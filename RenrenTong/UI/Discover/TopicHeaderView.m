//
//  TopicHeaderView.m
//  RenrenTong
//
//  Created by aedu on 15/3/26.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "TopicHeaderView.h"
#import "NSString+TextSize.h"

@implementation TopicHeaderView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *bgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREENHEIGHT, 40)];
        bgView.image = [UIImage imageNamed:@"ba-"];
        self.bgView = bgView;
        [self addSubview:bgView];
        
        UILabel *topicName = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, SCREENHEIGHT, 20)];
        topicName.text = @"123";
        [topicName setTextColor:[UIColor whiteColor]];
        self.topicName = topicName;
        [self addSubview:topicName];
        
        UILabel *topicDetail = [[UILabel alloc]init];
        self.topicDetail = topicDetail;
        self.topicDetail.numberOfLines = 0;
        self.topicDetail.font = [UIFont systemFontOfSize:16];
        [self addSubview:topicDetail];
    }
    return self;
}
- (void)setDetailString:(NSString *)detailString
{
    _detailString = detailString;
    self.topicDetail.text = detailString;
    CGSize textSize = [self.topicDetail.text sizeWithFont:self.topicDetail.font MaxSize:CGSizeMake(SCREENWIDTH - 2 * 15, MAXFLOAT)];
    self.topicDetail.frame = CGRectMake(15, 50, textSize.width, textSize.height);
}



@end
