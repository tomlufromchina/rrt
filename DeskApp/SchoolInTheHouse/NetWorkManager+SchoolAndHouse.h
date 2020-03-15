//
//  NetWorkManager+SchoolAndHouse.h
//  RenrenTong
//
//  Created by 符其彬 on 14-10-22.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//
/*为NetWorkManager类添加SchoolAndHouse方法,SchoolAndHouse就是类目名。*/
#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "Reachability.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "BaseRequest.h"

@interface NetWorkManager(SchoolAndHouse)<ASIHTTPRequestDelegate>

//Get
-(void)requestGetWithUrl:(NSString*)url requestDone:(SEL)requestDone;
//Post
-(void)requestPostWithUrl:(NSString*)url postdata:(NSMutableArray*)postdata requestDone:(SEL)requestDone;

#pragma mark -- 获取老师担当的角色
- (void)getTeacherRole:(NSString *)Token
             teacherId:(NSString *)teacherId
               success:(void(^)(NSString* data))successBlock
                failed:(void(^)(NSString *errorMSG))failedBlock;


#pragma mark - 获取自己受到的短信记录
#pragma mark -

- (void)getMessageCounts:(NSString *)Token
                  userId:(NSString *)userId
                userRole:(NSString *)userRole
             messageType:(int)messageType
                pageSize:(int)pageSize
               pageIndex:(int)pageIndex
                 success:(void(^)(NSMutableArray* data))successBlock
                  failed:(void(^)(NSString *errorMSG))failedBlock;

#pragma mark - 获取自己发送的短信记录
#pragma mark -

- (void)getMyselfMessageCounts:(NSString *)Token
                        userId:(NSString *)userId
                      pageSize:(int)pageSize
                     pageIndex:(int)pageIndex
                       success:(void(^)(NSMutableArray* data))successBlock
                        failed:(void(^)(NSString *errorMSG))failedBlock;




#pragma mark -- 获取教师绑定班级列表
#pragma mark --

- (void)getTeacherClassCounts:(NSString *)Token
                    teacherId:(NSString *)teacherId
                      success:(void(^)(NSMutableArray* data))successBlock
                       failed:(void(^)(NSString *errorMSG))failedBlock;

#pragma mark -- 获取班级学生列表

- (void)getClassStudentCounts:(NSString *)Token
                      classId:(long long)classId
                      success:(void(^)(NSMutableArray* data))successBlock
                       failed:(void(^)(NSString *errorMSG))failedBlock;

#pragma mark -- 获取教师创建的群组

- (void)getTeacherGroupCounts:(NSString *)Token
                    teacherId:(NSString *)teacherId
                      success:(void(^)(NSMutableArray* data))successBlock
                       failed:(void(^)(NSString *errorMSG))failedBlock;

#pragma mark -- 获取群组成员

- (void)getGroupMember:(NSString *)Token
               groupId:(long long)groupId
               success:(void(^)(NSMutableArray* data))successBlock
                failed:(void(^)(NSString *errorMSG))failedBlock;

#pragma mark -- 通过教师ID获取教师列表

- (void)getTeacherList:(NSString *)Token
             teacherId:(NSString *)teacherId
               success:(void(^)(NSMutableArray* data))successBlock
                failed:(void(^)(NSString *errorMSG))failedBlock;


#pragma mark -- 教师给群组发短信(网页)

- (void)teacherSendMessageForGroup:(NSString *)Token
                         teacherId:(NSString *)teacherId
                       messageType:(int)messageType
                           message:(NSString *)message
                      objectIdList:(NSString *)objectIdList
                           success:(void(^)(NSMutableArray* data))successBlock
                            failed:(void(^)(NSString *errorMSG))failedBlock;

#pragma mark -- 教师给群组发短信(短信)

- (void)teacherSendNextMessageForGroup:(NSString *)Token
                             teacherId:(NSString *)teacherId
                           messageType:(int)messageType
                               message:(NSString *)message
                          objectIdList:(NSString *)objectIdList
                               success:(void (^)(NSMutableArray *data))successBlock
                                failed:(void (^)(NSString *errorMSG))failedBlock;

#pragma mark -- 教师给个别成员发送短信（网页）

- (void)teacherSendMessageForSeveralMenver:(NSString *)Token
                                 teacherId:(NSString *)teacherId
                               messageType:(int)messageType
                                   message:(NSString *)message
                                   groupId:(NSString *)groupId
                              objectIdList:(NSString *)objectIdList
                                   success:(void (^)(NSMutableArray *data))successBlock
                                    failed:(void (^)(NSString *errorMSG))failedBlock;

#pragma mark -- 教师给个别成员发送短信（短信）

- (void)teacherSendNextMessageForSeveralMenber:(NSString *)Token
                                   messageType:(int)messageType
                                       message:(NSString *)message
                                       groupId:(NSString *)groupId
                                  objectIdList:(NSString *)objectIdList
                                       success:(void (^)(NSMutableArray *data))successBlock
                                        failed:(void (^)(NSString *errorMSG))failedBlock;

#pragma mark -- 教师给班级发送短信（网页）

- (void)teacherSendMessageForClass:(NSString *)Token
                         teacherId:(NSString *)teacherId
                       messageType:(int)messageType
                           message:(NSString *)message
                      objectIdList:(NSString *)objectIdList
                           success:(void (^)(NSMutableArray *data))successBlock
                            failed:(void (^)(NSString *errorMSG))failedBlock;
#pragma mark -- 教师给班级发送短信（短信）

- (void)teacherSendNextMessageForClass:(NSString *)Token
                           messageType:(int)messageType
                               message:(NSString *)message
                               classId:(NSString *)classId
                               success:(void (^)(NSMutableArray *data))successBlock
                                failed:(void (^)(NSString *errorMSG))failedBlock;


#pragma mark -- 给个别家长发送短信（网页）

- (void)teacherSendMessageForSeveralParents:(NSString *)Token
                                  teacherId:(NSString *)teacherId
                                messageType:(int)messageType
                                    message:(NSString *)message
                               objectIdList:(NSString *)objectIdList
                                    success:(void (^)(NSMutableArray *data))successBlock
                                     failed:(void (^)(NSString *errorMSG))failedBlock;
#pragma mark -- 给个别家长发送短信（短信）
- (void)teacherSendNextMessageForSeveralParents:(NSString *)Token
                                    messageType:(int)messageType
                                        message:(NSString *)message
                                        classId:(NSString *)classId
                                   objectIdList:(NSString *)objectIdList
                                        success:(void (^)(NSMutableArray *data))successBlock
                                         failed:(void (^)(NSString *errorMSG))failedBlock;

#pragma mark -- 校领导给个别教师发送短信（网页）
- (void)bossSendMessageForTeachers:(NSString *)Token
                     SenderAccount:(NSString *)SenderAccount
                        messageType:(int)messageType
                           Message:(NSString *)Message
                      ObjectIdList:(NSString *)ObjectIdList
                           success:(void (^)(NSMutableArray *data))successBlock
                            failed:(void (^)(NSString *errorMSG))failedBlock;

#pragma mark -- 校领导给个别教师发送短信（短信）
- (void)bossSendNextMessageForTeachers:(NSString *)Token
                            messageType:(int)messageType
                               Message:(NSString *)Message
                          ObjectIdList:(NSString *)ObjectIdList
                               success:(void (^)(NSMutableArray *data))successBlock
                                failed:(void (^)(NSString *errorMSG))failedBlock;

#pragma mark -- 通过教师获取学校短信字数限制

- (void)limitMessageCount:(NSString *)Token
                  userId:(NSString *)userId
                  success:(void (^)(NSString *data))successBlock
                   failed:(void (^)(NSString *errorMSG))failedBlock;

#pragma mark -- 教师发送记录

- (void)theTeacherSendRecords:(NSString *)userID
                        Token:(NSString *)Token
                     pageSize:(int)pageSize
                    pageIndex:(int)pageIndex
                      success:(void (^)(NSMutableArray *data))successBlock
                       failed:(void (^)(NSString *errorMSG))failedBlock;

// 新版家校沟通

#pragma mark -- 给班级发送

- (void)forTheClassSendMessag:(NSString *)token
                      message:(NSString *)message
                      classId:(NSString *)classId
                  messageType:(int)messageType
                   isSendName:(int)isSendName
                     sendType:(int)sendType
       isPublishToClassMaster:(int)isPublishToClassMaster
                  studentType:(int)studentType
                      audioes:(NSString *)audioes
                     pictures:(NSString *)pictures
                      success:(void (^)(NSString *data))successBlock
                       failed:(void (^)(NSString *errorMSG))failedBlock;

#pragma mark -- 给班级成员发送
- (void)forTheClassMenberSendMessag:(NSString *)token
                      message:(NSString *)message
                      classId:(NSString *)classId
                 objectIdList:(NSString *)objectIdList
                  messageType:(int)messageType
                   isSendName:(int)isSendName
                     sendType:(int)sendType
       isPublishToClassMaster:(int)isPublishToClassMaster
                      audioes:(NSString *)audioes
                     pictures:(NSString *)pictures
                      success:(void (^)(NSString *data))successBlock
                       failed:(void (^)(NSString *errorMSG))failedBlock;

#pragma mark -- 给群组发送
- (void)forTheGroupSendMessag:(NSString *)token
                            message:(NSString *)message
                            groupId:(NSString *)groupId
                        messageType:(int)messageType
                         isSendName:(int)isSendName
                           sendType:(int)sendType
                            audioes:(NSString *)audioes
                           pictures:(NSString *)pictures
                            success:(void (^)(NSString *data))successBlock
                             failed:(void (^)(NSString *errorMSG))failedBlock;

#pragma mark -- 给群组成员发送
- (void)forTheGroupMenberSendMessag:(NSString *)token
                            message:(NSString *)message
                            groupId:(NSString *)groupId
                       objectIdList:(NSString *)objectIdList
                        messageType:(int)messageType
                         isSendName:(int)isSendName
                           sendType:(int)sendType
                            audioes:(NSString *)audioes
                           pictures:(NSString *)pictures
                            success:(void (^)(NSString *data))successBlock
                             failed:(void (^)(NSString *errorMSG))failedBlock;

#pragma mark -- 给老师发送
- (void)forTheTeachersSendMessag:(NSString *)token
                      message:(NSString *)message
                      objectIdList:(NSString *)objectIdList
                  messageType:(int)messageType
                   isSendName:(int)isSendName
                     sendType:(int)sendType
                      audioes:(NSString *)audioes
                     pictures:(NSString *)pictures
                      success:(void (^)(NSString *data))successBlock
                          failed:(void (^)(NSString *errorMSG))failedBlock;


#pragma mark -- 获取教师权限
- (void)getTeacherMsgPermission:(NSString *)Token
                      teacherId:(NSString *)teacherId
                        success:(void(^)(NSMutableArray* data))successBlock
                         failed:(void(^)(NSString *errorMSG))failedBlock;

#pragma mark -- 家长或学生获取未读数据
- (void)GetMessagesWithUserId:(NSString *)userId
                     FromOrTo:(int)fromOrTo newOrOld:(NSString *)yesOrNo type:(int)type
                      success:(void(^)(NSMutableArray* data))successBlock
                       failed:(void(^)(NSString *errorMSG))failedBlock;
#pragma mark -- 家长或学生获取更多未读数据
- (void)getMoreMessagesWithUserId:(NSString *)userId HeadType:(int)headType
                         FromOrTo:(int)fromOrTo newOrOld:(NSString *)yesOrNo type:(int)type LineId:(NSString *)lineId
                          success:(void(^)(NSMutableArray* data))successBlock
                           failed:(void(^)(NSString *errorMSG))failedBlock;
#pragma mark -- 根据家长获取学生ID
- (void) getStudentIdWithUserId:(NSString *)userId
                        success:(void(^)(NSString* data))successBlock
                         failed:(void(^)(NSString *errorMSG))failedBlock;
@end
