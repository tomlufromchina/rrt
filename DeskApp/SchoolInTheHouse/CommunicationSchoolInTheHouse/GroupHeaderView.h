//
//  GroupHeaderView.h
//  RenrenTong
//
//  Created by aedu on 15/2/4.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import <UIKit/UIKit.h>


@class IWTitleButton;

@protocol GroupHeaderViewDelegate <NSObject>

- (void)didClickButton:(IWTitleButton *)button;

@end
@interface GroupHeaderView : UIView
@property (nonatomic, weak) id<GroupHeaderViewDelegate> delegate;
@end
