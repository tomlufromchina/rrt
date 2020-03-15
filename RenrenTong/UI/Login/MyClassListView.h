//
//  MyClassListView.h
//  RenrenTong
//
//  Created by 符其彬 on 15/3/30.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    IWComposeButtonTypeSendTabulation,   //写文章
    IWComposeButtonTypeSendAlbum,       // 传相片
    
} IWComposeButtonType;


@class MyClassListView;
@protocol MyClassListViewDelegate <NSObject>

- (void)compsoeView:(MyClassListView *)compsoeView didClickType:(IWComposeButtonType)type;
@end

@interface MyClassListView : UIView

/**
 *  显示菜单
 */
- (void)show;
/**
 *  隐藏菜单
 */
- (void)dismiss;

@property (nonatomic, weak) id<MyClassListViewDelegate> delegate;

@end
