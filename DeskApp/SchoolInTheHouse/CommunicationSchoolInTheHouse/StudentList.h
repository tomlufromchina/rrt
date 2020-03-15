//
//  StudentList.h
//  RenrenTong
//
//  Created by aedu on 15/2/5.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import <Foundation/Foundation.h>
@class StudentList;

@interface StudentList : NSObject

/**
 *  学生名字
 */
@property(nonatomic, strong)NSString *StudentName;
/**
 *  学生名字首字母
 */
@property(nonatomic, strong)NSString *Spell;
/**
 *  学生ID
 */
@property(nonatomic, strong)NSString *StudentId;
/**
 *  学号
 */
@property(nonatomic, strong)NSString *StudentNumber;
/**
 *  班级ID
 */
@property(nonatomic, strong)NSNumber *ClassId;
/**
 *  是否住校
 */
@property(nonatomic, assign)int IsOnCampus;
/**
 *  是否开通服务
 */
@property (nonatomic, assign) int UserService;

@end
