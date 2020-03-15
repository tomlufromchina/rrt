//
//  PersonalInfoNetService.h
//  RenrenTong
//
//  Created by 何丽娟 on 15/5/19.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AlbumList.h"
#import "PersonModel.h"

typedef void (^SuccessfulWithData)(id model);
typedef void (^ErrorWithData)(id model);
typedef void (^error)();
/**
 *  个人信息相关网络请求（AFNetworking)
 */
#warning  修改网络请求框架后个人相关信息的网络请求未完成，应写入此文件，对应的数据model写入PersonModel文件内，便于归类
@interface PersonalInfoNetService : NSObject
/**
 *  通过token获取用户信息
 *
 *  @param token     token
 *  @param success   成功回调
 *  @param error     失败回调
 *  @param cacheData 缓存回调
 */
//+(void)GetUserByToKen:(NSString*)token  Successful:(SuccessfulWithData)success Error:(ErrorWithData)error Cache:(SuccessfulWithData)cacheData;



@end
