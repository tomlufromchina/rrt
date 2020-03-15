//
//  DynamicCellTableViewCell.h
//  RenrenTong
//
//  Created by aedu on 15/4/29.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AllTendency.h"

@class DynamicCell;

@protocol DynamicCellDelegate<NSObject>

-(void)DynamicPraise:(DynamicCell*)cell;
-(void)DynamicComment:(DynamicCell *)cell;
-(void)DynamicMoreComment:(DynamicCell *)cell;
-(void)DynamicReplayComment:(DynamicCell *)cell ReplayID:(NSString*)toUserID;
@optional
-(void)hidenNavigationBar:(BOOL)isEnd;
@end

@interface DynamicCell : UITableViewCell

@property (nonatomic,weak) id <DynamicCellDelegate> delegate;
@property (nonatomic,strong) TheMyTendencyList *model;
@property (nonatomic,assign)  CGFloat height;

@end
