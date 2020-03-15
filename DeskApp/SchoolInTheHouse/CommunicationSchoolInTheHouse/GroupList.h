//
//  GroupList.h
//  RenrenTong
//
//  Created by aedu on 15/2/6.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GroupList : NSObject

/**
*  群组名字
*/
@property(nonatomic, strong)NSString *GroupName;
/**
 *  群组ID
 */
@property(nonatomic, strong)NSNumber *GroupId;
/**
 *  群组类型
 */
@property(nonatomic, assign)int GroupType;



@end
