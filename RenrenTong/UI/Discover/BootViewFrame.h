//
//  BootViewFrame.h
//  RenrenTong
//
//  Created by aedu on 15/3/30.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Microblog;

@interface BootViewFrame : NSObject
/**
 *  数据模型
 */
@property (nonatomic, strong) Microblog *microblog;

/**
 *  自己的frame
 * 注意: 如果继承UIView就不能写frame
 */
@property (nonatomic, assign) CGRect frame;

@property (nonatomic, assign, readonly)CGRect iconF;
@property (nonatomic, assign, readonly) CGRect lineF;
@property (nonatomic, assign, readonly) CGRect moreCommmentBtnF;

@property (nonatomic, assign, readonly) CGRect CommmentF;

@end
