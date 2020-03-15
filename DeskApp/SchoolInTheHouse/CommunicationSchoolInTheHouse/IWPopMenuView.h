//
//  IWPopMenuView.h
//  9期微博
//
//  Created by teacher on 14-9-29.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
@class IWPopMenuView;

@protocol IWPopMenuViewDelegate <NSObject>

- (void)popMenuViewDidClick:(IWPopMenuView *)popMenuView;

@end

@interface IWPopMenuView : UIView
/**
 *  快速创建方法
 *
 *  @param contentView 需要显示的内容
 *
 *  @return 自定义菜单
 */
- (instancetype)initWithContentView:(UIView *)contentView;
+ (instancetype)popMenuViewWithContentView:(UIView *)contentView;

/**
 *  显示自定义菜单
 *
 *  @param rect 菜单显示的位置
 */
- (void)showWithRect:(CGRect)rect;
/**
 *  隐藏自定义菜单
 */
- (void)dismiss;
/**
 *  蒙版
 */
@property (nonatomic, weak) UIButton *cover;

@property (nonatomic, weak) id<IWPopMenuViewDelegate> delegate;
@end
