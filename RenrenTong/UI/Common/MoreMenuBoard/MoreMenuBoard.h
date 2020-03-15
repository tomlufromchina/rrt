//
//  MoreMenuBoard.h
//  RenrenTong
//
//  Created by jeffrey on 14-8-13.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MoreMenuBoardDelegate <NSObject>

@optional
- (void)itemClicked:(int)index; //1,2,3,4,5

@end

@interface MoreMenuBoard : UIView

@property (weak, nonatomic) id<MoreMenuBoardDelegate> delegate;

@end
