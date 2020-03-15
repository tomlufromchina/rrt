//
//  JournalDetail.h
//  RenrenTong
//
//  Created by 司月皓 on 14-7-30.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "Commonality.h"

@interface JournalDetail : Commonality

//日志内容
@property (nonatomic, strong) NSString *Author;
@property (nonatomic, strong) NSString *Subject;
@property (nonatomic, strong) NSString *Body;
@property (nonatomic, strong) NSString *ThreadId;
@property (nonatomic, strong) NSString *TenantTypeId;
@property (nonatomic, strong) NSString *OwnerId;
@property (nonatomic, strong) NSString *UserId;
@property (nonatomic, strong) NSString *DateCreated;
@property (nonatomic, strong) NSString *LastModified;
@property (nonatomic, strong) NSString *AuditStatus;
@property (nonatomic, strong) NSString *OriginalAuthorId;

//点赞情况
@property (nonatomic, strong) NSString *Detail;
@property (nonatomic, assign) int Total;

//评价数组
@property (nonatomic, copy)NSMutableArray *Comments;



@end
