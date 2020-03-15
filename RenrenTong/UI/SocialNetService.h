//
//  SocialNetService.h
//  RenrenTong
//
//  Created by 何丽娟 on 15/5/19.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AlbumList.h"
#import "LoginModel.h"
#import "AllTendency.h"
typedef void (^SuccessfulWithData)(id model);
typedef void (^ErrorWithData)(id model);
typedef void (^error)();
/**
 *  社区动态功能相关网络请求（AFNetworking）
 */
@interface SocialNetService : NSObject
/**
 *  好友圈（我）
 *
 *  @param userId    用户id
 *  @param typeId    类型
 *  @param pageIndex 当前页
 *  @param success   成功回调
 *  @param error     失败回调
 *  @param cacheData 缓存回调
 */
//+(void)GetMyActivity:(NSString*)userId TypeId:(NSString*)typeId PageIndex:(NSInteger)pageIndex   Successful:(SuccessfulWithData)success Error:(ErrorWithData)error Cache:(SuccessfulWithData)cacheData;
/**
 *  获取好友动态
 *
 *  @param userId    用户id
 *  @param typeId    类型
 *  @param pageIndex 当前页
 *  @param success   成功回调
 *  @param error     失败回调
 *  @param cacheData 缓存回调
 */
//+(void)GetHomeActivity:(NSString*)token TypeId:(NSString*)typeId PageIndex:(NSInteger)pageIndex   Successful:(SuccessfulWithData)success Error:(ErrorWithData)error Cache:(SuccessfulWithData)cacheData;

/**
 *  访客模式，社区动态接口
 *
  *  @param userId    用户id
 *  @param typeId    动态类型
 *  @param pageSize  每页返回数
 *  @param pageIndex 当前页
 *  @param success   成功回调
 *  @param error     失败回调
 *  @param cacheData 缓存回调
 */
//+(void)GetActivity:(NSString*)typeId  UserId:(NSString*)userId PageSize:(NSInteger)pageSize PageIndex:(NSInteger)pageIndex Successful:(SuccessfulWithData)success Error:(ErrorWithData)error Cache:(SuccessfulWithData)cacheData;
@end
