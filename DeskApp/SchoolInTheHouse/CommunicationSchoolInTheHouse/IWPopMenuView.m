//
//  IWPopMenuView.m
//  9期微博
//
//  Created by teacher on 14-9-29.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "IWPopMenuView.h"


@interface IWPopMenuView()
/**
 *  需要显示的内容
 */
@property (nonatomic, strong) UIView *contentView;

/**
 *  用于显示内容的容器
 */
@property (nonatomic, weak) UIView *containerView;
@end

@implementation IWPopMenuView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 1.创建蒙版
        UIButton *cover = [[UIButton alloc] init];
        cover.backgroundColor  = [UIColor whiteColor];
        cover.alpha = 0.7;
        [cover addTarget:self action:@selector(coverClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cover];
        self.cover = cover;
        
        // 2.创建菜单
       UIView *containerView = [[UIView alloc] init];
       [self addSubview:containerView];
        self.containerView = containerView;
    }
    return self;
}

- (instancetype)initWithContentView:(UIView *)contentView
{
    if (self = [super init]) {
        // 保存需要显示的内容
        self.contentView = contentView;
    }
    return self;
}

+ (instancetype)popMenuViewWithContentView:(UIView *)contentView
{
    return [[self alloc] initWithContentView:contentView];
}

- (void)showWithRect:(CGRect)rect
{
    // 1.获取window
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    // 2.设置当前View(自定义菜单)的frame
    self.frame = window.bounds;
    
    // 3.调整内容的位置
    CGFloat contentX = 0;
    CGFloat contentY = 0;
    CGFloat margin = contentX;
    CGFloat contentW = rect.size.width - 2 * margin;
    CGFloat contentH = rect.size.height - contentY - 10;
    self.contentView.frame = CGRectMake(contentX, contentY, contentW, contentH);
    
    // 3.添加需要显示的内容到容器中
    [self.containerView addSubview:self.contentView];
    
    // 4.设置容器的frame
    self.containerView.frame = rect;
    
    // 5.将当前View添加到window中
    [window addSubview:self];
}

- (void)dismiss
{
    // 将自己从window中移除
    [self removeFromSuperview];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    // 设置蒙版的frame
    self.cover.frame = CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT);
}

- (void)coverClick:(UIButton *)cover
{
    
    if ([self.delegate respondsToSelector:@selector(popMenuViewDidClick:)]) {
        [self.delegate popMenuViewDidClick:self];
    }
    [self dismiss];
}
@end
