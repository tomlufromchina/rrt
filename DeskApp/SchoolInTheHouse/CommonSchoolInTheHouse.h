//
//  CommonSchoolInTheHouse.h
//  RenrenTong
//
//  Created by 符其彬 on 14-10-23.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import <Foundation/Foundation.h>

// 受到的信息
@interface GetMessage : NSObject

@property (nonatomic, assign) int SchoolId;
@property (nonatomic, assign) int BatchSerial;
@property (nonatomic, assign) int PubUserId;
@property (nonatomic, assign) int PubUserType;
@property (nonatomic, assign) int SendScope;
@property (nonatomic, assign) int UserRole;
@property (nonatomic, assign) int MsgCount;
@property (nonatomic, assign) int ObjectCount;
@property (nonatomic, assign) int UserCount;
@property (nonatomic, assign) int PublishUserCount;
@property (nonatomic, assign) int MsgType;
@property (nonatomic, assign) int SendType;
@property (nonatomic, assign) int StatusId;
@property (nonatomic, assign) int UserScopeProperty;
@property (nonatomic, assign) int PublishResult;
@property (nonatomic, assign) BOOL IsAysn;
@property (nonatomic, assign) BOOL IsSendName;
@property (nonatomic, assign) BOOL IsSameContent;
@property (nonatomic, assign) BOOL IsRecommend;
@property (nonatomic, assign) BOOL IsCatch;
@property (nonatomic, copy) NSString *BatchId;
@property (nonatomic, copy) NSString *SchoolName;
@property (nonatomic, copy) NSString *MsgContent;
@property (nonatomic, copy) NSString *CreateBy;
@property (nonatomic, copy) NSString *CreateTime;
@property (nonatomic, copy) NSString *PubUserName;
@end

@interface SendMessage : NSObject

@property (nonatomic, assign) int SchoolId;
@property (nonatomic, assign) int BatchSerial;
@property (nonatomic, assign) int PubUserId;
@property (nonatomic, assign) int PubUserType;
@property (nonatomic, assign) int SendScope;
@property (nonatomic, assign) int UserRole;
@property (nonatomic, assign) int MsgCount;
@property (nonatomic, assign) int ObjectCount;
@property (nonatomic, assign) int UserCount;
@property (nonatomic, assign) int PublishUserCount;
@property (nonatomic, assign) int MsgType;
@property (nonatomic, assign) int SendType;
@property (nonatomic, assign) int StatusId;
@property (nonatomic, assign) int UserScopeProperty;
@property (nonatomic, assign) int PublishResult;
@property (nonatomic, assign) BOOL IsAysn;
@property (nonatomic, assign) BOOL IsSendName;
@property (nonatomic, assign) BOOL IsSameContent;
@property (nonatomic, assign) BOOL IsRecommend;
@property (nonatomic, assign) BOOL IsCatch;
@property (nonatomic, strong) NSString *BatchId;
@property (nonatomic, strong) NSString *SchoolName;
@property (nonatomic, strong) NSString *MsgContent;
@property (nonatomic, strong) NSString *CreateBy;
@property (nonatomic, strong) NSString *CreateTime;

@end

@interface CurrentStudent : NSObject
@property (nonatomic, assign) long long StudentId;
@property (nonatomic, strong) NSString *StudentName;
@property (nonatomic, assign) int IsOnCampus;
@property (nonatomic, assign) int UserService;


@end

@interface CurrentTeacher : NSObject
@property (nonatomic, assign) long long TeacherId;
@property (nonatomic, strong) NSString *TeacherName;
@property (nonatomic, assign) int UserService;

@end

// 新版家校沟通

@interface TheTeacherSendRecords : NSObject
@property (nonatomic, strong) NSString *PubUserName;
@property (nonatomic, strong) NSString *MsgContent;
@property (nonatomic, strong) NSString *PubTime;
@property (nonatomic, strong) NSString *SendType;
@property (nonatomic, strong) NSString *MsgType;
@property (nonatomic, strong) NSString *ObjectId;
@property (nonatomic, strong) NSString *SchoolId;
@property (nonatomic, strong) NSString *PubUserId;
@property (nonatomic, strong) NSString *CreateTimeFormat;
@property (nonatomic, assign) BOOL IsRead;
@property (nonatomic, strong) NSString *Audioes;
@property (nonatomic, strong) NSString *Pictures;
@property (nonatomic, strong) NSString *Files;

@end
