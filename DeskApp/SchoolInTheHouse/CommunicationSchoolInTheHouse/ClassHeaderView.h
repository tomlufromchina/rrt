//
//  ClassHeaderView.h
//  RenrenTong
//
//  Created by aedu on 15/2/3.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import <UIKit/UIKit.h>
@class IWTitleButton;

@protocol ClassHeaderViewDelegate <NSObject>

- (void)didClickButton:(IWTitleButton *)button;

@end
@interface ClassHeaderView : UIView
@property (nonatomic, weak) id<ClassHeaderViewDelegate> delegate;
@end
