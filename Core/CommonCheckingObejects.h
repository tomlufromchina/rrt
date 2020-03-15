//
//  CommonCheckingObejects.h
//  RenrenTong
//
//  Created by 符其彬 on 14-9-26.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import <Foundation/Foundation.h>
// 平安考勤首页数据结构（老师）
@interface CheckingForTeachers : NSObject

@property (nonatomic, assign) int classId;
@property (nonatomic, assign) int gradeId;
@property (nonatomic, assign) int schoolId;
@property (nonatomic, assign) int studentCount;
@property (nonatomic, assign) int memberCount;
@property (nonatomic, assign) int classType;
@property (nonatomic, assign) int masterAccount;
@property (nonatomic, assign) int classSubjectType;
@property (nonatomic, assign) int statusId;
@property (nonatomic, assign) int masterId;
@property (nonatomic, strong) NSString *className;
@property (nonatomic, strong) NSString *classAlias;
@property (nonatomic, strong) NSString *classLayer;

@end
