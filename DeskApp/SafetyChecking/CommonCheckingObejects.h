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

@property (nonatomic, assign) long long ClassId;
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

// 今日考勤首页数据结构哦（老师）
@interface TodayAttendance : NSObject

@property (nonatomic, assign) long long ClassId;
@property (nonatomic, assign) int MasterId;
@property (nonatomic, assign) int cidaoNum;
@property (nonatomic, assign) int zaotuiNum;
@property (nonatomic, assign) int zhengchangNum;
@property (nonatomic, assign) int noRecordNum;
@property (nonatomic, strong) NSString *mydate;
@property (nonatomic, strong) NSString *ClassName;
@property (nonatomic, strong) NSString *MasterName;

@end

//某个班级某日考勤详情
@interface ClassAttendance : NSObject

@property (nonatomic, assign) long long ClassId;
@property (nonatomic, assign) int cidaoNum;
@property (nonatomic, assign) int zaotuiNum;
@property (nonatomic, assign) int zhengchangNum;
@property (nonatomic, assign) int noRecordNum;
@property (nonatomic, strong) NSString *mydate;
@property (nonatomic, strong) NSMutableArray *UserAttListArray;
@property (nonatomic, strong) NSMutableArray *myAttendanceListArray;

@end

// 某个班级某日所有学生的信息
@interface StudentAttList : NSObject
@property (nonatomic, assign) int UserId;
@property (nonatomic, assign) long long ClassId;
@property (nonatomic, strong) NSString *mydate;
@property (nonatomic, strong) NSString *UserName;

@end

// 某个班级某日所有学生考勤情况
@interface StudentAttDetails : NSObject
@property (nonatomic, assign) int dtype;
@property (nonatomic, assign) int count;
@property (nonatomic, strong) NSString *Memo;

@end

// 一个班级一个时间段内的未刷卡考勤计数统计
@interface ClassNoSwipingCardNumber : NSObject
@property (nonatomic, assign) long long ClassId;
@property (nonatomic, strong) NSString* ClassName;
@property (nonatomic, assign) int dType;
@property (nonatomic, assign) int Num;
@property (nonatomic, strong) NSString *UserNames;
@property (nonatomic, assign) int PopNum;
@property (nonatomic, strong) NSString *PopMemo;
@property (nonatomic, strong) NSArray *UsersList;




@end

// 刷卡记录
@interface SwipingCardRecor : NSObject
@property (nonatomic, assign) int LineId;
@property (nonatomic, assign) int SchoolId;
@property (nonatomic, assign) int UserId;
@property (nonatomic, assign) int UserType;
@property (nonatomic, assign) long long ClassId;
@property (nonatomic, strong) NSString *UserName;
@property (nonatomic, strong) NSString *usertypename;
@property (nonatomic, strong) NSString *cardnumber;
@property (nonatomic, strong) NSString *swingtime;

@end

//孩子的考勤统计
@interface ChildATTRecord : NSObject
@property (nonatomic, assign) long long ClassId;
@property (nonatomic, assign) int UserId;
@property (nonatomic, strong) NSString *UserName;
@property (nonatomic, strong) NSString *mydate;
@property (nonatomic, strong) NSMutableArray *myAttendanceList;

@end

