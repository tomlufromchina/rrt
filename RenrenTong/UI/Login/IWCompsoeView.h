//
//  IWCompsoeView.h
//  9期微博
//
//  Created by teacher on 14-10-14.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    IWComposeButtonTypeSina,    //新浪
    IWComposeButtonTypeQzone,   //QQ空间
    IWComposeButtonTypeWenXin,  //微信

} IWComposeButtonType;


@class IWCompsoeView;

@protocol IWCompsoeViewDelegate <NSObject>

- (void)compsoeView:(IWCompsoeView *)compsoeView didClickType:(IWComposeButtonType)type;

@end

@interface IWCompsoeView : UIView

/**
 *  显示菜单
 */
- (void)show;
/**
 *  隐藏菜单
 */
- (void)dismiss;

@property (nonatomic, weak) id<IWCompsoeViewDelegate> delegate;
@end
