//
//  MicroblogDetail.h
//  RenrenTong
//
//  Created by 司月皓 on 14-7-30.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "Commonality.h"

@interface MicroblogDetail : Commonality

//微博内容：BlogThread
@property (nonatomic, strong) NSString *Author;//作者
@property (nonatomic, strong) NSString *Body;//内容
@property (nonatomic, strong) NSString *Subject;//标题
@property (nonatomic, strong) NSString *ThreadId;
@property (nonatomic, strong) NSString *TenantTypeId;
@property (nonatomic, strong) NSString *UserId;
@property (nonatomic, strong) NSString *AuditStatus;
@property (nonatomic, strong) NSString *PrivacyStatus;
@property (nonatomic, strong) NSString *OriginalAuthorId;
@property (nonatomic, strong) NSString *DateCreated;//时间
@property (nonatomic, strong) NSString *MicroblogId;
@property (nonatomic, assign) NSString *DateCreatedStr;
@property (nonatomic, strong) NSString *LastModified;
@property (nonatomic, strong) NSString *FileName;//图片

//点赞情况：ParaseAct
@property (nonatomic, strong) NSString *Detail;
@property (nonatomic, assign) int Total;

//评价情况：Comments
@property (nonatomic, strong) NSMutableArray *Comments;
@property (nonatomic, strong) NSMutableArray *imageArray;


@end
