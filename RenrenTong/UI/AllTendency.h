//
//  AllTendency.h
//  RenrenTong
//
//  Created by 符其彬 on 15/5/20.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

/**
 *  关于社区动态功能的数据model都在此文件中
 *
 */

#import "JSONModel.h"
@protocol TheMyTendencyList @end
@protocol TheMyTendencyCommentCentent @end
@protocol TheMyTendencyPraiseUsers @end
@protocol TheGoodFriendTendencyList @end
@protocol TheGoodFriendTendencyCommentCentent @end
@protocol TheGoodFriendTendencyPraiseUsers @end

@interface AllTendency : JSONModel

@end

/**
 *  我的动态
 */

// 四级


@interface TheMyTendencyPraiseUsers : JSONModel

@property (nonatomic,strong) NSString <Optional>*UserId;
@property (nonatomic,strong) NSString <Optional>*UserName;
@property (nonatomic,strong) NSString <Optional>*PictureUrl;

@end

// 四级
@interface TheMyTendencyCommentCentent : JSONModel

@property (nonatomic,strong) NSString <Optional>*Author;
@property (nonatomic,strong) NSString <Optional>*Body;
@property (nonatomic,strong) NSString <Optional>*ChildCount;
@property (nonatomic,strong) NSString <Optional>*CommentedObjectId;
@property (nonatomic,strong) NSString <Optional>*DateCreated;
@property (nonatomic,strong) NSString <Optional>*Id;
@property (nonatomic,strong) NSString <Optional>*CommenId;
@property (nonatomic, strong) NSNumber <Optional>*IsAnonymous;
@property (nonatomic, strong) NSNumber <Optional>*IsPrivate;
@property (nonatomic,strong) NSString <Optional>*OwnerId;
@property (nonatomic,strong) NSString <Optional>*UserId;
@property (nonatomic,strong) NSString <Optional>*ParentId;
@property (nonatomic,strong) NSString <Optional>*TenantTypeId;
@property (nonatomic,strong) NSString <Optional>*ToUserDisplayName;
@property (nonatomic,strong) NSString <Optional>*ToUserId;

@end
//三级
@interface  TheMyTendencyList: JSONModel

@property (nonatomic,strong) NSString <Optional>*ActivityId;
@property (nonatomic,strong) NSString <Optional>*DateTime;
@property (nonatomic,strong) NSString <Optional>*ObjectId;
@property (nonatomic,strong) NSString <Optional>*UserId;
@property (nonatomic,strong) NSString <Optional>*UserName;
@property (nonatomic,strong) NSString <Optional>*PictureUrl;
@property (nonatomic,strong) NSString <Optional>*TypeId;
@property (nonatomic,strong) NSString <Optional>*FavoriteCount;
@property (nonatomic,strong) NSString <Optional>*IsFavorited;
@property (nonatomic,strong) NSString <Optional>*IsPrivate;
@property (nonatomic,strong) NSString <Optional>*IsComment;
@property (nonatomic,strong) NSString <Optional>*ArchiveId;
@property (nonatomic,strong) NSString <Optional>*LinkUrl;
@property (nonatomic,strong) NSNumber <Optional>*HasPhoto;
@property (nonatomic,strong) NSNumber <Optional>* HasFile;
@property (nonatomic,strong) NSNumber <Optional>* HasMusic;
@property (nonatomic,strong) NSNumber <Optional>* HasVideo;
@property (nonatomic,strong) NSNumber <Optional>* IsForward;
@property (nonatomic,strong) NSString <Optional>*Body;
@property (nonatomic,strong) NSString <Optional>*ImagesCount;
@property (nonatomic,strong) NSMutableArray <Optional>*ImagesUrl;// 内容图片数组
@property (nonatomic,strong) NSString <Optional>*CommentCount;
@property (nonatomic,strong) NSString <Optional>*PraiseCount;
@property (nonatomic,strong) NSString <Optional>*MicroblogId;
@property (nonatomic,strong) NSString <Optional>*From;
@property (nonatomic,strong) NSString <Optional>*ForwardedCount;
@property (nonatomic,strong) NSString <Optional>*OriginalMicroblogId;
@property (nonatomic,strong) NSString <Optional>*ForwardedMicroblogId;
@property (nonatomic,strong) NSString <Optional>*TheTitle;
@property (nonatomic,strong) NSNumber <Optional>*IsPraise;
@property (nonatomic, strong) NSMutableArray <Optional,TheMyTendencyCommentCentent>*CommentCentent;

@property (nonatomic, strong) NSMutableArray <Optional,TheMyTendencyPraiseUsers>*PraiseUsers;

@end

// 二级
@interface TheMyTendencyMsg : JSONModel

@property (nonatomic,strong) NSString <Optional>*count;
@property (nonatomic,strong) NSString <Optional>*totalCount;
@property (nonatomic, strong) NSArray <Optional,TheMyTendencyList>*list;

@end

//一级
@interface TheMyTendency : JSONModel
@property (nonatomic,assign) NSInteger st;
@property (nonatomic, strong) TheMyTendencyMsg <Optional>*msg;

@end

/**
 *  好友动态
 */
// 四级
@interface  TheGoodFriendTendencyPraiseUsers: JSONModel

@property (nonatomic,strong) NSString <Optional>*UserId;
@property (nonatomic,strong) NSString <Optional>*UserName;
@property (nonatomic,strong) NSString <Optional>*PictureUrl;

@end
// 四级
@interface TheGoodFriendTendencyCommentCentent : JSONModel

@property (nonatomic,strong) NSString <Optional>*Author;
@property (nonatomic,strong) NSString <Optional>*Body;
@property (nonatomic,strong) NSString <Optional>*ChildCount;
@property (nonatomic,strong) NSString <Optional>*CommentedObjectId;
@property (nonatomic,strong) NSString <Optional>*DateCreated;
@property (nonatomic,strong) NSString <Optional>*Id;
@property (nonatomic,strong) NSString <Optional>*CommenId;
@property (nonatomic, strong) NSNumber <Optional>*IsAnonymous;
@property (nonatomic, strong) NSNumber <Optional>*IsPrivate;
@property (nonatomic,strong) NSString <Optional>*OwnerId;
@property (nonatomic,strong) NSString <Optional>*UserId;
@property (nonatomic,strong) NSString <Optional>*ParentId;
@property (nonatomic,strong) NSString <Optional>*TenantTypeId;
@property (nonatomic,strong) NSString <Optional>*ToUserDisplayName;
@property (nonatomic,strong) NSString <Optional>*ToUserId;

@end
// 三级
@interface  TheGoodFriendTendencyList: JSONModel

@property (nonatomic,strong) NSString <Optional>*ActivityId;
@property (nonatomic,strong) NSString <Optional>*DateTime;
@property (nonatomic,strong) NSString <Optional>*ObjectId;
@property (nonatomic,strong) NSString <Optional>*UserId;
@property (nonatomic,strong) NSString <Optional>*UserName;
@property (nonatomic,strong) NSString <Optional>*PictureUrl;
@property (nonatomic,strong) NSString <Optional>*TypeId;
@property (nonatomic,strong) NSString <Optional>*FavoriteCount;
@property (nonatomic,strong) NSString <Optional>*IsFavorited;
@property (nonatomic,strong) NSString <Optional>*IsPrivate;
@property (nonatomic,strong) NSString <Optional>*IsComment;
@property (nonatomic,strong) NSString <Optional>*ArchiveId;
@property (nonatomic,strong) NSString <Optional>*LinkUrl;
@property (nonatomic,strong) NSNumber <Optional>*HasPhoto;
@property (nonatomic,strong) NSNumber <Optional>* HasFile;
@property (nonatomic,strong) NSNumber <Optional>* HasMusic;
@property (nonatomic,strong) NSNumber <Optional>* HasVideo;
@property (nonatomic,strong) NSNumber <Optional>* IsForward;
@property (nonatomic,strong) NSString <Optional>*Body;
@property (nonatomic,strong) NSString <Optional>*ImagesCount;
@property (nonatomic,strong) NSArray <Optional>*ImagesUrl;// 内容图片数组
@property (nonatomic,strong) NSString <Optional>*CommentCount;
@property (nonatomic,strong) NSString <Optional>*PraiseCount;
@property (nonatomic,strong) NSString <Optional>*MicroblogId;
@property (nonatomic,strong) NSString <Optional>*From;
@property (nonatomic,strong) NSString <Optional>*ForwardedCount;
@property (nonatomic,strong) NSString <Optional>*OriginalMicroblogId;
@property (nonatomic,strong) NSString <Optional>*ForwardedMicroblogId;

@property (nonatomic,strong) NSNumber <Optional>*IsPraise;
@property (nonatomic, strong) NSArray <Optional,TheMyTendencyCommentCentent>*CommentCentent;

@property (nonatomic, strong) NSMutableArray <Optional,TheMyTendencyPraiseUsers>*PraiseUsers;

@end
// 二级
@interface  TheGoodFriendTendencyMsg: JSONModel
@property (nonatomic,strong) NSString <Optional>*count;
@property (nonatomic,strong) NSString <Optional>*totalCount;
@property (nonatomic, strong) NSArray <Optional,TheGoodFriendTendencyList>*list;

@end
// 一级
@interface TheGoodFriendTendency : JSONModel
@property (nonatomic,assign) NSInteger st;
@property (nonatomic, strong) TheGoodFriendTendencyMsg <Optional>*msg;

@end

/**
 *  发布文章
 */

@interface RecentlyArticle : JSONModel
@property (nonatomic,strong) NSNumber <Optional>*result;
@property (nonatomic,strong) NSNumber <Optional>*st;

@property (nonatomic,strong) NSString <Optional>*msg;
@property (nonatomic,strong) NSString <Optional>*messageId;
@property (nonatomic,strong) NSString <Optional>*objectId;


@end
