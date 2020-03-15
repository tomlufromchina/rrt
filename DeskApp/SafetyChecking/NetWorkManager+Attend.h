//
//  NetWorkManager+Attend.h
//  RenrenTong
//
//  Created by 符其彬 on 14-9-25.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.

/*为NetWorkManager类添加Attend方法,Atend就是类目名。*/

#import <Foundation/Foundation.h>

@interface NetWorkManager (Attend)

#pragma mark - 平安考勤首页（老师）
#pragma mark -

- (void)getCheckingOfTearchs:(NSString *)toKen
                   teacherId:(NSString *)teacherId
                     success:(void(^)(NSMutableArray* data))successBlock
                      failed:(void(^)(NSString *errorMSG))failedBlock;

#pragma mark -- 今日考勤接口（老师）
#pragma mark --

- (void)todayAttendance:(NSString *)masterId
                 mydate:(NSString *)mydate
                success:(void(^)(NSMutableArray* data))successBlock
                 failed:(void(^)(NSString *errorMSG))failedBlock;

#pragma mark -- 某日某班级考勤详情（老师）
#pragma mark -- 

- (void)classAttendanceDetails:(long long)classId
                        mydate:(NSString *)mydate
                       success:(void(^)(NSMutableArray* data))successBlock
                        failed:(void(^)(NSString *errorMSG))failedBlock;

#pragma mark -- 某个学生的考勤详情（老师）
#pragma mark --

- (void)otherStudentsAttenanceDetails:(long long)classId
                               mydate:(NSString *)mydate
                               userid:(NSString *)userid
                             username:(NSString *)username
                              success:(void(^)(NSMutableArray* data))successBlock
                               failed:(void(^)(NSString *errorMSG))failedBlock;
#pragma mark -- 一个班级一个时间段内的未刷卡考勤计数统计
#pragma mark --
- (void)noSwipingCardNumber:(long long)classId
                mybegindate:(NSString *)mybegindate
                  myenddate:(NSString *)myenddate
                   UserType:(int)UserType
                    success:(void(^)(NSMutableArray* data))successBlock
                     failed:(void(^)(NSString *errorMSG))failedBlock;


#pragma mark -- 一个班级一个时间段内的异常考勤计数统计
#pragma mark --

- (void)YCAttendance:(long long)classId
         mybegindate:(NSString *)mybegindate
           myenddate:(NSString *)myenddate
            UserType:(int)UserType
             success:(void(^)(NSMutableArray* data))successBlock
              failed:(void(^)(NSString *errorMSG))failedBlock;

#pragma mark -- 一个班级一个时间段内的正常考勤计数统计
#pragma mark --

- (void)ZCAttendance:(long long)classId
         mybegindate:(NSString *)mybegindate
           myenddate:(NSString *)myenddate
            UserType:(int)UserType
             success:(void(^)(int data))successBlock
              failed:(void(^)(NSString *errorMSG))failedBlock;


#pragma mark -- 刷卡记录（老师）
#pragma mark --
- (void)SwipingCardRecordNumber:(long long)classId
                    mybegindate:(NSString *)mybegindate
                      myenddate:(NSString *)myenddate
                        success:(void(^)(NSMutableArray* data))successBlock
                         failed:(void(^)(NSString *errorMSG))failedBlock;

#pragma mark -- 获取孩子信息（家长）
#pragma mark --
- (void)GetChildInfoWithPid:(NSString*)parentid
                    success:(void(^)(NSDictionary* data))successBlock
                     failed:(void(^)(NSString *errorMSG))failedBlock;

#pragma mark -- 获取某个学生某个月有考勤异常的日期
#pragma mark --

- (void)GetYCByDate:(NSDate*)date uid:(NSString*)uid
            success:(void(^)(NSArray* data))successBlock
             failed:(void(^)(NSString *errorMSG))failedBlock;

#pragma mark -- 个人时间段内的考勤详情
#pragma mark -- 

- (void)CertainTimeAttendanceDetails:(int)userid
                         mybegindate:(NSString *)mybegindate
                           myenddate:(NSString *)myenddate
                             success:(void(^)(NSMutableArray* data))successBlock
                              failed:(void(^)(NSString *errorMSG))failedBlock;

#pragma mark -- 获取学生所在班级
#pragma mark --
- (void)GetStudentClassDetails:(int)studentid
                       success:(void(^)(NSMutableArray* data))successBlock
                        failed:(void(^)(NSString *errorMSG))failedBlock;

#pragma mark -- 获取学生考勤统计（家长）
#pragma mark -- 

- (void)GetStudentCheckingRecords:(long long)classId
                           mydate:(NSString *)mydate
                           userid:(int)userid
                          success:(void(^)(NSMutableArray* data))successBlock
                           failed:(void(^)(NSString *errorMSG))failedBlock;

@end
