//
//  NetWorkManager+NetworkTool.h
//  RenrenTong
//
//  Created by aedu on 15/2/5.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "NetWorkManager.h"

@interface NetWorkManager (NetworkTool)

#pragma mark -- 获取教师绑定班级列表

- (void)getTeacherClassCount:(NSString *)Token
                    teacherId:(NSString *)teacherId
                      success:(void(^)(NSMutableArray* data))successBlock
                       failed:(void(^)(NSString *errorMSG))failedBlock;

#pragma mark -- 获取教师所在学校学段
- (void)getSchoolType:(NSString *)Token
            teacherId:(NSString *)teacherId
              success:(void(^)(NSMutableArray* data))successBlock
               failed:(void(^)(NSString *errorMSG))failedBlock;

#pragma mark -- 获取班级学生列表

- (void)getClassStudents:(NSString *)Token
                      classId:(NSNumber *)classId
                      success:(void(^)(NSMutableArray* data))successBlock
                       failed:(void(^)(NSString *errorMSG))failedBlock;

#pragma mark -- 获取教师创建的群组
- (void)getTeacherGroups:(NSString *)Token
               teacherId:(NSString *)teacherId 
                 success:(void(^)(NSMutableArray* data))successBlock
                  failed:(void(^)(NSString *errorMSG))failedBlock;

#pragma mark -- 获取群组成员

- (void)getGroupMembers:(NSString *)Token
               groupId:(NSNumber *)groupId
               success:(void(^)(NSMutableArray* data))successBlock
                failed:(void(^)(NSString *errorMSG))failedBlock;

#pragma mark -- 通过教师ID获取教师列表

- (void)getTeacherLists:(NSString *)Token
             teacherId:(NSString *)teacherId
               success:(void(^)(NSMutableArray* data))successBlock
                failed:(void(^)(NSString *errorMSG))failedBlock;


@end
