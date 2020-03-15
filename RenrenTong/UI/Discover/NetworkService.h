//
//  NetworkService.h
//  RenrenTong
//
//  Created by aedu on 15/4/8.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArchiveList.h"
#import "AlbumList.h"
#import "MyCurrentClassModel.h"
#import "AllTendency.h"

/**
 *  班级相册,班级文章,广告，权限，热门话题详情网络请求（AFNetworking）
 */

@interface NetworkService : NSObject

typedef void (^SuccessfulWithData)(id model);
typedef void (^ErrorWithData)(id model);
/**
 *  网络请求错误
 */
typedef void (^error)();


//上传照片时用到
/**
 *  获取上传图片时的相册列表
 *
 *  @param classId   班级ID
 *  @param pageSize  当前数量
 *  @param pageIndex 当前页
 *  @param success   成功回调
 *  @param error     失败回调
 */
+(void)getPhotoAblumUpPhotoList:(NSString*)classId PageSize:(NSInteger)pageSize PageIndex:(NSInteger)pageIndex Successful:(SuccessfulWithData)success Error:(ErrorWithData)error Cache:(SuccessfulWithData)cacheData;
/**
 *  更新图片描述
 *
 *  @param ids     图片Id
 *  @param des     描述内容
 *  @param success 成功回调
 *  @param error   失败回调
 */
+(void)updatePhotoDes:(NSString*)ids Des:(NSString*)des Successful:(SuccessfulWithData)success Error:(ErrorWithData)error;

/**
 *  更新班级最新动态
 *
 *  @param classId 班级id
 *  @param ablumId 相册id
 *  @param batchId 唯一标志符
 *  @param token   token
 *  @param success 成功回调
 *  @param error   失败回调
 */
+(void)updatePhotoOrLogClassId:(NSString *)classId AblumId:(NSString *)ablumId BatchId:(NSString *)batchId Token:(NSString *)token Successful:(SuccessfulWithData)success Error:(ErrorWithData)error;


/**
 *  获取相册列表
 *
 *  @param classId 班级Id
 *  @param success 成功回调
 *  @param error   失败回调
 */
+(void)getPhotoAblumList:(NSString*)classId Successful:(SuccessfulWithData)success Error:(ErrorWithData)error;
/**
 *  获取图片列表
 *
 *  @param AblumId   相册ID
 *  @param pageSize  当前数量
 *  @param pageIndex 当前页
 *  @param success   成功回调
 *  @param error     失败回调
 */
+(void)getPhotoList:(NSString*)AblumId PageSize:(NSInteger)pageSize PageIndex:(NSInteger)pageIndex Successful:(SuccessfulWithData)success Error:(ErrorWithData)error Cache:(SuccessfulWithData)cacheData;

/**
 *  删除图片
 *
 *  @param objectId 图片ID
 *  @param typeId   类型
 *  @param success  成功回调
 *  @param error    失败回调
 */
+(void)deletePhoto:(NSString*)objectId TypeId:(NSString*)typeId Successful:(SuccessfulWithData)success Error:(ErrorWithData)error;
/**
 *  获取图片详情
 *
 *  @param PhotoId 图片ID
 *  @param success 成功回调
 *  @param error   失败回调
 */
+(void)getPhotoDetail:(NSString*)PhotoId Successful:(SuccessfulWithData)success Error:(ErrorWithData)error;

/**
 *  获取图片评论列表
 *
 *  @param PhotoId   图片ID
 *  @param pageSize  当前数量
 *  @param pageIndex 当前页
 *  @param success   成功回调
 *  @param error     失败回调
 */
+(void)getPhotoCommentList:(NSString*)PhotoId PageSize:(NSInteger)pageSize PageIndex:(NSInteger)pageIndex Successful:(SuccessfulWithData)success Error:(ErrorWithData)error Cache:(SuccessfulWithData)cacheData;

/**
 *  点赞
 *
 *  @param PhotoId 图片ID
 *  @param userId  用户ID
 *  @param success 成功回调
 *  @param error   失败回调
 */
+(void)praisePhoto:(NSString*)PhotoId UserId:(NSString*)userId Successful:(SuccessfulWithData)success Error:(ErrorWithData)error;
/**
 *  发表图片评论
 *
 *  @param archiveId   图片Id
 *  @param userId      用户ID
 *  @param pId         回复对象ID
 *  @param commentText 回复内容
 *  @param success     成功回调
 *  @param error       失败回调
 */
+(void)postPhotoComment:(NSString*)archiveId UserId:(NSString*)userId PId:(NSString*)pId CmmentText:(NSString*)commentText Successful:(SuccessfulWithData)success Error:(ErrorWithData)error;


/**
 *  获取文章列表
 *
 *  @param classId    班级ID
 *  @param userId     用户ID
 *  @param categoryId 分类ID
 *  @param pageSize   页数据数量
 *  @param pageIndex  当前页
 *  @param success    成功回调
 *  @param error      失败回调
 */
+(void)getArchiveList:(NSString*)classId UserId:(NSString*)userId CategoryId:(NSString*)categoryId PageSize:(NSInteger)pageSize PageIndex:(NSInteger)pageIndex Successful:(SuccessfulWithData)success Error:(ErrorWithData)error Cache:(SuccessfulWithData)cacheData;
/**
 *  获取文章分类列表
 *
 *  @param classId   班级ID
 *  @param pageSize  当前页列表数量
 *  @param pageIndex 当前页
 *  @param success   成功回调
 *  @param error     失败回调
 */
+(void)getArchiveCategoryList:(NSString*)classId  PageSize:(NSInteger)pageSize PageIndex:(NSInteger)pageIndex Successful:(SuccessfulWithData)success Error:(ErrorWithData)error Cache:(SuccessfulWithData)cacheData;
/**
 *  获取文章详情
 *
 *  @param archiveId 文章Id
 *  @param success   成功回调
 *  @param error     失败回调
 */
+(void)getArchiveDetail:(NSString*)archiveId Successful:(SuccessfulWithData)success Error:(ErrorWithData)error;
/**
 *  删除文章
 *
 *  @param archiveId 文章ID
 *  @param success   成功回调
 *  @param error     失败回调
 */
+(void)deleteArchive:(NSString*)archiveId Successful:(SuccessfulWithData)success Error:(ErrorWithData)error;

/**
 *  发表文章评论
 *
 *  @param archiveId   文章ID
 *  @param userId      用户Id
 *  @param pId         回复对象
 *  @param commentText 回复内容
 *  @param success     成功回调
 *  @param error       失败回调
 */
+(void)postPublishComment:(NSString*)archiveId UserId:(NSString*)userId PId:(NSString*)pId CmmentText:(NSString*)commentText Successful:(SuccessfulWithData)success Error:(ErrorWithData)error;

/**
 *  文章点赞
 *
 *  @param archiveId 文章ID
 *  @param userId    用户ID
 *  @param success   成功回调
 *  @param error     失败回调
 */
+(void)praiseArchive:(NSString*)archiveId UserId:(NSString*)userId Successful:(SuccessfulWithData)success Error:(ErrorWithData)error;

/**
 *  获取文章评论列表
 *
 *  @param archiveId 文章Id
 *  @param pageSize  当前列表数量
 *  @param pageIndex 当前列表页数
 *  @param success   成功回调
 *  @param error     失败回调
 */
+(void)getArchiveCommentList:(NSString*)archiveId PageSize:(NSInteger)pageSize PageIndex:(NSInteger)pageIndex Successful:(SuccessfulWithData)success Error:(ErrorWithData)error Cache:(SuccessfulWithData)cacheData;

/**
 *  获取广告
 *
 *  @param type    广告类型
 *  @param toKen   用户toKen
 *  @param success 成功回调
 *  @param error   失败回调
 */
+(void)getAdvert:(NSString*)type Token:(NSString*)toKen Successful:(SuccessfulWithData)success Error:(ErrorWithData)error;

/**
 *  权限查询
 *
 *  @param classId 班级Id
 *  @param userId  用户Id
 *  @param success 成功回调
 *  @param error   失败回调
 */
+(void)getAuthority:(NSString*)classId UserId:(NSString*)userId Successful:(SuccessfulWithData)success Error:(ErrorWithData)error;

/**
 *  获取话题评论列表
 *
 *  @param microblogId 话题Id
 *  @param success     成功回调
 *  @param error       失败回调
 */
+(void)getMicroblogComment:(NSString*)microblogId Successful:(SuccessfulWithData)success Error:(ErrorWithData)error;

/**
 *  话题点赞
 *
 *  @param toKen
 *  @param objectId 对象Id
 *  @param typeId   类型Id
 *  @param success  成功回调
 *  @param error    失败回调
 */
+(void)postPraise:(NSString*)toKen objectId:(NSString *)objectId typeId:(NSString*)typeId  Successful:(SuccessfulWithData)success Error:(ErrorWithData)error;
/**
 *  话题回复
 *
 *  @param UserId   用户id
 *  @param objectID 对象id
 *  @param body     回复内容
 *  @param typeId   类型Id
 *  @param parentId 回复对象Id
 *  @param success  成功回调
 *  @param error    失败回调
 */
+(void)postReplyComments:(NSString*)UserId commentedObjectId:(NSString *)objectID body:(NSString *)body typeId:(NSString*)typeId parentId:(NSString*)parentId Successful:(SuccessfulWithData)success Error:(ErrorWithData)error;

/**
 *  获取班级最新动态
 *
 *  @param toKen     token
 *  @param pageSize  页大小
 *  @param pageIndex 当前页
 *  @param success   成功回调
 *  @param error     失败回调
 *  @param cacheData 缓存回调
 */
+(void)GetMyClassActivity:(NSString*)toKen PageSize:(NSInteger)pageSize PageIndex:(NSInteger)pageIndex Successful:(SuccessfulWithData)success Error:(ErrorWithData)error Cache:(SuccessfulWithData)cacheData;
/**
 *  获取班级列表
 *
 *  @param userId    用户id
 *  @param userRole  用户类别
 *  @param success   成功回调
 *  @param error     失败回调
 *  @param cacheData 缓存回调
 */
+(void)GetClassList:(NSString*)userId UserRole:(NSString*)userRole Successful:(SuccessfulWithData)success Error:(ErrorWithData)error Cache:(SuccessfulWithData)cacheData;
/**
 *  班级公告
 *
 *  @param classId   班级id
 *  @param pageSize  页大小
 *  @param pageIndex 当前页
 *  @param success   成功回调
 *  @param error     失败回调
 *  @param cacheData 缓存回调
 */
+(void)GetNoticeList:(NSString*)classId PageSize:(NSInteger)pageSize PageIndex:(NSInteger)pageIndex Successful:(SuccessfulWithData)success Error:(ErrorWithData)error Cache:(SuccessfulWithData)cacheData;
/**
 *  获取班级动态
 *
  *  @param userId    用户id
 *  @param typeId    动态类型
 *  @param pageSize  每页返回数
 *  @param pageIndex 当前页
 *  @param success   成功回调
 *  @param error     失败回调
 *  @param cacheData 缓存回调
 */
+(void)GetClassActivity:(NSString*)typeId ClassId:(NSString *)classId UserId:(NSString*)userId PageSize:(NSInteger)pageSize PageIndex:(NSInteger)pageIndex Successful:(SuccessfulWithData)success Error:(ErrorWithData)error Cache:(SuccessfulWithData)cacheData;
@end
