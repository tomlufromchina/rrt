//
//  SchoolGrade.m
//  RenrenTong
//
//  Created by aedu on 15/2/5.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "SchoolGrade.h"

@implementation SchoolGrade

-(NSString *)description
{
    return [NSString stringWithFormat:@"%@,%@,%@",self.GradeId,self.GradeName,self.ClassType];
}

@end
