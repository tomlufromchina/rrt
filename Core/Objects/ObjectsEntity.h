//
//  ObjectsEntity.h
//  RenrenTong
//
//  Created by jeffrey on 14-5-21.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
@interface BaiDuPushParams : NSObject

@property (nonatomic, strong) NSString *appid;           
@property (nonatomic, strong) NSString *userid;
@property (nonatomic, strong) NSString *channelid;
@property (nonatomic, strong) NSString *deviceToken;
+(BaiDuPushParams*)shareBaiDuPushParams;
@end
//Login info
@interface Login : JSONModel

@property (nonatomic, strong) NSString *userId;           //唯一标识
@property (nonatomic, strong) NSString *tokenId;          //登陆token
@property (nonatomic, strong) NSString *userAvatar;
@property (nonatomic, strong) NSString *userName;         //nick name
@property (nonatomic, strong) NSString *userRole;         //用户角色

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
@property (nonatomic, copy) NSString *PicInfo;
@property (nonatomic, copy) NSString *photoID;
@property (nonatomic, copy) NSString *albumID;
@property (nonatomic, copy) NSMutableArray *photoAddress;
@property (nonatomic, copy) NSString *UserId;
@property (nonatomic, copy) NSString *UserName;
@property (nonatomic, copy) NSString *UserType;
@property (nonatomic, copy) NSString *parentName;
@property (nonatomic, copy) NSString *LatestNews;//更新了是 微博or日志or相册
@property (nonatomic, copy) NSString *headImage;
@property (nonatomic, copy) NSString *AccountMobile;

@property (nonatomic, assign) BOOL isFriend;

@end

// 本人资料
@interface MyselfDetails : NSObject
@property (nonatomic, copy) NSString *AccountEmail;
@property (nonatomic, copy) NSString *NickName;
@property (nonatomic, copy) NSString *TrueName;
@property (nonatomic, copy) NSString *PictureUrl;
@property (nonatomic, copy) NSString *AccountMobile;
@property (nonatomic, copy) NSString *QQ;
@property (nonatomic, copy) NSString *Birthday;
@property (nonatomic, copy) NSString *Introduction;
@property (nonatomic, copy) NSString *NowAreaCode;
@property (nonatomic, copy) NSString *School;
@property (nonatomic, copy) NSString *UserName;
@property (nonatomic, copy) NSString *Aliwangwang;
@property (nonatomic, assign) int Rank;
@property (nonatomic, assign) int BlogThreadsCount;
@property (nonatomic, assign) int ExperiencePoints;
@property (nonatomic, assign) int Sex;
@property (nonatomic, assign) int FavoritesCount;

@end

// 最新动态

@interface NewActivity : NSObject

@property (nonatomic, assign) int TypeId;
@property (nonatomic, copy) NSString *Body;
@property (nonatomic, copy) NSString *Title;
@property (nonatomic, strong) NSMutableArray *ImagesUrlArray;

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
@property (nonatomic, strong) NSString *SenderUserId;//
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
@property (nonatomic, strong) NSString *UserId;
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

// 搜索

@interface SeacherObject : NSObject

@property (nonatomic, copy) NSString *Body;
@property (nonatomic, copy) NSString *Description;
@property (nonatomic, copy) NSString *DateTime;
@property (nonatomic, copy) NSString *UserName;
@property (nonatomic, copy) NSString *UserId;
@property (nonatomic, copy) NSString *PictureUrl;
@property (nonatomic, copy) NSString *RelativePath;
@property (nonatomic, assign) int TypeId;
@property (nonatomic, copy) NSString *Schools;
@property (nonatomic,copy) NSString *Relevance;
@property (nonatomic, assign) BOOL IsFollows;
@property (nonatomic, assign) int Sex;
@property (nonatomic, copy) NSString *Roles;

@end

// 学生排名
@interface StudentRank : NSObject

@property (nonatomic, copy) NSString *ClassAlias;
@property (nonatomic, copy) NSString *ExamName;
@property (nonatomic, copy) NSString *ExamTime;
@property (nonatomic, copy) NSString *StudentName;
@property (nonatomic, assign) int SubjectCount;
@property (nonatomic, assign) int FullScore;
@property (nonatomic, assign) int TotalScore;
@property (nonatomic, assign) int StudentCount;
@property (nonatomic, assign) int StudentId;
@property (nonatomic, assign) int ClassRank;
@property (nonatomic, assign) int theStudentCount;
@property (nonatomic, strong) NSMutableArray *ExamSubject;

@end

// 每科详情
@interface StudentExam : NSObject
@property (nonatomic, copy) NSString *SubjectName;
@property (nonatomic, copy) NSString *StudentName;
@property (nonatomic, copy) NSString *CreateTime;
@property (nonatomic, assign) int SubjectIndex;
@property (nonatomic, assign) int ClassRank;
@property (nonatomic, assign) int GradeRank;
@property (nonatomic, assign) int StudentId;
@property (nonatomic, assign) int TotalScore;

@end

// 通知内容
@interface TheNotice : NSObject
@property (nonatomic, copy) NSString *CreateBy;
@property (nonatomic, copy) NSString *MsgContent;
@property (nonatomic, copy) NSString *CatchTime;

@end

// 通知内容
@interface GoodFriend : NSObject
@property (nonatomic, strong) NSNumber *FollowsCount;
@property (nonatomic, strong) NSString *Introduction;
@property (nonatomic, strong) NSNumber *IsFollowed;
@property (nonatomic, strong) NSNumber *IsOnline;
@property (nonatomic, strong) NSString *PictureUrl;
@property (nonatomic, strong) NSString *Roles;
@property (nonatomic, strong) NSString *Schools;
@property (nonatomic, strong) NSNumber *Sex;
@property (nonatomic, strong) NSNumber *UserId;
@property (nonatomic, strong) NSString *UserName;
@property (nonatomic, strong) NSString *TrueName;

@end

// 访客模式
@interface VisitorModel : NSObject <NSCoding>

@property (nonatomic, copy) NSString *UserName;
@property (nonatomic, copy) NSString *DateTime;
@property (nonatomic, copy) NSString *PictureUrl;
@property (nonatomic, copy) NSString *Title;
@property (nonatomic, copy) NSString *Body;
@property (nonatomic, assign) int CommentCount;
@property (nonatomic, assign) int PraiseCount;
@property (nonatomic, assign) int TypeId;// 判断微博、日志、相册、班级文章、班级网相册、班级网微博
@property (nonatomic, copy) NSString *ObjectId;
@property (nonatomic, assign) BOOL hasImage;
@property (nonatomic, assign) BOOL IsPraise;
@property (nonatomic, copy) NSString *LinkUrl;// 分享链接
@property (nonatomic, strong) NSMutableArray *CommentCentent;// 评论
@property (nonatomic, strong) NSMutableArray *ImagesUrl;// 图片
@property (nonatomic, strong) NSMutableArray *praisePopulationURLs;
@property (nonatomic, copy) NSString *MicroblogId;


@end

@interface MyClassLists : NSObject

@property (nonatomic, copy) NSString *ClassId;
@property (nonatomic, copy) NSString *ClassName;
@property (nonatomic, copy) NSString *ClassFace;
@property (nonatomic, copy) NSString *SchoolId;
@property (nonatomic, copy) NSString *Slogan;

@end

@interface MyClassListsBulletin : NSObject

@property (nonatomic, copy) NSString *ArchiveTitle;
@property (nonatomic, copy) NSString *ArchiveText;
@property (nonatomic, copy) NSString *HitCount;
@property (nonatomic, copy) NSString *PubTime;
@property (nonatomic, copy) NSString *ArchiveId;


@end

// 日志详情模式
@interface LogModel : NSObject

@property (nonatomic, copy) NSString *UserName;
@property (nonatomic, copy) NSString *DateTime;
@property (nonatomic, copy) NSString *PictureUrl;
@property (nonatomic, copy) NSString *UserFace;
@property (nonatomic, copy) NSString *Title;
@property (nonatomic, copy) NSString *Body;
@property (nonatomic, assign) int CommentCount;
@property (nonatomic, assign) int PraiseCount;
@property (nonatomic, assign) int TypeId;// 判断微博、日志、相册
@property (nonatomic, copy) NSString *ObjectId;
@property (nonatomic, copy) NSString *ArchiveId;
@property (nonatomic, assign) BOOL hasImage;
@property (nonatomic, assign) BOOL IsPraise;
@property (nonatomic, copy) NSString *LinkUrl;// 分享链接
@property (nonatomic, strong) NSMutableArray *CommentCentent;// 评论
@property (nonatomic, strong) NSMutableArray *ImagesUrl;// 图片
@property (nonatomic, strong) NSMutableArray *praisePopulationURLs;
// 班级文章详情
@property (nonatomic, strong) NSMutableArray *praise;
@property (nonatomic, copy) NSString *ArchiveTitle;
@property (nonatomic, copy) NSString *ArchiveText;

@end

@interface BlogCommentLists : NSObject

@end

// 发送班级文章类目
@interface ReleaseClassArticleList : NSObject

@property (nonatomic, copy) NSString *CategoryId;
@property (nonatomic, copy) NSString *CategoryName;

@end

// 教育资讯

@interface EducationInformation : NSObject <NSCoding>
@property (nonatomic, copy) NSString *Detail;
@property (nonatomic, copy) NSString *Title;
@property (nonatomic, copy) NSString *PublishDate;

@end

// 我的班级最新动态

@interface MyClassNewActivity : NSObject <NSCoding>
@property (nonatomic, copy) NSString *UserName;
@property (nonatomic, copy) NSString *DateTime;
@property (nonatomic, copy) NSString *Body;
@property (nonatomic, copy) NSString *TypeId;

@end


