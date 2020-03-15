//
//  LoginNetService.m
//  RenrenTong
//
//  Created by 何丽娟 on 15/5/18.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "LoginNetService.h"

@implementation LoginNetService
+(void)PhoneRegister:(NSString*)userName Phone:(NSString*)phone Role:(NSString*)role Successful:(SuccessfulWithData)success Error:(ErrorWithData)error Cache:(SuccessfulWithData)cacheData

{
    NSString *url = [NSString stringWithFormat:@"http://passport.%@/api/PhoneRegister",aedudomain];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userName,@"username",phone,@"phone",role,@"role",nil];
    
    [HttpUtil GetWithUrl:url parameters:dic success:^(id json) {
        LoginModels *loginModel = [[LoginModels alloc] initWithString:json error:nil];
        if (loginModel.status == 0) {
            if (success) {
                success(loginModel.msg);
            };
        }else{
            ErrorModel *erromodel = [[ErrorModel alloc] initWithString:json error:nil];
            error(erromodel.msg);
        }
    } fail:^(id errors) {
        error(errors);
    } cache:^(id cache) {
       
    }];
}
+(void)getlogin:(NSString*)uid Password:(NSString*)pwd Successful:(SuccessfulWithData)success Error:(ErrorWithData)error{
    NSString *url = [NSString stringWithFormat:@"http://passport.%@/api/login",aedudomain];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",pwd,@"pwd",nil];
    [HttpUtil GetWithUrl:url parameters:dic success:^(id json) {
        LoginModels *loginModel = [[LoginModels alloc] initWithString:json error:nil];
        if (loginModel.status == 0) {
            if (success) {
                success(loginModel.msg);
            };
        }else{
            ErrorModel *erromodel = [[ErrorModel alloc] initWithString:json error:nil];
            error(erromodel.msg);
        }
    } fail:^(id errors) {
        error(errors);
    } cache:^(id cache) {
    }];
}


+(void)Register:(NSString*)account Password:(NSString*)password UserName:(NSString*)userName UserType:(NSString*)userType Successful:(SuccessfulWithData)success Error:(ErrorWithData)error{
    NSString *url = [NSString stringWithFormat:@"http://passport.%@/api/register",aedudomain];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:account,@"UserAccount",password,@"Password",userName,@"UserName",userType,@"UserType",nil];
    [HttpUtil PostWithUrl:url parameters:dic success:^(id json) {
        LoginModels *loginModel = [[LoginModels alloc] initWithString:json error:nil];
        if (loginModel.status == 0) {
            if (success) {
                success(loginModel.msg);
            };
        }else{
            ErrorModel *erromodel = [[ErrorModel alloc] initWithString:json error:nil];
            error(erromodel.msg);
        }
    } fail:^(id errors) {
        error(errors);
    } cache:^(id cache) {
    }];
}
+(void)loginForPhone:(NSString*)uid Password:(NSString*)pwd Successful:(SuccessfulWithData)success Error:(ErrorWithData)error
{
    NSString *url = [NSString stringWithFormat:@"http://passport.%@/api/GetLogionByAccount",aedudomain];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",pwd,@"pwd",nil];
    [HttpUtil GetWithUrl:url parameters:dic success:^(id json) {
        LoginModels *loginModel = [[LoginModels alloc] initWithString:json error:nil];
        if (loginModel.status == 0) {
            if (success) {
                success(loginModel.msg);
            };
        }else{
            ErrorModel *erromodel = [[ErrorModel alloc] initWithString:json error:nil];
            error(erromodel.msg);
        }
    } fail:^(id errors) {
        error(errors);
    } cache:^(id cache) {
    }];
}
+(void)MyselfDetails:(NSString*)token UserId:(NSString*)userId Successful:(SuccessfulWithData)success Error:(ErrorWithData)error Cache:(SuccessfulWithData)cacheData
{
    NSString *url = [NSString stringWithFormat:@"http://passport.%@/api/GetLogionByAccount",aedudomain];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:token,@"Token",userId,@"UserId",nil];
    [HttpUtil GetWithUrl:url parameters:dic success:^(id json) {
        LoginModels *loginModel = [[LoginModels alloc] initWithString:json error:nil];
        if (loginModel.status == 0) {
            if (success) {
                success(loginModel.msg);
            };
        }else{
            ErrorModel *erromodel = [[ErrorModel alloc] initWithString:json error:nil];
            error(erromodel.msg);
        }
    } fail:^(id errors) {
        error(errors);
    } cache:^(id cache) {
    }];
}

+(void)GetNewsList:(NSString*)count Successful:(SuccessfulWithData)success Error:(ErrorWithData)error Cache:(SuccessfulWithData)cacheData
{
    NSString *url = [NSString stringWithFormat:@"http://nmapi.%@/home/GetNewsList",aedudomain];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:count,@"count",nil];
    [HttpUtil GetWithUrl:url parameters:dic success:^(id json) {
        AeduNewModel *aeduNewModel = [[AeduNewModel alloc] initWithString:json error:nil];
        if (aeduNewModel.result == 1) {
            if (success) {
                success(aeduNewModel.items);
            };
        }else{
            ErrorModel *erromodel = [[ErrorModel alloc] initWithString:json error:nil];
            error(erromodel.msg);
        }
    } fail:^(id errors) {
        error(errors);
    } cache:^(id cache) {
        AeduNewModel *aeduNewModel = [[AeduNewModel alloc] initWithString:cache error:nil];
        if (aeduNewModel.result == 1) {
            if (cache) {
                cacheData(aeduNewModel.items);
            }
        }
    }];
}

+(void)RecordAppClick:(NSString*)userId Ppid:(BigData)ppId ProductId:(NSString*)productId Version:(NSString *)version Successful:(SuccessfulWithData)success Error:(ErrorWithData)error
{
    NSString *url = [NSString stringWithFormat:@"http://dsjtj.%@/Api/RecordAppClick",aedudomain];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userId,@"userId",[NSString stringWithFormat:@"%d",ppId],@"ppId",productId,@"productId",version,@"version",nil];
    [HttpUtil GetWithUrl:url parameters:dic success:^(id json) {
       //不作任何处理
    } fail:^(id errors) {
        
    } cache:^(id cache) {
        
    }];
}
@end
