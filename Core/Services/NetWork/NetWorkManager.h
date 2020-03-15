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
#import "UserSession.h"
#import "AllTendency.h"

/**
 * 大数据统计
 */
typedef enum BigData
{
    //老师
    T_PersonalInfo = 92,// 个人信息
    T_Intergral = 94,//积分
    T_ReleaseInfo,//发布消息
    T_DianDianWeiPing,//点点微评
    T_CheckOnWorkAttendance,//查考勤
    T_CheckPerformance,//查成绩
    T_SchoolNofication,//学习通知
    T_EducationConsult,//教育咨询
    T_SocialDynamic,//社区动态
    T_ClassDynamic,//班级动态
    T_Chat,//聊天
    T_ContactList,//联系人
    T_Topic,//话题
    T_FriendsCircle,//好友圈
    T_MyClass,//我的班级
    T_ShoppingMall,//商城
    T_Activity,//活动
    
    /**
     *  家长
     */
    P_PersonalInfo,// 个人信息
    P_Intergral,//积分
    P_Performance,//成绩
    P_CheckOnWorkAttendance,//查考勤
    P_DianDianWeiPing,//点点微评
    P_CourseList,//课程表
    P_SchoolNofication,//学校消息
    P_EducationConsult,//教育咨询
    P_SocialDynamic,//社区动态
    P_ClassDynamic,//班级动态
    P_Chat,//聊天
    P_ContactList,//联系人
    P_Topic,//话题
    P_FriendsCircle,//好友圈
    P_MyClass,//我的班级
    P_ShoppingMall,//商城
    P_Activity,//活动
    
    /**
     *  学生
     */
    S_PersonalInfo,// 个人信息
    S_Intergral,//积分
    S_Performance,//成绩
    S_CheckOnWorkAttendance,//查考勤
    S_OptionalCourse,//选修课
    S_CourseList,//课程表
    S_SchoolNofication,//学校消息
    S_EducationConsult,//教育咨询
    S_SocialDynamic,//社区动态
    S_ClassDynamic,//班级动态
    S_Chat,//聊天
    S_ContactList,//联系人
    S_Topic,//话题
    S_FriendsCircle,//好友圈
    S_MyClass,//我的班级
    S_ShoppingMall,//商城
    S_Activity,//活动
    
    /**
     *  应用列表
     */
    A_CosumptionInfo,// 消费信息
    A_TerminalAdviceNote,// 期末通知书
    A_OptionalCourse,// 选修课
    A_ResultSystem = 33,
    A_SafeChecking = 34,
    A_ClassActivity = 36,
    A_ClassArticle = 35,
    /**
     *  登录统计
     */
    D_Login = 40,
    
}BigData;

/**
 *  负责页面请求
 */
@interface NetWorkManager : NSObject


- (void)handerPostRequest:(NSString *)requestUrl
               parameters:(NSDictionary*)parameters
                     body:(NSData*)data
                  success:(void (^)(NSDictionary *data))successBlock
                   failed:(void (^)(NSString *message))failedBlock;

- (void)handerGetRequest:(NSString *)requestUrl
              parameters:(NSDictionary*)parameters
                    body:(NSData*)data
                 success:(void (^)(NSDictionary *data))successBlock
                  failed:(void (^)(NSString *message))failedBlock;

#pragma mark - 登录
#pragma mark -
- (void)loginWithUserName:(NSString *)user
             withPassword:(NSString *)password
                  success:(void(^)(Login *login))successBlock
                   failed:(void(^)(NSString *errorMSG))failedBlock;

#pragma mark -- 登录广告请求

- (void)getLoginAdvertisementsuccess:(void(^)(NSArray* data))successBlock
                              failed:(void(^)(NSString *errorMSG))failedBlock;

#pragma mark -- 访客模式

- (void)getVisitorModelMessage:(NSString *)typeId
                        userId:(NSString *)userId
                      pageSize:(int)pageSize
                     pageIndex:(int)pageIndex
                       success:(void(^)(NSMutableArray* data))successBlock
                        failed:(void(^)(NSString *errorMSG))failedBlock;

- (void)loginQiDiUserName:(NSString *)user
                  success:(void(^)(Login *login))successBlock
                   failed:(void(^)(NSString *errorMSG))failedBlock;

#pragma mark -- 获取老师担当的角色
- (void)getTeacherRole1:(NSString *)Token
             teacherId:(NSString *)teacherId
               success:(void(^)(NSString* data))successBlock
                failed:(void(^)(NSString *errorMSG))failedBlock;


#pragma mark -- 获取付费用户
- (void)getPayUserRole:(NSString *)userid
              userrole:(NSString *)userrole
               success:(void(^)(int data))successBlock
                failed:(void(^)(NSString *errorMSG))failedBlock;


#pragma mark - 注册
#pragma mark -
- (void)registerWithUserName:(NSString *)account
             withPassword:(NSString *)password
                    username:(NSString *)username
                    usertype:(NSString *)usertype
                  success:(void(^)(NSDictionary* data))successBlock
                   failed:(void(^)(NSString *errorMSG))failedBlock;

#pragma mark - 检查版本更新
#pragma mark -

- (void)checkingVersion:(NSString *)versionId
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
               File:(NSString *)File success:(void(^)(NSDictionary * data))successBlock
             failed:(void(^)(NSString *errorMSG))failedBlock;

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
         HasPhoto:(int)HasPhoto
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

#pragma mark -- 我的班级列表
#pragma mark --

- (void)myClassLists:(NSString *)userId
            UserRole:(NSString *)UserRole
             success:(void(^)(NSMutableArray *data))successBlock
              failed:(void(^)(NSString *errorMSG))failedBlock;

#pragma mark -- 班级公告
#pragma mark --

- (void)myClassBulletin:(NSString *)classId
               pagesize:(int)pagesize
              pageindex:(int)pageindex
                success:(void(^)(NSMutableArray *data))successBlock
                 failed:(void(^)(NSString *errorMSG))failedBlock;

#pragma mark -- 班级动态
#pragma mark --

- (void)myClassDynamic:(NSString *)classId
                userId:(NSString *)userId
                typeId:(NSString *)typeId
              pageSize:(int)pageSize
             pageIndex:(int)pageIndex
               success:(void(^)(NSMutableArray *data))successBlock
                failed:(void(^)(NSString *errorMSG))failedBlock;

#pragma mark -- 删除公告、文章
#pragma mark --

- (void)deleteBulletinOrArticle:(NSArray *)archiveId
                        success:(void(^)(NSString *data))successBlock
                         failed:(void(^)(NSString *errorMSG))failedBlock;

#pragma mark -- 公告详情
#pragma mark --

- (void)theBulletinsDetails:(NSString *)archiveId
                  archiveId:(NSString *)userid
                    success:(void(^)(NSMutableArray *data))successBlock
                     failed:(void(^)(NSString *errorMSG))failedBlock;

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

- (void)clickPraise:(NSString *)toKen
           objectId:(NSString *)objectId
             typeId:(NSString *)typeId
            success:(void(^)(NSDictionary* data))successBlock
             failed:(void(^)(NSString *errorMSG))failedBlock;


#pragma mark - 评论
#pragma mark -

- (void)clickComment:(NSString *)userId
   commentedObjectId:(NSString *)commentedObjectId
                body:(NSString *)body
              typeId:(NSString *)typeId
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

- (void)clickReply:(NSString *)userId
 commentedObjectId:(NSString *)commentedObjectId
              body:(NSString *)body
            typeId:(NSString *)typeId
          parentId:(NSString *)parentId
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

- (void)addFriends:(NSString *)UserId
      FollowUserId:(NSString *)FollowUserId
          GroupIds:(NSString *)GroupIds
          NoteName:(NSString *)NoteName
           success:(void(^)(NSString* msg))successBlock
            failed:(void(^)(NSString *errorMSG))failedBlock;
#pragma mark - 好友动态
#pragma mark -

- (void)friendsDynamicDetail:(NSString *)UserId pageIndex:(int)pageIndex pageSize:(int)pageSize
                     success:(void(^)(NSMutableArray *friendDynamic))successBlock
                      failed:(void(^)(NSString *errorMSG))failedBlock;

#pragma mark - 个人资料
#pragma mark -

- (void)personalDataWithDetailToken:(NSString *)token
                             UserId:(NSString *)UserId
                            success:(void(^)(NdividualData *ndividual))successBlock
                             failed:(void(^)(NSString *errorMSG))failedBlock;

#pragma mark -- 修改个人头像

- (void)modificationHeaderIMG:(NSString *)UserId
                         File:(NSString *)File
                      success:(void(^)(NSMutableArray *friendDynamic))successBlock
                       failed:(void(^)(NSString *errorMSG))failedBlock;
#pragma mark -- 修改密码
- (void)changeThePassWord:(NSString *)userId
                   oldPwd:(NSString *)oldPwd
                   newPwd:(NSString *)newPwd
                  success:(void(^)(NSString *data))successBlock
                   failed:(void(^)(NSString *errorMSG))failedBlock;

#pragma mark -- 修改个人资料接口之修改资料

- (void)modificationMyselfDetails:(NSString *)UserId
                             modificationType:(NSString *)modificationType
                          success:(void(^)(NSDictionary *friendDynamic))successBlock
                           failed:(void(^)(NSString *errorMSG))failedBlock;

#pragma mark -- 搜索
- (void)seacher:(NSString *)UserId
        KeyWord:(NSString *)KeyWord
         TypeId:(int)TypeId
       PageSize:(int)PageSize
      PageIndex:(int)PageIndex
        success:(void(^)(NSMutableArray* data))successBlock
         failed:(void(^)(NSString *errorMSG))failedBlock;

#pragma mark -- 获取地区编号
- (void)getZoneSerialNumbersuccess:(void(^)(NSMutableArray *friendDynamic))successBlock
                            failed:(void(^)(NSString *errorMSG))failedBlock;


#pragma mark -- 本人资料

- (void)myselfDetails:(NSString *)ToKen
               UserId:(NSString *)UserId
              success:(void(^)(MyselfDetails *myselfDict))successBlock
               failed:(void(^)(NSString *errorMSG))failedBlock;
#pragma mark -- 获取个人最新动态
- (void)getMyselfActivityDetails:(NSString *)UserId
                          typeId:(int)typeId
                       pageindex:(int)pageindex
                        pagesize:(int)pagesize
                         success:(void(^)(NSMutableArray *myselfDict))successBlock
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

#pragma mark -- 发现搜索中添加好友

- (void)addStrangers:(NSString *)Token
              UserId:(NSString *)UserId
        SenderUserId:(NSString *)SenderUserId
              Sender:(NSString *)Sender
           InviteTxt:(NSString *)InviteTxt
             success:(void(^)(NSString* data))successBlock
              failed:(void(^)(NSString *errorMSG))failedBlock;


#pragma mark - 联系人列表
#pragma mark -
- (void)AddressBookDetail:(NSString *)uid token:(NSString *)token
                PageIndex:(int)PageIndex
                  success:(void(^)(NSMutableArray *data))successBlock
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
- (void)newFriends:(NSString *)uid
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


/* 新版本人人通请求 */
#pragma mark -- 获取用户信息
- (void)getUIData:(NSString *)Token
          success:(void(^)(NSMutableArray* data))successBlock
           failed:(void(^)(NSString *errorMSG))failedBlock;

#pragma mark -- 获取排名
- (void)getTheStudentPlace:(NSString *)UserId
                  userrole:(NSString *)userrole
                   success:(void(^)(NSMutableArray* data))successBlock
                    failed:(void(^)(NSString *errorMSG))failedBlock;


#pragma mark -- 统计安装量

- (void)getInstallmentNumber:(NSString *)productId
                     version:(NSString *)version
                     success:(void(^)(NSString* data))successBlock
                      failed:(void(^)(NSString *errorMSG))failedBlock;

#pragma mark -- 统计浏览引用数量

- (void)getBrowseNumber:(NSString *)userId
                   ppId:(BigData)ppId
              productId:(NSString *)productId
                version:(NSString *)version
                success:(void(^)(NSString* data))successBlock
                 failed:(void(^)(NSString *errorMSG))failedBlock;

#pragma mark -- 获取开通服务情况
- (void)getClearServiceDetails:(NSString *)UserId
                      userrole:(NSString *)userrole
                       success:(void(^)(NSMutableArray* data))successBlock
                        failed:(void(^)(NSString *errorMSG))failedBlock;

#pragma mark -- 获取短信消息记录

- (void)getMessageRecords:(NSString *)UserId
                 userrole:(NSString *)userrole
              messageType:(int)messageType
                 pageSize:(int)pageSize
                pageIndex:(int)pageIndex
                  success:(void(^)(NSMutableArray* data))successBlock
                   failed:(void(^)(NSString *errorMSG))failedBlock;

#pragma mark -- 通过手机号码获取验证码

- (void)getDynamicPassword:(NSString *)phone
              sendMsgValue:(int)sendMsgValue
                   success:(void(^)(NSString* data))successBlock
                    failed:(void(^)(NSString *errorMSG))failedBlock;

#pragma mark -- 获取广告图片

- (void)getAdvertisement:(int)advertType
                   toKen:(NSString *)toKen
                 success:(void(^)(NSArray* data))successBlock
                  failed:(void(^)(NSString *errorMSG))failedBlock;

#pragma mark -- 判断首页广告每日登录

- (void)isTodayAppears:(NSString *)Token
               success:(void(^)(NSString *data))successBlock
                failed:(void(^)(NSString *errorMSG))failedBlock;

#pragma mark -- 登陆的广告

- (void)theGetAdvertisementsuccess:(void(^)(NSString* data))successBlock
                            failed:(void(^)(NSString *errorMSG))failedBlock;

#pragma mark -- 获取手机base64位编码

- (void)getPhoneBase64Code:(NSString *)phone
                   success:(void(^)(NSString* data))successBlock
                    failed:(void(^)(NSString *errorMSG))failedBlock;

#pragma mark -- 根据手机号码获取用户

- (void)AccordingPhoneGetUser:(NSString *)phone
                         code:(NSString *)code
                      success:(void(^)(NSMutableArray* data))successBlock
                       failed:(void(^)(NSString *errorMSG))failedBlock;

#pragma mark -- 根据账号登录

- (void)AccordingAccountDebarkation:(NSString *)uid
                                pwd:(NSString *)pwd
                            success:(void(^)(Login *login))successBlock
                             failed:(void(^)(NSString *errorMSG))failedBlock;

#pragma mark -- 设置学校通知为已读状态

- (void)settingSchoolNoticeState:(NSString *)Token
                          userId:(NSString *)userId
                         success:(void(^)(NSString *data))successBlock
                          failed:(void(^)(NSString *errorMSG))failedBlock;

#pragma mark -- 绑定用户推送关系
- (void)bindPush;
- (void)getIMserverSuccess:(void(^)(NSString* ip,int port))successBlock
                    failed:(void(^)(NSString *errorMSG))failedBlock;

#pragma mark -- 获取离线消息
- (void) getOfflineMessages:(NSString *)userId
                    success:(void(^)(NSMutableArray* data))successBlock
                     failed:(void(^)(NSString *errorMSG))failedBlock;
#pragma mark -- 根据guid获取消息
- (void) getMessageWithGuid:(NSString *)guid
                    success:(void(^)(NSMutableArray* data))successBlock
                     failed:(void(^)(NSString *errorMSG))failedBlock;

#pragma mark - 群组列表

- (void)getUserGroup:(NSString *)UserId
           userRoles:(int)role
             success:(void(^)(NSArray *groupData))successBlock
              failed:(void(^)(NSString *errorMSG))failedBlock;

#pragma mark - 群组成员列表
#pragma mark -
- (void)getGroupUser:(NSString *)groupId
             success:(void(^)(NSArray *groupData))successBlock
              failed:(void(^)(NSString *errorMSG))failedBlock;
#pragma mark -- 获取话题
- (void) getRecommendTagsWithNum:(int)num
                         success:(void(^)(NSMutableArray* data))successBlock
                          failed:(void(^)(NSString *errorMSG))failedBlock;
#pragma mark -- 参与话题微博列表
- (void) GetMicroblogByTagId:(NSNumber*)tagId
                      userId:(NSString *)userId
                    pageSize:(int)pageSize
                   pageIndex:(int)pageIndex
                     success:(void(^)(NSMutableArray* data))successBlock
                      failed:(void(^)(NSString *errorMSG))failedBlock;

- (void) getMicroblogCommentWithmicroblogId:(NSNumber*)microblogId
                                    success:(void(^)(NSMutableArray* data))successBlock
                                     failed:(void(^)(NSString *errorMSG))failedBlock;
#pragma mark -- 发表微博评论
- (void) postReplyCommentsWithUserId:(NSString*)UserId commentedObjectId:(NSString *)objectID body:(NSString *)body typeId:(int)typeId parentId:(int)parentId
                             success:(void(^)(NSDictionary* data))successBlock
                              failed:(void(^)(NSString *errorMSG))failedBlock;

- (void)postTheReplyCommentsWithUserId:(NSString *)UserId
                     commentedObjectId:(NSString *)objectID
                                  body:(NSString *)body
                                typeId:(int)typeId
                               success:(void(^)(NSDictionary* data))successBlock
                                failed:(void(^)(NSString *errorMSG))failedBlock;

#pragma mark -- 班级网评论/回复
- (void)classNetworkCommentary:(NSString *)archiveId
                        userId:(NSString *)userId
                           pId:(NSString *)pId
                   commentText:(NSString *)commentText
                       success:(void(^)(NSDictionary* data))successBlock
                        failed:(void(^)(NSString *errorMSG))failedBlock;
#pragma mark -- 点赞
- (void) postPraiseWithtoken:(NSString*)token objectId:(NSString *)objectID typeId:(int)typeId
                     success:(void(^)(NSDictionary* data))successBlock
                      failed:(void(^)(NSString *errorMSG))failedBlock;

#pragma mark -- 班级文章点赞
#pragma mark -- 
- (void)classArticlePraise:(NSString *)archiveId
                    userId:(NSString *)userId
                   success:(void(^)(NSDictionary* data))successBlock
                    failed:(void(^)(NSString *errorMSG))failedBlock;

#pragma mark -- 班级文章评论
#pragma mark --

- (void)classArticleCommentary:(NSString *)archiveId
                        userId:(NSString *)userId
                           pId:(NSString *)pId
                   commentText:(NSString *)commentText
                       success:(void(^)(NSDictionary* data))successBlock
                        failed:(void(^)(NSString *errorMSG))failedBlock;

#pragma mark -- 班级文章分类
#pragma mark --

- (void)classArticleCategory:(NSString *)classId
                    pagesize:(int)pagesize
                   pageindex:(int)pageindex
                     success:(void(^)(NSMutableArray *data))successBlock
                      failed:(void(^)(NSString *errorMSG))failedBlock;

#pragma mark -- 单条访客模式数据（为了归档缓存）

- (void)getOneVisitorModelMessage:(NSString *)typeId
                           userId:(NSString *)userId
                         pageSize:(int)pageSize
                        pageIndex:(int)pageIndex
                          success:(void (^)(NSMutableArray *))successBlock
                           failed:(void (^)(NSString *))failedBlock;

#pragma mark -- 发布文章
#pragma mark --

- (void)releaseArticle:(NSString *)ClassId
                UserId:(NSString *)UserId
            CategoryId:(NSString *)CategoryId
          ArchiveTitle:(NSString *)ArchiveTitle
           ArchiveText:(NSString *)ArchiveText
               success:(void(^)(NSString *data))successBlock
                failed:(void(^)(NSString *errorMSG))failedBlock;


#pragma mark -- 日志详情
#pragma mark --

- (void)logDetails:(NSString *)userId
            blogId:(NSString *)blogId
           success:(void(^)(NSMutableArray *data))successBlock
            failed:(void(^)(NSString *errorMSG))failedBlock;

#pragma mark -- 日志评论列表
#pragma mark --

- (void)getBlogCommentList:(NSString *)blogThreadsId
                 pageIndex:(int)pageIndex
                   success:(void(^)(NSMutableArray *data))successBlock
                    failed:(void(^)(NSString *errorMSG))failedBlock;

#pragma mark -- 班级网文章评论列表
#pragma mark --

- (void)getClassArticleCommentLists:(NSString *)archiveId
                           pageSize:(int)pageSize
                          pageIndex:(int)pageIndex
                            success:(void(^)(NSMutableArray *data))successBlock
                             failed:(void(^)(NSString *errorMSG))failedBlock;

#pragma mark -- 班级文章详情
#pragma mark -- 

- (void)classArticleDetails:(NSString *)archiveId
                     userid:(NSString *)userid
                    success:(void(^)(NSMutableArray *data))successBlock
                     failed:(void(^)(NSString *errorMSG))failedBlock;

#pragma mark -- 好友动态
#pragma mark --

- (void)GoodFriendTendencyDetails:(NSString *)token
                           typeId:(NSString *)typeId
                        pageIndex:(int)pageIndex
                          success:(void(^)(NSMutableArray *data))successBlock
                           failed:(void(^)(NSString *errorMSG))failedBlock;

#pragma mark -- 我的动态
#pragma mark --

- (void)MyselfTendencyDetails:(NSString *)userId
                       typeId:(NSString *)typeId
                    pageIndex:(int)pageIndex
                      success:(void(^)(NSMutableArray *data))successBlock
                       failed:(void(^)(NSString *errorMSG))failedBlock;

#pragma mark -- 教育资讯
#pragma mark --

- (void)educationInformation:(NSString *)count
                     success:(void(^)(NSMutableArray *data))successBlock
                      failed:(void(^)(NSString *errorMSG))failedBlock;

#pragma mark -- 我的班级最新动态
#pragma mark --

- (void)myClassNewTendencyDetails:(NSString *)toKen
                         pageSize:(int)pageSize
                        pageIndex:(int)pageIndex
                          success:(void(^)(NSMutableArray *data))successBlock
                           failed:(void(^)(NSString *errorMSG))failedBlock;
#pragma mark -- 学生家校消息
#pragma mark --
- (void)getStudentHomeAndSchoolMessage:(NSString *)uid
                              pageSize:(int)pageSize
                             pageIndex:(int)pageIndex
                               success:(void(^)(NSDictionary *data))successBlock
                                failed:(void(^)(NSString *errorMSG))failedBlock;

#pragma mark -- 获取历史话题

- (void)getHistoricalTopicList:(NSString *)noInTop
                     pageindex:(int)pageindex
                       success:(void(^)(NSMutableArray* data))successBlock
                        failed:(void(^)(NSString *errorMSG))failedBlock;
@end

