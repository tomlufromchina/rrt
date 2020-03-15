//
//  SocialNetService.m
//  RenrenTong
//
//  Created by 何丽娟 on 15/5/19.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "SocialNetService.h"

@implementation SocialNetService
+(void)GetMyActivity:(NSString*)userId TypeId:(NSString*)typeId PageIndex:(NSInteger)pageIndex   Successful:(SuccessfulWithData)success Error:(ErrorWithData)error Cache:(SuccessfulWithData)cacheData{
    NSString *url = [NSString stringWithFormat:@"http://home.%@/api/GetMyActivity",aedudomain];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:typeId,@"typeId",userId,@"userId",[NSString stringWithFormat:@"%d",pageIndex],@"pageIndex",nil];
    [HttpUtil GetWithUrl:url parameters:dic success:^(id json) {
        TheMyTendency *theMyTendency = [[TheMyTendency alloc] initWithString:json error:nil];
        if (theMyTendency.st == 0) {
            if (success) {
                success(theMyTendency.msg.list);
            };
        }else{
            ErrorModel *erromodel = [[ErrorModel alloc] initWithString:json error:nil];
            error(erromodel.msg);
        }
    } fail:^(id errors) {
        error(errors);
    } cache:^(id cache) {
        TheMyTendency *theMyTendency = [[TheMyTendency alloc] initWithString:cache error:nil];
        if (theMyTendency.st == 0) {
            if (cache) {
                cacheData(theMyTendency.msg.list);
            }
        }
    }];
}

+(void)GetHomeActivity:(NSString*)token TypeId:(NSString*)typeId PageIndex:(NSInteger)pageIndex   Successful:(SuccessfulWithData)success Error:(ErrorWithData)error Cache:(SuccessfulWithData)cacheData{
    NSString *url = [NSString stringWithFormat:@"http://home.%@/api/GetHomeActivity",aedudomain];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:typeId,@"typeId",token,@"token",[NSString stringWithFormat:@"%d",pageIndex],@"pageIndex",nil];
    [HttpUtil GetWithUrl:url parameters:dic success:^(id json) {
        TheMyTendency *theGoodFriendTendency = [[TheMyTendency alloc] initWithString:json error:nil];
        if (theGoodFriendTendency.st == 0) {
            if (success) {
                success(theGoodFriendTendency.msg.list);
            };
        }else{
            ErrorModel *erromodel = [[ErrorModel alloc] initWithString:json error:nil];
            error(erromodel.msg);
        }
    } fail:^(id errors) {
        error(errors);
    } cache:^(id cache) {
        TheMyTendency *theGoodFriendTendency = [[TheMyTendency alloc] initWithString:cache error:nil];
        if (theGoodFriendTendency.st == 0) {
            if (cache) {
                cacheData(theGoodFriendTendency.msg.list);
            }
        }
    }];
}

+(void)GetActivity:(NSString*)typeId  UserId:(NSString*)userId PageSize:(NSInteger)pageSize PageIndex:(NSInteger)pageIndex Successful:(SuccessfulWithData)success Error:(ErrorWithData)error Cache:(SuccessfulWithData)cacheData{
    NSString *url = [NSString stringWithFormat:@"http://home.%@/api/GetActivity",aedudomain];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:typeId,@"typeId",userId,@"userId",[NSString stringWithFormat:@"%d",pageSize],@"pageSize",[NSString stringWithFormat:@"%d",pageIndex],@"pageIndex",nil];
    [HttpUtil GetWithUrl:url parameters:dic success:^(id json) {
        TheMyTendency *theGoodFriendTendency = [[TheMyTendency alloc] initWithString:json error:nil];
        if (theGoodFriendTendency.st == 0) {
            if (success) {
                success(theGoodFriendTendency.msg.list);
            };
        }else{
            ErrorModel *erromodel = [[ErrorModel alloc] initWithString:json error:nil];
            error(erromodel.msg);
        }
    } fail:^(id errors) {
        error(errors);
    } cache:^(id cache) {
        TheMyTendency *theGoodFriendTendency = [[TheMyTendency alloc] initWithString:cache error:nil];
        if (theGoodFriendTendency.st == 0) {
            if (cache) {
                cacheData(theGoodFriendTendency.msg.list);
            }
        }
    }];
}
@end
