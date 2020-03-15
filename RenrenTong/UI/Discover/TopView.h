//
//  TopView.h
//  RenrenTong
//
//  Created by aedu on 15/3/27.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TopViewFrame;

@protocol TopViewDelegate <NSObject>

- (void)btnClick:(int)tag;

@end
@interface TopView : UIView
@property(nonatomic, weak)UIButton *commentBtn;
@property(nonatomic, weak)UIButton *praiseBtn;
@property(nonatomic, strong)TopViewFrame *topViewFrame;
@property(nonatomic, weak)id<TopViewDelegate> delegate;
@end
