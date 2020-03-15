//
//  ObjectsEntity.h
//  RenrenTong
//
//  Created by jeffrey on 14-5-21.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import <Foundation/Foundation.h>

//Login info
@interface Login : NSObject

@property (nonatomic, strong) NSString *userId;           //唯一标识
@property (nonatomic, strong) NSString *tokenId;          //登陆token
@property (nonatomic, strong) NSString *userAvatar;
@property (nonatomic, strong) NSString *userName;         //nick name
@property (nonatomic, strong) NSString *userRole;

@property (nonatomic, strong) NSString *blogAddress;
@property (nonatomic, strong) NSString *classId;
@property (nonatomic, strong) NSString *schoolId;
@property (nonatomic, strong) NSString *schoolName;

@property (nonatomic, assign) int integral;
@property (nonatomic, assign) BOOL bSaveLoginState;
@property (nonatomic, strong) NSString *loginTime;
@property (nonatomic, strong) NSString *publicProperty;
@property (nonatomic, strong) NSString *saveStateTime;

@property (nonatomic, copy) NSString *account;         //登录账号 可能是数字，手机号码，邮箱等
@property (nonatomic, strong) NSString *password;      //登录密码

@end

//联系人
@interface Contact : NSObject
//<NSCoding>

@property (nonatomic, strong) NSString *face;
@property (nonatomic, strong) NSString *contactId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *objType;
@property (nonatomic, strong) NSString *avatarUrl;
@property (nonatomic, strong) NSString *py;

@end

//个人资料
@interface NdividualData : NSObject

@property (nonatomic, copy) NSString *TrueName;
@property (nonatomic, copy) NSString *NickName;
@property (nonatomic, copy) NSString *SchoolName;
@property (nonatomic, copy) NSString *SchoolId;
@property (nonatomic, copy) NSString *NowAreaName;//地址
@property (nonatomic, copy) NSString *NowAreaCode;//邮编
@property (nonatomic, copy) NSString *UserAccount;//账号
@property (nonatomic, copy) NSString *PicInfo;//（包含 相册id 图片ID 图片地址）
@property (nonatomic, copy) NSString *photoID;
@property (nonatomic, copy) NSString *albumID;
@property (nonatomic, copy) NSMutableArray *photoAddress;
@property (nonatomic, copy) NSString *UserId;
@property (nonatomic, copy) NSString *UserName;
@property (nonatomic, copy) NSString *UserType;
@property (nonatomic, copy) NSString *parentName;
@property (nonatomic, copy) NSString *LatestNews;//更新了是 微博or日志or相册
@property (nonatomic, copy) NSString *headImage;

@property (nonatomic, assign) BOOL isFriend;

@end
//日志列表
@interface BlogList : NSObject

@property (nonatomic, copy) NSString * blogThreadId;
@property (nonatomic, copy) NSString *body;
@property (nonatomic, copy) NSString *dateTime;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *pictureUrl;//日志人头像
@property (nonatomic, copy) NSString *commentCount;//
@property (nonatomic, copy) NSString *title;//标题
@property (nonatomic, copy) NSString *hitCount;//点击数
@property (nonatomic, copy) NSString *bolgID;//点击数

@end

//新朋友
@interface NewFriends : NSObject

@property (nonatomic, copy) NSString *InvitationId;
@property (nonatomic, copy) NSString *body;
@property (nonatomic, copy) NSString *dateTime;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *pictureUrl;//
@property (nonatomic, copy) NSString *SenderPictureUrl;
@property (nonatomic, copy) NSString *SenderUserId;//
@property (nonatomic, copy) NSString *TypeId;//
@property (nonatomic, copy) NSString *SenderUserName;//
@property (nonatomic, copy) NSString *IsFollows;//
@property (nonatomic, copy) NSString *totalCount;//
@property (nonatomic, copy) NSString *Type;//类型
@property (nonatomic, copy) NSString *Id;

@end

//通讯录列表
@interface AddressBookDetai :NSObject

@end

//用户套餐
@interface UserOfCombo :NSObject

@property (nonatomic, copy) NSString *UserTacticsId;
@property (nonatomic, copy) NSString *SysTacticsId;
@property (nonatomic, copy) NSString *IsUsedtimeValidate;
@property (nonatomic, copy) NSString *EndDate;
@property (nonatomic, copy) NSString *BeginDate;
@property (nonatomic, copy) NSString *StatusId;

@end

//添加好友搜索后详细内容
@interface SendFriendDetail :NSObject

@property (nonatomic, copy) NSString *TrueName;
@property (nonatomic, copy) NSString *NickName;
@property (nonatomic, copy) NSString *NowAreaName;
@property (nonatomic, copy) NSString *NowAreaCode;
@property (nonatomic, copy) NSString *SchoolName;
@property (nonatomic, copy) NSString *UserId;
@property (nonatomic, copy) NSString *PicInfo;
@property (nonatomic, copy) NSString *UserAccount;
@property (nonatomic, assign) BOOL isFriend;

@end

//绑定家长搜索后的详细内容
@interface SendParentsDetail :NSObject

@property (nonatomic, copy) NSString *TrueName;
@property (nonatomic, copy) NSString *NickName;
@property (nonatomic, copy) NSString *NowAreaName;
@property (nonatomic, copy) NSString *NowAreaCode;
@property (nonatomic, copy) NSString *SchoolName;
@property (nonatomic, copy) NSString *UserId;
@property (nonatomic, copy) NSString *PicInfo;
@property (nonatomic, copy) NSString *ParentAccount;
@property (nonatomic, copy) NSString *UserType;
@property (nonatomic, assign) int CanBinding; //是否可以绑定

@end

//微博列表
@interface WeiboList : NSObject

@property (nonatomic, assign) int MicroblogId;
@property (nonatomic, assign) int CommentCount; //评论数
@property (nonatomic, assign) int FavoriteCount; //赞个数
@property (nonatomic, strong) NSString *DateTime;
@property (nonatomic, strong) NSString *body;
@property (nonatomic, strong) NSString *UserName;
@property (nonatomic, strong) NSMutableArray *ImagesUrl;

@end

//我的动态
@interface MyDynamic : NSObject

@property (nonatomic, assign)int ActivityId;//动态ID
@property (nonatomic, assign) int OwnerId;
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
@property (nonatomic, assign) int albumNumber;
@property (nonatomic, assign) int blogThreadNumber;
@property (nonatomic, assign) int microBlogNumber;
//点赞：Parase
@property (nonatomic, copy)NSString *Detail;
@property (nonatomic, assign)int Total;
@property (nonatomic, strong)NSArray *Photos;
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

/****相册列表****/
@interface PhotoList : NSObject
@property (nonatomic, strong) NSString *AlbumName;
@property (nonatomic, strong) NSString *CoverPatch;
@property (nonatomic, strong) NSString *DateTime;
@property (nonatomic, strong) NSString *Description;
@property (nonatomic, assign) int AlbumId;
@property (nonatomic, assign) int PhotoCount;

@end

//图片 -- 相册中一张图片的信息
@interface Photo : NSObject

@property (nonatomic, copy) NSString *albumId;
@property (nonatomic, copy) NSString *photoId;
@property (nonatomic, copy) NSString *url;

@end

//最近图片

@interface RecentlyPhotos : NSObject
@property (nonatomic,copy) NSString *mydate;
@property (nonatomic,copy) NSString *todaydes;
@property (nonatomic,copy) NSString *PicInfos;
@property (nonatomic, assign) int TenantTypeId;
@property (nonatomic,strong) NSMutableArray *ImageArray;

@end


