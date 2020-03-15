//
//  Grouper.m
//  RenrenTong
//
//  Created by aedu on 15/3/25.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "Grouper.h"

@implementation Grouper
 -(NSString *)description
{
    return [NSString stringWithFormat:@"%@--%@",self.UserName,self.SubjectName];
}

@end
