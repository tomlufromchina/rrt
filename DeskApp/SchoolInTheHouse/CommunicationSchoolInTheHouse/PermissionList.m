//
//  PermissionList.m
//  RenrenTong
//
//  Created by aedu on 15/2/28.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "PermissionList.h"

@implementation PermissionList

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@,%@",self.FeatureName,self.FeatureId];
}

@end
