//
//  NetWorkManager.h
//  nextSing
//
//  Created by chester on 14-2-22.
//  Copyright (c) 2014年 iflytek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ObjectsEntity.h"
#import "Activity.h"
#import "Commonality.h"
#import "JournalDetail.h"
#import "MicroblogDetail.h"
#import "AlbumDetail.h"
#import "FriendDynamicDetail.h"
#import "DynamicComments.h"
#import "BlogComments.h"

/**
 *  负责页面请求
 */
@interface NetWorkManager : NSObject

#pragma mark - 登录
#pragma mark -
- (void)loginWithUserName:(NSString *)user
             withPassword:(NSString *)password
                  success:(void(^)(Login *login))successBlock
                   failed:(void(^)(NSString *errorMSG))failedBlock;

#pragma mark - 注册
#pragma mark -
- (void)registerWithUserName:(NSString *)account
             withPassword:(NSString *)password
                    username:(NSString *)username
                    usertype:(NSString *)usertype
                  success:(void(^)(NSDictionary* data))successBlock
                   failed:(void(^)(NSString *errorMSG))failedBlock;

#pragma mark - 获取用户角色
#pragma mark -

- (void)getUserOfRole:(NSString *)userId
              success:(void(^)(NSDictionary* data))successBlock
               failed:(void(^)(NSString *errorMSG))failedBlock;

#pragma mark - 获取用户角色
#pragma mark -

- (void)getUserOfPackage:(NSString *)token
                 success:(void(^)(NSArray* data))successBlock
                  failed:(void(^)(NSString *errorMSG))failedBlock;

#pragma mark - 上传图片
#pragma mark -

- (void)uploadImage:(NSString *)UserId
             TypeId:(NSString *)TypeId
               File:(NSString *)File;

#pragma mark - Activity
#pragma mark -
- (void)fetchActivity:(NSString *)tokenId
               typeId:(NSString *)typeId
              groupId:(NSString *)groupId
            pageIndex:(int)pageIndex
              success:(void(^)(NSArray *data))successBlock
               failed:(void(^)(NSString *errorMSG))failedBlock;

- (void)refreshActivity:(NSString *)tokenId
                 typeId:(NSString *)typeId
                groupId:(NSString *)groupId
         lastActivityId:(NSString *)activityId
                success:(void(^)(NSDictionary* data))successBlock
                 failed:(void(^)(NSString *errorMSG))failedBlock;

- (void)favoriteActivity:(NSString *)tokenId
                  objectId:(NSString *)objectId
                 typeId:(NSString *)typeId
                 success:(void(^)(NSDictionary* data))successBlock
                  failed:(void(^)(NSString *errorMSG))failedBlock;

- (void)forwardActivity:(NSString *)userId
                objectId:(NSString *)objectId
                   body:(NSString *)body
                 success:(void(^)(NSDictionary* data))successBlock
                  failed:(void(^)(NSString *errorMSG))failedBlock;

- (void)shareActivity:(NSString *)userId
               objectId:(NSString *)objectId
                   body:(NSString *)body
                success:(void(^)(NSDictionary* data))successBlock
                 failed:(void(^)(NSString *errorMSG))failedBlock;

- (void)shieldActivity:(NSString *)tokenId
            activityId:(NSString *)activityId
               success:(void(^)(NSDictionary* data))successBlock
                failed:(void(^)(NSString *errorMSG))failedBlock;

- (void)reportActivity:(NSString *)tokenId
            activityId:(NSString *)activityId
                  body:(NSString *)body
                  type:(int)type
               success:(void(^)(NSDictionary* data))successBlock
                failed:(void(^)(NSString *errorMSG))failedBlock;

#pragma mark - Activity---weibo
#pragma mark -
//微博详情
- (void)fetchWeiboDetail:(NSString *)weiboId
              success:(void(^)(Activity* activity))successBlock
               failed:(void(^)(NSString *errorMSG))failedBlock;

- (void)fetchComments:(NSString *)tokenId
              ofWeibo:(NSString *)weiboId
                 success:(void(^)(NSDictionary* data))successBlock
                  failed:(void(^)(NSString *errorMSG))failedBlock;

- (void)refreshComments:(NSString *)lastCommentId
              ofWeibo:(NSString *)weiboId
              success:(void(^)(NSDictionary* data))successBlock
               failed:(void(^)(NSString *errorMSG))failedBlock;

- (void)fetchForwardOfWeibo:(NSString *)weiboId
                   pageSize:(int)pageSize
                  pageIndex:(int)pageIndex
                    success:(void(^)(NSDictionary* data))successBlock
                     failed:(void(^)(NSString *errorMSG))failedBlock;

- (void)refreshForwardOfWeibo:(NSString *)weiboId
                   lastForwardedId:(NSString*)lastForwardedId
                  pageIndex:(int)pageIndex
                    success:(void(^)(NSDictionary* data))successBlock
                     failed:(void(^)(NSString *errorMSG))failedBlock;

- (void)fetchFavoritedOfWeibo:(NSString *)weiboId
                  pageIndex:(int)pageIndex
                    success:(void(^)(NSDictionary* data))successBlock
                     failed:(void(^)(NSString *errorMSG))failedBlock;

- (void)sendWeibo:(NSString *)userId
             body:(NSString *)body
         HasPhoto:(NSString *)HasPhoto
         ImageUrl:(NSString *)ImageUrl
          success:(void(^)(NSDictionary* data))successBlock
           failed:(void(^)(NSString *errorMSG))failedBlock;

#pragma mark - Activity---blog
#pragma mark -
- (void)fetchBlogDetail:(NSString *)blogId
                 success:(void(^)(Activity* activity))successBlock
                  failed:(void(^)(NSString *errorMSG))failedBlock;

- (void)fetchCommentsOfBlog:(NSString *)blogId
                    pageIndex:(int)pageIndex
                      success:(void(^)(NSDictionary* data))successBlock
                       failed:(void(^)(NSString *errorMSG))failedBlock;

- (void)fetchForwardedOfBlog:(NSString *)blogId
                  pageIndex:(int)pageIndex
                    success:(void(^)(NSDictionary* data))successBlock
                     failed:(void(^)(NSString *errorMSG))failedBlock;

- (void)fetchFavoritedOfBlog:(NSString *)blogId
                   pageIndex:(int)pageIndex
                     success:(void(^)(NSDictionary* data))successBlock
                      failed:(void(^)(NSString *errorMSG))failedBlock;
//写日志
- (void)sendBlog:(NSString *)UserId
             Subject:(NSString *)pageIndex
             Body:(NSString *)Body
          success:(void(^)(NSDictionary* data))successBlock
           failed:(void(^)(NSString *errorMSG))failedBlock;

#pragma mark - Message
#pragma mark -

#pragma mark - Contact
#pragma mark -
//- (void)fetchContactFor:(int)type
//               withRole:(int)role
//              withToken:(NSString *)tokenId
//               withUser:(NSString*)userId
//                success:(void(^)(NSArray* data))successBlock
//                 failed:(void(^)(NSString *errorMSG))failedBlock;

//- (void)fetchContactDetailById:(NSString*)userId
//                     withToken:(NSString *)tokenId
//                       success:(void(^)(Contact* data))successBlock
//                        failed:(void(^)(NSString *errorMSG))failedBlock;


#pragma mark - 权限设置功能（必须返回参数：查看者是否已屏蔽此用户的空间信息，查看者是否已设置禁止此人访问）
#pragma mark -fqb
//设置禁止此人访问自己的空间或允许此人访问自己的空间
- (void)prohibitVisit:(NSString *)Token
              VUserId:(NSString *)VUserId
              OUserId:(NSString *)OUserId
             IsForbid:(NSString *)IsForbid
              success:(void(^)(NSDictionary* data))successBlock
               failed:(void(^)(NSString *errorMSG))failedBlock;

// 设置自己屏蔽此人的空间信息或取消屏蔽此人的空间信息

- (void)shieldingSpace:(NSString *)Token
               VUserId:(NSString *)VUserId
               OUserId:(NSString *)OUserId
             OUserName:(NSString *)OUserName
                  IsPb:(NSString *)IsPb
               success:(void(^)(NSDictionary* data))successBlock
                failed:(void(^)(NSString *errorMSG))failedBlock;


#pragma mark - 点赞
#pragma mark -

- (void)clickPraise:(NSString *)Token
           ObjectId:(NSString *)ObjectId
       ObjectTypeId:(NSString *)ObjectTypeId
             UserId:(NSString *)UserId
           UserName:(NSString *)UserName
            success:(void(^)(NSDictionary* data))successBlock
             failed:(void(^)(NSString *errorMSG))failedBlock;


#pragma mark - 评论
#pragma mark -

- (void)clickComment:(NSString *)CommentedObjectId
              UserId:(NSString *)UserId
                Body:(NSString *)Body
              TypeId:(NSString *)TypeId
             success:(void(^)(NSDictionary* data))successBlock
              failed:(void(^)(NSString *errorMSG))failedBlock;

#pragma mark - 相册的动态评论
#pragma mark -

- (void)albumComment:(NSString *)Token
   CommentedObjectId:(NSString *)CommentedObjectId
             OwnerId:(NSString *)OwnerId
              UserId:(NSString *)UserId
              Author:(NSString *)Author
             subject:(NSString *)subject
                body:(NSString *)body
             success:(void(^)(NSDictionary* data))successBlock
              failed:(void(^)(NSString *errorMSG))failedBlock;

#pragma mark - 相册动态回复
#pragma mark -
- (void)albumReply:(NSString *)Token
   CommentedObjectId:(NSString *)CommentedObjectId
             OwnerId:(NSString *)OwnerId
              UserId:(NSString *)UserId
              Author:(NSString *)Author
             subject:(NSString *)subject
                body:(NSString *)body
            ToUserId:(NSString *)ToUserId
          ToUserName:(NSString *)ToUserName
             success:(void(^)(NSDictionary* data))successBlock
              failed:(void(^)(NSString *errorMSG))failedBlock;

#pragma mark - 日志/微博（回复）
#pragma mark -

- (void)clickReply:(NSString *)CommentedObjectId
              UserId:(NSString *)UserId
                Body:(NSString *)Body
              TypeId:(NSString *)TypeId
            ParentId:(NSString *)ParentId
             success:(void(^)(NSDictionary* data))successBlock
              failed:(void(^)(NSString *errorMSG))failedBlock;

#pragma mark - 我的动态
#pragma mark -

- (void)myDynamic:(NSString *)UserId
           typeId:(int)typeId
        PageIndex:(int)PageIndex
         PageSize:(int)PageSize
          success:(void(^)(NSMutableArray *MyDynamic))successBlock
           failed:(void(^)(NSString *errorMSG))failedBlock;


#pragma mark - 日志，评论等点赞情况获取接口
#pragma mark -

- (void)gainPraiseBlogEvaluateDetail:(NSString *)ObjectId
                             success:(void(^)(NSDictionary* data))successBlock
                              failed:(void(^)(NSString *errorMSG))failedBlock;


#pragma mark - 添加好友
#pragma mark -

- (void)addFriends:(NSString *)Token
            UserId:(NSString *)UserId
      SenderUserId:(NSString *)SenderUserId
            Sender:(NSString *)Sender
         InviteTxt:(NSString *)InviteTxt
           success:(void(^)(NSDictionary* data))successBlock
            failed:(void(^)(NSString *errorMSG))failedBlock;

#pragma mark - 好友动态
#pragma mark -

- (void)friendsDynamicDetail:(NSString *)UserId pageIndex:(int)pageIndex pageSize:(int)pageSize
                     success:(void(^)(NSMutableArray *friendDynamic))successBlock
                      failed:(void(^)(NSString *errorMSG))failedBlock;

#pragma mark - 个人资料
#pragma mark -

- (void)personalDataWithDetail:(NSString *)vuserid
                        OUserId:(NSString *)UserId
                       success:(void(^)(NdividualData *ndividual))successBlock
                        failed:(void(^)(NSString *errorMSG))failedBlock;

#pragma mark - 返回权限信息
#pragma mark -

- (void)backPermissionDetail:(NSString *)vuserid
                     OUserId:(NSString *)OUserId
                     success:(void(^)(NSDictionary* data))successBlock
                      failed:(void(^)(NSString *errorMSG))failedBlock;

#pragma mark - 删除好友
#pragma mark -

- (void)deleteMyFriends:(NSString *)Token
          FriendUserId:(NSString *)FriendUserId
                success:(void(^)(NSDictionary* data))successBlock
                 failed:(void(^)(NSString *errorMSG))failedBlock;

#pragma mark - 联系人列表
#pragma mark -
- (void)AddressBookDetail:(NSString *)Token
                  success:(void(^)(NSDictionary *data))successBlock
                   failed:(void(^)(NSString *errorMSG))failedBlock;

#pragma mark - 微博列表
#pragma mark -

- (void)weiboList:(NSString *)UserId
        PageIndex:(int)PageIndex
          success:(void(^)(NSArray *micList))successBlock
           failed:(void(^)(NSString *errorMSG))failedBlock;

#pragma mark - 微博详情
#pragma mark -
- (void)weiboDetail:(NSString *)MicroblogId
            success:(void(^)(NSArray *micArray))successBlock
             failed:(void(^)(NSString *errorMSG))failedBlock;

#pragma mark - 日志列表
#pragma mark -

- (void)blogListDetail:(NSString *)Token
                UsedId:(NSString *)UserId
             PageIndex:(int)PageIndex
              PageSize:(int)PageSize
               success:(void(^)(NSArray *blog))successBlock
                failed:(void(^)(NSString *errorMSG))failedBlock;


#pragma mark - 日志详情
#pragma mark -
- (void)blogDetail:(NSString *)ThreadId
           success:(void(^)(NSArray *blogDetailArray))successBlock
            failed:(void(^)(NSString *errorMSG))failedBlock;

#pragma mark - 相册列表
#pragma mark -

- (void)photoList:(NSString *)ToKen
           UserId:(NSString *)UserId
         PageSize:(int)PageSize
        PageIndex:(int)PageIndex
          success:(void(^)(NSArray *photoListArray))successBlock
           failed:(void(^)(NSString *errorMSG))failedBlock;

#pragma mark - 图片列表列表
#pragma mark -
- (void)pictureList:(NSString *)ToKen
             UserId:(NSString *)UserId
            AlbumId:(NSString *)AlbumId
           PageSize:(int)PageSize
          PageIndex:(int)PageIndex
            success:(void(^)(NSArray *photoListArray))successBlock
             failed:(void(^)(NSString *errorMSG))failedBlock;

#pragma mark - 删除图片
#pragma mark -
- (void)deletePhotos:(NSString *)token
             photoId:(NSArray *)photoIds
            success:(void(^)(NSDictionary *dict))successBlock
             failed:(void(^)(NSString *errorMSG))failedBlock;

#pragma mark - 新建相册
#pragma mark -

- (void)buildAblum:(NSString *)UserId
        AlbumsName:(NSString *)AlbumsName
       Description:(NSString *)Description
           Privacy:(NSString *)Privacy
           success:(void(^)(NSDictionary *photoListArray))successBlock
            failed:(void(^)(NSString *errorMSG))failedBlock;

#pragma mark - 最近相册
#pragma mark -

- (void)recentlyAblum:(NSString *)Token
            pageIndex:(int)pageIndex
             pageSize:(int)pageSize
             TopCount:(int)TopCount
              success:(void(^)(NSArray *photoListArray))successBlock
               failed:(void(^)(NSString *errorMSG))failedBlock;

#pragma mark - 新朋友
#pragma mark -
- (void)newFriends:(NSString *)Token
            typeId:(NSString *)typeId
         pageIndex:(int)pageIndex
          pageSize:(int)pageSize
           success:(void(^)(NSArray *newFriend))successBlock
            failed:(void(^)(NSString *errorMSG))failedBlock;

#pragma mark - 接受好友请求
#pragma mark -

- (void)acceptNewFriend:(NSString *)InvitationId
                success:(void(^)(NSDictionary *data))successBlock
                 failed:(void(^)(NSString *errorMSG))failedBlock;

#pragma mark - 接受家长请求
#pragma mark -

- (void)acceptNewFamily:(NSString *)Token
                   Type:(NSString *)Type
         ChildrenUserId:(NSString *)ChildrenUserId
                success:(void(^)(NSDictionary *data))successBlock
                 failed:(void(^)(NSString *errorMSG))failedBlock;

#pragma mark - 添加朋友搜索
#pragma mark -

- (void)addFriendsOfSearch:(NSString *)Token
                   ParUserAccount:(NSString *)ParUserAccount
                   success:(void(^)(NSArray *data))successBlock
                    failed:(void(^)(NSString *errorMSG))failedBlock;

#pragma mark - 绑定家长搜索
#pragma mark -

- (void)bindFamilySearch:(NSString *)Token
          ParUserAccount:(NSString *)ParUserAccount
                 success:(void(^)(NSArray *data))successBlock
                  failed:(void(^)(NSString *errorMSG))failedBlock;

#pragma mark - 绑定家长发送
#pragma mark -

- (void)FamilySendValidation:(NSString *)Token
              ParUserAccount:(NSString *)ParUserAccount
                    ValidTxt:(NSString *)ValidTxt
                     success:(void(^)(NSDictionary* data))successBlock
                      failed:(void(^)(NSString *errorMSG))failedBlock;


//#pragma mark - 上传IM产生的语音文件
//#pragma mark -
//- (void)uploadFile:(NSString*)filePath
//           success:(void(^)(NSDictionary *data))successBlock
//            failed:(void(^)(NSString *errorMSG))failedBlock;


@end

