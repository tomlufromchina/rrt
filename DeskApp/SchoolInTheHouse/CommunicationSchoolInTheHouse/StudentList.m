//
//  StudentList.m
//  RenrenTong
//
//  Created by aedu on 15/2/5.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "StudentList.h"

@implementation StudentList

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@,%@,%@,%@,%d,%d",self.StudentName,self.StudentNumber,self.StudentId,self.ClassId,self.IsOnCampus,self.UserService];
}


@end
