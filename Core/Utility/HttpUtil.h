//
//  HttpUtil.h
//  RenrenTong
//
//  Created by 符其彬 on 15/5/14.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "Reachability.h"
@interface HttpUtil : NSObject
/**
 *  有无网络提示
 *
 *  @param block 回调
 */
+ (void)netWorkStatus:(void (^)(BOOL status))block;

/**
 *  GET获取网络请求
 *
 *  @param url        url
 *  @param parameters 网络请求数据参数
 *  @param success    请求成功回调
 *  @param fail       失败回调
 *  @param cache      缓存回调
 */
+ (void)GetWithUrl:(NSString *)url parameters:(NSDictionary*)parameters success:(void (^)(id json))success fail:(void (^)(id error))fail cache:(void (^)(id cache))cache;
/**
 *  POST网络请求
 *
 *  @param url        url
 *  @param parameters 网络请求参数
 *  @param success    成功回调
 *  @param fail       失败回调
 *  @param cache      缓存回调
 */
+ (void)PostWithUrl:(NSString *)url parameters:(NSDictionary*)parameters success:(void (^)(id json))success fail:(void (^)(id error))fail cache:(void (^)(id cache))cache;
/**
 *  下载文件网络请求
 *
 *  @param fileurl url
 *  @param success 成功回调
 *  @param fail    失败回调
 */
+ (void)sessionDownloadWithUrl:(NSString *)fileurl success:(void (^)(NSURL *filepath))success fail:(void (^)(id error))fail;
/**
 *  上传文件网络请求
 *
 *  @param url      url
 *  @param filepath 文件路径
 *  @param fileName 文件名
 *  @param fileTye  文件类型
 *  @param success  成功回调
 *  @param fail     失败回调
 */
+ (void)UploadFileWithUrl:(NSString *)url filepath:(NSURL *)filepath fileName:(NSString *)fileName fileType:(NSString *)fileTye success:(void (^)(id json))success fail:(void (^)(id error))fail;


@end
