//
//  CommentView.h
//  RenrenTong
//
//  Created by aedu on 15/3/30.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CommentViewDelegate <NSObject>

- (void)toUserBtnClick:(int)tag;

@end

@interface CommentView : UIView

@property(nonatomic, strong)NSArray *commentArray;

+ (CGSize)sizeWithCount:(NSArray*)array;
@property(nonatomic, weak)id<CommentViewDelegate> delegate;

@end
