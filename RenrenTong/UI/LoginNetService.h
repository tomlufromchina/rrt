//
//  LoginNetService.h
//  RenrenTong
//
//  Created by 何丽娟 on 15/5/18.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginModel.h"
#import "AlbumList.h"
#import "PersonModel.h"

typedef void (^SuccessfulWithData)(id model);
typedef void (^ErrorWithData)(id model);
typedef void (^error)();

/**
 *  登录相关及大数据统计网络请求（AFNetworking）
 */
@interface LoginNetService : NSObject
/**
 *  手机登录
 *
 *  @param userName 用户名
 *  @param phone    手机号
 *  @param role     分类：1代表学生，2代表家长，3代表老师
 */
//+(void)PhoneRegister:(NSString*)userName Phone:(NSString*)phone Role:(NSString*)role Successful:(SuccessfulWithData)success Error:(ErrorWithData)error Cache:(SuccessfulWithData)cacheData;
/**
 *  登录
 *
 *  @param uid     用户账号
 *  @param pwd     用户名
 *  @param success 成功回调
 *  @param error   失败回调
 */
//+(void)getlogin:(NSString*)uid Password:(NSString*)pwd Successful:(SuccessfulWithData)success Error:(ErrorWithData)error;



/**
 *  用户注册
 *
 *  @param account  用户账号
 *  @param password 密码
 *  @param userName 用户名
 *  @param userType 用户类型
 *  @param success  成功回调
 *  @param error    失败回调
 */
//+(void)Register:(NSString*)account Password:(NSString*)password UserName:(NSString*)userName UserType:(NSString*)userType Successful:(SuccessfulWithData)success Error:(ErrorWithData)error;
/**
 *  手机登录
 *
 *  @param uid     手机号
 *  @param pwd     密码
 *  @param success 成功回调
 *  @param error   失败回调
 */
//+(void)loginForPhone:(NSString*)uid Password:(NSString*)pwd Successful:(SuccessfulWithData)success Error:(ErrorWithData)error;
///**
// *  用户详情
// *
// *  @param token     token
// *  @param userId    用户id
// *  @param success   成功回调
// *  @param error     失败回调
// *  @param cacheData 缓存回调
// */
//+(void)MyselfDetails:(NSString*)token UserId:(NSString*)userId Successful:(SuccessfulWithData)success Error:(ErrorWithData)error Cache:(SuccessfulWithData)cacheData;
///**
// *  获取教育咨询
// *
// *  @param count     count
// *  @param success   成功回调
// *  @param error     失败回调
// *  @param cacheData 缓存回调
// */
//+(void)GetNewsList:(NSString*)count Successful:(SuccessfulWithData)success Error:(ErrorWithData)error Cache:(SuccessfulWithData)cacheData;
///**
// *  大数据统计
// *
// *  @param userId    用户id
// *  @param ppId      点击类型
// *  @param productId
// *  @param version   版本号
// *  @param success   成功回调
// *  @param error     失败回调
// */
//+(void)RecordAppClick:(NSString*)userId Ppid:(BigData)ppId ProductId:(NSString*)productId Version:(NSString *)version Successful:(SuccessfulWithData)success Error:(ErrorWithData)error;
@end
