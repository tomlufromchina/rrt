//
//  PersonalInfoNetService.m
//  RenrenTong
//
//  Created by 何丽娟 on 15/5/19.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "PersonalInfoNetService.h"

@implementation PersonalInfoNetService
+(void)GetUserByToKen:(NSString*)token  Successful:(SuccessfulWithData)success Error:(ErrorWithData)error Cache:(SuccessfulWithData)cacheData
{
    NSString *url = [NSString stringWithFormat:@"http://home.%@/api/GetUserByToKen",aedudomain];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:token,@"Token",[RRTManager manager].loginManager.loginInfo.userId,@"userId",nil];
    [HttpUtil GetWithUrl:url parameters:dic success:^(id json) {
        PersonModel *result = [[PersonModel alloc] initWithString:json error:nil];
        if (result.st == 0) {
            success(result.msg);
        }else{
            ErrorModel *erromodel = [[ErrorModel alloc] initWithString:json error:nil];
            error(erromodel.msg);
        }
    } fail:^(id errors) {
        error(errors);
    } cache:^(id cache) {
        PersonModel *result = [[PersonModel alloc] initWithString:cache error:nil];
        if (result.st == 0 ) {
            cacheData(result.msg);
        }
    }];
}
@end
