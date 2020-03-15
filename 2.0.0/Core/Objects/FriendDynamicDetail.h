//
//  FriendDynamicDetail.h
//  RenrenTong
//
//  Created by 司月皓 on 14-7-31.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//


#import "DynamicComments.h"

@interface FriendDynamicDetail : NSObject

@property (nonatomic, assign)int ActivityId;//动态ID
@property (nonatomic, assign) int serId;
@property (nonatomic, copy)NSString *activityItemKey;
@property (nonatomic, assign)int applicationid;//发表类型,1001微博，1002日志，1003相册
@property (nonatomic, copy)NSString *DateCreated;
@property (nonatomic, copy)NSString *DateCreatedStr;
@property (nonatomic, assign)BOOL hasImage;
@property (nonatomic, assign)BOOL hasMusic;
@property (nonatomic, assign)BOOL hasVideo;
@property (nonatomic, assign)BOOL isOriginalThread;//是不是原创
@property (nonatomic, assign)BOOL isPrivate;
@property (nonatomic, copy)NSString *LastModified;
@property (nonatomic, assign)int ownerid;//拥有者ID
@property (nonatomic, copy)NSString *OwnerName;//拥有者名称
@property (nonatomic, copy)NSString *dynNew;//拥有者名称
@property (nonatomic, assign)int OwnerType;//拥有者类型
//点赞：Parase
@property (nonatomic, copy)NSString *Detail;
@property (nonatomic, assign)int Total;
@property (nonatomic, copy)NSArray *Photos;
@property (nonatomic, assign)int referenceId;
@property (nonatomic, copy)NSString *referenceTenantTypeId;
@property (nonatomic, assign)int sourceId;
@property (nonatomic, assign)int tenantTypeid;
@property (nonatomic, assign)int userId;
@property (nonatomic, copy)NSMutableArray *Comments;//评论

@property (nonatomic, copy)NSString *rownum;

//内容详情：dynDetial(公共的)根据Key的不同可以取出对应的
@property (nonatomic, copy)NSString *photoId;
@property (nonatomic, copy)NSString *AlbumId;
@property (nonatomic, copy)NSString *Author;
//1,相册
@property (nonatomic, copy)NSString *RelativePath;
@property (nonatomic, copy)NSString *OriginalUrl;
@property (nonatomic, assign)int AuditStatus;
@property (nonatomic, copy)NSString *Description;
//2,日志
@property (nonatomic, copy)NSString *ThreadId;
@property (nonatomic, copy)NSString *Subject;//日志标题
@property (nonatomic, copy)NSString *Body;//日志内容
@property (nonatomic, copy)NSString *Summary;
//3,微博
@property (nonatomic, copy)NSString *OriginalMicroblogId;
@property (nonatomic, copy)NSString *content;//微博内容



@end
