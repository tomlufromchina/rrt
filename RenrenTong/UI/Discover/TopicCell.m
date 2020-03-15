//
//  TopicCell.m
//  RenrenTong
//
//  Created by aedu on 15/3/27.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "TopicCell.h"
#import "MicroblogFrame.h"
#import "TopView.h"
#import "Microblog.h"
#import "BootView.h"

@interface TopicCell ()


@end

@implementation TopicCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        TopView *topView = [[TopView alloc]init];
        [self.contentView addSubview:topView];
        self.topView = topView;
        
        // 2.初始化底部视图
        BootView *bootView = [[BootView alloc] init];
        [self.contentView addSubview:bootView];
        self.bootView = bootView;
    }
    return self;
}
- (void)setMicroblogFrame:(MicroblogFrame *)microblogFrame
{
    _microblogFrame = microblogFrame;
    self.topView.topViewFrame = _microblogFrame.topViewFrame;
    self.bootView.bootViewFrame = _microblogFrame.bootViewFrame;
}
+ (instancetype)cellWithTabelView:(UITableView *)tableView
{
    // 1.定义一个标识
    static NSString *ID = @"cell";
    
    // 2.去缓存池中取出可循环利用的cell
    TopicCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if( cell!=nil )
    {
        cell = nil;
    }
    
    // 3.如果缓存中没有可循环利用的cell
    if (cell == nil) {
        cell = [[TopicCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
