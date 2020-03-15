//
//  ClassList.h
//  RenrenTong
//
//  Created by aedu on 15/2/5.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClassList : NSObject

/**
 *  班级名字
 */
@property(nonatomic, strong)NSString *ClassAlias;
/**
 *  班级ID
 */
@property(nonatomic, strong)NSNumber *ClassId;
/**
 *  学段类型
 */
@property(nonatomic, strong)NSNumber *ClassType;
/**
 *  年级类型
 */
@property(nonatomic, strong)NSNumber *GradeId;
@end
