//
//  BootView.h
//  RenrenTong
//
//  Created by aedu on 15/3/30.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CommentView;
@protocol BootViewDelegate <NSObject>
- (void)moreComment:(int)tag;

@end
@class BootViewFrame;
@interface BootView : UIView
@property (nonatomic, weak) UIButton *moreBtn;
@property(nonatomic, strong)BootViewFrame *bootViewFrame;
@property (nonatomic, weak) CommentView *commentView;
@property(nonatomic, weak)id<BootViewDelegate> delagete;
@end
