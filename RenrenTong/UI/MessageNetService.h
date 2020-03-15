//
//  MessageNetService.h
//  RenrenTong
//
//  Created by 何丽娟 on 15/5/20.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageModel.h"
#import "AlbumList.h"
typedef void (^SuccessfulWithData)(id model);
typedef void (^ErrorWithData)(id model);
typedef void (^error)();
/**
 *  IM即时通讯聊天功能相关网络请求（AFNetwoking）
 */
#warning 相关网络请求框架转化未完成，需要在VC中一一对应查看、修改
@interface MessageNetService : NSObject
/**
 *  获取最新消息列表
 *
 *  @param userId    用户id
 *  @param userRole  用户角色
 *  @param success   成功回调
 *  @param error     失败回调
 *  @param cacheData 缓存回调
 */
//+(void)GetUserGroup:(NSString*)userId UserRole:(NSString*)userRole  Successful:(SuccessfulWithData)success Error:(ErrorWithData)error Cache:(SuccessfulWithData)cacheData;
/**
 *  聊天界面发送图片／音频
 *
 *  @param token    token
 *  @param playTime 时间
 *  @param file     文件
 *  @param success  成功回调
 *  @param error    失败回调
 */
//+(void)PostMessageFile:(NSString*)token PlayTime:(NSString*)playTime File:(NSData*)file Successful:(SuccessfulWithData)success Error:(ErrorWithData)error;
/**
 *  联系人列表（人人通好友列表）
 *
 *  @param uid       用户id
 *  @param token     token
 *  @param pageIndex 当前页
 *  @param success   成功回调
 *  @param error     失败回调
 */
//+(void)GetFollows:(NSString*)uid Token:(NSString*)token PageIndex:(NSInteger)pageIndex Successful:(SuccessfulWithData)success Error:(ErrorWithData)error;
/**
 *  获取好友申请
 *
 *  @param uid     用户id
 *  @param success 成功回调
 *  @param error   失败回调
 */
//+(void)GetInvitation:(NSString *)uid Successful:(SuccessfulWithData)success Error:(ErrorWithData)error;

/**
 *  接受好友请求
 *
 *  @param InvitationId 请求id
 *  @param success      成功回调
 *  @param error        失败回调
 */
//+(void)PostAcceptInvitation:(NSString *)InvitationId Successful:(SuccessfulWithData)success Error:(ErrorWithData)error;
/**
 *  接受家长绑定请求
 *
 *  @param token          token
 *  @param type           类型
 *  @param childrenUserId 孩子id
 *  @param success        成功回调
 *  @param error          失败回调
 */
//+(void)AcceptBinding:(NSString*)token Type:(NSString*)type ChildrenUserId:(NSString*)childrenUserId Successful:(SuccessfulWithData)success Error:(ErrorWithData)error;
/**
 *  搜索添加好友
 *
 *  @param Token          token
 *  @param ParUserAccount 搜索用户账号
 *  @param success        成功回调
 *  @param error          失败回调
 */
//+(void)GetUserInfoBySJ_Search:(NSString *)Token ParUserAccount:(NSString *)ParUserAccount Successful:(SuccessfulWithData)success Error:(ErrorWithData)error;

/**
 *  好友资料中资料设置获取权限
 *
 *  @param vuserid 本用户id
 *  @param OUserId 修改对象用户id
 *  @param success 成功回调
 *  @param error   失败回调
 */
//+(void)GetUserSpacePower:(NSString *)vuserid OUserId:(NSString *)OUserId Successful:(SuccessfulWithData)success Error:(ErrorWithData)error;
/**
 *  好友访问当前用户空间权限设置
 *
 *  @param Token    token
 *  @param VUserId  当前用户id
 *  @param OUserId  好友id
 *  @param IsForbid 是否屏蔽
 *  @param success  成功回调
 *  @param error    失败回调
 */
//+(void)SetForbidVisitSpace:(NSString *)Token UserId:(NSString *)VUserId OUserId:(NSString *)OUserId IsForbid:(NSString *)IsForbid Successful:(SuccessfulWithData)success Error:(ErrorWithData)error;
/**
 *  设置当前用户对好友空间的权限
 *
 *  @param Token     token
 *  @param VUserId   当前用户id
 *  @param OUserId   好友id
 *  @param OUserName 好友名字
 *  @param IsPb      是否屏蔽
 *  @param success   成功回调
 *  @param error     失败回调
 */
//+(void)SetPBActivities:(NSString *)Token VUserId:(NSString *)VUserId OUserId:(NSString *)OUserId OUserName:(NSString *)OUserName  IsPb:(NSString *)IsPb Successful:(SuccessfulWithData)success Error:(ErrorWithData)error;
/**
 *  删除好友
 *
 *  @param Token        token
 *  @param FriendUserId 好友id
 *  @param success      成功回调
 *  @param error        失败回调
 */
//+(void)CancelFriends:(NSString *)Token FriendUserId:(NSString *)FriendUserId Successful:(SuccessfulWithData)success Error:(ErrorWithData)error;
/**
 *  添加好友申请备注
 *
 *  @param UserId       当前用户ID
 *  @param FollowUserId 好友ID
 *  @param GroupIds     分组ID
 *  @param NoteName     备注
 *  @param success      成功回调
 *  @param error        失败回调
 */
//+(void)PostAddFollow:(NSString *)UserId FollowUserId:(NSString *)FollowUserId GroupIds:(NSString *)GroupIds NoteName:(NSString *)NoteName Successful:(SuccessfulWithData)success Error:(ErrorWithData)error;
/**
 *  通过id 和token 获取用户信息
 *
 *  @param token   token
 *  @param UserId  userid
 *  @param success 成功回调
 *  @param error   失败回调
 */
//+(void)GetUserById:(NSString*)token  UserId:(NSString *)UserId Successful:(SuccessfulWithData)success Error:(ErrorWithData)error Cache:(SuccessfulWithData)cacheData;
@end
