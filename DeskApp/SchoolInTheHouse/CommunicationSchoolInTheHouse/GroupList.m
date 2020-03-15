//
//  GroupList.m
//  RenrenTong
//
//  Created by aedu on 15/2/6.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "GroupList.h"

@implementation GroupList
- (NSString *)description
{
    return [NSString stringWithFormat:@"%@,%@,%d",self.GroupName,self.GroupId,self.GroupType];
}

@end
