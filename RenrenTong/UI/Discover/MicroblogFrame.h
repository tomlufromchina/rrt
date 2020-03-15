//
//  MicroblogFrame.h
//  RenrenTong
//
//  Created by aedu on 15/3/27.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Microblog,TopViewFrame,BootViewFrame;
@interface MicroblogFrame : NSObject
/**
 *  数据模型
 */
@property(nonatomic, strong)Microblog *micBlog;
@property(nonatomic, strong)TopViewFrame *topViewFrame;

@property(nonatomic, strong)BootViewFrame *bootViewFrame;

/** cell的高度 */
@property (nonatomic, assign) CGFloat cellHeight;

@end
