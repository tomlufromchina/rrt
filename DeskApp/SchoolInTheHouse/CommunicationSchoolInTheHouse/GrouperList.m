//
//  GrouperList.m
//  RenrenTong
//
//  Created by aedu on 15/2/7.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "GrouperList.h"

@implementation GrouperList
- (NSString *)description
{
    return [NSString stringWithFormat:@"%@,%@,%@,%d",self.UserName,self.UserId,self.GroupId,self.UserService];
}

@end
