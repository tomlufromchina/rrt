//
//  TeacherGroup.m
//  RenrenTong
//
//  Created by aedu on 15/2/7.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "TeacherGroup.h"

@implementation TeacherGroup

+ (TeacherGroup *)teacherWithName:(NSString *)name groupTpye:(int)type{
    TeacherGroup *teacherGroup = [[TeacherGroup alloc] init];
    teacherGroup.GroupName = name;
    teacherGroup.GroupType = type + 3;
    return teacherGroup;
}


@end
