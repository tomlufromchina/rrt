//
//  GrouperList.h
//  RenrenTong
//
//  Created by aedu on 15/2/7.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GrouperList : NSObject
/**
 *  成员名字
 */
@property(nonatomic, strong)NSString *UserName;
/**
 *  成员名字首字母
 */
@property(nonatomic, strong)NSString *Spell;
/**
 *  成员ID
 */
@property(nonatomic, strong)NSString *UserId;
/**
 *  群组ID
 */
@property(nonatomic, strong)NSNumber *GroupId;
/**
 *  是否开通服务
 */
@property (nonatomic, assign) int UserService;

@end
