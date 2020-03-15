//
//  DetectionView.h
//  RenrenTong
//
//  Created by 符其彬 on 15/3/23.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    IWComposeButtonTypeSendWeiBo,    //发微博
    IWComposeButtonTypeSendRecod,   //写日志
    IWComposeButtonTypeSendPhotos,
} IWComposeButtonType;


@class DetectionView;
@protocol DetectionViewDelegate <NSObject>

- (void)compsoeView:(DetectionView *)compsoeView didClickType:(IWComposeButtonType)type;
@end
@interface DetectionView : UIView
/**
 *  显示菜单
 */
- (void)show;
/**
 *  隐藏菜单
 */
- (void)dismiss;

@property (nonatomic, weak) id<DetectionViewDelegate> delegate;
@end
