//
//  TeacherList.h
//  RenrenTong
//
//  Created by aedu on 15/2/7.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TeacherList : NSObject
/**
 *  教师名字
 */
@property(nonatomic, strong)NSString *TeacherName;
/**
 *  教师名字首字母
 */
@property(nonatomic, strong)NSString *Spell;
/**
 *  学生ID
 */
@property(nonatomic, strong)NSString *TeacherId;

/**
 *  是否开通服务
 */
@property (nonatomic, assign) int UserService;

/**
 *  教师类型
 */
@property (nonatomic, assign) int TeacherRole;

@end
