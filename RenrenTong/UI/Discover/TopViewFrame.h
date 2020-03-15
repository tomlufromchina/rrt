//
//  TopViewFrame.h
//  RenrenTong
//
//  Created by aedu on 15/3/30.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Microblog;
@interface TopViewFrame : NSObject
/**
 *  数据模型
 */
@property (nonatomic, strong) Microblog *microblog;

/**
 *  自己的frame
 * 注意: 如果继承UIView就不能写frame
 */
@property (nonatomic, assign) CGRect frame;


/** 头像 */
@property (nonatomic, assign, readonly) CGRect iconViewF;
/** 昵称 */
@property (nonatomic, assign, readonly) CGRect nameLabelF;
/** 时间 */
@property (nonatomic, assign, readonly) CGRect timeLableF;
/** 正文\内容 */
@property (nonatomic, assign, readonly) CGRect contentLabelF;
/** 正配图Frame */
@property (nonatomic, assign, readonly) CGRect photosViewF;
@property (nonatomic, assign, readonly) CGRect commentBtnF;
@property (nonatomic, assign, readonly) CGRect lineF;
@property (nonatomic, assign, readonly) CGRect prasieBtnF;

@end
