
//
//  MessageNetService.m
//  RenrenTong
//
//  Created by 何丽娟 on 15/5/20.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "MessageNetService.h"

@implementation MessageNetService
+(void)GetUserGroup:(NSString*)userId UserRole:(NSString*)userRole  Successful:(SuccessfulWithData)success Error:(ErrorWithData)error Cache:(SuccessfulWithData)cacheData
{
    NSString *url = [NSString stringWithFormat:@"http://home.%@/api/GetUserGroup",aedudomain];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userId,@"userId",userRole,@"userRole",nil];
    [HttpUtil GetWithUrl:url parameters:dic success:^(id json) {
        GroupModel *loginModel = [[GroupModel alloc] initWithString:json error:nil];
        if (loginModel.st == 0) {
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
        GroupModel *loginModel = [[GroupModel alloc] initWithString:cache error:nil];
        if (loginModel.st == 0) {
            if (success) {
                success(loginModel.msg);
            };
        }
    }];
}

+(void)PostMessageFile:(NSString*)token PlayTime:(NSString*)playTime File:(NSData*)file Successful:(SuccessfulWithData)success Error:(ErrorWithData)error
{
//    NSString *url = [NSString stringWithFormat:@"http://nmapi.%@/Push/PostMessageFile",aedudomain];
//    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:token,@"token",playTime,@"playTime",nil];
}

+(void)GetFollows:(NSString*)uid Token:(NSString*)token PageIndex:(NSInteger)pageIndex Successful:(SuccessfulWithData)success Error:(ErrorWithData)error
{
    NSString *url = [NSString stringWithFormat:@"http://home.%@/Api/GetFollows",aedudomain];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:token,@"toKen",uid,@"UserId",[NSString stringWithFormat:@"%d",pageIndex],@"PageIndex",nil];
    [HttpUtil GetWithUrl:url parameters:dic success:^(id json) {
        GetFollows *loginModel = [[GetFollows alloc] initWithString:json error:nil];
        if (loginModel.st == 0) {
            if (success) {
                success(loginModel.msg.list);
            }
        }else{
            ErrorModel *erromodel = [[ErrorModel alloc] initWithString:json error:nil];
            error(erromodel.msg);
        }
    } fail:^(id errors) {
        error(errors);
    } cache:^(id cache) {
    }];
}
+(void)GetInvitation:(NSString *)uid Successful:(SuccessfulWithData)success Error:(ErrorWithData)error
{
    NSString *url = [NSString stringWithFormat:@"http://home.%@/Api/GetInvitation",aedudomain];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"UserId",nil];
    [HttpUtil GetWithUrl:url parameters:dic success:^(id json) {
        GetInvitation *loginModel = [[GetInvitation alloc] initWithString:json error:nil];
        if (loginModel.st == 0) {
            if (success) {
                success(loginModel.msg.list);
            }
        }else{
            ErrorModel *erromodel = [[ErrorModel alloc] initWithString:json error:nil];
            error(erromodel.msg);
        }
    } fail:^(id errors) {
        error(errors);
    } cache:^(id cache) {
    }];
}
+(void)PostAcceptInvitation:(NSString *)InvitationId Successful:(SuccessfulWithData)success Error:(ErrorWithData)error
{
    NSString *url = [NSString stringWithFormat:@"http://home.%@/Api/PostAcceptInvitation",aedudomain];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:InvitationId,@"InvitationId",nil];
    [HttpUtil PostWithUrl:url parameters:dic success:^(id json) {
            if (success) {
                success(json);
            }
    } fail:^(id errors) {
        error(errors);
    } cache:^(id cache) {
    }];
}
+(void)AcceptBinding:(NSString*)token Type:(NSString*)type ChildrenUserId:(NSString*)childrenUserId Successful:(SuccessfulWithData)success Error:(ErrorWithData)error
{
    NSString *url = [NSString stringWithFormat:@" http://interface.%@/sjrrt/AcceptBinding",aedudomain];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:token,@"Token",type,@"Type",childrenUserId,@"ChildrenUserId",nil];
    [HttpUtil PostWithUrl:url parameters:dic success:^(id json) {
            if (success) {
                success(json);
            }
    } fail:^(id errors) {
        error(errors);
    } cache:^(id cache) {
    }];

}
+(void)GetUserInfoBySJ_Search:(NSString *)Token ParUserAccount:(NSString *)ParUserAccount Successful:(SuccessfulWithData)success Error:(ErrorWithData)error
{
    NSString *url = [NSString stringWithFormat:@"http://interface.%@/sjrrt/GetUserInfoBySJ_Search",aedudomain];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:Token,@"Token",ParUserAccount,@"UserOrEmailName",nil];
    [HttpUtil GetWithUrl:url parameters:dic success:^(id json) {
        GetUserInfoBySJ_Search *loginModel = [[GetUserInfoBySJ_Search alloc] initWithString:json error:nil];
        if (loginModel.st == 0) {
            if (success) {
                success(loginModel.msg);
            }
        }else{
            ErrorModel *erromodel = [[ErrorModel alloc] initWithString:json error:nil];
            error(erromodel.msg);
        }
    } fail:^(id errors) {
        error(errors);
    } cache:^(id cache) {
    }];
}
+(void)GetUserSpacePower:(NSString *)vuserid OUserId:(NSString *)OUserId Successful:(SuccessfulWithData)success Error:(ErrorWithData)error
{
    NSString *url = [NSString stringWithFormat:@"http://interface.%@/sjrrt/GetUserSpacePower",aedudomain];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:vuserid,@"vuserid",OUserId,@"OUserId",nil];
    [HttpUtil GetWithUrl:url parameters:dic success:^(id json) {
        GetUserSpacePower *result = [[GetUserSpacePower alloc] initWithString:json error:nil];
        if (result.st == 0 && result.msg) {
            success(result.msg);
        }else{
            ErrorModel *erromodel = [[ErrorModel alloc] initWithString:json error:nil];
            error(erromodel.msg);
        }
    } fail:^(id errors) {
        error(errors);
    } cache:^(id cache) {
        
    }];
}
+(void)SetForbidVisitSpace:(NSString *)Token UserId:(NSString *)VUserId OUserId:(NSString *)OUserId IsForbid:(NSString *)IsForbid Successful:(SuccessfulWithData)success Error:(ErrorWithData)error
{
    NSString *url = [NSString stringWithFormat:@"http://interface.%@/sjrrt/SetForbidVisitSpace",aedudomain];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:Token,@"Token",OUserId,@"OUserId",VUserId,@"VUserId",IsForbid,@"IsForbid",nil];
    [HttpUtil PostWithUrl:url parameters:dic success:^(id json) {
        ErrorModel *erromodel = [[ErrorModel alloc] initWithString:json error:nil];
        if (erromodel.result.integerValue != 1) {
            error(erromodel.msg);
        }
    } fail:^(id errors) {
        error(errors);
    } cache:^(id cache) {
    }];
}
+(void)SetPBActivities:(NSString *)Token VUserId:(NSString *)VUserId OUserId:(NSString *)OUserId OUserName:(NSString *)OUserName  IsPb:(NSString *)IsPb Successful:(SuccessfulWithData)success Error:(ErrorWithData)error
{
    NSString *url = [NSString stringWithFormat:@"http://interface.%@/sjrrt/SetPBActivities",aedudomain];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:Token,@"Token",OUserId,@"OUserId",VUserId,@"VUserId",IsPb,@"IsPb",OUserName,@"OUserName",nil];
    [HttpUtil PostWithUrl:url parameters:dic success:^(id json) {
        ErrorModel *erromodel = [[ErrorModel alloc] initWithString:json error:nil];
        if (erromodel.result.integerValue !=0) {
            error(erromodel.msg);
        }
    } fail:^(id errors) {
        error(errors);
    } cache:^(id cache) {
    }];
}
+(void)CancelFriends:(NSString *)Token FriendUserId:(NSString *)FriendUserId Successful:(SuccessfulWithData)success Error:(ErrorWithData)error
{
    NSString *url = [NSString stringWithFormat:@"http://interface.%@/sjrrt/CancelFriends",aedudomain];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:Token,@"Token",FriendUserId,@"FriendUserId",nil];
    [HttpUtil PostWithUrl:url parameters:dic success:^(id json) {
        ErrorModel *erromodel = [[ErrorModel alloc] initWithString:json error:nil];
        if (erromodel.result.integerValue !=1) {
            error(erromodel.msg);
        }else{
            success(nil);
        }
    } fail:^(id errors) {
        error(errors);
    } cache:^(id cache) {
    }];
}
+(void)PostAddFollow:(NSString *)UserId FollowUserId:(NSString *)FollowUserId GroupIds:(NSString *)GroupIds NoteName:(NSString *)NoteName Successful:(SuccessfulWithData)success Error:(ErrorWithData)error
{
    NSString *url = [NSString stringWithFormat:@"http://interface.%@/sjrrt/CancelFriends",aedudomain];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:UserId,@"UserId",FollowUserId,@"FollowUserId",nil];
    [HttpUtil PostWithUrl:url parameters:dic success:^(id json) {
        ErrorModel *erromodel = [[ErrorModel alloc] initWithString:json error:nil];
        if (erromodel.result.integerValue !=0) {
            error(erromodel.msg);
        }
    } fail:^(id errors) {
        error(errors);
    } cache:^(id cache) {
    }];
}
+(void)GetUserById:(NSString*)token  UserId:(NSString *)UserId Successful:(SuccessfulWithData)success Error:(ErrorWithData)error Cache:(SuccessfulWithData)cacheData
{
    NSString *url = [NSString stringWithFormat:@"http://home.%@/api/GetUserById",aedudomain];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:token,@"toKen",UserId,@"UserId",nil];
    [HttpUtil GetWithUrl:url parameters:dic success:^(id json) {
        GetUserById *result = [[GetUserById alloc] initWithString:json error:nil];
        if (result.st == 0 && result.msg.list) {
            success(result.msg.list);
        }else{
            ErrorModel *erromodel = [[ErrorModel alloc] initWithString:json error:nil];
            error(erromodel.msg);
        }
    } fail:^(id errors) {
        error(errors);
    } cache:^(id cache) {
        GetUserById *result = [[GetUserById alloc] initWithString:cache error:nil];
        if (result.st == 0 && result.msg.list) {
            success(result.msg.list);
        }
    }];
}

@end
