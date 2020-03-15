//
//  AlbumList.h
//  RenrenTong
//
//  Created by aedu on 15/4/8.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

// 关于相册功能的model都在本文件中

#import "JSONModel.h"
#import "ArchiveList.h"

@protocol MyCurrentClassListModelitems @end
@protocol MyCurrentClassModelBulletinitems @end
@protocol AlbumListItems @end
@protocol GetPhotoItemList @end
@protocol GetPhotoItems @end
@protocol GetPhotoCommentListItem @end
@protocol AdverData @end
@protocol GetAuthorityItem @end

/**
 *  获取相册列表model
 */
@interface AlbumListItems : JSONModel

@property (nonatomic,strong) NSString <Optional>*AblumId;
@property (nonatomic,strong) NSString <Optional>*AblumName;
@property (nonatomic,strong) NSString <Optional>*Description;
@property (nonatomic,strong) NSString <Optional>*DefaultPhotoUrl;
@property (nonatomic,strong) NSString <Optional>*ClassId;
@property (nonatomic,strong) NSString <Optional>*SchoolName;
@property (nonatomic,strong) NSString <Optional>*ClassName;
@property (nonatomic,strong) NSString <Optional>*SchoolClassName;
@property (nonatomic,strong) NSString <Optional>*AblumLink;
@property (nonatomic,strong) NSNumber <Optional>*PhotoCount;

@property (nonatomic,strong) NSString <Optional>*ablumFace;
@property (nonatomic,strong) NSString <Optional>*ablumId;
@property (nonatomic,strong) NSString <Optional>*ablumName;
@property (nonatomic,strong) NSString <Optional>*classId;
@property (nonatomic,strong) NSNumber <Optional>*photoCount;



@end

@interface AlbumList : JSONModel

@property (nonatomic,assign) NSInteger result;
@property (nonatomic,strong) NSNumber <Optional>*count;
@property (nonatomic,strong) NSNumber <Optional>*TotleCount;
@property (nonatomic,strong) NSArray <AlbumListItems,Optional>*items;

@end
//获取相册列表model end>

/**
 *  获取照片列表model
 */
@interface GetPhotoItemList : JSONModel

@property (nonatomic,strong) NSString <Optional>*AblumId;
@property (nonatomic,strong) NSString <Optional>*PhotoId;
@property (nonatomic,strong) NSString <Optional>*PhotoCaption;
@property (nonatomic,strong) NSString <Optional>*PhotoName;
@property (nonatomic,strong) NSString <Optional>*PhotoUrl;
@property (nonatomic,strong) NSString <Optional>*PubTime;
@property (nonatomic,strong) NSString <Optional>*ViewsCount;
@property (nonatomic,strong) NSString <Optional>*GoodCount;
@property (nonatomic,strong) NSNumber <Optional>*IsPraise;
@property (nonatomic,strong) NSArray <Optional,GetArchivePraise>*Praise;
@property (nonatomic,strong) NSString <Optional>*UserFace;
@property (nonatomic,strong) NSString <Optional>*UserId;
@property (nonatomic,strong) NSString <Optional>*UserName;

@end


@interface GetPhotoItems : JSONModel

@property (nonatomic,strong) NSMutableArray <GetPhotoItemList,Optional>*List;
@property (nonatomic,strong) NSString <Optional>*Month;

@end

@interface GetPhotoList : JSONModel

@property (nonatomic,assign) NSInteger result;
@property (nonatomic,strong) NSNumber <Optional>*count;
@property (nonatomic,strong) NSNumber <Optional>*TotleCount;
@property (nonatomic,strong) NSMutableArray < GetPhotoItems,Optional>*items;
@property (nonatomic,strong) NSString <Optional>*msg;

@end
//获取图片列表model end>

/**
 *  获取照片详情model
 */
@interface GetPhotoDetail : JSONModel

@property (nonatomic,assign) NSInteger result;
@property (nonatomic,strong) GetPhotoItemList *photo;

@end

/**
 *  获取图片评论model
 */
@interface GetPhotoCommentListItem : JSONModel

@property (nonatomic,strong) NSString <Optional>*Author;
@property (nonatomic,strong) NSString <Optional>*Body;
@property (nonatomic,strong) NSNumber <Optional>*ChildCount;
@property (nonatomic,strong) NSString <Optional>*CommentedObjectId;
@property (nonatomic,strong) NSString <Optional>*DateCreated;
@property (nonatomic,strong) NSString <Optional>*Id;
@property (nonatomic,strong) NSString <Optional>*CommenId;
@property (nonatomic,strong) NSString <Optional>*CommentId;
@property (nonatomic,assign) BOOL IsAnonymous;
@property (nonatomic,assign) BOOL IsPrivate;
@property (nonatomic,strong) NSString <Optional>*OwnId;
@property (nonatomic,strong) NSString <Optional>*ParentId;
@property (nonatomic,strong) NSString <Optional>*TenantTypeId;
@property (nonatomic,strong) NSString <Optional>*ToUserDisplayName;
@property (nonatomic,strong) NSString <Optional>*ToUserId;
@property (nonatomic,strong) NSString <Optional>*UserId;

@end


@interface GetPhotoCommentList : JSONModel

@property (nonatomic,assign) NSInteger result;
@property (nonatomic,strong) NSNumber <Optional>*count;
@property (nonatomic,strong) NSNumber <Optional>*TotleCount;
@property (nonatomic,strong) NSMutableArray <GetPhotoCommentListItem,Optional>*items;

@end
//获取图片评论model end>

/**
 *  上传图片成功返回数据model
 */
@interface UploadPhotoResult : JSONModel

@property (nonatomic,strong) NSNumber *error;
@property (nonatomic,strong) NSString <Optional>*url;
@property (nonatomic,strong) NSString <Optional>*filename;
@property (nonatomic,strong) NSString <Optional>*id;
@property (nonatomic,strong) NSString <Optional>*Message;

@end
//上传图片成功返回数据model end>

/**
 *  获取广告信息model
 */
@interface AdverData: JSONModel

@property (nonatomic,strong) NSString <Optional>*AdColumn;
@property (nonatomic,strong) NSString <Optional>*AdID;
@property (nonatomic,strong) NSString <Optional>*AdName;
@property (nonatomic,strong) NSString <Optional>*GradeType;
@property (nonatomic,strong) NSString <Optional>*AreaName;
@property (nonatomic,strong) NSString <Optional>*CityName;
@property (nonatomic,strong) NSString <Optional>*CreateDate;
@property (nonatomic,strong) NSString <Optional>*ImageURL;
@property (nonatomic,strong) NSString <Optional>*LinkUrl;
@property (nonatomic,strong) NSString <Optional>*ProvinceName;
@property (nonatomic,strong) NSString <Optional>*SchoolType;
@property (nonatomic,strong) NSString <Optional>*Sex;
@property (nonatomic,strong) NSString <Optional>*StatusID;
@property (nonatomic,strong) NSString <Optional>*UserRole;

@end

@interface Adver: JSONModel

@property (nonatomic,assign) NSInteger Status;
@property (nonatomic,strong) NSArray <AdverData,Optional>*Data;

@end
//获取广告数据model end>

/**
 *  获取用户权限model
 */
@interface GetAuthorityItem: JSONModel

@property (nonatomic,strong) NSString <Optional>*AuthId;
@property (nonatomic,strong) NSString <Optional>*AuthName;
@property (nonatomic,strong) NSString <Optional>*AuthDes;
@property (nonatomic,assign) BOOL IsOwn;

@end

@interface GetAuthority: JSONModel
@property (nonatomic,assign) NSInteger result;
@property (nonatomic,strong) NSArray <GetAuthorityItem,Optional>*items;
@end

//获取用户权限model end>


/**
 *  获取热门话题评论model（由于评论model与相片评论model类似，未归类到热门话题model）
 */
@interface GetMicroblogCommentMsg: JSONModel

@property (nonatomic,assign) NSInteger count;
@property (nonatomic,assign) NSInteger totalCount;
@property (nonatomic,strong) NSArray <GetPhotoCommentListItem,Optional>*list;
@end

@interface GetMicroblogComment: JSONModel
@property (nonatomic,assign) NSInteger st;
@property (nonatomic,strong) GetMicroblogCommentMsg *msg;

@end

//获取热门话题评论model end>

/**
 *  我的班级列表
 */
// 二级
@interface  MyCurrentClassListModelitems: JSONModel

@property (nonatomic,strong) NSString <Optional>*ClassId;
@property (nonatomic,strong) NSString <Optional>*ClassName;
@property (nonatomic,strong) NSString <Optional>*ClassFace;
@property (nonatomic,strong) NSString <Optional>*SchoolId;
@property (nonatomic,strong) NSString <Optional>*Slogan;


@end
// 一级
@interface MyCurrentClassListModel : JSONModel

@property (nonatomic,assign) NSInteger result;
@property (nonatomic, strong) NSArray <Optional,MyCurrentClassListModelitems>*items;

@end

/**
 *  班级公告
 */

@interface  MyCurrentClassModelBulletinitems: JSONModel

@property (nonatomic,strong) NSString <Optional>*ArchiveId;
@property (nonatomic,strong) NSString <Optional>*UserName;
@property (nonatomic,strong) NSString <Optional>*UserPhoto;
@property (nonatomic,strong) NSString <Optional>*ArchiveTitle;
@property (nonatomic,strong) NSString <Optional>*ArchiveText;
@property (nonatomic,strong) NSString <Optional>*HitCount;
@property (nonatomic,strong) NSString <Optional>*PubTime;

@end
// 一级
@interface MyCurrentClassModelBulletin : JSONModel

@property (nonatomic,assign) NSInteger result;
@property (nonatomic,assign) NSInteger count;
@property (nonatomic,assign) NSInteger TotalCount;
@property (nonatomic, strong) NSArray <Optional,MyCurrentClassModelBulletinitems>*items;

@end