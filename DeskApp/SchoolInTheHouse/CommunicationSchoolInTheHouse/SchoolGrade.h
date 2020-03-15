//
//  SchoolGrade.h
//  RenrenTong
//
//  Created by aedu on 15/2/5.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SchoolGrade : NSObject
@property(nonatomic, strong)NSString *GradeName;
@property(nonatomic, strong)NSNumber *GradeId;
/**
 *  学段类型
 */
@property(nonatomic, strong)NSNumber *ClassType;

@end
