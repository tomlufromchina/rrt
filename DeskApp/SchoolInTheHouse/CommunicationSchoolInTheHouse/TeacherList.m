//
//  TeacherList.m
//  RenrenTong
//
//  Created by aedu on 15/2/7.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "TeacherList.h"

@implementation TeacherList
- (NSString *)description
{
    return [NSString stringWithFormat:@"%@,%@,%@,%d,%d",self.TeacherName,self.TeacherId,self.Spell,self.UserService,self.TeacherRole];
}

@end
