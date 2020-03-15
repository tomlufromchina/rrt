//
//  PermissionList.h
//  RenrenTong
//
//  Created by aedu on 15/2/28.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PermissionList : NSObject
/**
 *  权限名字
 */
@property(nonatomic, strong)NSString *FeatureName;
/**
 *  权限ID
 */
@property(nonatomic, strong)NSNumber *FeatureId;


@end
