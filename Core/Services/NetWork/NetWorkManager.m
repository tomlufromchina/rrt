//
//  NetWorkManager.m
//  nextSing
//
//  Created by chester on 14-2-22.
//  Copyright (c) 2014年 iflytek. All rights reserved.
//

#import "NetWorkManager.h"
#import "AFNetworking.h"
#import "AFHTTPRequestOperationManager.h"
#import "ISingHTTPRequestOperationManager.h"
#import "EnumDefine.h"
#import <Foundation/NSJSONSerialization.h>

@interface NetWorkManager ()


@end

@implementation NetWorkManager



- (void)handerPostRequest:(NSString *)requestUrl
               parameters:(NSDictionary*)parameters
                     body:(NSData*)data
                  success:(void (^)(NSDictionary *data))successBlock
                   failed:(void (^)(NSString *message))failedBlock
{
    ISingHTTPRequestOperationManager *manager = [[ISingHTTPRequestOperationManager alloc] init];
    manager.requestURLString = requestUrl;
    manager.afHttpBody = data;
    
    //image/jpeg, image/gif, image/pjpeg, application/x-ms-application, application/xaml+xml, application/x-ms-xbap, */*
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",
                                                         @"application/json",
                                                         @"image/jpeg",
                                                         @"image/gif",
                                                         @"image/pjpeg",
                                                         @"application/x-ms-application",
                                                         @"application/xaml+xml",
                                                         @"application/x-ms-xbap",
                                                         @"*/*",
                                                         nil];
    
    [manager POST:requestUrl
             body:manager.afHttpBody
       parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSData *deData = responseObject;
              
              NSString *xmlStr = [[NSString alloc] initWithData:deData encoding:NSUTF8StringEncoding];
              
              
              NSLog(@"The response is:%@", xmlStr);
              
              NSError *error = nil;
              NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:deData
                                                                   options:kNilOptions
                                                                     error:&error];
              
              //    NSLog(@"The response xml is:%@", dict);
              
              if (successBlock) {
                  successBlock(dict);
              }
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              if (failedBlock) {
                  if (error.code == -1009 || error.code == -1001 || error.code == -1004) {
                      failedBlock(@"亲，您的当前网络不可用");
                  } else {
                      failedBlock(error.localizedDescription);
                  }
              }
          }];
}

- (void)handerGetRequest:(NSString *)requestUrl
              parameters:(NSDictionary*)parameters
                    body:(NSData*)data
                 success:(void (^)(NSDictionary *data))successBlock
                  failed:(void (^)(NSString *message))failedBlock
{
    ISingHTTPRequestOperationManager *manager = [[ISingHTTPRequestOperationManager alloc] init];
    manager.requestURLString = requestUrl;
    manager.afHttpBody = nil;
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",
                                                         @"application/json",
                                                         @"text/plain",
                                                         nil];
    
    [manager GET:requestUrl
      parameters:parameters
            body:data
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             //
             NSData *deData = responseObject;
             
             NSString *xmlStr = [[NSString alloc] initWithData:deData encoding:NSUTF8StringEncoding];
             
             
             NSLog(@"The response is:%@", xmlStr);
             
             //服务器传的数据有问题，json前后多了小括号，要去掉
             NSMutableString *newStr = [NSMutableString stringWithString:xmlStr];
             
             if ([newStr characterAtIndex:0] == '(') {
                 NSRange range = NSMakeRange(0, 1);
                 [newStr deleteCharactersInRange:range];
             }
             
             if ([newStr characterAtIndex:[newStr length] - 1] == ')') {
                 NSRange range = NSMakeRange([newStr length] - 1, 1);
                 [newStr deleteCharactersInRange:range];
             }
             
             //        NSLog(@"The xml string is:%@", newStr);
             
             NSError *error = nil;
             NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:
                                   [newStr dataUsingEncoding:NSUTF8StringEncoding]
                                                                  options:kNilOptions
                                                                    error:&error];
             
             //   NSLog(@"The response xml is:%@", dict);
             
             if (successBlock) {
                 successBlock(dict);
             }
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             //
             if (failedBlock) {
                 if (error.code == -1009 || error.code == -1001 || error.code == -1004) {
                     failedBlock(@"亲，您的当前网络不可用哦");
                 } else if (error.code == -1011) {
                     failedBlock(@"服务器不给力，没获取到数据！");
                 } else {
                     failedBlock(error.localizedDescription);//错误时候，系统返回数据
                 }
             }
         }];
}

#pragma mark -- 登录广告请求

- (void)getLoginAdvertisementsuccess:(void(^)(NSArray* data))successBlock
                              failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://dsjtj.%@/api/GetTopAdvert",aedudomain];
    NSString * encodingString = [requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self handerGetRequest:encodingString parameters:nil body:nil success:^(NSDictionary *data) {
        BOOL statusCode = [[data objectForKey:@"Status"] boolValue];
        if (statusCode == 1) {
            NSMutableArray *array = [data objectForKey:@"Data"];
            if (array && [array count] > 0) {
                if (successBlock) {
                    successBlock(array);
                }
                
            } else{
                if (failedBlock) {
                    failedBlock(@"");
                }
                
            }
            
        } else{
            if (failedBlock) {
                failedBlock(@"");
            }
            
        }
        
    } failed:^(NSString *message) {
        if (failedBlock) {
            failedBlock(message);
        }
        
    }];
}

#pragma mark - login and registe
#pragma mark -
- (void)loginWithUserName:(NSString *)user
             withPassword:(NSString *)password
                  success:(void(^)(Login *login))successBlock
                   failed:(void(^)(NSString *errorMSG))failedBlock;
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://passport.%@/api/login?uid=%@&pwd=%@", aedudomain, user, password];
    
    NSString * encodingString = [requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self handerPostRequest:encodingString parameters:nil body:nil success:^(NSDictionary *data) {
        
        NSInteger statusCode = [[data objectForKey:@"status"] intValue];
        if (statusCode == 0) {
            NSDictionary *dict = (NSDictionary*)[data objectForKey:@"msg"];
            
            Login *login = [[Login alloc] init];
            
            login.userId = [NSString stringWithFormat:@"%@", [dict objectForKey:@"Id"]];
            login.tokenId = [dict objectForKey:@"Token"];
            
            
            login.userAvatar = [NSString stringWithFormat:@"%@%@%@?lq=123456",appHeadImage,login.userId,@".jpg"];
            
            
            login.userName = [dict objectForKey:@"UserName"];
            login.userRole = [dict objectForKey:@"UserRole"];
            
            login.blogAddress = [dict objectForKey:@"BlogAddress"];
            login.classId = [dict objectForKey:@"ClassId"];
            login.schoolId = [dict objectForKey:@"SchoolId"];
            login.schoolName = [dict objectForKey:@"SchoolName"];
            
            login.integral = [[dict objectForKey:@"Integral"] intValue];
            login.bSaveLoginState = [[dict objectForKey:@"IsSaveLoginState"] boolValue];
            login.loginTime = [dict objectForKey:@"LoginTime"];
            login.publicProperty = [dict objectForKey:@"PublicProperty"];
            login.saveStateTime = [dict objectForKey:@"SaveStateTime"];
            login.account=user;
            
            // 做缓存，将login对象变成字符串
            NSString *loginStr = login.toJSONString;
            //1. 创建一个plist文件
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
            NSString *path = [paths objectAtIndex:0];
            NSLog(@"path = %@",path);
            NSString *filename = [path stringByAppendingPathComponent:@"login.plist"];
            NSFileManager* fm = [NSFileManager defaultManager];
            [fm createFileAtPath:filename contents:nil attributes:nil];
            //创建一个dic，写到plist文件里
            NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:loginStr,@"loginStr",nil];
            [dic writeToFile:filename atomically:YES];
            if (successBlock) {
                [UserSession shareUserSession].user=login;
                [self bindPush];
#warning im登陆
                Connection* connection= [Connection shareConnection];
                connection.account=user;
                connection.pwd=password;
                connection.phone=nil;
                if ([connection getsocket]) {
                    [connection disconnect];
                }else{
                    [connection connect];
                }
                successBlock(login);
            }
        } else {
            if (failedBlock) {
                failedBlock([NSString stringWithFormat:@"status error:%d", statusCode]);
            }
        }
    } failed:^(NSString *message) {
        if (failedBlock) {
            failedBlock(message);
        }
    }];
}

#pragma mark - login and registe
#pragma mark -
- (void)loginQiDiUserName:(NSString *)user
                  success:(void(^)(Login *login))successBlock
                   failed:(void(^)(NSString *errorMSG))failedBlock;
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://nmapi.%@/QiDiLogin/Login?userAccount=%@", aedudomain, user];
    
    [self handerPostRequest:requestUrl parameters:nil body:nil success:^(NSDictionary *data) {
        
        NSInteger statusCode = [[data objectForKey:@"result"] intValue];
        if (statusCode == 0) {
            NSDictionary *dict = (NSDictionary*)[data objectForKey:@"msg"];
            
            Login *login = [[Login alloc] init];
            
            login.userId = [NSString stringWithFormat:@"%@", [dict objectForKey:@"Id"]];
            login.tokenId = [dict objectForKey:@"Token"];
            
            
            login.userAvatar = [NSString stringWithFormat:@"%@%@%@?lq=123456",appHeadImage,login.userId,@".jpg"];
            
            
            login.userName = [dict objectForKey:@"UserName"];
            login.userRole = [dict objectForKey:@"UserRole"];
            
            login.blogAddress = [dict objectForKey:@"BlogAddress"];
            login.classId = [dict objectForKey:@"ClassId"];
            login.schoolId = [dict objectForKey:@"SchoolId"];
            login.schoolName = [dict objectForKey:@"SchoolName"];
            
            login.integral = [[dict objectForKey:@"Integral"] intValue];
            login.bSaveLoginState = [[dict objectForKey:@"IsSaveLoginState"] boolValue];
            login.loginTime = [dict objectForKey:@"LoginTime"];
            login.publicProperty = [dict objectForKey:@"PublicProperty"];
            login.saveStateTime = [dict objectForKey:@"SaveStateTime"];
            login.account=user;
            if (successBlock) {
                [UserSession shareUserSession].user=login;
                [self bindPush];
                
#warning im登陆
                Connection* connection= [Connection shareConnection];
                connection.account=user;
                connection.pwd=nil;
                connection.phone=nil;
                if ([connection getsocket]) {
                    [connection disconnect];
                }else{
                    [connection connect];
                }
                successBlock(login);
            }
        } else {
            if (failedBlock) {
                failedBlock([data objectForKey:@"msg"]);
            }
        }
    } failed:^(NSString *message) {
        if (failedBlock) {
            failedBlock(message);
        }
    }];
}

#pragma mark -- 获取老师担当的角色
- (void)getTeacherRole1:(NSString *)Token
              teacherId:(NSString *)teacherId
                success:(void(^)(NSString* data))successBlock
                 failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://nmapi.%@/Push/GetTeacherRole?Token=%@&teacherId=%@", aedudomain, Token,teacherId];
    NSString * encodedString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)requestUrl, NULL, NULL,  kCFStringEncodingUTF8 );
    [self handerGetRequest:encodedString
                parameters:nil
                      body:nil
                   success:^(NSDictionary *data) {
                       NSInteger statusCode = [[data objectForKey:@"result"] intValue];
                       if (statusCode == 0) {
                           
                           NSMutableDictionary *dict = (NSMutableDictionary *)[data objectForKey:@"msg"];
                           if (dict) {
                               NSString *roleStr = [dict objectForKey:@"UserRole"];
                               if (successBlock) {
                                   successBlock(roleStr);
                               }
                               
                           } else {
                               if (failedBlock) {
                                   failedBlock(@"获取角色老师角色失败...");
                               }
                           }
                           
                           
                       } else {
                           if (failedBlock) {
                               failedBlock(@"获取角色老师角色失败...");
                           }
                       }
                       
                   } failed:^(NSString *message) {
                       failedBlock(@"获取老师角色失败...");
                   }];
}

#pragma mark -- 获取付费用户
- (void)getPayUserRole:(NSString *)userid
              userrole:(NSString *)userrole
               success:(void(^)(int data))successBlock
                failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://interface.%@/sjrrt/GetIsActiveFeeUser?userid=%@&userrole=%@", aedudomain, userid,userrole];
    NSString * encodedString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)requestUrl, NULL, NULL,  kCFStringEncodingUTF8 );
    [self handerGetRequest:encodedString
                parameters:nil
                      body:nil
                   success:^(NSDictionary *data) {
                       NSInteger statusCode = [[data objectForKey:@"result"] intValue];
                       if (statusCode) {
                           if (successBlock) {
                               successBlock(statusCode);
                           }
                       } else{
                           if (failedBlock) {
                               failedBlock(@"获取付费角色失败");
                           }
                       }
                       
                   } failed:^(NSString *message) {
                       failedBlock(@"获取付费角色失败");
                   }];
    
}

#pragma mark - 注册
#pragma mark -
- (void)registerWithUserName:(NSString *)account
                withPassword:(NSString *)password
                    username:(NSString *)username
                    usertype:(NSString *)usertype
                     success:(void(^)(NSDictionary* data))successBlock
                      failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://passport.%@/api/register?UserAccount=%@&Password=%@&UserName=%@&UserType=%@", aedudomain, account, password,username,usertype];
    NSString * encodedString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)requestUrl, NULL, NULL,  kCFStringEncodingUTF8 );
    
    [self handerPostRequest:encodedString parameters:nil body:nil success:^(NSDictionary *data) {
        NSInteger statusCode = [[data objectForKey:@"status"] intValue];
        if (statusCode == 0) {
            if (successBlock) {
                successBlock(data);
            }
        } else if(statusCode == -2) {
            if (failedBlock) {
                failedBlock(@"账号已存在！");
            }
        } else{
            if (failedBlock) {
                failedBlock(@"注册失败！");
            }
        }
    } failed:^(NSString *message) {
        if (failedBlock) {
            failedBlock(message);
        }
    }];
}

#pragma mark - 检查版本更新
#pragma mark -

- (void)checkingVersion:(NSString *)versionId
                success:(void(^)(NSDictionary* data))successBlock
                 failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *url = @"http://itunes.apple.com/cn/lookup";
    NSString *requestUrl = [NSString stringWithFormat:@"%@?id=%@", url, versionId];
    NSString * encodedString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)requestUrl, NULL, NULL,  kCFStringEncodingUTF8 );
    [self handerPostRequest:encodedString parameters:nil body:nil success:^(NSDictionary *data) {
        NSInteger statusCode = [[data objectForKey:@"resultCount"] intValue];
        if (statusCode == 1) {
            if (successBlock) {
                successBlock(data);
            }
        } else {
            if (failedBlock) {
                if (failedBlock) {
                    failedBlock(@"已经是最新版本啦~");
                }
            }
        }
        
    } failed:^(NSString *message) {
        
    }];
}


#pragma mark - 获取用户角色
#pragma mark -

- (void)getUserOfRole:(NSString *)userId
              success:(void(^)(NSDictionary* data))successBlock
               failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://home.%@/Api/GetParentId?userId=%@", aedudomain, userId];
    NSString * encodedString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)requestUrl, NULL, NULL,  kCFStringEncodingUTF8 );
    [self handerGetRequest:encodedString parameters:nil body:nil success:^(NSDictionary *data) {
        if (successBlock) {
            successBlock(data);
        }
    } failed:^(NSString *message) {
        if (failedBlock) {
            failedBlock(message);
        }
    }];
    
}

#pragma mark - 获取用户套餐
#pragma mark -
- (void)getUserOfPackage:(NSString *)token
                 success:(void(^)(NSArray* data))successBlock
                  failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://home.%@/Api/GetUserTactics?token=%@", aedudomain, token];
    NSString * encodedString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)requestUrl, NULL, NULL,  kCFStringEncodingUTF8 );
    [self handerGetRequest:encodedString parameters:nil body:nil success:^(NSDictionary *data) {
        NSInteger statusCode = [[data objectForKey:@"st"] intValue];
        if (statusCode == 1) {
            NSDictionary *dict = (NSDictionary*)[data objectForKey:@"msg"];
            NSLog(@"%@",dict);
            if (dict) {
                NSMutableArray *comboArray = [[NSMutableArray alloc] init];
                UserOfCombo *Combo = [[UserOfCombo alloc] init];
                Combo.UserTacticsId = [[dict objectForKey:@"list"][0] valueForKey:@"UserTacticsId"];
                Combo.SysTacticsId = [[dict objectForKey:@"list"][0] valueForKey:@"SysTacticsId"];
                Combo.StatusId = [[dict objectForKey:@"list"][0] valueForKey:@"StatusId"];
                [comboArray addObject:Combo];
                
                if (successBlock) {
                    successBlock(comboArray);
                }
                
            } else{
                if (failedBlock) {
                    failedBlock([NSString stringWithFormat:@"Json parsing wrong"]);
                }
                
            }
        } else{
            if (failedBlock) {
                failedBlock([NSString stringWithFormat:@"%d", statusCode]);
            }
            
        }
        
    } failed:^(NSString *message) {
        if (failedBlock) {
            failedBlock(message);
        }
    }];
}

#pragma mark - 上传图片
#pragma mark -

- (void)uploadImage:(NSString *)UserId
               File:(NSString *)File success:(void(^)(NSDictionary * data))successBlock
             failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://home.%@/api/PostUploadImages?UserId=%@&File=%@",
                            aedudomain, UserId, File];
    NSString * encodedString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)requestUrl, NULL, NULL,  kCFStringEncodingUTF8 );
    
    [self handerPostRequest:encodedString parameters:nil body:nil success:^(NSDictionary *data) {
        successBlock(data);
    } failed:^(NSString *message) {
        failedBlock(message);
        
    }];
}

#pragma mark - Activity
#pragma mark -
- (void)fetchActivity:(NSString *)tokenId
               typeId:(NSString *)typeId
              groupId:(NSString *)groupId
            pageIndex:(int)pageIndex
              success:(void(^)(NSArray * data))successBlock
               failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://home.%@/Api/GetHomeActivity?ToKen=%@&TypeId=%@&GroupId=%@&PageIndex=%d",
                            aedudomain, tokenId, typeId, groupId, pageIndex];
    
    [self handerGetRequest:requestUrl parameters:nil body:nil success:^(NSDictionary *data) {
        NSInteger statusCode = [[data objectForKey:@"st"] intValue];
        if (statusCode == 0) {
            NSDictionary *dict = (NSDictionary*)[data objectForKey:@"msg"];
            if (dict) {
                NSArray *array = (NSArray *)[dict objectForKey:@"list"];
                NSMutableArray *activities = [NSMutableArray arrayWithCapacity:[array count]];
                for (int i = 0; i < [array count]; i++) {
                    Activity *activity = [[Activity alloc] init];
                    NSDictionary *info = [array objectAtIndex:i];
                    
                    activity.activityId = [info objectForKey:@"ActivityId"];
                    activity.activityBody = [info objectForKey:@"Body"];
                    activity.activityType = [[info objectForKey:@"TypeId"] intValue];
                    activity.commentCount = [[info objectForKey:@"CommentCount"] intValue];
                    activity.time = [info objectForKey:@"DateTime"];
                    activity.favoriteCount = [[info objectForKey:@"FavoriteCount"] intValue];
                    activity.forwardCount = [[info objectForKey:@"ForwardedCount"] intValue];
                    activity.forwardedWeiboId = [info objectForKey:@"ForwardedMicroblogId"];
                    activity.from = [info objectForKey:@"From"];
                    activity.bFavorited = [[info objectForKey:@"IsFavorited"] boolValue];
                    activity.bForwarded = [[info objectForKey:@"IsForward"] boolValue];
                    activity.weiboId = [info objectForKey:@"MicroblogId"];
                    activity.originalWeiboId = [info objectForKey:@"OriginalMicroblogId"];
                    activity.imageUrl = [info objectForKey:@"PictureUrl"];
                    activity.userId = [info objectForKey:@"UserId"];
                    activity.userName = [info objectForKey:@"UserName"];
                    
                    activity.albumId = [info objectForKey:@"AlbumId"];
                    activity.images  = (NSArray*)[info objectForKey:@"ImagesUrl"];
                    
                    activity.blogId = [info objectForKey:@"BlogId"];
                    activity.title  = [info objectForKey:@"Title"];
                    
                    [activities addObject:activity];
                }//end for
                
                if (successBlock) {
                    successBlock(activities);
                }
            } else {
                if (failedBlock) {
                    failedBlock([NSString stringWithFormat:@"Json parsing wrong"]);
                }
            }
        } else {
            if (failedBlock) {
                failedBlock([NSString stringWithFormat:@"%d", statusCode]);
            }
        }
    } failed:^(NSString *message) {
        if (failedBlock) {
            failedBlock(message);
        }
    }];
}

- (void)refreshActivity:(NSString *)tokenId
                 typeId:(NSString *)typeId
                groupId:(NSString *)groupId
         lastActivityId:(NSString *)activityId
                success:(void(^)(NSDictionary* data))successBlock
                 failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://home.%@/Api/GetHomeNewActivity?ToKen=%@&TypeId=%@&GroupId=%@&LastActivityId=%@",
                            aedudomain, tokenId, typeId, groupId, activityId];
    [self handerGetRequest:requestUrl parameters:nil body:nil success:^(NSDictionary *data) {
        if (successBlock) {
            successBlock(data);
        }
    } failed:^(NSString *message) {
        if (failedBlock) {
            failedBlock(message);
        }
    }];
}

- (void)favoriteActivity:(NSString *)tokenId
                objectId:(NSString *)objectId
                  typeId:(NSString *)typeId
                 success:(void(^)(NSDictionary* data))successBlock
                  failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://home.%@/Api/PostActivityFavorited?ToKen=%@&ObjectId=%@&TypeId=%@",
                            aedudomain, tokenId, objectId, typeId];
    
    [self handerPostRequest:requestUrl parameters:nil body:nil success:^(NSDictionary *data) {
        if (successBlock) {
            successBlock(data);
        }
    } failed:^(NSString *message) {
        if (failedBlock) {
            failedBlock(message);
        }
    }];
}

- (void)forwardActivity:(NSString *)userId
               objectId:(NSString *)objectId
                   body:(NSString *)body
                success:(void(^)(NSDictionary* data))successBlock
                 failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://home.%@/Api/PostActivityForwarded?UserId=%@&MicroblogId=%@&Body=%@",
                            aedudomain, userId, objectId, body];
    
    NSString * encodedString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)requestUrl, NULL, NULL,  kCFStringEncodingUTF8 );
    
    [self handerPostRequest:encodedString parameters:nil body:nil success:^(NSDictionary *data) {
        if (successBlock) {
            successBlock(data);
        }
    } failed:^(NSString *message) {
        if (failedBlock) {
            failedBlock(message);
        }
    }];
}

- (void)shareActivity:(NSString *)userId
             objectId:(NSString *)objectId
                 body:(NSString *)body
              success:(void(^)(NSDictionary* data))successBlock
               failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://home.%@/Api/PostActivityShare?UserId=%@&ActivityId=%@&Body=%@",
                            aedudomain, userId, objectId, body];
    
    NSString * encodedString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)requestUrl, NULL, NULL,  kCFStringEncodingUTF8 );
    
    [self handerPostRequest:encodedString parameters:nil body:nil success:^(NSDictionary *data) {
        if (successBlock) {
            successBlock(data);
        }
    } failed:^(NSString *message) {
        if (failedBlock) {
            failedBlock(message);
        }
    }];
}

- (void)shieldActivity:(NSString *)tokenId
            activityId:(NSString *)activityId
               success:(void(^)(NSDictionary* data))successBlock
                failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://home.%@/Api/PostScreenActivity?ToKen=%@&ActivityId=%@",
                            aedudomain, tokenId, activityId];
    
    [self handerPostRequest:requestUrl parameters:nil body:nil success:^(NSDictionary *data) {
        if (successBlock) {
            successBlock(data);
        }
    } failed:^(NSString *message) {
        if (failedBlock) {
            failedBlock(message);
        }
    }];
}

- (void)reportActivity:(NSString *)tokenId
            activityId:(NSString *)activityId
                  body:(NSString *)body
                  type:(int)type
               success:(void(^)(NSDictionary* data))successBlock
                failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://home.%@/Api/PostReportActivity?ToKen=%@&ActivityId=%@&Body=%@&TypeId=%d",
                            aedudomain, tokenId, activityId, body, type];
    
    NSString * encodedString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)requestUrl, NULL, NULL,  kCFStringEncodingUTF8 );
    
    [self handerPostRequest:encodedString parameters:nil body:nil success:^(NSDictionary *data) {
        if (successBlock) {
            successBlock(data);
        }
    } failed:^(NSString *message) {
        if (failedBlock) {
            failedBlock(message);
        }
    }];
}

#pragma mark - Activity---weibo
#pragma mark -
- (void)fetchWeiboDetail:(NSString *)weiboId
                 success:(void(^)(Activity* activity))successBlock
                  failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://interface.%@/sjrrt/GetMicroBlogById?MicroblogId=%@",
                            aedudomain, weiboId];
    [self handerGetRequest:requestUrl parameters:nil body:nil success:^(NSDictionary *data) {
        NSInteger statusCode = [[data objectForKey:@"st"] intValue];
        NSLog(@"******:%d",statusCode);
        if (statusCode == 0) {
            NSDictionary *dict = (NSDictionary*)[data objectForKey:@"msg"];
            if (dict) {
                NSDictionary *info = (NSDictionary *)[dict objectForKey:@"list"];
                if (info) {
                    Activity *activity = [[Activity alloc] init];
                    
                    activity.activityBody = [info objectForKey:@"Body"];
                    activity.activityType = Activity_Type_Weibo;
                    activity.commentCount = [[info objectForKey:@"CommentCount"] intValue];
                    activity.time = [info objectForKey:@"DateTime"];
                    activity.favoriteCount = [[info objectForKey:@"FavoriteCount"] intValue];
                    activity.forwardCount = [[info objectForKey:@"ForwardedCount"] intValue];
                    activity.forwardedWeiboId = [info objectForKey:@"ForwardedMicroblogId"];
                    activity.from = [info objectForKey:@"From"];
                    activity.weiboId = [info objectForKey:@"MicroblogId"];
                    activity.originalWeiboId = [info objectForKey:@"OriginalMicroblogId"];
                    activity.imageUrl = [info objectForKey:@"PictureUrl"];
                    activity.userId = [info objectForKey:@"UserId"];
                    activity.userName = [info objectForKey:@"UserName"];
                    
                    if (successBlock) {
                        successBlock(activity);
                    }
                }
            } else {
                if (failedBlock) {
                    failedBlock([NSString stringWithFormat:@"Json parsing wrong"]);
                }
            }
        } else {
            if (failedBlock) {
                failedBlock([NSString stringWithFormat:@"加载完成..."]);
            }
        }
    }  failed:^(NSString *message) {
        if (failedBlock) {
            failedBlock(message);
        }
    }];
}

- (void)fetchComments:(NSString *)tokenId
              ofWeibo:(NSString *)weiboId
              success:(void(^)(NSDictionary* data))successBlock
               failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://home.%@/Api/GetMicroblogComment?ToKen=%@&MicroblogId=%@",
                            aedudomain, tokenId, weiboId];
    [self handerGetRequest:requestUrl parameters:nil body:nil success:^(NSDictionary *data) {
        if (successBlock) {
            successBlock(data);
        }
    } failed:^(NSString *message) {
        if (failedBlock) {
            failedBlock(message);
        }
    }];
}

- (void)refreshComments:(NSString *)lastCommentId
                ofWeibo:(NSString *)weiboId
                success:(void(^)(NSDictionary* data))successBlock
                 failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://home.%@/Api/GetMicroblogNewComment?MicroblogId=%@&LastCommentId=%@",
                            aedudomain, weiboId, lastCommentId];
    [self handerGetRequest:requestUrl parameters:nil body:nil success:^(NSDictionary *data) {
        if (successBlock) {
            successBlock(data);
        }
    } failed:^(NSString *message) {
        if (failedBlock) {
            failedBlock(message);
        }
    }];
}

- (void)fetchForwardOfWeibo:(NSString *)weiboId
                   pageSize:(int)pageSize
                  pageIndex:(int)pageIndex
                    success:(void(^)(NSDictionary* data))successBlock
                     failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://home.%@/Api/GetMicroblogForwarded?MicroblogId=%@&PageSize=%d&PageIndex=%d",
                            aedudomain, weiboId, pageSize, pageIndex];
    [self handerGetRequest:requestUrl parameters:nil body:nil success:^(NSDictionary *data) {
        if (successBlock) {
            successBlock(data);
        }
    } failed:^(NSString *message) {
        if (failedBlock) {
            failedBlock(message);
        }
    }];
}

- (void)refreshForwardOfWeibo:(NSString *)weiboId
              lastForwardedId:(NSString*)lastForwardedId
                    pageIndex:(int)pageIndex
                      success:(void(^)(NSDictionary* data))successBlock
                       failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://home.%@/Api/GetMicroblogNewForwarded?MicroblogId=%@&LastForwardedId=%@&PageIndex=%d",
                            aedudomain, weiboId, lastForwardedId, pageIndex];
    [self handerGetRequest:requestUrl parameters:nil body:nil success:^(NSDictionary *data) {
        if (successBlock) {
            successBlock(data);
        }
    } failed:^(NSString *message) {
        if (failedBlock) {
            failedBlock(message);
        }
    }];
}

- (void)fetchFavoritedOfWeibo:(NSString *)weiboId
                    pageIndex:(int)pageIndex
                      success:(void(^)(NSDictionary* data))successBlock
                       failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://home.%@/Api/GetMicroblogFavorited?MicroblogId=%@&PageIndex=%d",
                            aedudomain, weiboId, pageIndex];
    [self handerGetRequest:requestUrl parameters:nil body:nil success:^(NSDictionary *data) {
        if (successBlock) {
            successBlock(data);
        }
    } failed:^(NSString *message) {
        if (failedBlock) {
            failedBlock(message);
        }
    }];
}

- (void)sendWeibo:(NSString *)userId
             body:(NSString *)body
         HasPhoto:(int)HasPhoto
         ImageUrl:(NSString *)ImageUrl
          success:(void(^)(NSDictionary* data))successBlock
           failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = nil;
    if (HasPhoto == 0) {
        requestUrl = [NSString stringWithFormat:@"http://home.%@/Api/PostCreateMicroblog?UserId=%@&Body=%@", aedudomain, userId,body];
    } else {
        requestUrl = [NSString stringWithFormat:@"http://home.%@/Api/PostCreateMicroblog?UserId=%@&Body=%@&HasPhoto=%d&ImageUrl=%@",
                      aedudomain, userId,body,HasPhoto,ImageUrl];
    }
    
    NSString * encodedString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)requestUrl, NULL, NULL,  kCFStringEncodingUTF8 );
    
    [self handerPostRequest:encodedString parameters:nil body:nil success:^(NSDictionary *data) {
        if (successBlock) {
            successBlock(data);
        }
    } failed:^(NSString *message) {
        if (failedBlock) {
            failedBlock(message);
        }
    }];
}

#pragma mark - Activity---blog
#pragma mark -
- (void)fetchBlogDetail:(NSString *)blogId
                success:(void(^)(Activity* activity))successBlock
                 failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://home.%@/Api/GetActivityBlogThread?BlogThreadsId=%@",
                            aedudomain, blogId];
    [self handerGetRequest:requestUrl parameters:nil body:nil success:^(NSDictionary *data) {
        NSInteger statusCode = [[data objectForKey:@"st"] intValue];
        if (statusCode == 0) {
            NSDictionary *dict = (NSDictionary*)[data objectForKey:@"msg"];
            if (dict) {
                NSDictionary *info = (NSDictionary *)[dict objectForKey:@"list"];
                if (info) {
                    Activity *activity = [[Activity alloc] init];
                    
                    activity.blogId = [info objectForKey:@"BlogThreadId"];
                    activity.activityBody = [info objectForKey:@"Body"];
                    activity.activityType = Activity_Type_Blog;
                    activity.commentCount = [[info objectForKey:@"CommentCount"] intValue];
                    activity.time = [info objectForKey:@"DateTime"];
                    activity.favoriteCount = [[info objectForKey:@"FavoriteCount"] intValue];
                    activity.forwardCount = [[info objectForKey:@"ForwardedCount"] intValue];
                    activity.from = [info objectForKey:@"From"];
                    activity.imageUrl = [info objectForKey:@"PictureUrl"];
                    activity.userId = [info objectForKey:@"UserId"];
                    activity.userName = [info objectForKey:@"UserName"];
                    
                    if (successBlock) {
                        successBlock(activity);
                    }
                }
            } else {
                if (failedBlock) {
                    failedBlock([NSString stringWithFormat:@"Json parsing wrong"]);
                }
            }
        } else {
            if (failedBlock) {
                failedBlock([NSString stringWithFormat:@"%d", statusCode]);
            }
        }
    } failed:^(NSString *message) {
        if (failedBlock) {
            failedBlock(message);
        }
    }];
}

- (void)fetchCommentsOfBlog:(NSString *)blogId
                  pageIndex:(int)pageIndex
                    success:(void(^)(NSDictionary* data))successBlock
                     failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://home.%@/Api/GetBlogThreadsComment?BlogThreadsId=%@&pageIndex=%d",
                            aedudomain, blogId, pageIndex];
    [self handerGetRequest:requestUrl parameters:nil body:nil success:^(NSDictionary *data) {
        if (successBlock) {
            successBlock(data);
        }
    } failed:^(NSString *message) {
        if (failedBlock) {
            failedBlock(message);
        }
    }];
}

- (void)fetchForwardedOfBlog:(NSString *)blogId
                   pageIndex:(int)pageIndex
                     success:(void(^)(NSDictionary* data))successBlock
                      failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://home.%@/Api/GetBlogThreadsForwarded?BlogThreadsId=%@&pageIndex=%d",
                            aedudomain, blogId, pageIndex];
    [self handerGetRequest:requestUrl parameters:nil body:nil success:^(NSDictionary *data) {
        if (successBlock) {
            successBlock(data);
        }
    } failed:^(NSString *message) {
        if (failedBlock) {
            failedBlock(message);
        }
    }];
}

- (void)fetchFavoritedOfBlog:(NSString *)blogId
                   pageIndex:(int)pageIndex
                     success:(void(^)(NSDictionary* data))successBlock
                      failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://home.%@/Api/GetBlogThreadsFavorited?BlogThreadsId=%@&pageIndex=%d",
                            aedudomain, blogId, pageIndex];
    [self handerGetRequest:requestUrl parameters:nil body:nil success:^(NSDictionary *data) {
        if (successBlock) {
            successBlock(data);
        }
    } failed:^(NSString *message) {
        if (failedBlock) {
            failedBlock(message);
        }
    }];
}

- (void)sendBlog:(NSString *)UserId
         Subject:(NSString *)pageIndex
            Body:(NSString *)Body
         success:(void(^)(NSDictionary* data))successBlock
          failed:(void(^)(NSString *errorMSG))failedBlock;
{
//    NSString *requestUrl = [NSString stringWithFormat:@"http://home.%@/Api/PostCreateBlogThreads?UserId=%@&Subject=%@&Body=%@",aedudomain, UserId, pageIndex,Body];
//    
//    NSString * encodedString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)requestUrl, NULL, NULL,  kCFStringEncodingUTF8 );
    
    NSString *requestUrl = [NSString stringWithFormat:@"http://home.%@/Api/PostCreateBlogThreads",aedudomain];
    NSDictionary *parametersDict = [[NSDictionary alloc] initWithObjectsAndKeys:UserId,@"UserId",pageIndex,@"Subject",Body,@"Body",nil];
    
    [HttpUtil PostWithUrl:requestUrl
               parameters:parametersDict
                  success:^(id json) {
                      RecentlyArticle *recentlyArticle = [[RecentlyArticle alloc] initWithString:json error:nil];
                      if (recentlyArticle.st.intValue == 0) {
                          if (successBlock) {
                              successBlock(nil);
                          }
                      }else{
                          failedBlock(recentlyArticle.msg);
                      }
                  } fail:^(id error) {
                      if (failedBlock) {
                          failedBlock(@"发送失败！");
                      }
                  } cache:^(id cache) {
                      
                  }];
    
//    [self handerPostRequest:encodedString parameters:nil body:nil success:^(NSDictionary *data) {
//        if (successBlock) {
//            successBlock(data);
//        }
//    } failed:^(NSString *message) {
//        if (failedBlock) {
//            failedBlock(message);
//        }
//    }];
    
}

#pragma mark - Message
#pragma mark -




#pragma mark - 点赞
#pragma mark -

- (void)clickPraise:(NSString *)toKen
           objectId:(NSString *)objectId
             typeId:(NSString *)typeId
            success:(void(^)(NSDictionary* data))successBlock
             failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://home.%@/api/PostPraise?toKen=%@&objectId=%@&typeId=%@",
                            aedudomain, toKen, objectId, typeId];
    //URL汉字转码：
    NSString * encodedString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)requestUrl, NULL, NULL,  kCFStringEncodingUTF8 );
    
    [self handerPostRequest:encodedString parameters:nil body:nil success:^(NSDictionary *data) {
        NSInteger statusCode = [[data objectForKey:@"result"] intValue];
        if (statusCode == 1) {
            if (successBlock) {
                successBlock(data);
            }
        } else {
            if (failedBlock) {
                failedBlock([NSString stringWithFormat:@"亲，你已经点过赞了哦！"]);
            }
        }
    } failed:^(NSString *message) {
        if (failedBlock) {
            failedBlock(message);
        }
    }];
    
}

#pragma mark - 评论
#pragma mark -

- (void)clickComment:(NSString *)userId
   commentedObjectId:(NSString *)commentedObjectId
                body:(NSString *)body
              typeId:(NSString *)typeId
             success:(void(^)(NSDictionary* data))successBlock
              failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://home.%@/api/PostReplyComments?userId=%@&commentedObjectId=%@&body=%@&typeId=%@",
                            aedudomain, userId, commentedObjectId, body , typeId];
    //URL汉字转码：
    NSString * encodedString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)requestUrl, NULL, NULL,  kCFStringEncodingUTF8 );
    [self handerPostRequest:encodedString parameters:nil body:nil success:^(NSDictionary *data) {
        NSInteger statusCode = [[data objectForKey:@"st"] intValue];
        if (statusCode == 0) {
            if (successBlock) {
                successBlock(data);
            }
        } else if (statusCode == -3){
            if (failedBlock) {
                
                failedBlock([NSString stringWithFormat:@"亲，你评论内容不能为空哦！"]);
            }
        } else{
            if (failedBlock) {
                failedBlock([NSString stringWithFormat:@"亲，你已经点过赞了哦！"]);
            }
        }
        
    } failed:^(NSString *message) {
        if (failedBlock) {
            failedBlock(message);
        }
    }];
}

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
              failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://interface.%@/sjrrt/AddDynComment?Token=%@&CommentedObjectId=%@&OwnerId=%@&UserId=%@&Author=%@&subject=%@&body=%@",
                            aedudomain, Token, CommentedObjectId, OwnerId, UserId, Author, subject, body];
    //URL汉字转码：
    NSString * encodedString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)requestUrl, NULL, NULL,  kCFStringEncodingUTF8 );
    [self handerPostRequest:encodedString parameters:nil body:nil success:^(NSDictionary *data) {
        if (successBlock) {
            successBlock(data);
        }
    } failed:^(NSString *message) {
        if (failedBlock) {
            failedBlock(message);
        }
    }];
}

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
            failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://interface.%@/sjrrt/AddDynComment?Token=%@&CommentedObjectId=%@&OwnerId=%@&UserId=%@&Author=%@&subject=%@&body=%@&ToUserId=%@&ToUserName=%@",
                            aedudomain, Token, CommentedObjectId, OwnerId, UserId, Author, subject, body, ToUserId, ToUserName];
    //URL汉字转码：
    NSString * encodedString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)requestUrl, NULL, NULL,  kCFStringEncodingUTF8 );
    [self handerPostRequest:encodedString parameters:nil body:nil success:^(NSDictionary *data) {
        if (data) {
            if (successBlock) {
                successBlock(data);
            }
        }
        
    } failed:^(NSString *message) {
        if (failedBlock) {
            failedBlock(message);
        }
    }];
    
}


#pragma mark - 回复
#pragma mark -

- (void)clickReply:(NSString *)userId
 commentedObjectId:(NSString *)commentedObjectId
              body:(NSString *)body
            typeId:(NSString *)typeId
          parentId:(NSString *)parentId
           success:(void(^)(NSDictionary* data))successBlock
            failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://home.%@/api/PostReplyComments?userId=%@&commentedObjectId=%@&body=%@&typeId=%@&parentId=%@",
                            aedudomain, userId, commentedObjectId, body ,typeId,parentId];
    //URL汉字转码：
    NSString * encodedString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)requestUrl, NULL, NULL,  kCFStringEncodingUTF8 );
    [self handerPostRequest:encodedString parameters:nil body:nil success:^(NSDictionary *data) {
        NSInteger statusCode = [[data objectForKey:@"st"] intValue];
        if (statusCode == 0) {
            if (successBlock)
                successBlock(data);
        } else {
            if (failedBlock) {
                failedBlock([NSString stringWithFormat:@"被评论的内容不存在或已删除！"]);
            }
        }
    } failed:^(NSString *message) {
        if (failedBlock) {
            failedBlock(message);
        }
    }];
}

#pragma mark - 日志，评论等点赞情况获取接口
#pragma mark -

- (void)gainPraiseBlogEvaluateDetail:(NSString *)ObjectId
                             success:(void(^)(NSDictionary* data))successBlock
                              failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://interface.%@/sjrrt/GetPraseSummary?ObjectId=%@",
                            aedudomain, ObjectId];
    [self handerGetRequest:requestUrl parameters:nil body:nil success:^(NSDictionary *data) {
        if (data) {
            if (successBlock) {
                successBlock(data);
            }
        }
        
    } failed:^(NSString *message) {
        if (failedBlock) {
            failedBlock(message);
        }
    }];
    
}

#pragma mark - 权限设置功能
#pragma mark -
//设置禁止此人访问自己的空间或允许此人访问自己的空间
- (void)prohibitVisit:(NSString *)Token
              VUserId:(NSString *)VUserId
              OUserId:(NSString *)OUserId
             IsForbid:(NSString *)IsForbid
              success:(void(^)(NSDictionary* data))successBlock
               failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://interface.%@/sjrrt/SetForbidVisitSpace?Token=%@&VUserId=%@&OUserId=%@&IsForbid=%@",
                            aedudomain, Token, VUserId, OUserId, IsForbid];
    [self handerPostRequest:requestUrl parameters:nil body:nil success:^(NSDictionary *data) {
        if (successBlock) {
            successBlock(data);
        }
    } failed:^(NSString *message) {
        if (failedBlock) {
            failedBlock(message);
        }
    }];
    
    
}

// 设置自己屏蔽此人的空间信息或取消屏蔽此人的空间信息
- (void)shieldingSpace:(NSString *)Token
               VUserId:(NSString *)VUserId
               OUserId:(NSString *)OUserId
             OUserName:(NSString *)OUserName
                  IsPb:(NSString *)IsPb
               success:(void(^)(NSDictionary* data))successBlock
                failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://interface.%@/sjrrt/SetPBActivities?Token=%@&VUserId=%@&OUserId=%@&OUserName=%@&IsPb=%@",
                            aedudomain, Token, VUserId, OUserId, OUserName,IsPb];
    //汉字转码
    NSString * encodedString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)requestUrl, NULL, NULL,  kCFStringEncodingUTF8 );
    
    [self handerPostRequest:encodedString parameters:nil body:nil success:^(NSDictionary *data) {
        if (successBlock) {
            successBlock(data);
        }
    } failed:^(NSString *message) {
        if (failedBlock) {
            failedBlock(message);
        }
    }];
    
    
}

#pragma mark - 返回权限信息
#pragma mark -

- (void)backPermissionDetail:(NSString *)vuserid
                     OUserId:(NSString *)OUserId
                     success:(void(^)(NSDictionary* data))successBlock
                      failed:(void(^)(NSString *errorMSG))failedBlock

{
    NSString *requestUrl = [NSString stringWithFormat:@"http://interface.%@/sjrrt/GetUserSpacePower?vuserid=%@&OUserId=%@",
                            aedudomain, vuserid,OUserId];
    [self handerGetRequest:requestUrl parameters:nil body:nil success:^(NSDictionary *data) {
        NSArray *dict = (NSArray *)[data objectForKey:@"msg"];
        if (dict) {
            if (successBlock) {
                successBlock(data);
            }
        }
    } failed:^(NSString *message) {
        if (failedBlock) {
            failedBlock(message);
        }
    }];
    
}

- (void)deleteMyFriends:(NSString *)Token
           FriendUserId:(NSString *)FriendUserId
                success:(void(^)(NSDictionary* data))successBlock
                 failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://interface.%@/sjrrt/CancelFriends?Token=%@&FriendUserId=%@",
                            aedudomain, Token,FriendUserId];
    [self handerPostRequest:requestUrl parameters:nil body:nil success:^(NSDictionary *data) {
        if (successBlock) {
            successBlock(data);
        }
    } failed:^(NSString *message) {
        if (failedBlock) {
            failedBlock(message);
        }
    }];
}

#pragma mark - 添加好友
#pragma mark -

- (void)addFriends:(NSString *)UserId
      FollowUserId:(NSString *)FollowUserId
          GroupIds:(NSString *)GroupIds
          NoteName:(NSString *)NoteName
           success:(void(^)(NSString* msg))successBlock
            failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://home.%@/Api/PostAddFollow?UserId=%@&FollowUserId=%@&GroupIds=%@&NoteName=%@",
                            aedudomain, UserId, FollowUserId, GroupIds,NoteName];
    //带汉字编码
    NSString * encodingString = [requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //    请求后，返回的数据，如何显示的是这样的格式：%3A%2F%2F，此时需要我们进行UTF-8解码，用到的方法是：
    //    NSString *str = [model.album_name stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self handerPostRequest:encodingString parameters:nil body:nil success:^(NSDictionary *data) {
        if (successBlock) {
            int st=[[data objectForKey:@"st"] intValue];
            if (st==0) {
                successBlock(@"等待对方同意");
            }else if (st==-1) {
                successBlock(@"登录用户为空");
            }else if (st==-2) {
                successBlock(@"用户ID为空");
            }else if (st==-3) {
                successBlock(@"被关注人ID为空");
            }else if (st==-99) {
                successBlock(@"已发送过请求");
            }else{
                failedBlock(@"添加好友失败！");
            }
        }
    } failed:^(NSString *message) {
        if (failedBlock) {
            failedBlock(message);
        }
    }];
    
}

#pragma mark - 好友动态
#pragma mark -

- (void)friendsDynamicDetail:(NSString *)UserId pageIndex:(int)pageIndex pageSize:(int)pageSize
                     success:(void(^)(NSMutableArray *friendDynamic))successBlock
                      failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://interface.%@/sjrrt/GetMyMobileTimeline?UserId=%@&pageIndex=%d&pageSize=%d",
                            aedudomain, UserId,pageIndex,pageSize];
    
    [self handerGetRequest:requestUrl parameters:nil body:nil success:^(NSDictionary *data) {
        NSString* resultstr=[data objectForKey:@"result"];
        int result=[resultstr intValue];
        if ([resultstr isEqual:@"-?"]) {
            if (failedBlock) {
                failedBlock(@"错误的请求");
            }
        }else if(result==1){
            NSArray *dict = (NSArray *)[data objectForKey:@"msg"];
            if (dict) {
                NSMutableArray* array=[[NSMutableArray alloc] init];
                for (int i = 0; i < dict.count; i++) {
                    
                    FriendDynamicDetail *friends = [[FriendDynamicDetail alloc] init];
                    friends.ActivityId = [[dict[i] valueForKey:@"ActivityId"] intValue];
                    friends.serId = [[dict[i] objectForKey:@"UserId"] intValue];
                    friends.activityItemKey = [dict[i] valueForKey:@"ActivityItemKey"];
                    friends.applicationid = [[dict[i] valueForKey:@"ApplicationId"] intValue];
                    friends.DateCreated=[dict[i] valueForKey:@"DateCreated"];
                    friends.DateCreatedStr=[dict[i] valueForKey:@"DateCreatedStr"];
                    friends.hasImage=[[dict[i] objectForKey:@"HasImage"] boolValue];
                    friends.hasMusic=[[dict[i] objectForKey:@"HasMusic"] boolValue];
                    friends.hasVideo=[[dict[i] objectForKey:@"HasVideo"] boolValue];
                    friends.isOriginalThread=[[dict[i] objectForKey:@"IsOriginalThread"] boolValue];
                    friends.isPrivate=[[dict[i] objectForKey:@"IsPrivate"] boolValue];
                    friends.LastModified=[dict[i] objectForKey:@"LastModified"];
                    friends.ownerid=[[dict[i] objectForKey:@"OwnerId"] intValue];
                    friends.OwnerName=[dict[i] objectForKey:@"OwnerName"];
                    friends.OwnerType=[[dict[i] objectForKey:@"OwnerType"] intValue];
                    //赞
                    if (![[dict[i] objectForKey:@"Parase"] isKindOfClass:[NSNull class]]) {
                        friends.Detail=[[dict[i] objectForKey:@"Parase"] objectForKey:@"Detail"];
                        friends.Total=[[[dict[i] objectForKey:@"Parase"] objectForKey:@"Total"] intValue];
                    }else{
                        friends.Detail=@"";
                        friends.Total=0;
                    }
                    //相片
                    if (![[dict[i] objectForKey:@"Photos"] isKindOfClass:[NSNull class]]) {
                        friends.Photos= [dict[i] objectForKey:@"Photos"];
                        
                    }else{
                        friends.Photos = nil;
                        
                    }
                    friends.referenceId=[[dict[i] objectForKey:@"ReferenceId"] intValue];
                    friends.referenceTenantTypeId=[dict[i] objectForKey:@"ReferenceTenantTypeId"];
                    friends.sourceId=[[dict[i] objectForKey:@"SourceId"] intValue];
                    friends.tenantTypeid=[[dict[i] objectForKey:@"TenantTypeId"] intValue];
                    friends.userId=[[dict[i] objectForKey:@"UserId"] intValue];
                    friends.AuditStatus=[[dict[i] objectForKey:@"UserId"] intValue];
                    switch (friends.applicationid) {
                        case 1001://微博
                            if (![[dict[i] objectForKey:@"dynNew"] isKindOfClass:[NSNull class]]) {
                                friends.Author=[[dict[i] objectForKey:@"dynNew"] objectForKey:@"Author"];
                                friends.Body=[[dict[i] objectForKey:@"dynNew"] objectForKey:@"Body"];
                            }
                            break;
                        case 1002://日志
                            if (![[dict[i] objectForKey:@"dynNew"] isKindOfClass:[NSNull class]]) {
                                friends.Author=[[dict[i] objectForKey:@"dynNew"] objectForKey:@"Author"];
                                friends.Body=[[dict[i] objectForKey:@"dynNew"] objectForKey:@"Body"];
                                friends.Subject=[[dict[i] objectForKey:@"dynNew"] objectForKey:@"Subject"];
                                friends.ThreadId=[[dict[i] objectForKey:@"dynNew"] objectForKey:@"ThreadId"];
                            }
                            break;
                        case 1003://相册
                            friends.dynNew=[dict[i] objectForKey:@"dynNew"];
                            break;
                    }
                    //评论
                    NSArray* comarray=[dict[i] objectForKey:@"myCommentsList"];
                    if ([comarray count]>0) {
                        NSMutableArray* Comments=[[NSMutableArray alloc]init];
                        for (int j=0; j<[comarray count]; j++) {
                            DynamicComments* dc=[[DynamicComments alloc]  init];
                            if (![[comarray[j] objectForKey:@"AtTrueName"] isKindOfClass:[NSNull class]]) {
                                dc.AtNickName=[comarray[j] objectForKey:@"AtTrueName"];
                            }else{
                                dc.AtNickName=@"";
                            }
                            dc.AtUserId=[[comarray[j] objectForKey:@"AtUserId"] intValue];
                            dc.UserId = [[comarray[j] objectForKey:@"UserId"] intValue];
                            dc.Author=[comarray[j] objectForKey:@"Author"];
                            dc.Body=[comarray[j] objectForKey:@"Body"];
                            dc.DateCreatedStr=[comarray[j] objectForKey:@"DateCreatedStr"];
                            dc.Id=[[comarray[j] objectForKey:@"Id"] intValue];
                            dc.OwnerId=[[comarray[j] objectForKey:@"OwnerId"] intValue];
                            dc.ParentId=[[comarray[j] objectForKey:@"ParentId"] intValue];
                            dc.Subject=[comarray[j] objectForKey:@"Subject"];
                            dc.TenantTypeId=[[comarray[j] objectForKey:@"TenantTypeId"] intValue];
                            [Comments addObject:dc];
                        }
                        friends.Comments=Comments;
                    }
                    [array addObject:friends];
                }
                if (successBlock) {
                    successBlock(array);
                }
            }else{
                if (failedBlock) {
                    failedBlock(@"错误的请求");
                }
            }
        }else if(result==-99){
            if (failedBlock) {
                failedBlock(@"暂无数据");
            }
        }else{
            if (failedBlock) {
                failedBlock(@"错误的请求");
            }
        }
        
    } failed:^(NSString *message) {
        if (failedBlock) {
            failedBlock(message);
        }
    }];
    
}

#pragma mark - 个人资料
#pragma mark -
- (void)personalDataWithDetailToken:(NSString *)token
                             UserId:(NSString *)UserId
                            success:(void(^)(NdividualData *ndividual))successBlock
                             failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://home.%@/api/GetUserById?toKen=%@&UserId=%@",
                            aedudomain, token, UserId];
    
    [self handerGetRequest:requestUrl parameters:nil body:nil success:^(NSDictionary *data) {
        NSInteger statusCode = [[data objectForKey:@"st"] intValue];
        if (statusCode == 0) {
            NSDictionary *dict = [[data objectForKey:@"msg"] objectForKey:@"list"];
            NdividualData *ndividual = [[NdividualData alloc] init];
            ndividual.NickName = [dict objectForKey:@"NickName"];
            ndividual.TrueName = [dict objectForKey:@"TrueName"];
            ndividual.SchoolName = [dict objectForKey:@"School"];
            if ([ndividual.SchoolName isKindOfClass:[NSNull class]]) {
                ndividual.SchoolName = nil;
            }
            ndividual.NowAreaName = [dict objectForKey:@"NowAreaName"];
            ndividual.NowAreaCode = [dict objectForKey:@"NowAreaCode"];
            ndividual.PicInfo = [dict objectForKey:@"PictureUrl"];
            if ([ndividual.PicInfo isKindOfClass:[NSNull class]]) {
                ndividual.PicInfo = nil;
            }
            ndividual.AccountMobile = [dict objectForKey:@"AccountMobile"];
            if ([ndividual.AccountMobile isKindOfClass:[NSNull class]]) {
                ndividual.AccountMobile = nil;
            }
            ndividual.UserAccount = [dict objectForKey:@"UserAccount"];
            if ([ndividual.UserAccount isKindOfClass:[NSNull class]]) {
                ndividual.UserAccount = nil;
            }
            ndividual.isFriend = [[dict objectForKey:@"IsFollowed"] boolValue];
            ndividual.UserId = [NSString stringWithFormat:@"%@",[dict objectForKey:@"UserId"]];
            ndividual.parentName = [dict objectForKey:@"ParentName"];
            
            if ([ndividual.parentName isKindOfClass:[NSNull class]]) {
                ndividual.parentName = nil;
            }
            ndividual.LatestNews = [dict objectForKey:@"LatestNews"];
            if ([ndividual.LatestNews isKindOfClass:[NSNull class]]) {
                ndividual.LatestNews = nil;
            }
            
            if (successBlock) {
                successBlock(ndividual);
            }
        }else{
            if (failedBlock) {
                failedBlock([NSString stringWithFormat:@"status error:%d", statusCode]);
            }
        }
        
    } failed:^(NSString *message) {
        if (failedBlock) {
            failedBlock(message);
        }
    }];
    
}

#pragma mark -- 本人资料

- (void)myselfDetails:(NSString *)ToKen
               UserId:(NSString *)UserId
              success:(void(^)(MyselfDetails *myselfDict))successBlock
               failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://home.%@/Api/GetUserById?Token=%@&UserId=%@", aedudomain, ToKen,UserId];
    NSString * encodedString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)requestUrl, NULL, NULL,  kCFStringEncodingUTF8 );
    [self handerGetRequest:encodedString
                parameters:nil
                      body:nil
                   success:^(NSDictionary *data) {
                       NSInteger statusCode = [[data objectForKey:@"st"] intValue];
                       if (statusCode == 0) {
                           NSDictionary *dict = [data objectForKey:@"msg"];
                           if (dict) {
                               NSDictionary *listDict = [dict objectForKey:@"list"];
                               if (listDict) {
                                   
                                   MyselfDetails *MD = [[MyselfDetails alloc] init];
                                   MD.NickName = [listDict objectForKey:@"NickName"];
                                   MD.NowAreaCode = [listDict objectForKey:@"NowAreaCode"];
                                   MD.Introduction = [listDict objectForKey:@"Introduction"];
                                   MD.TrueName = [listDict objectForKey:@"TrueName"];
                                   MD.Sex = [[listDict objectForKey:@"Sex"] intValue];
                                   MD.Rank = [[listDict objectForKey:@"Rank"] intValue];
                                   //                                   MD.Birthday = [listDict objectForKey:@"Birthday"];
                                   NSString *dateStr = [listDict objectForKey:@"Birthday"];
                                   // 分割、替换时间：
                                   NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
                                   [formatter setDateFormat:@"yyyy/MM/dd hh:mm:ss"];
                                   NSDate * date = [formatter dateFromString:dateStr];
                                   NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian] ;
                                   NSDateComponents *comps = [[NSDateComponents alloc] init] ;
                                   NSInteger unitFlags = NSCalendarUnitYear |
                                   NSCalendarUnitMonth |
                                   NSCalendarUnitDay |
                                   NSCalendarUnitWeekday |
                                   NSCalendarUnitHour |
                                   NSCalendarUnitMinute |
                                   NSCalendarUnitSecond;
                                   comps = [calendar components:unitFlags fromDate:date];
                                   int year=[comps year];
                                   int month = [comps month];
                                   int day = [comps day];
                                   NSString * result = [NSString stringWithFormat:@"%d年%d月%d日",year,month,day];
                                   MD.Birthday = result;
                                   
                                   MD.AccountEmail = [listDict objectForKey:@"AccountEmail"];
                                   MD.AccountMobile = [listDict objectForKey:@"AccountMobile"];
                                   MD.QQ = [listDict objectForKey:@"QQ"];
                                   
                                   if (successBlock) {
                                       successBlock(MD);
                                   }
                                   
                               } else{
                                   if (failedBlock) {
                                       failedBlock(@"暂无数据");
                                   }
                               }
                               
                               
                           } else{
                               if (failedBlock) {
                                   failedBlock(@"暂无数据");
                               }
                           }
                           
                       } else {
                           if (failedBlock) {
                               failedBlock(@"暂无数据");
                               
                           }
                       }
                       
                   } failed:^(NSString *message) {
                       failedBlock(@"暂无数据");
                   }];
}

#pragma mark -- 搜索
- (void)seacher:(NSString *)UserId
        KeyWord:(NSString *)KeyWord
         TypeId:(int)TypeId
       PageSize:(int)PageSize
      PageIndex:(int)PageIndex
        success:(void(^)(NSMutableArray* data))successBlock
         failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://home.%@/Api/GetSearchList?userId=%@&KeyWord=%@&TypeId=%d&PageSize=%d&PageIndex=%d", aedudomain, UserId,KeyWord,TypeId,PageSize,PageIndex];
    NSString * encodedString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)requestUrl, NULL, NULL,  kCFStringEncodingUTF8 );
    
    [self handerGetRequest:encodedString
                parameters:nil
                      body:nil
                   success:^(NSDictionary *data) {
                       NSInteger statusCode = [[data objectForKey:@"st"] intValue];
                       if (statusCode == 0) {
                           NSMutableArray *dataArray = [[data objectForKey:@"msg"] objectForKey:@"AllInfo"][0];
                           NSMutableArray *datailArray = [[NSMutableArray alloc] init];
                           if (dataArray && [dataArray count] > 0) {
                               for (int i = 0; i < [dataArray count]; i ++) {
                                   SeacherObject *SO = [[SeacherObject alloc] init];
                                   SO.Body = [dataArray[i] objectForKey:@"Body"];
                                   SO.Description = [dataArray[i] objectForKey:@"Description"];
                                   SO.DateTime = [dataArray[i] objectForKey:@"DateTime"];
                                   SO.UserName = [dataArray[i] objectForKey:@"UserName"];
                                   SO.PictureUrl = [dataArray[i] objectForKey:@"PictureUrl"];
                                   SO.UserId = [NSString stringWithFormat:@"%@",[dataArray[i] objectForKey:@"UserId"]];
                                   SO.RelativePath = [dataArray[i] objectForKey:@"RelativePath"];
                                   SO.TypeId = [[dataArray[i] objectForKey:@"TypeId"] intValue];
                                   SO.Schools = [dataArray[i] objectForKey:@"Schools"];
                                   SO.Sex = [[dataArray[i] objectForKey:@"Sex"] intValue];
                                   SO.IsFollows = [[dataArray[i] objectForKey:@"IsFollowed"] boolValue];
                                   SO.Relevance = [dataArray[i] objectForKey:@"Relevance"];
                                   SO.Roles = [dataArray[i] objectForKey:@"Roles"];
                                   
                                   [datailArray addObject:SO];
                               }
                               
                               if (successBlock) {
                                   successBlock(datailArray);
                               }
                           } else {
                               if (failedBlock) {
                                   failedBlock(@"没有更多相关内容");
                               }
                           }
                           
                           
                       } else if (statusCode == -1){
                           if (failedBlock) {
                               failedBlock(@"关键词不能为空");
                           }
                       } else {
                           if (failedBlock) {
                               failedBlock(@"暂无数据");
                           }
                       }
                       
                   } failed:^(NSString *message) {
                       failedBlock(@"暂无数据");
                   }];
    
}

#pragma mark -- 获取地区编号
- (void)getZoneSerialNumbersuccess:(void(^)(NSMutableArray *friendDynamic))successBlock
                            failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://home.%@/api/GetArea", aedudomain];
    NSString * encodedString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)requestUrl, NULL, NULL,  kCFStringEncodingUTF8 );
    [self handerGetRequest:encodedString
                parameters:nil
                      body:nil
                   success:^(NSDictionary *data) {
                       NSInteger statusCode = [[data objectForKey:@"st"] intValue];
                       if (statusCode == 0) {
                           NSDictionary *dict = [data objectForKey:@"msg"];
                           if (dict) {
                               NSMutableArray *listArray = [dict objectForKey:@"list"];
                               if (listArray && [listArray count] > 0) {
                                   if (successBlock) {
                                       successBlock(listArray);
                                   }
                                   
                                   
                               } else{
                                   if (failedBlock) {
                                       failedBlock(@"获取不到数据");
                                   }
                               }
                               
                               
                           } else{
                               if (failedBlock) {
                                   failedBlock(@"获取不到数据");
                               }
                           }
                           
                           
                       } else {
                           if (failedBlock) {
                               failedBlock(@"获取不到数据");
                           }
                       }
                       
                       
                   } failed:^(NSString *message) {
                       failedBlock(@"获取不到数据");
                   }];
}

#pragma mark -- 修改个人头像

- (void)modificationHeaderIMG:(NSString *)UserId
                         File:(NSString *)File
                      success:(void(^)(NSMutableArray *friendDynamic))successBlock
                       failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://home.%@/api/PostUserPhoto?UserId=%@&File=%@", aedudomain, UserId,File];
    NSString * encodedString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)requestUrl, NULL, NULL,  kCFStringEncodingUTF8 );
    [self handerPostRequest:encodedString
                 parameters:nil
                       body:nil
                    success:^(NSDictionary *data) {
                        
                        
                    } failed:^(NSString *message) {
                        
                        
                    }];
    
}

#pragma mark -- 修改个人资料接口之修改资料

- (void)modificationMyselfDetails:(NSString *)UserId
                 modificationType:(NSString *)modificationType
                          success:(void(^)(NSDictionary *friendDynamic))successBlock
                           failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://home.%@/api/PostUserProfile?UserId=%@&%@", aedudomain, UserId,modificationType];
    NSString * encodedString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)requestUrl, NULL, NULL,  kCFStringEncodingUTF8 );
    [self handerPostRequest:encodedString
                 parameters:nil
                       body:nil
                    success:^(NSDictionary *data) {
                        NSInteger statusCode = [[data objectForKey:@"st"] intValue];
                        if (statusCode == 0) {
                            if (successBlock) {
                                successBlock(data);
                            }
                            
                        } else{
                            if (failedBlock) {
                                failedBlock(@"更改资料失败");
                            }
                        }
                        
                        
                    } failed:^(NSString *message) {
                        failedBlock(@"更改资料失败");
                    }];
    
}

#pragma mark -- 修改密码
- (void)changeThePassWord:(NSString *)userId
                   oldPwd:(NSString *)oldPwd
                   newPwd:(NSString *)newPwd
                  success:(void(^)(NSString *data))successBlock
                   failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://home.%@/api/PostChangePassword?userId=%@&oldPwd=%@&newPwd=%@", aedudomain, userId,oldPwd,newPwd];
    NSString * encodedString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)requestUrl, NULL, NULL,  kCFStringEncodingUTF8 );
    [self handerPostRequest:encodedString
                 parameters:nil
                       body:nil
                    success:^(NSDictionary *data) {
                        NSInteger statusCode = [[data objectForKey:@"st"] intValue];
                        
                        if (statusCode == 0) {
                            if (successBlock) {
                                successBlock(@"修改密码成功！");
                            }
                        } else if (statusCode == 1){
                            if (failedBlock) {
                                failedBlock(@"原密码错误,请正确输入！");
                            }
                        }
                        
                    } failed:^(NSString *message) {
                        if (failedBlock) {
                            failedBlock(@"修改密码失败！");
                        }
                        
                    }];
    
}

#pragma mark -- 获取个人最新动态
- (void)getMyselfActivityDetails:(NSString *)UserId
                          typeId:(int)typeId
                       pageindex:(int)pageindex
                        pagesize:(int)pagesize
                         success:(void(^)(NSMutableArray *myselfDict))successBlock
                          failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://home.%@/Api/GetMyActivity?UserId=%@&typeId=%d&pageindex=%d&pagesize=%d", aedudomain, UserId,typeId,pageindex,pagesize];
    NSString * encodedString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)requestUrl, NULL, NULL,  kCFStringEncodingUTF8 );
    [self handerGetRequest:encodedString
                parameters:nil
                      body:nil
                   success:^(NSDictionary *data) {
                       NSInteger statusCode = [[data objectForKey:@"st"] intValue];
                       if (statusCode == 0) {
                           NSDictionary *dict = [data objectForKey:@"msg"];
                           if (dict) {
                               
                               NSMutableArray *listArray = [dict objectForKey:@"list"];
                               if (listArray && [listArray count] > 0) {
                                   NSMutableArray *myselfArray = [[NSMutableArray alloc] init];
                                   for (int i = 0; i <[listArray count]; i ++) {
                                       
                                       NewActivity *newActivity = [[NewActivity alloc] init];
                                       
                                       newActivity.TypeId = [[listArray[i] objectForKey:@"TypeId"] intValue];
                                       newActivity.Body = [listArray[i] objectForKey:@"Body"];
                                       newActivity.Title = [listArray[i] objectForKey:@"Title"];
                                       newActivity.ImagesUrlArray = [listArray [i] objectForKey:@"ImagesUrl"];
                                       [myselfArray addObject:newActivity];
                                   }
                                   if (successBlock) {
                                       successBlock(myselfArray);
                                   }
                                   
                               } else{
                                   if (failedBlock) {
                                       failedBlock(@"暂无数据");
                                   }
                               }
                               
                           } else {
                               if (failedBlock) {
                                   failedBlock(@"暂无数据");
                               }
                           }
                           
                           
                       } else {
                           if (failedBlock) {
                               failedBlock(@"暂无数据");
                           }
                       }
                       
                   } failed:^(NSString *message) {
                       failedBlock(@"暂无数据");
                   }];
    
}

#pragma mark - 联系人列表 = 新人人通好友列表
#pragma mark -


- (void)AddressBookDetail:(NSString *)uid token:(NSString *)token
                PageIndex:(int)PageIndex
                  success:(void(^)(NSMutableArray *data))successBlock
                   failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://home.%@/Api/GetFollows?UserId=%@&toKen=%@&PageIndex=%d",aedudomain, uid,token,PageIndex];
    
    [self handerGetRequest:requestUrl parameters:nil body:nil success:^(NSDictionary *data) {
        NSInteger statusCode = [[data objectForKey:@"st"] intValue];
        if (statusCode == 0) {
            int count=[[[data objectForKey:@"msg"] objectForKey:@"count"] intValue];
            if (count>0) {
                NSArray* hyarray = [[data objectForKey:@"msg"] objectForKey:@"list"];
                if (hyarray) {
                    NSMutableArray* arrayrs=[[NSMutableArray alloc] init];
                    for (NSDictionary *gf in hyarray) {
                        GoodFriend* goodfriend=[[GoodFriend alloc] init];
                        [goodfriend setFollowsCount:[gf objectForKey:@"FollowsCount"]];
                        [goodfriend setIntroduction:[gf objectForKey:@"Introduction"]];
                        [goodfriend setIsFollowed:[gf objectForKey:@"IsFollowed"]];
                        [goodfriend setIsOnline:[gf objectForKey:@"IsOnline"]];
                        [goodfriend setPictureUrl:[gf objectForKey:@"PictureUrl"]];
                        [goodfriend setRoles:[gf objectForKey:@"Roles"]];
                        [goodfriend setSchools:[gf objectForKey:@"Schools"]];
                        [goodfriend setSex:[gf objectForKey:@"Sex"]];
                        [goodfriend setUserId:[gf objectForKey:@"UserId"]];
                        [goodfriend setUserName:[gf objectForKey:@"UserName"]];
                        [goodfriend setTrueName:[gf objectForKey:@"TrueName"]];
                        [arrayrs addObject:goodfriend];
                    }
                    if (successBlock) {
                        successBlock(arrayrs);
                    }
                }else{
                    failedBlock(@"你还没有好友的哦");
                }
            }else{
                failedBlock(@"你还没有好友的哦");
            }
        } else {
            if (failedBlock) {
                NSString *str = [data objectForKey:@"msg"];
                failedBlock(str);
            }
        }
    } failed:^(NSString *message) {
        if (failedBlock) {
            failedBlock(message);
        }
    }];
    
}
#pragma mark - 微博列表
#pragma mark -

- (void)weiboList:(NSString *)UserId
        PageIndex:(int)PageIndex
          success:(void(^)(NSArray *micList))successBlock
           failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://home.%@/api/GetMicroblogByUserId?UserId=%@&PageIndex=%d",aedudomain,UserId,PageIndex];
    NSString * encodingString = [requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self handerGetRequest:encodingString parameters:nil body:nil success:^(NSDictionary *data) {
        NSInteger statusCode = [[data objectForKey:@"st"] intValue];
        if (statusCode == 0) {
            NSArray *array = [[data objectForKey:@"msg"] objectForKey:@"list"];
            if ([array count] > 0) {
                NSMutableArray *weiboArray = [NSMutableArray arrayWithCapacity:[array count]];
                for (int i = 0; i < [array count] ; i ++) {
                    NSDictionary *dict = array[i];
                    WeiboList *WL = [[WeiboList alloc] init];
                    WL.MicroblogId = [[dict objectForKey:@"MicroblogId"] intValue];
                    WL.CommentCount = [[dict objectForKey:@"CommentCount"] intValue];
                    WL.FavoriteCount = [[dict objectForKey:@"FavoriteCount"] intValue];
                    WL.body = [dict objectForKey:@"Body"];
                    WL.UserName = [dict objectForKey:@"UserName"];
                    WL.DateTime = [dict objectForKey:@"DateTime"];
                    if ([dict objectForKey:@"ImagesUrl"]) {
                        WL.ImagesUrl = [dict objectForKey:@"ImagesUrl"]; //图片数组
                    }else{
                        WL.ImagesUrl = nil;
                    }
                    [weiboArray addObject:WL];
                }
                if (successBlock) {
                    successBlock(weiboArray);
                }
            }
        }else{
            if (failedBlock) {
                failedBlock([NSString stringWithFormat:@"没有更多相关微博信息了哦！"]);
            }
        }
        
    }failed:^(NSString *message) {
        if (failedBlock) {
            failedBlock(@"刷新失败...");
        }
    }];
}

#pragma mark - 群组列表
#pragma mark -

- (void)getUserGroup:(NSString *)UserId
           userRoles:(int)role
             success:(void(^)(NSArray *groupData))successBlock
              failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://home.%@/api/GetUserGroup?userId=%@&userRole=%d",aedudomain,UserId,role];
    NSString * encodingString = [requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self handerGetRequest:encodingString parameters:nil body:nil success:^(NSDictionary *data) {
        NSInteger statusCode = [[data objectForKey:@"st"] intValue];
        if (statusCode == 0) {
            NSArray *array = [data objectForKey:@"msg"];
            if ([array count] > 0) {
                if (successBlock) {
                    successBlock(array);
                }
            }
        }else{
            if (failedBlock) {
                failedBlock([NSString stringWithFormat:@""]);
            }
        }
        
    }failed:^(NSString *message) {
        if (failedBlock) {
            failedBlock(@"");
        }
    }];
}
#pragma mark - 群组成员列表
#pragma mark -
- (void)getGroupUser:(NSString *)groupId
             success:(void(^)(NSArray *groupData))successBlock
              failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://home.%@/api/GetGroupUser?groupId=%@",aedudomain,groupId];
    NSString * encodingString = [requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self handerGetRequest:encodingString parameters:nil body:nil success:^(NSDictionary *data) {
        NSInteger statusCode = [[data objectForKey:@"st"] intValue];
        if (statusCode == 0) {
            NSArray *array = [data objectForKey:@"msg"];
            if ([array count] > 0) {
                if (successBlock) {
                    successBlock(array);
                }
            }
        }else{
            if (failedBlock) {
                failedBlock([NSString stringWithFormat:@""]);
            }
        }
        
    }failed:^(NSString *message) {
        if (failedBlock) {
            failedBlock(@"");
        }
    }];
}


#pragma mark - 相册列表
#pragma mark -

- (void)photoList:(NSString *)ToKen
           UserId:(NSString *)UserId
         PageSize:(int)PageSize
        PageIndex:(int)PageIndex
          success:(void(^)(NSArray *photoListArray))successBlock
           failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://home.%@/Api/GetAlbumList?ToKen=%@&UserId=%@&PageSize=%d&PageIndex=%d",aedudomain,ToKen,UserId,PageSize,PageIndex];
    NSString * encodingString = [requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self handerGetRequest:encodingString parameters:nil body:nil success:^(NSDictionary *data) {
        NSInteger statusCode = [[data objectForKey:@"st"] intValue];
        if (statusCode == 0) {
            NSArray *array = [[data objectForKey:@"msg"] objectForKey:@"list"];
            if ([array count] > 0) {
                NSMutableArray *photoArray = [NSMutableArray arrayWithCapacity:[array count]];
                for (int i = 0; i < [array count]; i ++) {
                    NSDictionary *dict = array[i];
                    PhotoList * PL = [[PhotoList alloc] init];
                    PL.AlbumId = [[dict objectForKey:@"AlbumId"] intValue];
                    PL.AlbumName = [dict objectForKey:@"AlbumName"];
                    
                    PL.CoverPatch = [dict objectForKey:@"CoverPatch"];
                    PL.CoverPatch = [NSString stringWithFormat:@"%@%@",appPhotoImage,PL.CoverPatch];
                    PL.DateTime = [dict objectForKey:@"DateTime"];
                    PL.Description = [dict objectForKey:@"Description"];
                    PL.PhotoCount = [[dict objectForKey: @"PhotoCount"] intValue];
                    [photoArray addObject:PL];
                }
                if (successBlock) {
                    successBlock(photoArray);
                }
            }
        }else{
            if (failedBlock) {
                failedBlock([NSString stringWithFormat:@"没有更多的相册信息了哦！"]);
            }
        }
        //解析错误的时候
    } failed:^(NSString *message) {
        if (failedBlock) {
            failedBlock(message);
        }
    }];
}

#pragma mark - 删除图片
#pragma mark -
- (void)deletePhotos:(NSString *)token
             photoId:(NSArray *)photoIds
             success:(void(^)(NSDictionary *dict))successBlock
              failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSMutableString *photoIdStr = [NSMutableString string];
    for (int i = 0; i < [photoIds count]; i++) {
        [photoIdStr appendString:[photoIds objectAtIndex:i]];
        if (i != [photoIds count] - 1) {
            [photoIdStr appendString:@","];
        }
    }
    
    NSString *requestUrl = [NSString stringWithFormat:@"http://home.%@/api/PostDeletePhoto?ToKen=%@&PhotoIdStr=%@",aedudomain,token,photoIdStr];
    NSString * encodingString = [requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [self handerPostRequest:encodingString parameters:nil body:nil success:^(NSDictionary *data) {
        if (successBlock) {
            successBlock(data);
        }
    } failed:^(NSString *message) {
        if (failedBlock) {
            failedBlock(message);
        }
    }];
}

#pragma mark - 图片列表
#pragma mark -
- (void)pictureList:(NSString *)ToKen
             UserId:(NSString *)UserId
            AlbumId:(NSString *)AlbumId
           PageSize:(int)PageSize
          PageIndex:(int)PageIndex
            success:(void(^)(NSArray *photoListArray))successBlock
             failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://home.%@/Api/GetPhotoList?ToKen=%@&UserId=%@&AlbumId=%@&PageSize=%d&PageIndex=%d",aedudomain,ToKen,UserId,AlbumId,PageSize,PageIndex];
    NSString * encodingString = [requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self handerGetRequest:encodingString parameters:nil body:nil success:^(NSDictionary *data) {
        NSInteger statusCode = [[data objectForKey:@"st"] intValue];
        if (statusCode == 0) {
            NSArray *array = [[data objectForKey:@"msg"] objectForKey:@"list"];
            if ([array count] > 0) {
                NSMutableArray *photoArray = [NSMutableArray arrayWithCapacity:[array count]];
                for (int i = 0; i < [array count]; i ++) {
                    NSDictionary *dict = array[i];
                    Photo *photo = [[Photo alloc] init];
                    photo.url = (NSString*)[dict objectForKey:@"RelativePath"];
                    NSNumber *number = (NSNumber*)[dict objectForKey:@"PhotoId"];
                    photo.photoId = [NSString stringWithFormat:@"%d", [number intValue]];
                    number = (NSNumber*)[dict objectForKey:@"AlbumId"];
                    photo.albumId = [NSString stringWithFormat:@"%d", [number intValue]];
                    [photoArray addObject:photo];
                }
                if (successBlock) {
                    successBlock(photoArray);
                }
            }
        }else{
            if (failedBlock) {
                failedBlock([NSString stringWithFormat:@"没有相关相册信息！"]);
            }
        }
    } failed:^(NSString *message) {
        if (failedBlock) {
            failedBlock(message);
        }
    }];
    
}

#pragma mark - 新建相册
#pragma mark -

- (void)buildAblum:(NSString *)UserId
        AlbumsName:(NSString *)AlbumsName
       Description:(NSString *)Description
           Privacy:(NSString *)Privacy
           success:(void(^)(NSDictionary *photoListArray))successBlock
            failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://home.%@/Api/PostCreateAlbums?UserId=%@&AlbumsName=%@",aedudomain,UserId,AlbumsName];
    if (Description) {
        requestUrl = [NSString stringWithFormat:@"%@&Description=%@", requestUrl, Description];
    }
    if (Privacy) {
        requestUrl = [NSString stringWithFormat:@"%@&Privacy=%@", requestUrl, Privacy];
    }
    
    NSString * encodingString = [requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [self handerPostRequest:encodingString parameters:nil body:nil success:^(NSDictionary *data) {
        if (successBlock) {
            successBlock(data);
        }
    } failed:^(NSString *message) {
        if (failedBlock) {
            failedBlock(message);
        }
    }];
}

#pragma mark - 最近相册
#pragma mark -

- (void)recentlyAblum:(NSString *)Token
            pageIndex:(int)pageIndex
             pageSize:(int)pageSize
             TopCount:(int)TopCount
              success:(void(^)(NSArray *photoListArray))successBlock
               failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://interface.%@/sjrrt/myLastestPhotosAndAttachPic?Token=%@&pageIndex=%d&pageSize=%d&TopCount=%d",aedudomain,Token,pageIndex,pageSize,TopCount];
    NSString * encodingString = [requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self handerGetRequest:encodingString parameters:nil body:nil success:^(NSDictionary *data) {
        NSInteger statusCode = [[data objectForKey:@"result"] intValue];
        if (statusCode == 1) {
            NSArray *array = [data objectForKey:@"msg"];
            if (![array isKindOfClass:[NSNull class]]) {
                if ([array isKindOfClass:[NSArray class]]) {
                    NSMutableArray *photoArray = [NSMutableArray arrayWithCapacity:[array count]];
                    for (int i = 0; i < [array count]; i ++) {
                        NSDictionary *dict = array[i];
                        RecentlyPhotos *RP = [[RecentlyPhotos alloc] init];
                        RP.TenantTypeId = [[dict objectForKey:@"TenantTypeId"] intValue];
                        NSMutableArray *photosArray = [dict objectForKey:@"Photos"];
                        switch (RP.TenantTypeId) {
                            case 100101:
                            {
                                if (photosArray != nil && ![photosArray isKindOfClass:[NSNull class]] && photosArray.count != 0) {
                                    NSMutableArray *weiboArray = [[NSMutableArray alloc] init];
                                    for (int j = 0; j < [photosArray count]; j ++) {
                                        NSMutableDictionary *weibopPhotosDict = photosArray[j];
                                        [weiboArray addObject:[weibopPhotosDict objectForKey:@"FileName"]];
                                    }
                                    RP.ImageArray = weiboArray;
                                }
                            }
                                break;
                            case 100201:
                            {
                                
                                //日志暂时不能传相片，不做操作
                                
                            }
                                break;
                            case 100302:
                            {
                                if (photosArray && [photosArray count] > 0) {
                                    NSMutableArray *albumArray = [[NSMutableArray alloc] init];
                                    for (int k = 0; k < [photosArray count]; k ++) {
                                        NSMutableDictionary *albumDict = photosArray[k];
                                        [albumArray addObject:[albumDict objectForKey:@"RelativePath"]];
                                    }
                                    RP.ImageArray = albumArray;
                                }
                            }
                                break;
                            default:
                                break;
                        }
                        RP.mydate = [dict objectForKey:@"DateCreatedStr"];
                        if (![[dict objectForKey:@"dynNew"] isKindOfClass:[NSNull class]]) {
                            RP.todaydes= [dict objectForKey:@"dynNew"];
                        }
                        [photoArray addObject:RP];
                    }
                    if (successBlock) {
                        successBlock(photoArray);
                    }
                } else if ([array isKindOfClass:[NSString class]]){
                    NSLog(@"是字符串");
                    if (successBlock) {
                        successBlock([NSArray array]);
                    }
                }
            }else{
                RecentlyPhotos *RP = [[RecentlyPhotos alloc] init];
                NSMutableArray *photoArray = [NSMutableArray arrayWithCapacity:[array count]];
                [photoArray addObject:RP];
            }
        } else  {
            if (failedBlock) {
                failedBlock([NSString stringWithFormat:@"没有更多的相片信息了哦！"]);
            }
        }
    } failed:^(NSString *message) {
        if (failedBlock) {
            failedBlock(message);
        }
    }];
    
    
}

#pragma mark - 我的动态
#pragma mark -

- (void)myDynamic:(NSString *)UserId
           typeId:(int)typeId
        PageIndex:(int)PageIndex
         PageSize:(int)PageSize
          success:(void(^)(NSMutableArray *MyDynamic))successBlock
           failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://interface.%@/sjrrt/GetMyPersonTimeLine?UserId=%@&typeId=%d&PageIndex=%d&PageSize=%d",aedudomain,UserId,typeId,PageIndex,PageSize];
    NSString * encodingString = [requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self handerGetRequest:encodingString parameters:nil body:nil success:^(NSDictionary *data) {
        NSInteger statusCode = [[data objectForKey:@"st"] intValue];
        if (statusCode == 0) {
            NSArray *array = [data objectForKey:@"msg"];
            NSMutableArray *myDynamicArray = [NSMutableArray arrayWithCapacity:[array count]];
            if (array && [array count] > 0) {
                for (int i = 0; i < [array count]; i ++) {
                    MyDynamic *Md = [[MyDynamic alloc] init];
                    Md.albumNumber = [[data objectForKey:@"Album"] intValue];
                    Md.blogThreadNumber = [[data objectForKey:@"BlogThread"] intValue];
                    Md.microBlogNumber = [[data objectForKey:@"MicroBlog"] intValue];
                    Md.ActivityId = [[array[i] objectForKey:@"ActivityId"] intValue];
                    Md.activityItemKey = [array[i] valueForKey:@"ActivityItemKey"];
                    Md.applicationid = [[array[i] valueForKey:@"ApplicationId"] intValue];
                    Md.DateCreatedStr=[array[i] valueForKey:@"DateCreatedStr"];
                    Md.hasImage=[[array[i] objectForKey:@"HasImage"] boolValue];
                    Md.hasMusic=[[array[i] objectForKey:@"HasMusic"] boolValue];
                    Md.hasVideo=[[array[i] objectForKey:@"HasVideo"] boolValue];
                    Md.isOriginalThread=[[array[i] objectForKey:@"IsOriginalThread"] boolValue];
                    Md.isPrivate=[[array[i] objectForKey:@"IsPrivate"] boolValue];
                    Md.OwnerName=[array[i] objectForKey:@"OwnerName"];
                    Md.OwnerId = [[array[i] objectForKey:@"OwnerId"] intValue];
                    Md.OwnerType=[[array[i] objectForKey:@"OwnerType"] intValue];
                    //赞
                    if (![[array[i] objectForKey:@"Parase"] isKindOfClass:[NSNull class]]) {
                        Md.Detail=[[array[i] objectForKey:@"Parase"] objectForKey:@"Detail"];
                        Md.Total=[[[array[i] objectForKey:@"Parase"] objectForKey:@"Total"] intValue];
                    }else{
                        Md.Detail=@"";
                        Md.Total=0;
                    }
                    //相片
                    if (![[array[i] objectForKey:@"Photos"] isKindOfClass:[NSNull class]]) {
                        Md.Photos= [array[i] objectForKey:@"Photos"];
                        
                    }else{
                        Md.Photos = nil;
                        
                    }
                    Md.referenceId = [[array [i] objectForKey:@"ReferenceId"] intValue];
                    Md.sourceId=[[array[i] objectForKey:@"SourceId"] intValue];
                    Md.tenantTypeid=[[array[i] objectForKey:@"TenantTypeId"] intValue];
                    Md.userId=[[array[i] objectForKey:@"UserId"] intValue];
                    
                    switch (Md.applicationid) {
                        case 1001:
                            if (![[array[i] objectForKey:@"dynNew"] isKindOfClass:[NSNull class]]) {
                                Md.Author=[[array[i] objectForKey:@"dynNew"] objectForKey:@"Author"];
                                Md.Body=[[array[i] objectForKey:@"dynNew"] objectForKey:@"Body"];
                            }
                            break;
                            
                        case 1002:
                            if (![[array[i] objectForKey:@"dynNew"] isKindOfClass:[NSNull class]]) {
                                Md.Author=[[array[i] objectForKey:@"dynNew"] objectForKey:@"Author"];
                                Md.Body=[[array[i] objectForKey:@"dynNew"] objectForKey:@"Body"];
                                Md.Subject=[[array[i] objectForKey:@"dynNew"] objectForKey:@"Subject"];
                                Md.ThreadId=[[array[i] objectForKey:@"dynNew"] objectForKey:@"ThreadId"];
                            }
                            break;
                            
                        case 1003:
                            Md.dynNew=[array[i] objectForKey:@"dynNew"];
                            
                            break;
                            
                        default:
                            break;
                    }
                    //评论
                    NSArray* comarray=[array[i] objectForKey:@"myCommentsList"];
                    if ([comarray count] > 0) {
                        NSMutableArray* Comments=[[NSMutableArray alloc]init];
                        for (int j = 0; j < [comarray count]; j ++) {
                            DynamicComments* dc=[[DynamicComments alloc]  init];
                            if (![[comarray[j] objectForKey:@"AtTrueName"] isKindOfClass:[NSNull class]]) {
                                dc.AtNickName=[comarray[j] objectForKey:@"AtTrueName"];
                            }else{
                                dc.AtNickName=@"";
                            }
                            dc.AtUserId=[[comarray[j] objectForKey:@"AtUserId"] intValue];
                            dc.Author=[comarray[j] objectForKey:@"Author"];
                            dc.Body=[comarray[j] objectForKey:@"Body"];
                            dc.DateCreatedStr=[comarray[j] objectForKey:@"DateCreatedStr"];
                            dc.Id=[[comarray[j] objectForKey:@"Id"] intValue];
                            dc.OwnerId=[[comarray[j] objectForKey:@"OwnerId"] intValue];
                            dc.UserId = [[comarray[j] objectForKey:@"UserId"] intValue];
                            dc.ParentId=[[comarray[j] objectForKey:@"ParentId"] intValue];
                            dc.Subject=[comarray[j] objectForKey:@"Subject"];
                            dc.TenantTypeId=[[comarray[j] objectForKey:@"TenantTypeId"] intValue];
                            [Comments addObject:dc];
                        }
                        Md.Comments = Comments;
                    }
                    [myDynamicArray addObject:Md];
                }
                if (successBlock) {
                    successBlock(myDynamicArray);
                }
            }else{
                if (failedBlock) {
                    failedBlock(@"没有更多的动态了哦！");
                }
            }
        }
    } failed:^(NSString *message) {
        if (failedBlock) {
            failedBlock(message);
        }
    }];
}

#pragma mark -- 我的班级列表
#pragma mark --

- (void)myClassLists:(NSString *)userId
            UserRole:(NSString *)UserRole
             success:(void(^)(NSMutableArray *data))successBlock
              failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://nmapi.%@/class/GetClassList?UserId=%@&UserRole=%@",aedudomain, userId,UserRole];
    NSString * encodingString = [requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self handerGetRequest:encodingString
                parameters:nil
                      body:nil
                   success:^(NSDictionary *data) {
                       NSInteger statusCode = [[data objectForKey:@"result"] intValue];
                       if (statusCode == 1) {
                           NSArray *array = [data objectForKey:@"items"];
                           NSMutableArray *myDynamicArray = [NSMutableArray arrayWithCapacity:[array count]];
                           if (array && [array count] > 0) {
                               for (int i = 0; i < [array count]; i ++) {
                                   MyClassLists *Md = [[MyClassLists alloc] init];
                                   Md.ClassId = [array[i] objectForKey:@"ClassId"];
                                   Md.ClassName = [array[i] objectForKey:@"ClassName"];
                                   Md.ClassFace = [array[i] objectForKey:@"ClassFace"];
                                   Md.SchoolId = [array[i] objectForKey:@"SchoolId"];
                                   Md.Slogan = [array[i] objectForKey:@"Slogan"];
                                   
                                   [myDynamicArray addObject:Md];
                               }
                               if (successBlock) {
                                   successBlock(myDynamicArray);
                               }
                           } else{
                               if (failedBlock) {
                                   failedBlock(@"没有加入任何班级");
                               }
                           }
                           
                       } else{
                           if (failedBlock) {
                               failedBlock(@"没有加入任何班级");
                           }
                       }
                   } failed:^(NSString *message) {
                       if (failedBlock) {
                           failedBlock(message);
                       }
                   }];
}

#pragma mark -- 班级公告
#pragma mark --

- (void)myClassBulletin:(NSString *)classId
               pagesize:(int)pagesize
              pageindex:(int)pageindex
                success:(void(^)(NSMutableArray *data))successBlock
                 failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://nmapi.%@/class/GetNoticeList?classId=%@&pagesize=%d&pageindex=%d",aedudomain, classId,pagesize,pageindex];
    NSString * encodingString = [requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self handerGetRequest:encodingString
                parameters:nil
                      body:nil
                   success:^(NSDictionary *data) {
                       NSInteger statusCode = [[data objectForKey:@"result"] intValue];
                       if (statusCode == 1) {
                           NSArray *array = [data objectForKey:@"items"];
                           NSMutableArray *myDynamicArray = [NSMutableArray arrayWithCapacity:[array count]];
                           if (array && [array count] > 0) {
                               for (int i = 0; i < [array count]; i ++) {
                                   MyClassListsBulletin *Mb = [[MyClassListsBulletin alloc] init];
                                   Mb.ArchiveTitle = [array[i] objectForKey:@"ArchiveTitle"];
                                   Mb.ArchiveText = [array[i] objectForKey:@"ArchiveText"];
                                   Mb.HitCount = [array[i] objectForKey:@"HitCount"];
                                   Mb.PubTime = [array[i] objectForKey:@"PubTime"];
                                   Mb.ArchiveId = [array[i] objectForKey:@"ArchiveId"];
                                   [myDynamicArray addObject:Mb];
                               }
                               if (successBlock) {
                                   successBlock(myDynamicArray);
                               }
                           } else{
                               if (failedBlock) {
                                   failedBlock(@"暂无班级公告");
                               }
                           }
                       } else{
                           if (failedBlock) {
                               failedBlock(@"暂无班级公告");
                           }
                       }
                       
                   } failed:^(NSString *message) {
                       if (failedBlock) {
                           failedBlock(@"暂无班级公告");
                       }
                   }];
    
}

#pragma mark -- 删除公告、文章
#pragma mark --

- (void)deleteBulletinOrArticle:(NSArray *)archiveId
                        success:(void(^)(NSString *data))successBlock
                         failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSMutableString *archiveIdStr = [NSMutableString string];
    for (int i = 0; i < [archiveId count]; i++) {
        [archiveIdStr appendString:[archiveId objectAtIndex:i]];
        if (i != [archiveId count] - 1) {
            [archiveIdStr appendString:@","];
        }
    }
    NSString *requestUrl = [NSString stringWithFormat:@"http://nmapi.%@/class/DeleteArchive?archiveId=%@",aedudomain, archiveIdStr];
    NSString * encodingString = [requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self handerPostRequest:encodingString
                 parameters:nil
                       body:nil
                    success:^(NSDictionary *data) {
                        NSInteger statusCode = [[data objectForKey:@"result"] intValue];
                        if (statusCode == 1) {
                            if (successBlock) {
                                successBlock([data objectForKey:@"msg"]);
                            }
                        } else{
                            if (failedBlock) {
                                failedBlock(@"删除失败！");
                            }
                        }
                    } failed:^(NSString *message) {
                        if (failedBlock) {
                            failedBlock(@"删除失败！");
                        }
                    }];
}

#pragma mark -- 公告详情
#pragma mark --

- (void)theBulletinsDetails:(NSString *)archiveId
                  archiveId:(NSString *)userid
                    success:(void(^)(NSMutableArray *data))successBlock
                     failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://nmapi.%@/class/GetArchiveDetailS?archiveId=%@&userid=%@",aedudomain, archiveId,userid];
    NSString * encodingString = [requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self handerGetRequest:encodingString
                parameters:nil
                      body:nil
                   success:^(NSDictionary *data) {
                       
                   } failed:^(NSString *message) {
                       
                   }];
}

#pragma mark -- 班级文章分类
#pragma mark --

- (void)classArticleCategory:(NSString *)classId
                    pagesize:(int)pagesize
                   pageindex:(int)pageindex
                     success:(void(^)(NSMutableArray *data))successBlock
                      failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://nmapi.%@/class/GetArchiveCategoryList?classId=%@&pagesize=%d&pageindex=%d",aedudomain, classId,pagesize,pageindex];
    NSString * encodingString = [requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self handerGetRequest:encodingString
                parameters:nil
                      body:nil
                   success:^(NSDictionary *data) {
                       NSInteger statusCode = [[data objectForKey:@"result"] intValue];
                       if (statusCode == 1) {
                           NSArray *array = [data objectForKey:@"items"];
                           NSMutableArray *myDynamicArray = [NSMutableArray arrayWithCapacity:[array count]];
                           if (array && [array count] > 0) {
                               for (int i = 0; i < [array count]; i ++) {
                                   ReleaseClassArticleList *RCL = [[ReleaseClassArticleList alloc] init];
                                   RCL.CategoryId = [array[i] objectForKey:@"CategoryId"];
                                   RCL.CategoryName = [array[i] objectForKey:@"CategoryName"];
                                   [myDynamicArray addObject:RCL];
                               }
                               if (successBlock) {
                                   successBlock(myDynamicArray);
                               }
                           }
                       } else{
                           if (failedBlock) {
                               failedBlock(@"");
                           }
                       }
                       
                   } failed:^(NSString *message) {
                       if (failedBlock) {
                           failedBlock(message);
                       }
                   }];
    
}

#pragma mark -- 发布文章
#pragma mark --

- (void)releaseArticle:(NSString *)ClassId
                UserId:(NSString *)UserId
            CategoryId:(NSString *)CategoryId
          ArchiveTitle:(NSString *)ArchiveTitle
           ArchiveText:(NSString *)ArchiveText
               success:(void(^)(NSString *data))successBlock
                failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://nmapi.%@/Class/PostPublishArchive",aedudomain];
    NSDictionary *parametersDict = [[NSDictionary alloc] initWithObjectsAndKeys:ClassId,@"ClassId",UserId,@"UserId",CategoryId,@"CategoryId",ArchiveTitle,@"ArchiveTitle",ArchiveText,@"ArchiveText", nil];
    [HttpUtil PostWithUrl:requestUrl parameters:parametersDict success:^(id json) {
        RecentlyArticle *recentlyArticle = [[RecentlyArticle alloc] initWithString:json error:nil];
        if (recentlyArticle.result.intValue == 1) {
            if (successBlock) {
                successBlock(recentlyArticle.msg);
            }else{
                failedBlock(recentlyArticle.msg);
            }
        }
    } fail:^(id errors) {
        failedBlock(errors);
    } cache:^(id cache) {
        
    }];
    
}

#pragma mark - 微博详情
#pragma mark -
- (void)weiboDetail:(NSString *)MicroblogId
            success:(void(^)(NSArray *micArray))successBlock
             failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://interface.%@/sjrrt/GetMicroBlogById?MicroblogId=%@",aedudomain, MicroblogId];
    
    [self handerGetRequest:requestUrl parameters:nil body:nil success:^(NSDictionary *data) {
        NSInteger statusCode = [[data objectForKey:@"st"] intValue];
        if (statusCode == 1) {
            //内容和赞
            NSMutableDictionary *dct = [data objectForKey:@"MicroBlog"];
            NSMutableDictionary *dict = [data objectForKey:@"ParaseAct"];
            if (dct || dict) {
                NSMutableArray *micDetailArray = [[NSMutableArray alloc] init];
                MicroblogDetail *micDetail = [[MicroblogDetail alloc] init];
                micDetail.Body = [dct objectForKey:@"Body"];
                micDetail.Author = [dct objectForKey:@"Author"];
                micDetail.DateCreatedStr = [dct objectForKey:@"DateCreatedStr"];
                micDetail.MicroblogId = [dct objectForKey:@"MicroblogId"];
                micDetail.DateCreated = [dct objectForKey:@"DateCreated"];
                //赞
                micDetail.Detail = [dict objectForKey:@"Detail"];
                micDetail.Total = [[dict objectForKey:@"Total"] intValue];
                [micDetailArray addObject:micDetail];
                //评论。。。
                NSMutableArray *array = [data objectForKey:@"Comments"];
                if (![array isKindOfClass:[NSNull class]]) {
                    if (array && [array count] > 0) {
                        NSMutableArray* Comments=[[NSMutableArray alloc]init];
                        for (int i = 0; i < [array count]; i ++) {
                            BlogComments *blogComments = [[BlogComments alloc] init];
                            blogComments.Body = [array[i] objectForKey:@"Body"];
                            blogComments.DateCreatedStr = [array[i] objectForKey:@"DateCreatedStr"];
                            blogComments.UserId = [[array[i] objectForKey:@"UserId"] intValue];
                            blogComments.AtUserId = [[array[i] objectForKey:@"AtUserId"] intValue];
                            if (![[array[i] objectForKey:@"AtNickName"] isKindOfClass:[NSNull class]]) {
                                blogComments.AtNickName=[array[i] objectForKey:@"AtNickName"];
                            }else{
                                blogComments.AtNickName=@"";
                            }
                            blogComments.Author=[array[i] objectForKey:@"Author"];
                            blogComments.OwnerId=[[array[i] objectForKey:@"OwnerId"] intValue];
                            blogComments.ParentId=[[array[i] objectForKey:@"ParentId"] intValue];
                            blogComments.Id=[[array[i] objectForKey:@"Id"] intValue];
                            blogComments.TenantTypeId=[[array[i] objectForKey:@"TenantTypeId"] intValue];
                            
                            [Comments addObject:blogComments];
                        }
                        micDetail.Comments = Comments;
                    }
                }else{
                    NSMutableArray* Comments=[[NSMutableArray alloc]init];
                    micDetail.Comments = Comments;
                }
                //获取图片
                NSMutableArray *Attahements = [data objectForKey:@"Attahements"];
                if (![Attahements isKindOfClass:[NSNull class]]) {
                    NSMutableArray* imageArray=[[NSMutableArray alloc]init];
                    if (Attahements && [Attahements count] > 0) {
                        for (int j = 0; j < [Attahements count]; j ++) {
                            NSDictionary *attDict = Attahements[j];
                            [imageArray addObject:[attDict objectForKey:@"FileName"]];
                        }
                        micDetail.imageArray = imageArray;
                    }
                    
                    [micDetailArray addObject:micDetail];
                    
                }else{
                    
                    NSMutableArray* imageArray=[[NSMutableArray alloc]init];
                    micDetail.imageArray = imageArray;
                }
                if (successBlock) {
                    successBlock(micDetailArray);
                }
            }
        }else{
            if (failedBlock) {
                failedBlock([NSString stringWithFormat:@"获取不到微博详情哦！"]);
            }
        }
        
    } failed:^(NSString *message) {
        if (failedBlock) {
            failedBlock(message);
        }
    }];
    
    
}

#pragma mark - 日志列表
#pragma mark -

- (void)blogListDetail:(NSString *)Token
                UsedId:(NSString *)UserId
             PageIndex:(int)PageIndex
              PageSize:(int)PageSize
               success:(void(^)(NSArray *blog))successBlock
                failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://home.%@/api/GetBlogThreadByUserId?Token=%@&UserId=%@&PageIndex=%d&PageSize=%d",aedudomain, Token,UserId,PageIndex,PageSize];
    NSString * encodingString = [requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self handerGetRequest:encodingString parameters:nil body:nil success:^(NSDictionary *data) {
        NSInteger statusCode = [[data objectForKey:@"st"] intValue];
        if (statusCode == 0) {
            NSArray *array = [[data objectForKey:@"msg"] objectForKey:@"list"];
            if ([array count] > 0) {
                NSMutableArray *blogArray = [NSMutableArray arrayWithCapacity:[array count]];
                for (int i = 0; i < array.count; i ++) {
                    NSDictionary *dict = array[i];
                    BlogList *blog = [[BlogList alloc] init];
                    blog.title = [dict objectForKey:@"Title"];
                    NSLog(@"%@",blog.title);
                    blog.hitCount = [dict objectForKey:@"HitCount"];
                    blog.blogThreadId = [dict valueForKey:@"BlogThreadId"];
                    blog.dateTime = [dict objectForKey:@"DateTime"];
                    blog.pictureUrl = [dict valueForKey:@"PictureUrl"];
                    blog.body = [dict objectForKey:@"Body"];
                    blog.commentCount = [dict objectForKey:@"CommentCount"];
                    [blogArray addObject:blog];
                }
                if (successBlock) {
                    successBlock(blogArray);
                }
            }
        }else{
            if (failedBlock) {
                failedBlock([NSString stringWithFormat:@"没有相关日志信息了哦！"]);
            }
            
        }
    } failed:^(NSString *message) {
        if (failedBlock) {
            failedBlock(message);
        }
    }];
}

#pragma mark - 日志详情
#pragma mark -
- (void)blogDetail:(NSString *)ThreadId
           success:(void(^)(NSArray *blogDetailArray))successBlock
            failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://interface.%@/sjrrt/GetBlogThreadsById?ThreadId=%@",aedudomain, ThreadId];
    NSString * encodingString = [requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self handerGetRequest:encodingString parameters:nil body:nil success:^(NSDictionary *data) {
        NSInteger statusCode = [[data objectForKey:@"st"] intValue];
        if (statusCode == 1) {
            //内容和赞
            NSMutableDictionary *dct = [data objectForKey:@"BlogThread"];
            NSMutableDictionary *dict = [data objectForKey:@"ParaseAct"];
            if (dct || dict) {
                NSMutableArray *BlogDetailArray = [[NSMutableArray alloc] init];
                JournalDetail *journal = [[JournalDetail alloc] init];
                journal.Author = [dct objectForKey:@"Author"];
                journal.Subject = [dct objectForKey:@"Subject"];
                journal.Body = [dct objectForKey:@"Body"];
                journal.DateCreated = [dct objectForKey:@"DateCreatedStr"];
                journal.ThreadId = [dct objectForKey:@"ThreadId"];
                //头像
                journal.OwnerId = [NSString stringWithFormat:@"%@%@%@",appHeadImage,[dct objectForKey:@"OwnerId"],@".jpg"];
                //赞。。。
                journal.Detail = [dict objectForKey:@"Detail"];
                journal.Total = [[dict objectForKey:@"Total"] intValue];
                [BlogDetailArray addObject:journal];
                //评论。。。
                NSMutableArray *array = [data objectForKey:@"Comments"];
                if (![array isKindOfClass:[NSNull class]]) {
                    if (array && [array count] > 0) {
                        NSMutableArray* Comments=[[NSMutableArray alloc]init];
                        for (int k=0; k < [array count]; k ++) {
                            BlogComments *blogComments = [[BlogComments alloc] init];
                            blogComments.Body = [array[k] objectForKey:@"Body"];
                            blogComments.DateCreatedStr = [array[k] objectForKey:@"DateCreatedStr"];
                            blogComments.AtUserId = [[array[k] objectForKey:@"AtUserId"] intValue];
                            if (![[array[k] objectForKey:@"AtTrueName"] isKindOfClass:[NSNull class]]) {
                                blogComments.AtNickName=[array[k] objectForKey:@"AtTrueName"];
                            }else{
                                blogComments.AtNickName=@"";
                            }
                            blogComments.Author=[array[k] objectForKey:@"Author"];
                            blogComments.OwnerId=[[array[k] objectForKey:@"OwnerId"] intValue];
                            blogComments.ParentId=[[array[k] objectForKey:@"ParentId"] intValue];
                            blogComments.Id=[[array[k] objectForKey:@"Id"] intValue];
                            blogComments.TenantTypeId=[[array[k] objectForKey:@"TenantTypeId"] intValue];
                            blogComments.CommentedObjectId = [[array[k] objectForKey:@"CommentedObjectId"] intValue];
                            
                            [Comments addObject:blogComments];
                        }
                        journal.Comments = Comments;
                    }
                    [BlogDetailArray addObject:journal];
                    
                }else{
                    NSMutableArray* Comments=[[NSMutableArray alloc]init];
                    journal.Comments = Comments;
                }
                if (successBlock) {
                    successBlock(BlogDetailArray);
                }
            }
        }else if(statusCode==-2){
            if (failedBlock) {
                failedBlock((NSString*)[data objectForKey:@"msg"]);
            }
        }
    } failed:^(NSString *message) {
        if (failedBlock) {
            failedBlock(message);
        }
    }];
    //        JournalDetail *journal = [[JournalDetail alloc] init];
    
}

#pragma mark - 新朋友
#pragma mark -
- (void)newFriends:(NSString *)uid
           success:(void(^)(NSArray *newFriend))successBlock
            failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://home.%@/Api/GetInvitation?UserId=%@",aedudomain, uid];
    [self handerGetRequest:requestUrl parameters:nil body:nil success:^(NSDictionary *data) {
        NSInteger statusCode = [[data objectForKey:@"st"] intValue];
        if (statusCode == 0) {
            NSArray *array = [[data valueForKey:@"msg"] objectForKey:@"list"];
            NSMutableArray *friendsArray = [NSMutableArray arrayWithCapacity:[array count]];
            
            for (int i = 0; i < array.count; i++) {
                NSDictionary *dict = array[i];
                NewFriends *friend = [[NewFriends alloc] init];
                friend.InvitationId = [dict valueForKey:@"InvitationId"];
                friend.dateTime = [dict valueForKey:@"DateTime"];
                friend.userId = [dict valueForKey:@"UserId"];
                friend.userName = [dict valueForKey:@"UserName"];
                friend.SenderPictureUrl = [dict valueForKey:@"SenderPictureUrl"];
                friend.body = [dict valueForKey:@"Body"];
                if ([friend.body isKindOfClass:[NSNull class]]) {
                    friend.body = @"";
                }
                friend.IsFollows = [dict valueForKey:@"IsFollows"];
                friend.SenderUserName = [dict valueForKey:@"SenderUserName"];
                friend.SenderUserId = [NSString stringWithFormat:@"%@",[dict valueForKey:@"SenderUserId"]];
                friend.Type = [NSString stringWithFormat:@"%@",[dict valueForKey:@"TypeId"]];
                friend.Id = [dict valueForKey:@"SenderUserId"];
                
                [friendsArray addObject:friend];
            }
            if (successBlock) {
                successBlock(friendsArray);
            }
            
        }else{
            if (failedBlock) {
                failedBlock([NSString stringWithFormat:@"没有最新朋友"]);
            }
        }
        
    } failed:^(NSString *message) {
        if (failedBlock) {
            failedBlock(message);
        }
    }];
    
    
}
#pragma mark - 接受好友添加请求
#pragma mark -
- (void)acceptNewFriend:(NSString *)InvitationId
                success:(void(^)(NSDictionary *data))successBlock
                 failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://home.%@/Api/PostAcceptInvitation?InvitationId=%@",aedudomain, InvitationId];
    NSString * encodingString = [requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self handerPostRequest:encodingString parameters:nil body:nil success:^(NSDictionary *datum) {
        if (successBlock) {
            successBlock(datum);
        }
    } failed:^(NSString *message) {
        if (failedBlock) {
            failedBlock(message);
        }
    }];
    
    
}

#pragma mark - 接受家长绑定请求
#pragma mark -

- (void)acceptNewFamily:(NSString *)Token
                   Type:(NSString *)Type
         ChildrenUserId:(NSString *)ChildrenUserId
                success:(void(^)(NSDictionary *data))successBlock
                 failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://interface.%@/sjrrt/AcceptBinding?Token=%@&Type=%@&ChildrenUserId=%@",aedudomain, Token,Type,ChildrenUserId];
    NSString * encodingString = [requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self handerPostRequest:encodingString parameters:nil body:nil success:^(NSDictionary *datum) {
        if (successBlock) {
            successBlock(datum);
        }
    } failed:^(NSString *message) {
        if (failedBlock) {
            failedBlock(message);
        }
    }];
}

#pragma mark - 添加朋友搜索
#pragma mark -

- (void)addFriendsOfSearch:(NSString *)Token
            ParUserAccount:(NSString *)ParUserAccount
                   success:(void(^)(NSArray *data))successBlock
                    failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://interface.%@/sjrrt/GetUserInfoBySJ_Search?Token=%@&UserOrEmailName=%@",aedudomain,Token,ParUserAccount];
    NSString * encodingString = [requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [self handerGetRequest:encodingString parameters:nil body:nil success:^(NSDictionary *datum) {
        NSInteger statusCode = [[datum objectForKey:@"st"] intValue];
        if (statusCode == 0) {
            NSArray *array = [datum objectForKey:@"msg"];
            NSMutableArray *friendsArray = [NSMutableArray arrayWithCapacity:[array count]];
            SendFriendDetail *detail = [[SendFriendDetail alloc] init];
            detail.TrueName = [array[0] objectForKey:@"TrueName"];
            detail.NowAreaName = [array[0] objectForKey:@"NowAreaName"];
            detail.SchoolName = [array[0] objectForKey:@"SchoolName"];
            if ([detail.SchoolName isKindOfClass:[NSNull class]]) {
                detail.SchoolName = nil;
            }
            detail.PicInfo = [NSString stringWithFormat:@"%@%@%@",appHeadImage,[array[0] objectForKey:@"UserId"],@".jpg"];
            if ([detail.PicInfo isKindOfClass:[NSNull class]]) {
                detail.PicInfo = nil;
            }
            detail.UserId = [NSString stringWithFormat:@"%@",[array[0] objectForKey:@"UserId"]];
            detail.isFriend = [[array[0] objectForKey:@"isFriend"] boolValue];
            detail.UserAccount = [array[0] objectForKey:@"UserAccount"];
            
            if ([detail.UserAccount isKindOfClass:[NSNull class]]) {
                detail.UserAccount = nil;
            }
            
            [friendsArray addObject:detail];
            if (successBlock) {
                successBlock(friendsArray);
            }
            
        }else{
            if (failedBlock) {
                failedBlock([NSString stringWithFormat:@"Json parsing wrong"]);
            }
            
        }
        
    } failed:^(NSString *message) {
        if (failedBlock) {
            failedBlock(message);
        }
    }];
}


#pragma mark - 绑定家长搜索
#pragma mark -

- (void)bindFamilySearch:(NSString *)Token
          ParUserAccount:(NSString *)ParUserAccount
                 success:(void(^)(NSArray *data))successBlock
                  failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://interface.%@/sjrrt/BindParent_Search?Token=%@&ParUserAccount=%@",aedudomain,Token,ParUserAccount];
    NSString * encodingString = [requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [self handerGetRequest:encodingString parameters:nil body:nil success:^(NSDictionary *data) {
        NSInteger statusCode = [[data objectForKey:@"st"] intValue];
        if (statusCode == 0) {
            NSArray *array = [data objectForKey:@"msg"];
            NSMutableArray *ParentArray = [[NSMutableArray alloc] init];
            SendParentsDetail *parent = [[SendParentsDetail alloc] init];
            parent.TrueName = [array[0] objectForKey:@"TrueName"];
            parent.NowAreaName = [array[0] objectForKey:@"NowAreaName"];
            parent.ParentAccount = [array[0] objectForKey:@"ParentAccount"];
            if ([parent.ParentAccount isKindOfClass:[NSNull class]]) {
                parent.ParentAccount = nil;
            }
            parent.CanBinding = [[array[0] objectForKey:@"CanBinding"] boolValue];
            parent.SchoolName = [array[0] objectForKey:@"SchoolName"];
            
            [ParentArray addObject:parent];
            if (successBlock) {
                successBlock(ParentArray);
            }
        }else{
            if (failedBlock) {
                failedBlock([NSString stringWithFormat:@"Json parsing wrong"]);
            }
            
        }
        
    } failed:^(NSString *message) {
        if (failedBlock) {
            failedBlock(message);
        }
    }];
}

#pragma mark -- 发现搜索中添加好友

- (void)addStrangers:(NSString *)Token
              UserId:(NSString *)UserId
        SenderUserId:(NSString *)SenderUserId
              Sender:(NSString *)Sender
           InviteTxt:(NSString *)InviteTxt
             success:(void(^)(NSString* data))successBlock
              failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://interface.%@/sjrrt/addfriendapply?Token=%@&UserId=%@&SenderUserId=%@&Sender=%@&InviteTxt=%@",aedudomain, Token,UserId,SenderUserId,Sender,InviteTxt];
    NSString * encodingString = [requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self handerPostRequest:encodingString
                 parameters:nil
                       body:nil
                    success:^(NSDictionary *datum) {
                        NSInteger statusCode = [[datum objectForKey:@"result"] intValue];
                        if (statusCode == 0) {
                            if (successBlock) {
                                successBlock(@"发送请求成功！");
                            }
                        } else if(statusCode == -7) {
                            if (failedBlock) {
                                failedBlock(@"你已经发送了好友邀请，请等待对方验证！");
                            }
                        }
                        
                    } failed:^(NSString *message) {
                        
                        failedBlock(@"添加失败");
                        
                    }];
}

#pragma mark - 绑定家长发送
#pragma mark -

- (void)FamilySendValidation:(NSString *)Token
              ParUserAccount:(NSString *)ParUserAccount
                    ValidTxt:(NSString *)ValidTxt
                     success:(void(^)(NSDictionary* data))successBlock
                      failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://interface.%@/sjrrt/BindParent_Apply?Token=%@&ParUserAccount=%@&ValidTxt=%@",aedudomain,Token,ParUserAccount,ValidTxt];
    NSString * encodingString = [requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self handerPostRequest:encodingString parameters:nil body:nil success:^(NSDictionary *data) {
        NSInteger statusCode = [[data objectForKey:@"st"] intValue];
        if (statusCode == 0) {
            if (successBlock) {
                successBlock(data);
            }
        }else{
            if (failedBlock) {
                failedBlock([NSString stringWithFormat:@"Json parsing wrong"]);
            }
            
        }
        
    } failed:^(NSString *message) {
        if (failedBlock) {
            failedBlock(message);
        }
    }];
    
}

/* 新版人人通请求 */
#pragma mark -- 获取用户信息
- (void)getUIData:(NSString *)Token
          success:(void(^)(NSMutableArray* data))successBlock
           failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://home.%@/api/GetUserByToKen?Token=%@",aedudomain, Token];
    NSString * encodingString = [requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self handerGetRequest:encodingString parameters:nil body:nil success:^(NSDictionary *data) {
        NSInteger statusCode = [[data objectForKey:@"st"] intValue];
        if (statusCode == 0) {
            
            NSMutableArray *UIArray = [[NSMutableArray alloc] init];
            NSDictionary *tempDict = [data objectForKey:@"msg"];
            if (tempDict) {
                [UIArray addObject:tempDict];
            } else{
                if (failedBlock) {
                    failedBlock(@"获取不到用户数据");
                }
            }
            if (successBlock) {
                successBlock(UIArray);
            }
        }else{
            if (failedBlock) {
                failedBlock(@"获取不到用户数据");
            }
            
        }
    } failed:^(NSString *message) {
        if (failedBlock) {
            failedBlock(message);
        }
    }];
    
}

#pragma mark -- 判断首页广告每日登录

- (void)isTodayAppears:(NSString *)Token
               success:(void(^)(NSString *data))successBlock
                failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://www.%@/gift/home/freenum?Token=%@",aedudomain,Token];
    NSString * encodingString = [requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [self handerGetRequest:encodingString
                parameters:nil
                      body:nil
                   success:^(NSDictionary *data) {
                       NSInteger statusCode = [[data objectForKey:@"st"] intValue];
                       NSString *isToday = [NSString stringWithFormat:@"%@",[data objectForKey:@"num"]];
                       if (statusCode == 1) {
                           if (isToday) {
                               if (successBlock) {
                                   successBlock(isToday);
                               }
                           } else{
                               if (failedBlock) {
                                   failedBlock(@"");
                               }
                           }
                           
                           
                       } else if (statusCode == 0){
                           if (isToday) {
                               if (successBlock) {
                                   successBlock(isToday);
                               }
                           } else{
                               if (failedBlock) {
                                   failedBlock(@"");
                               }
                           }
                           
                       } else{
                           if (failedBlock) {
                               failedBlock(@"");
                           }
                       }
                       
                   } failed:^(NSString *message) {
                       
                   }];
}


#pragma mark -- 设置学校通知为已读状态

- (void)settingSchoolNoticeState:(NSString *)Token
                          userId:(NSString *)userId
                         success:(void(^)(NSString *data))successBlock
                          failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://nmapi.%@/Push/PostSmsRead?Token=%@&userId=%@",aedudomain,Token,userId];
    NSString * encodingString = [requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self handerPostRequest:encodingString
                 parameters:nil
                       body:nil
                    success:^(NSDictionary *data) {
                        
                        
                    } failed:^(NSString *message) {
                        
                    }];
    
}

#pragma mark -- 获取排名

- (void)getTheStudentPlace:(NSString *)UserId
                  userrole:(NSString *)userrole
                   success:(void(^)(NSMutableArray* data))successBlock
                    failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://home.%@/api/GetExamRank?userId=%@&userRole=%@",aedudomain,UserId,userrole];
    NSString * encodingString = [requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self handerGetRequest:encodingString parameters:nil body:nil success:^(NSDictionary *data) {
        NSInteger statusCode = [[data objectForKey:@"st"] intValue];
        if (statusCode == 0) {
            NSDictionary *dict = [data objectForKey:@"msg"];
            NSArray *array = [dict objectForKey:@"ExamSubject"];
            NSMutableArray *myDynamicArray = [NSMutableArray arrayWithCapacity:[array count]];
            // 在班级的排名
            StudentRank *studentRank = [[StudentRank alloc] init];
            studentRank.ExamName = [dict objectForKey:@"ExamName"];
            studentRank.SubjectCount = [[dict objectForKey:@"SubjectCount"] intValue];
            studentRank.theStudentCount = [[dict objectForKey:@"StudentCount"] intValue];
            studentRank.ClassRank = [[dict objectForKey:@"ClassRank"] intValue];
            if (array && [array count] > 0) {
                NSMutableArray* Comments=[[NSMutableArray alloc]init];
                for (int i = 0; i < [array count] ; i ++) {
                    StudentExam *studentExam = [[StudentExam alloc] init];
                    studentExam.SubjectName = [array[i] objectForKey:@"SubjectName"];
                    studentExam.ClassRank = [[array[i] objectForKey:@"ClassRank"] intValue];
                    [Comments addObject:studentExam];
                }
                studentRank.ExamSubject = Comments;
                [myDynamicArray addObject:studentRank];
                
                if (successBlock) {
                    successBlock(myDynamicArray);
                }
                
            } else{
                if (failedBlock) {
                    failedBlock(@"获取不到数据！");
                }
                
            }
        } else{
            if (failedBlock) {
                failedBlock(@"获取不到数据！");
            }
            
        }
        
    } failed:^(NSString *message) {
        if (failedBlock) {
            failedBlock(message);
        }
        
    }];
    
}

#pragma mark -- 获取开通服务情况
- (void)getClearServiceDetails:(NSString *)UserId
                      userrole:(NSString *)userrole
                       success:(void(^)(NSMutableArray* data))successBlock
                        failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://home.%@/api/GetUserService?userId=%@&userRole=%@",aedudomain,UserId,userrole];
    NSString * encodingString = [requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self handerGetRequest:encodingString parameters:nil body:nil success:^(NSDictionary *data) {
        NSInteger statusCode = [[data objectForKey:@"st"] intValue];
        NSMutableArray *UIArray = [[NSMutableArray alloc] init];
        if (statusCode == 0) {// 开通服务
            NSNumber *datailsState = [NSNumber numberWithInt:statusCode];
            [UIArray addObject:datailsState];
            if (successBlock) {
                successBlock(UIArray);
            }
        } else if(statusCode == 1 || statusCode == -1){// 服务为开通或者服务到期
            NSNumber *datailsState = [NSNumber numberWithInt:statusCode];
            [UIArray addObject:datailsState];
            if (successBlock) {
                successBlock(UIArray);
            }
        } else if (statusCode == 2){// 显示抢红包广告
            NSNumber *datailsState = [NSNumber numberWithInt:statusCode];
            [UIArray addObject:datailsState];
            if (successBlock) {
                successBlock(UIArray);
            }
        } else{
            if (failedBlock) {
                failedBlock(@"");
            }
        }
        
    } failed:^(NSString *message) {
        if (failedBlock) {
            failedBlock(message);
        }
        
    }];
    
}

#pragma mark -- 获取短信消息记录

- (void)getMessageRecords:(NSString *)UserId
                 userrole:(NSString *)userrole
              messageType:(int)messageType
                 pageSize:(int)pageSize
                pageIndex:(int)pageIndex
                  success:(void(^)(NSMutableArray* data))successBlock
                   failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://home.%@/api/GetSMSMessage?userId=%@&userRole=%@&messageType=%d&pageSize=%d&pageIndex=%d",aedudomain,UserId,userrole,messageType,pageSize,pageIndex];
    NSString * encodingString = [requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self handerGetRequest:encodingString parameters:nil body:nil success:^(NSDictionary *data) {
        NSInteger statusCode = [[data objectForKey:@"st"] intValue];
        
        if (statusCode == 0) {
            NSMutableArray *UIArray = [[NSMutableArray alloc] init];
            NSDictionary *tmpDict = [data objectForKey:@"msg"];
            if (tmpDict && [tmpDict count] > 0) {
                NSArray *tmpArray = [tmpDict objectForKey:@"list"];
                if (tmpArray && [tmpArray count] > 0) {
                    for (int i = 0; i < [tmpArray count]; i ++) {
                        TheNotice *theNotice = [[TheNotice alloc] init];
                        theNotice.CreateBy = [tmpArray[i] objectForKey:@"CreateBy"];
                        theNotice.MsgContent = [tmpArray[i] objectForKey:@"MsgContent"];
                        NSString *tmpStr = [ [tmpArray[i] objectForKey:@"CreateTime"]substringToIndex:10];
                        theNotice.CatchTime = tmpStr;
                        [UIArray addObject:theNotice];
                    }
                    if (successBlock) {
                        successBlock(UIArray);
                    }
                    
                } else{
                    if (failedBlock) {
                        failedBlock(@"获取不到相关数据");
                    }
                }
                
            } else{
                if (failedBlock) {
                    failedBlock(@"没有更多通知了！");
                }
            }
            
        } else{
            
            if (failedBlock) {
                failedBlock(@"获取不到数据");
            }
        }
    } failed:^(NSString *message) {
        if (failedBlock) {
            failedBlock(message);
        }
    }];
    
}

#pragma mark -- 通过手机号码获取验证码

- (void)getDynamicPassword:(NSString *)phone
              sendMsgValue:(int)sendMsgValue
                   success:(void(^)(NSString *data))successBlock
                    failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://member.%@/validatecode/fetch?phone=%@&sendMsgValue=%d",aedudomain,phone,sendMsgValue];
    NSString * encodingString = [requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self handerGetRequest:encodingString parameters:nil body:nil success:^(NSDictionary *data) {
        NSInteger statusCode = [[data objectForKey:@"result"] intValue];
        // 接口可以不可以统一一下状态值 艹/账号不存在的时候返回的状态不同艹
        if (statusCode == 1) {
            NSString *dynamicPassword = [data objectForKey:@"code"];
            if (dynamicPassword) {
                if (successBlock) {
                    successBlock(dynamicPassword);
                }
            }
        } else if (statusCode == 0){
            if (failedBlock) {
                failedBlock([data objectForKey:@"message"]);
            }
            
        }
    } failed:^(NSString *message) {
        if (failedBlock) {
            failedBlock(message);
        }
        
    }];
    
}

#pragma mark -- 获取广告图片

- (void)getAdvertisement:(int)advertType
                   toKen:(NSString *)toKen
                 success:(void(^)(NSArray* data))successBlock
                  failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://dsjtj.%@/Api/GetAdvert?advertType=%d&toKen=%@",aedudomain,advertType,toKen];
    NSString * encodingString = [requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self handerGetRequest:encodingString parameters:nil body:nil success:^(NSDictionary *data) {
        BOOL statusCode = [[data objectForKey:@"Status"] boolValue];
        if (statusCode == 1) {
            NSMutableArray *array = [data objectForKey:@"Data"];
            if (array && [array count] > 0) {
                for (int i = 0; i < [array count]; i ++) {
                    if (successBlock) {
                        successBlock(array);
                    }
                }
                
            } else{
                if (failedBlock) {
                    failedBlock(@"");
                }
                
            }
            
        } else{
            if (failedBlock) {
                failedBlock(@"");
            }
            
        }
        
    } failed:^(NSString *message) {
        if (failedBlock) {
            failedBlock(message);
        }
        
    }];
}

#pragma mark -- 登陆的广告

- (void)theGetAdvertisementsuccess:(void(^)(NSString* data))successBlock
                            failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://dsjtj.%@/Api/GetLoginAdvert",aedudomain];
    NSString * encodingString = [requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self handerGetRequest:encodingString parameters:nil body:nil success:^(NSDictionary *data) {
        BOOL statusCode = [[data objectForKey:@"Status"] boolValue];
        if (statusCode == 1) {
            NSMutableArray *array = [data objectForKey:@"Data"];
            if (array && [array count] > 0) {
                for (int i = 0; i < [array count]; i ++) {
                    NSString *imageURL = [array[i] objectForKey:@"ImageURL"];
                    if (successBlock) {
                        successBlock(imageURL);
                    }
                }
                
            } else{
                if (failedBlock) {
                    failedBlock(@"获取广告失败");
                }
                
            }
            
        } else{
            if (failedBlock) {
                failedBlock(@"获取广告失败");
            }
            
        }
        
    } failed:^(NSString *message) {
        if (failedBlock) {
            failedBlock(message);
        }
        
    }];
}

#pragma mark -- 班级动态
#pragma mark --
- (void)myClassDynamic:(NSString *)classId
                userId:(NSString *)userId
                typeId:(NSString *)typeId
              pageSize:(int)pageSize
             pageIndex:(int)pageIndex
               success:(void(^)(NSMutableArray *data))successBlock
                failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://home.%@/api/GetClassActivity?classId=%@&typeId=%@&userId=%@&pageSize=%d&pageIndex=%d",aedudomain,classId,typeId,userId,pageSize,pageIndex];
    NSString * encodingString = [requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self handerGetRequest:encodingString
                parameters:nil
                      body:nil
                   success:^(NSDictionary *data) {
                       NSInteger statusCode = [[data objectForKey:@"st"] intValue];
                       if (statusCode == 0) {
                           NSArray *array = [[data objectForKey:@"msg"] objectForKey:@"list"];
                           NSMutableArray *myDynamicArray = [NSMutableArray arrayWithCapacity:[array count]];
                           if (array && [array count] > 0) {
                               for (int i = 0; i < [array count]; i ++) {
                                   VisitorModel *VM = [[VisitorModel alloc] init];
                                   VM.UserName = [array[i] objectForKey:@"UserName"];
                                   VM.DateTime = [array[i] objectForKey:@"DateTime"];
                                   VM.PictureUrl = [array[i] objectForKey:@"PictureUrl"];
                                   VM.TypeId = [[array[i] objectForKey:@"TypeId"] intValue];
                                   VM.hasImage=[[array[i] objectForKey:@"HasPhoto"] boolValue];
                                   VM.ObjectId = [array[i] objectForKey:@"ObjectId"];
                                   VM.IsPraise = [[array[i] objectForKey:@"IsPraise"] boolValue];
                                   //相片
                                   NSArray *tempArray = [array[i] objectForKey:@"ImagesUrl"];
                                   if ([array[i] objectForKey:@"ImagesUrl"] && [tempArray count] > 0) {
                                       VM.ImagesUrl = [array[i] objectForKey:@"ImagesUrl"];
                                   }
                                   // 赞
                                   VM.PraiseCount = [[array[i] objectForKey:@"PraiseCount"] intValue];
                                   
                                   switch (VM.TypeId) {
                                       case 1:
                                       {
                                           VM.Body = [array[i] objectForKey:@"Body"];
                                       }
                                           break;
                                       case 2:
                                       {
                                           VM.Body = [array[i] objectForKey:@"Body"];
                                           VM.Title = [array[i] objectForKey:@"Title"];
                                       }
                                           break;
                                       case 3:
                                       {
                                           VM.Body = [array[i] objectForKey:@"Body"];
                                       }
                                           break;
                                       case 4:
                                       {
                                           VM.Body = [array[i] objectForKey:@"Body"];
                                       }
                                           break;
                                       case 5:
                                       {
                                           VM.Body = [array[i] objectForKey:@"Body"];
                                       }
                                           break;
                                       case 6:
                                       {
                                           VM.Body = [array[i] objectForKey:@"Body"];
                                       }
                                           break;
                                           
                                       default:
                                           break;
                                   }
                                   
                                   // 赞的人数头像
                                   NSArray * PraiseUsersArray = [array[i] objectForKey:@"PraiseUsers"];
                                   if ([PraiseUsersArray count] > 0) {
                                       NSMutableArray *praiseArray = [[NSMutableArray alloc] init];
                                       for (int k = 0; k < [PraiseUsersArray count]; k ++) {
                                           DynamicComments *DC = [[DynamicComments alloc] init];
                                           DC.PictureUrl = [PraiseUsersArray[k] objectForKey:@"PictureUrl"];
                                           [praiseArray addObject:DC];
                                       }
                                       VM.praisePopulationURLs = praiseArray;
                                   }
                                   // 评论
                                   NSArray* comarray = [array[i] objectForKey:@"CommentCentent"];
                                   
                                   if ([comarray count] > 0) {
                                       NSMutableArray* Comments = [[NSMutableArray alloc]init];
                                       for (int j = 0; j < [comarray count]; j ++) {
                                           DynamicComments* dc = [[DynamicComments alloc]  init];
                                           dc.Author = [comarray[j] objectForKey:@"Author"];
                                           dc.Body = [comarray[j] objectForKey:@"Body"];
                                           dc.OwnerId = [[comarray[j] objectForKey:@"OwnerId"] intValue];
                                           dc.ToUserId = [[comarray[j] objectForKey:@"ToUserId"] intValue];
                                           dc.ParentId = [[comarray[j] objectForKey:@"ParentId"] intValue];
                                           dc.CommenId = [[comarray[j] objectForKey:@"CommenId"] intValue];
                                           dc.ToUserDisplayName = [comarray[j] objectForKey:@"ToUserDisplayName"];
                                           [Comments addObject:dc];
                                           
                                       }
                                       VM.CommentCentent = Comments;
                                   }
                                   [myDynamicArray addObject:VM];
                               }
                               if (successBlock) {
                                   successBlock(myDynamicArray);
                               } else{
                                   if (failedBlock) {
                                       failedBlock(@"没有更多的动态了哦！");
                                   }
                               }
                           }
                       } else{
                           if (failedBlock) {
                               failedBlock([data objectForKey:@"msg"]);
                           }
                       }
                       
                   } failed:^(NSString *message) {
                       
                   }];
}

#pragma mark -- 单条访客模式数据（为了归档缓存）

- (void)getOneVisitorModelMessage:(NSString *)typeId
                           userId:(NSString *)userId
                         pageSize:(int)pageSize
                        pageIndex:(int)pageIndex
                          success:(void (^)(NSMutableArray *))successBlock
                           failed:(void (^)(NSString *))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://home.%@/api/GetActivity?typeId=%@&userId=%@&pageSize=%d&pageIndex=%d",aedudomain,typeId,userId,pageSize,pageIndex];
    NSString * encodingString = [requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self handerGetRequest:encodingString
                parameters:nil
                      body:nil
                   success:^(NSDictionary *data) {
                       NSInteger statusCode = [[data objectForKey:@"st"] intValue];
                       if (statusCode == 0) {
                           NSArray *array = [[data objectForKey:@"msg"] objectForKey:@"list"];
                           NSMutableArray *myDynamicArray = [NSMutableArray arrayWithCapacity:[array count]];
                           if (array && [array count] > 0) {
                               for (int i = 0; i < [array count]; i ++) {
                                   VisitorModel *VM = [[VisitorModel alloc] init];
                                   VM.UserName = [array[i] objectForKey:@"UserName"];
                                   VM.DateTime = [array[i] objectForKey:@"DateTime"];
                                   VM.PictureUrl = [array[i] objectForKey:@"PictureUrl"];
                                   VM.TypeId = [[array[i] objectForKey:@"TypeId"] intValue];
                                   VM.hasImage = [[array[i] objectForKey:@"HasPhoto"] boolValue];
                                   VM.ObjectId = [array[i] objectForKey:@"ObjectId"];
                                   VM.IsPraise = [[array[i] objectForKey:@"IsPraise"] boolValue];
                                   VM.LinkUrl = [array[i] objectForKey:@"LinkUrl"];
                                   //相片
                                   NSArray *temArray = [array[i] objectForKey:@"ImagesUrl"];
                                   if ([array[i] objectForKey:@"ImagesUrl"] && [temArray count] > 0) {
                                       VM.ImagesUrl = [array[i] objectForKey:@"ImagesUrl"];
                                   }
                                   // 赞
                                   VM.PraiseCount = [[array[i] objectForKey:@"PraiseCount"] intValue];
                                   
                                   switch (VM.TypeId) {
                                       case 1:
                                       {
                                           VM.Body = [array[i] objectForKey:@"Body"];
                                       }
                                           break;
                                       case 2:
                                       {
                                           VM.Body = [array[i] objectForKey:@"Body"];
                                           VM.Title = [array[i] objectForKey:@"Title"];
                                       }
                                           break;
                                       case 3:
                                       {
                                           VM.Body = [array[i] objectForKey:@"Body"];
                                       }
                                           break;
                                       case 4:
                                       {
                                           VM.Body = [array[i] objectForKey:@"Body"];
                                       }
                                           break;
                                       case 5:
                                       {
                                           VM.Body = [array[i] objectForKey:@"Body"];
                                       }
                                           break;
                                       case 6:
                                       {
                                           VM.Body = [array[i] objectForKey:@"Body"];
                                       }
                                           break;
                                           
                                       default:
                                           break;
                                   }
                                   
                                   // 赞的人数头像
                                   NSArray * PraiseUsersArray = [array[i] objectForKey:@"PraiseUsers"];
                                   if ([PraiseUsersArray count] > 0) {
                                       NSMutableArray *praiseArray = [[NSMutableArray alloc] init];
                                       for (int k = 0; k < [PraiseUsersArray count]; k ++) {
                                           DynamicComments *DC = [[DynamicComments alloc] init];
                                           DC.PictureUrl = [PraiseUsersArray[k] objectForKey:@"PictureUrl"];
                                           [praiseArray addObject:DC];
                                       }
                                       VM.praisePopulationURLs = praiseArray;
                                   }
                                   // 评论
                                   NSArray* comarray = [array[i] objectForKey:@"CommentCentent"];
                                   
                                   if ([comarray count] > 0) {
                                       NSMutableArray* Comments = [[NSMutableArray alloc]init];
                                       for (int j = 0; j < [comarray count]; j ++) {
                                           DynamicComments* dc = [[DynamicComments alloc]  init];
                                           dc.Author = [comarray[j] objectForKey:@"Author"];
                                           dc.Body = [comarray[j] objectForKey:@"Body"];
                                           dc.OwnerId = [[comarray[j] objectForKey:@"OwnerId"] intValue];
                                           dc.ToUserId = [[comarray[j] objectForKey:@"ToUserId"] intValue];
                                           dc.ParentId = [[comarray[j] objectForKey:@"ParentId"] intValue];
                                           dc.ToUserDisplayName = [comarray[j] objectForKey:@"ToUserDisplayName"];
                                           dc.CommenId = [[comarray[j] objectForKey:@"CommenId"] intValue];
                                           [Comments addObject:dc];
                                           
                                       }
                                       VM.CommentCentent = Comments;
                                   }
                                   [myDynamicArray addObject:VM];
                                   
                                   // 缓存
                                   NSMutableArray * dataArray = [NSMutableArray array];
                                   NSData *data = [NSKeyedArchiver archivedDataWithRootObject:VM];
                                   [dataArray addObject:data];
                                   [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"VisitorModel"];
                               }
                               if (successBlock) {
                                   successBlock(myDynamicArray);
                               } else{
                                   if (failedBlock) {
                                       failedBlock(@"没有更多的动态了哦！");
                                   }
                               }
                           }
                       }
                   } failed:^(NSString *message) {
                       if (failedBlock) {
                           failedBlock(message);
                       }
                   }];
}

#pragma mark -- 访客模式

- (void)getVisitorModelMessage:(NSString *)typeId
                        userId:(NSString *)userId
                      pageSize:(int)pageSize
                     pageIndex:(int)pageIndex
                       success:(void(^)(NSMutableArray* data))successBlock
                        failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://home.%@/api/GetActivity?typeId=%@&userId=%@&pageSize=%d&pageIndex=%d",aedudomain,typeId,userId,pageSize,pageIndex];
    NSString * encodingString = [requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self handerGetRequest:encodingString
                parameters:nil
                      body:nil
                   success:^(NSDictionary *data) {
                       NSInteger statusCode = [[data objectForKey:@"st"] intValue];
                       if (statusCode == 0) {
                           NSArray *array = [[data objectForKey:@"msg"] objectForKey:@"list"];
                           NSMutableArray *myDynamicArray = [NSMutableArray arrayWithCapacity:[array count]];
                           if (array && [array count] > 0) {
                               for (int i = 0; i < [array count]; i ++) {
                                   VisitorModel *VM = [[VisitorModel alloc] init];
                                   VM.UserName = [array[i] objectForKey:@"UserName"];
                                   VM.DateTime = [array[i] objectForKey:@"DateTime"];
                                   VM.PictureUrl = [array[i] objectForKey:@"PictureUrl"];
                                   VM.TypeId = [[array[i] objectForKey:@"TypeId"] intValue];
                                   VM.hasImage = [[array[i] objectForKey:@"HasPhoto"] boolValue];
                                   VM.ObjectId = [array[i] objectForKey:@"ObjectId"];
                                   VM.IsPraise = [[array[i] objectForKey:@"IsPraise"] boolValue];
                                   VM.LinkUrl = [array[i] objectForKey:@"LinkUrl"];
                                   //相片
                                   NSArray *temArray = [array[i] objectForKey:@"ImagesUrl"];
                                   if ([array[i] objectForKey:@"ImagesUrl"] && [temArray count] > 0) {
                                       VM.ImagesUrl = [array[i] objectForKey:@"ImagesUrl"];
                                   }
                                   // 赞
                                   VM.PraiseCount = [[array[i] objectForKey:@"PraiseCount"] intValue];
                                   
                                   switch (VM.TypeId) {
                                       case 1:
                                       {
                                           VM.Body = [array[i] objectForKey:@"Body"];
                                       }
                                           break;
                                       case 2:
                                       {
                                           VM.Body = [array[i] objectForKey:@"Body"];
                                           VM.Title = [array[i] objectForKey:@"Title"];
                                       }
                                           break;
                                       case 3:
                                       {
                                           VM.Body = [array[i] objectForKey:@"Body"];
                                       }
                                           break;
                                       case 4:
                                       {
                                           VM.Body = [array[i] objectForKey:@"Body"];
                                       }
                                           break;
                                       case 5:
                                       {
                                           VM.Body = [array[i] objectForKey:@"Body"];
                                       }
                                           break;
                                       case 6:
                                       {
                                           VM.Body = [array[i] objectForKey:@"Body"];
                                       }
                                           break;
                                           
                                       default:
                                           break;
                                   }
                                   
                                   // 赞的人数头像
                                   NSArray * PraiseUsersArray = [array[i] objectForKey:@"PraiseUsers"];
                                   if ([PraiseUsersArray count] > 0) {
                                       NSMutableArray *praiseArray = [[NSMutableArray alloc] init];
                                       for (int k = 0; k < [PraiseUsersArray count]; k ++) {
                                           DynamicComments *DC = [[DynamicComments alloc] init];
                                           DC.PictureUrl = [PraiseUsersArray[k] objectForKey:@"PictureUrl"];
                                           [praiseArray addObject:DC];
                                       }
                                       VM.praisePopulationURLs = praiseArray;
                                   }
                                   // 评论
                                   NSArray* comarray = [array[i] objectForKey:@"CommentCentent"];
                                   
                                   if ([comarray count] > 0) {
                                       NSMutableArray* Comments = [[NSMutableArray alloc]init];
                                       for (int j = 0; j < [comarray count]; j ++) {
                                           DynamicComments* dc = [[DynamicComments alloc]  init];
                                           dc.Author = [comarray[j] objectForKey:@"Author"];
                                           dc.Body = [comarray[j] objectForKey:@"Body"];
                                           dc.OwnerId = [[comarray[j] objectForKey:@"OwnerId"] intValue];
                                           dc.ToUserId = [[comarray[j] objectForKey:@"ToUserId"] intValue];
                                           dc.ParentId = [[comarray[j] objectForKey:@"ParentId"] intValue];
                                           dc.ToUserDisplayName = [comarray[j] objectForKey:@"ToUserDisplayName"];
                                           dc.CommenId = [[comarray[j] objectForKey:@"CommenId"] intValue];
                                           [Comments addObject:dc];
                                           
                                       }
                                       VM.CommentCentent = Comments;
                                   }
                                   [myDynamicArray addObject:VM];
                               }
                               if (successBlock) {
                                   successBlock(myDynamicArray);
                               } else{
                                   if (failedBlock) {
                                       failedBlock(@"没有更多的动态了哦！");
                                   }
                               }
                           }
                       } else{
                           if (failedBlock) {
                               failedBlock([data objectForKey:@"msg"]);
                           }
                       }
                   } failed:^(NSString *message) {
                       if (failedBlock) {
                           failedBlock(message);
                       }
                   }];
}

#pragma mark -- 统计安装量

- (void)getInstallmentNumber:(NSString *)productId
                     version:(NSString *)version
                     success:(void(^)(NSString* data))successBlock
                      failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://dsjtj.%@/Api/RecordAppInstall?productId=%@&version=%@",aedudomain,productId,version];
    NSString * encodingString = [requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self handerGetRequest:encodingString parameters:nil body:nil success:^(NSDictionary *data) {
        BOOL statusCode = [[data objectForKey:@"Status"] boolValue];
        if (statusCode == 1) {
            
            if (successBlock) {
                successBlock(@"");
            }
            
        } else{
            if (failedBlock) {
                failedBlock(@"");
            }
            
        }
        
    } failed:^(NSString *message) {
        
    }];
    
}

#pragma mark -- 统计浏览应用数量

- (void)getBrowseNumber:(NSString *)userId
                   ppId:(BigData)ppId
              productId:(NSString *)productId
                version:(NSString *)version
                success:(void(^)(NSString* data))successBlock
                 failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://dsjtj.%@/Api/RecordAppClick?userId=%@&ppId=%d&productId=%@&version=%@",aedudomain,userId,ppId,productId,version];
    NSString * encodingString = [requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self handerGetRequest:encodingString parameters:nil body:nil success:^(NSDictionary *data) {
        BOOL statusCode = [[data objectForKey:@"status"] boolValue];
        if (statusCode == 1) {
            
            if (successBlock) {
                successBlock(@"");
            }
            
        } else{
            if (failedBlock) {
                failedBlock(@"");
            }
            
        }
        
    } failed:^(NSString *message) {
        
    }];
    
}

#pragma mark -- 获取手机base64位编码

- (void)getPhoneBase64Code:(NSString *)phone
                   success:(void(^)(NSString* data))successBlock
                    failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://member.%@/validatecode/description?phone=%@",aedudomain,phone];
    NSString * encodingString = [requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    ISingHTTPRequestOperationManager *manager = [[ISingHTTPRequestOperationManager alloc] init];
    manager.requestURLString = requestUrl;
    manager.afHttpBody = nil;
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",
                                                         @"application/json",
                                                         @"text/plain",
                                                         nil];
    
    [manager GET:encodingString
      parameters:nil
            body:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             //
             NSData *deData = responseObject;
             
             NSString *xmlStr = [[NSString alloc] initWithData:deData encoding:NSUTF8StringEncoding];
             
             NSLog(@"The response is:%@", xmlStr);
             
             NSString* theXmlStr=[xmlStr stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
             
             if (successBlock) {
                 successBlock(theXmlStr);
             }
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             //
             if (failedBlock) {
                 if (error.code == -1009 || error.code == -1001 || error.code == -1004) {
                     failedBlock(@"亲，您的当前网络不可用哦");
                 } else if (error.code == -1011) {
                     failedBlock(@"亲，您的当前网络不可用哦");
                 } else {
                     failedBlock(error.localizedDescription);//错误时候，系统返回数据
                 }
             }
         }];
}

#pragma mark -- 根据手机号码获取用户

- (void)AccordingPhoneGetUser:(NSString *)phone
                         code:(NSString *)code
                      success:(void(^)(NSMutableArray* data))successBlock
                       failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://home.%@/api/GetUserByPhone?phone=%@&code=%@",aedudomain,phone,code];
    NSString * encodingString = [requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self handerGetRequest:encodingString parameters:nil body:nil success:^(NSDictionary *data) {
        NSInteger statusCode = [[data objectForKey:@"st"] intValue];
        if (statusCode == 0) {
            NSMutableArray *array = [data objectForKey:@"msg"];
            if (array && [array count] > 0 && [array isKindOfClass:[NSMutableArray class]]) {
                //不做model，烦
                if (successBlock) {
                    successBlock(array);
                }
                
            } else{
                
                if (failedBlock) {
                    failedBlock(@"获取用户列表失败！");
                    
                }
            }
        } else if (statusCode == -5 || statusCode == -6){
            if (failedBlock) {
                failedBlock(@"验证码已过期或无用，获取不到用户列表!");
                
            }
        } else if (statusCode == -7){
            if (failedBlock) {
                failedBlock(@"未获取到手机绑定的账号!");
                
            }
        } else{
            if (failedBlock) {
                failedBlock(@"获取用户列表失败！");
                
            }
            
        }
        
    } failed:^(NSString *message) {
        if (failedBlock) {
            failedBlock(message);
        }
        
    }];
    
}

#pragma mark -- 根据账号登录

- (void)AccordingAccountDebarkation:(NSString *)uid
                                pwd:(NSString *)pwd
                            success:(void(^)(Login *login))successBlock
                             failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://passport.%@/api/GetLogionByAccount?uid=%@&pwd=%@",aedudomain,uid,pwd];
    NSString * encodingString = [requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self handerGetRequest:encodingString parameters:nil body:nil success:^(NSDictionary *data) {
        NSInteger statusCode = [[data objectForKey:@"status"] intValue];
        if (statusCode == 0) {
            NSDictionary *dict = (NSDictionary*)[data objectForKey:@"msg"];
            
            Login *login = [[Login alloc] init];
            
            login.userId = [NSString stringWithFormat:@"%@", [dict objectForKey:@"Id"]];
            login.tokenId = [dict objectForKey:@"Token"];
            
            
            login.userAvatar = [NSString stringWithFormat:@"%@%@%@?lq=123456",appHeadImage,login.userId,@".jpg"];
            
            
            login.userName = [dict objectForKey:@"UserName"];
            login.userRole = [dict objectForKey:@"UserRole"];
            
            login.blogAddress = [dict objectForKey:@"BlogAddress"];
            login.classId = [dict objectForKey:@"ClassId"];
            login.schoolId = [dict objectForKey:@"SchoolId"];
            login.schoolName = [dict objectForKey:@"SchoolName"];
            
            login.integral = [[dict objectForKey:@"Integral"] intValue];
            login.bSaveLoginState = [[dict objectForKey:@"IsSaveLoginState"] boolValue];
            login.loginTime = [dict objectForKey:@"LoginTime"];
            login.publicProperty = [dict objectForKey:@"PublicProperty"];
            login.saveStateTime = [dict objectForKey:@"SaveStateTime"];
            login.account=uid;
            if (successBlock) {
                [UserSession shareUserSession].user=login;
                [self bindPush];
#warning im登陆
                Connection* connection= [Connection shareConnection];
                connection.account=uid;
                connection.pwd=nil;
                connection.phone=pwd;
                if ([connection getsocket]) {
                    [connection disconnect];
                }else{
                    [connection connect];
                }
                successBlock(login);
            }
        } else {
            if (failedBlock) {
                failedBlock([data objectForKey:@"msg"]);
            }
        }
        
        
        
    } failed:^(NSString *message) {
        if (failedBlock) {
            failedBlock(message);
        }
        
    }];
    
}

#pragma mark -- 绑定用户推送关系
- (void)bindPush{
    BaiDuPushParams* bdpp=[BaiDuPushParams shareBaiDuPushParams];
    Login *loginInfo=[UserSession shareUserSession].user;
    if (bdpp.deviceToken==nil||loginInfo==nil) {
        return;
    }else{
        NSString *requestUrl = [NSString stringWithFormat:@"http://pushservice.%@/home/AddDevice?UserId=%@&Token=%@&DeviceType=%d&ChannelId=%@",aedudomain,loginInfo.userId,bdpp.deviceToken,(int)DeviceIphone,@" "];
        NSString * encodingString = [requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [self handerPostRequest:encodingString parameters:nil body:nil success:^(NSDictionary *data) {
            NSInteger statusCode = [[data objectForKey:@"result"] intValue];
            if (statusCode == 1) {
                NSLog(@"%@",@"绑定用户推送成功");
            }else{
                NSLog(@"%@",@"绑定用户推送失败");
            }
            
        } failed:^(NSString *message) {
            NSLog(@"%@",@"绑定用户推送失败");
        }];
        
    }
}


#pragma mark -- 根据账号登录

- (void)getIMserverSuccess:(void(^)(NSString* ip,int port))successBlock
                    failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://dispatcherserver.%@/service/server-list.jsp",aedudomain];
    NSString * encodingString = [requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self handerGetRequest:encodingString parameters:nil body:nil success:^(NSDictionary *data) {
        NSInteger statusCode = [[data objectForKey:@"StateCode"] intValue];
        if (statusCode == 1) {
            NSArray *array = (NSArray*)[data objectForKey:@"list"];
            if (array!=nil&&[array count]>0) {
                NSDictionary* dic=[array objectAtIndex:0];
                NSString* ip=[dic objectForKey:@"remoteip"];
                int port=[[dic objectForKey:@"remoteport"] intValue];
                if (successBlock) {
                    successBlock(ip,port);
                }
            }else{
                if (failedBlock) {
                    failedBlock(@"没有消息服务器可提供服务");
                }
            }
        } else {
            if (failedBlock) {
                failedBlock([data objectForKey:@"Msg"]);
            }
        }
        
        
        
    } failed:^(NSString *message) {
        if (failedBlock) {
            failedBlock(message);
        }
        
    }];
    
}

#pragma mark -- 获取离线消息
- (void) getOfflineMessages:(NSString *)userId
                    success:(void(^)(NSMutableArray* data))successBlock
                     failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://pushservice.%@/message/GetOfflineMessages/%@",aedudomain, userId];
    NSString * encodedString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)requestUrl, NULL, NULL,  kCFStringEncodingUTF8);
    [self handerGetRequest:encodedString
                parameters:nil
                      body:nil
                   success:^(NSDictionary *data) {
                       NSInteger statusCode = [[data objectForKey:@"result"] intValue];
                       if (statusCode == 0) {
                           NSMutableArray *array = (NSMutableArray *)[data objectForKey:@"messages"];
                           if (array && [array count] > 0) {
                               if (successBlock) {
                                   successBlock(array);
                               }
                           }
                       }else {
                           if (failedBlock) {
                               failedBlock(@"暂无数据...");
                           }
                       }
                       
                   }
                    failed:^(NSString *message) {
                        if (failedBlock) {
                            failedBlock(@"获取失败");
                        }
                    }];
    
    requestUrl = [NSString stringWithFormat:@"http://pushservice.%@/message/GetGroupMessages?id=%@",aedudomain, userId];
    encodedString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)requestUrl, NULL, NULL,  kCFStringEncodingUTF8);
    [self handerGetRequest:encodedString
                parameters:nil
                      body:nil
                   success:^(NSDictionary *data) {
                       NSInteger statusCode = [[data objectForKey:@"result"] intValue];
                       if (statusCode == 0) {
                           NSMutableArray *array = (NSMutableArray *)[data objectForKey:@"messages"];
                           if (array && [array count] > 0) {
                               if (successBlock) {
                                   successBlock(array);
                               }
                           }
                       }else {
                           if (failedBlock) {
                               failedBlock(@"暂无数据...");
                           }
                       }
                       
                   }
                    failed:^(NSString *message) {
                        if (failedBlock) {
                            failedBlock(@"获取失败");
                        }
                    }];
}

#pragma mark -- 根据guid获取消息
- (void) getMessageWithGuid:(NSString *)guid
                    success:(void(^)(NSMutableArray* data))successBlock
                     failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://pushservice.%@/message/GetMessage?id=%@",aedudomain, guid];
    NSString * encodedString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)requestUrl, NULL, NULL,  kCFStringEncodingUTF8);
    [self handerGetRequest:encodedString
                parameters:nil
                      body:nil
                   success:^(NSDictionary *data) {
                       NSInteger count = [[data objectForKey:@"count"] intValue];
                       if (count >= 1) {
                           NSMutableArray *array = (NSMutableArray *)[data objectForKey:@"messages"];
                           if (array && [array count] > 0) {
                               if (successBlock) {
                                   successBlock(array);
                               }
                           }
                       }else {
                           if (failedBlock) {
                               failedBlock(@"暂无数据...");
                           }
                       }
                       
                   }
                    failed:^(NSString *message) {
                        if (failedBlock) {
                            failedBlock(@"获取失败");
                        }
                    }];
    
}
#pragma mark -- 获取话题
- (void) getRecommendTagsWithNum:(int)num
                         success:(void(^)(NSMutableArray* data))successBlock
                          failed:(void(^)(NSString *errorMSG))failedBlock
{
    
    NSString *requestUrl = [NSString stringWithFormat:@"http://home.%@/api/GetRecommendTags?topNum=%d",aedudomain,num];
    NSString * encodedString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)requestUrl, NULL, NULL,  kCFStringEncodingUTF8);
    [self handerGetRequest:encodedString parameters:nil body:nil success:^(NSDictionary *data) {
        NSInteger statusCode = [[data objectForKey:@"st"] intValue];
        if (statusCode == 0) {
            NSMutableArray *array = [[data objectForKey:@"msg"] objectForKey:@"list"];
            if ([array count] > 0) {
                if (successBlock) {
                    successBlock(array);
                }
            }
        }else{
            if (failedBlock) {
                failedBlock([NSString stringWithFormat:@""]);
            }
        }
        
    }failed:^(NSString *message) {
        if (failedBlock) {
            failedBlock(@"");
        }
    }];
}

#pragma mark -- 获取历史话题

- (void)getHistoricalTopicList:(NSString *)noInTop
                     pageindex:(int)pageindex
                       success:(void(^)(NSMutableArray* data))successBlock
                        failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://home.%@/Api/GetTags?noInTop=%@&pageindex=%d",aedudomain,noInTop,pageindex];
    NSString * encodedString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)requestUrl, NULL, NULL,  kCFStringEncodingUTF8);
    [self handerGetRequest:encodedString
                parameters:nil
                      body:nil
                   success:^(NSDictionary *data) {
                       NSInteger statusCode = [[data objectForKey:@"st"] intValue];
                       if (statusCode == 0) {
                           NSMutableArray *array = [[data objectForKey:@"msg"] objectForKey:@"list"];
                           if ([array count] > 0) {
                               if (successBlock) {
                                   successBlock(array);
                               }
                           }
                       }else{
                           if (failedBlock) {
                               failedBlock([NSString stringWithFormat:@""]);
                           }
                       }
                       
                   } failed:^(NSString *message) {
                       if (failedBlock) {
                           failedBlock(@"");
                       }
                   }];
    
}

#pragma mark -- 参与话题微博列表
- (void) GetMicroblogByTagId:(NSNumber*)tagId
                      userId:(NSString *)userId
                    pageSize:(int)pageSize
                   pageIndex:(int)pageIndex
                     success:(void(^)(NSMutableArray* data))successBlock
                      failed:(void(^)(NSString *errorMSG))failedBlock
{
    
    NSString *requestUrl = [NSString stringWithFormat:@"http://home.%@/api/GetMicroblogByTagId?tagId=%@&userId=%@&pageSize=%d&pageIndex=%d",aedudomain,tagId,userId,pageSize,pageIndex];
    NSString * encodedString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)requestUrl, NULL, NULL,  kCFStringEncodingUTF8);
    [self handerGetRequest:encodedString parameters:nil body:nil success:^(NSDictionary *data) {
        NSInteger statusCode = [[data objectForKey:@"st"] intValue];
        if (statusCode == 0) {
            NSMutableArray *array = [[data objectForKey:@"msg"] objectForKey:@"list"];
            NSMutableArray *myDynamicArray = [NSMutableArray arrayWithCapacity:[array count]];
            if ([array count] > 0) {
                for (int i = 0; i < [array count]; i ++) {
                    VisitorModel *VM = [[VisitorModel alloc] init];
                    VM.UserName = [array[i] objectForKey:@"UserName"];
                    VM.DateTime = [array[i] objectForKey:@"DateTime"];
                    VM.PictureUrl = [array[i] objectForKey:@"PictureUrl"];
                    VM.Body = [array[i] objectForKey:@"Body"];
                    VM.IsPraise = [[array[i] objectForKey:@"IsPraise"] boolValue];
                    VM.MicroblogId = [array[i] objectForKey:@"MicroblogId"];
                    //相片
                    NSArray *tempArray = [array[i] objectForKey:@"ImagesUrl"];
                    if ([array[i] objectForKey:@"ImagesUrl"] && [tempArray count] > 0) {
                        VM.ImagesUrl = [array[i] objectForKey:@"ImagesUrl"];
                    }
                    VM.PraiseCount = [[array[i] objectForKey:@"PraiseCount"] intValue];
                    // 赞的人数头像
                    NSArray * PraiseUsersArray = [array[i] objectForKey:@"PraiseUsers"];
                    if ([PraiseUsersArray count] > 0) {
                        NSMutableArray *praiseArray = [[NSMutableArray alloc] init];
                        for (int k = 0; k < [PraiseUsersArray count]; k ++) {
                            DynamicComments *DC = [[DynamicComments alloc] init];
                            DC.PictureUrl = [PraiseUsersArray[k] objectForKey:@"PictureUrl"];
                            [praiseArray addObject:DC];
                        }
                        VM.praisePopulationURLs = praiseArray;
                    }
                    NSArray* comarray = [array[i] objectForKey:@"CommentCentent"];
                    if ([comarray count] > 0) {
                        NSMutableArray* Comments = [[NSMutableArray alloc]init];
                        for (int j = 0; j < [comarray count]; j ++) {
                            DynamicComments* dc = [[DynamicComments alloc]  init];
                            dc.Author = [comarray[j] objectForKey:@"Author"];
                            dc.Body = [comarray[j] objectForKey:@"Body"];
                            dc.OwnerId = [[comarray[j] objectForKey:@"OwnerId"] intValue];
                            dc.ToUserId = [[comarray[j] objectForKey:@"ToUserId"] intValue];
                            dc.ParentId = [[comarray[j] objectForKey:@"ParentId"] intValue];
                            dc.ToUserDisplayName = [comarray[j] objectForKey:@"ToUserDisplayName"];
                            dc.CommenId = [[comarray[j] objectForKey:@"CommenId"] intValue];
                            [Comments addObject:dc];
                            
                        }
                        VM.CommentCentent = Comments;
                    }
                    [myDynamicArray addObject:VM];
                }
                if (successBlock) {
                    successBlock(myDynamicArray);
                }
            }
        }else{
            if (failedBlock) {
                failedBlock([NSString stringWithFormat:@""]);
            }
        }
    }failed:^(NSString *message) {
        if (failedBlock) {
            failedBlock(@"");
        }
    }];
    
}
#pragma mark -- 获取微博评论
- (void) getMicroblogCommentWithmicroblogId:(NSString*)microblogId
                                    success:(void(^)(NSMutableArray* data))successBlock
                                     failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://home.%@/api/GetMicroblogComment?microblogId=%@",aedudomain,microblogId];
    NSString * encodedString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)requestUrl, NULL, NULL,  kCFStringEncodingUTF8);
    [self handerGetRequest:encodedString parameters:nil body:nil success:^(NSDictionary *data) {
        NSInteger statusCode = [[data objectForKey:@"st"] intValue];
        if (statusCode == 0) {
            NSMutableArray *array = [[data objectForKey:@"msg"] objectForKey:@"list"];
            if ([array count] > 0) {
                if (successBlock) {
                    successBlock(array);
                }
            }
        }else{
            if (failedBlock) {
                failedBlock([NSString stringWithFormat:@""]);
            }
        }
        
    }failed:^(NSString *message) {
        if (failedBlock) {
            failedBlock(@"");
        }
    }];
}
#pragma mark -- 发表微博评论
- (void) postReplyCommentsWithUserId:(NSString*)UserId commentedObjectId:(NSString *)objectID body:(NSString *)body typeId:(int)typeId parentId:(int)parentId
                             success:(void(^)(NSDictionary* data))successBlock
                              failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://home.%@/api/PostReplyComments?UserId=%@&commentedObjectId=%@&body=%@&typeId=%d&parentId=%d",
                            aedudomain, UserId, objectID, body,typeId,parentId];
    NSString * encodedString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)requestUrl, NULL, NULL,  kCFStringEncodingUTF8 );
    
    [self handerPostRequest:encodedString parameters:nil body:nil success:^(NSDictionary *data){
        NSInteger statusCode = [[data objectForKey:@"st"] intValue];
        if (statusCode == 0) {
            if (successBlock) {
                successBlock(data);
            }
        } else{
            if (failedBlock) {
                failedBlock(@"回复失败");
            }
        }
        
    } failed:^(NSString *message) {
        if (failedBlock) {
            failedBlock(@"回复失败");
        }
    }];
}

- (void)postTheReplyCommentsWithUserId:(NSString *)UserId
                     commentedObjectId:(NSString *)objectID
                                  body:(NSString *)body
                                typeId:(int)typeId
                               success:(void(^)(NSDictionary* data))successBlock
                                failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://home.%@/api/PostReplyComments?UserId=%@&commentedObjectId=%@&body=%@&typeId=%d",
                            aedudomain, UserId, objectID, body,typeId];
    NSString * encodedString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)requestUrl, NULL, NULL,  kCFStringEncodingUTF8 );
    [self handerPostRequest:encodedString parameters:nil body:nil success:^(NSDictionary *data){
        if (successBlock) {
            successBlock(data);
        }
        
    } failed:^(NSString *message) {
        
    }];
    
    
}

#pragma mark -- 班级网评论/回复
- (void)classNetworkCommentary:(NSString *)archiveId
                        userId:(NSString *)userId
                           pId:(NSString *)pId
                   commentText:(NSString *)commentText
                       success:(void(^)(NSDictionary* data))successBlock
                        failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://home.%@/class/PostPublishComment?archiveId=%@&userId=%@&pId=%@&commentText=%@",
                            aedudomain, archiveId, userId, pId,commentText];
    NSString * encodedString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)requestUrl, NULL, NULL,  kCFStringEncodingUTF8 );
    [self handerPostRequest:encodedString parameters:nil body:nil success:^(NSDictionary *data){
        if (successBlock) {
            successBlock(data);
        }
        
    } failed:^(NSString *message) {
        
    }];
    
}
#pragma mark -- 点赞
- (void) postPraiseWithtoken:(NSString*)token objectId:(NSString *)objectID typeId:(int)typeId
                     success:(void(^)(NSDictionary* data))successBlock
                      failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://home.%@/api/PostPraise?toKen=%@&objectId=%@&typeId=%d",
                            aedudomain, token, objectID,typeId];
    NSString * encodedString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)requestUrl, NULL, NULL,  kCFStringEncodingUTF8 );
    
    [self handerPostRequest:encodedString parameters:nil body:nil success:^(NSDictionary *data){
        NSInteger statusCode = [[data objectForKey:@"st"] intValue];
        if (statusCode == 0) {
            if (successBlock) {
                successBlock(data);
            }
        } else if (statusCode == 1){
            if (failedBlock) {
                failedBlock(@"你已经点过赞了");
            }
        } else{
            if (failedBlock) {
                failedBlock(@"点赞失败");
            }
        }
    } failed:^(NSString *message) {
        failedBlock(message);
        
    }];
}

#pragma mark -- 班级文章点赞
#pragma mark --
- (void)classArticlePraise:(NSString *)archiveId
                    userId:(NSString *)userId
                   success:(void(^)(NSDictionary* data))successBlock
                    failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://nmapi.%@/class/PraiseArchive?archiveId=%@&userId=%@",
                            aedudomain, archiveId, userId];
    NSString * encodedString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)requestUrl, NULL, NULL,  kCFStringEncodingUTF8 );
    
    [self handerPostRequest:encodedString parameters:nil body:nil success:^(NSDictionary *data){
        NSInteger statusCode = [[data objectForKey:@"result"] intValue];
        if (statusCode == 1) {
            if (successBlock) {
                successBlock(data);
            }
        } else if (statusCode == 0){
            if (failedBlock) {
                failedBlock(@"你已经点过赞了");
            }
        }
    } failed:^(NSString *message) {
        failedBlock(message);
        
    }];
    
}

#pragma mark -- 班级文章评论
#pragma mark --

- (void)classArticleCommentary:(NSString *)archiveId
                        userId:(NSString *)userId
                           pId:(NSString *)pId
                   commentText:(NSString *)commentText
                       success:(void(^)(NSDictionary* data))successBlock
                        failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://nmapi.%@/class/PostPublishComment?archiveId=%@&userId=%@&pId=%@&commentText=%@",
                            aedudomain,archiveId, userId,pId,commentText];
    NSString * encodedString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)requestUrl, NULL, NULL,  kCFStringEncodingUTF8 );
    [self handerPostRequest:encodedString
                 parameters:nil
                       body:nil
                    success:^(NSDictionary *data) {
                        NSInteger statusCode = [[data objectForKey:@"result"] intValue];
                        if (statusCode == 1) {
                            if (successBlock) {
                                successBlock(data);
                            }
                        } else{
                            if (failedBlock) {
                                failedBlock(@"评论失败");
                            }
                        }
                        
                    } failed:^(NSString *message) {
                        if (failedBlock) {
                            failedBlock(message);
                        }
                    }];
}

#pragma mark -- 日志详情
#pragma mark --
- (void)logDetails:(NSString *)userId
            blogId:(NSString *)blogId
           success:(void(^)(NSMutableArray *data))successBlock
            failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://home.%@/Api/GetActivityBlogThread?userId=%@&BlogThreadsId=%@",
                            aedudomain,userId, blogId];
    NSString * encodedString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)requestUrl, NULL, NULL,  kCFStringEncodingUTF8 );
    [self handerGetRequest:encodedString
                parameters:nil
                      body:nil
                   success:^(NSDictionary *data) {
                       NSInteger statusCode = [[data objectForKey:@"st"] intValue];
                       if (statusCode == 0) {
                           NSDictionary *dic = [[data objectForKey:@"msg"] objectForKey:@"list"];
                           NSMutableArray *myDynamicArray = [NSMutableArray arrayWithCapacity:[dic count]];
                           if (dic && [dic count] > 0) {
                               LogModel *LM = [[LogModel alloc] init];
                               LM.UserName = [dic objectForKey:@"UserName"];
                               LM.DateTime = [dic objectForKey:@"DateTime"];
                               LM.PictureUrl = [dic objectForKey:@"PictureUrl"];
                               LM.TypeId = [[dic objectForKey:@"TypeId"] intValue];
                               LM.LinkUrl = [dic objectForKey:@"LinkUrl"];
                               LM.hasImage=[[dic objectForKey:@"HasPhoto"] boolValue];
                               LM.ObjectId = [dic objectForKey:@"BlogThreadId"];
                               LM.Body = [dic objectForKey:@"Body"];
                               LM.Title = [dic objectForKey:@"Title"];
                               LM.IsPraise = [[dic objectForKey:@"IsPraise"] boolValue];
                               // 赞
                               LM.PraiseCount = [[dic objectForKey:@"PraiseCount"] intValue];
                               // 赞的人数头像
                               NSArray * PraiseUsersArray = [dic objectForKey:@"PraiseUsers"];
                               if ([PraiseUsersArray count] > 0) {
                                   NSMutableArray *praiseArray = [[NSMutableArray alloc] init];
                                   for (int k = 0; k < [PraiseUsersArray count]; k ++) {
                                       DynamicComments *DC = [[DynamicComments alloc] init];
                                       DC.PictureUrl = [PraiseUsersArray[k] objectForKey:@"PictureUrl"];
                                       [praiseArray addObject:DC];
                                   }
                                   LM.praisePopulationURLs = praiseArray;
                               }
                               // 评论
                               NSArray* comarray = [dic objectForKey:@"CommentCentent"];
                               
                               if ([comarray count] > 0) {
                                   NSMutableArray* Comments = [[NSMutableArray alloc]init];
                                   for (int j = 0; j < [comarray count]; j ++) {
                                       DynamicComments* dc = [[DynamicComments alloc]  init];
                                       dc.Author = [comarray[j] objectForKey:@"Author"];
                                       dc.Body = [comarray[j] objectForKey:@"Body"];
                                       dc.OwnerId = [[comarray[j] objectForKey:@"OwnerId"] intValue];
                                       dc.ToUserId = [[comarray[j] objectForKey:@"ToUserId"] intValue];
                                       dc.ParentId = [[comarray[j] objectForKey:@"ParentId"] intValue];
                                       dc.CommenId = [[comarray[j] objectForKey:@"CommenId"] intValue];
                                       dc.ToUserDisplayName = [comarray[j] objectForKey:@"ToUserDisplayName"];
                                       [Comments addObject:dc];
                                       
                                   }
                                   LM.CommentCentent = Comments;
                               }
                               [myDynamicArray addObject:LM];
                               if (successBlock) {
                                   successBlock(myDynamicArray);
                               } else{
                                   if (failedBlock) {
                                       failedBlock(@"获取不到详情");
                                   }
                               }
                           }
                       }
                   } failed:^(NSString *message) {
                       if (failedBlock) {
                           failedBlock(message);
                       }
                   }];
    
}
#pragma mark -- 日志评论列表
#pragma mark --

- (void)getBlogCommentList:(NSString *)blogThreadsId
                 pageIndex:(int)pageIndex
                   success:(void(^)(NSMutableArray *data))successBlock
                    failed:(void(^)(NSString *errorMSG))failedBlock
{
    
    NSString *requestUrl = [NSString stringWithFormat:@"http://home.%@/api/GetBlogThreadsComment?blogThreadsId=%@&pageIndex=%d",
                            aedudomain,blogThreadsId, pageIndex];
    NSString * encodedString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)requestUrl, NULL, NULL,  kCFStringEncodingUTF8);
    [self handerGetRequest:encodedString
                parameters:nil
                      body:nil
                   success:^(NSDictionary *data) {
                       NSInteger statusCode = [[data objectForKey:@"st"] intValue];
                       if (statusCode == 0) {
                           NSArray* comarray = [[data objectForKey:@"msg"] objectForKey:@"list"];
                           if ([comarray count] > 0) {
                               NSMutableArray* Comments = [[NSMutableArray alloc]init];
                               for (int j = 0; j < [comarray count]; j ++) {
                                   DynamicComments* dc = [[DynamicComments alloc]  init];
                                   dc.Author = [comarray[j] objectForKey:@"Author"];
                                   dc.Body = [comarray[j] objectForKey:@"Body"];
                                   dc.OwnerId = [[comarray[j] objectForKey:@"OwnerId"] intValue];
                                   dc.ToUserId = [[comarray[j] objectForKey:@"ToUserId"] intValue];
                                   dc.ParentId = [[comarray[j] objectForKey:@"ParentId"] intValue];
                                   dc.ToUserDisplayName = [comarray[j] objectForKey:@"ToUserDisplayName"];
                                   dc.CommenId = [[comarray[j] objectForKey:@"CommenId"] intValue];
                                   [Comments addObject:dc];
                               }
                               if (successBlock) {
                                   successBlock (Comments);
                               }
                           }
                       } else{
                           if (failedBlock) {
                               failedBlock(@"");
                           }
                       }
                   } failed:^(NSString *message) {
                       if (failedBlock) {
                           failedBlock(message);
                       }
                   }];
}

#pragma mark -- 班级网文章评论列表
#pragma mark --

- (void)getClassArticleCommentLists:(NSString *)archiveId
                           pageSize:(int)pageSize
                          pageIndex:(int)pageIndex
                            success:(void(^)(NSMutableArray *data))successBlock
                             failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://nmapi.%@/class/GetArchiveCommentList?archiveId=%@&pageSize=%d&pageIndex=%d",
                            aedudomain,archiveId, pageSize,pageIndex];
    NSString * encodedString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)requestUrl, NULL, NULL,  kCFStringEncodingUTF8);
    [self handerGetRequest:encodedString
                parameters:nil
                      body:nil
                   success:^(NSDictionary *data) {
                       NSInteger statusCode = [[data objectForKey:@"result"] intValue];
                       if (statusCode == 1) {
                           NSArray* comarray = [data objectForKey:@"items"];
                           if ([comarray count] > 0) {
                               NSMutableArray* Comments = [[NSMutableArray alloc]init];
                               for (int j = 0; j < [comarray count]; j ++) {
                                   DynamicComments* dc = [[DynamicComments alloc]  init];
                                   dc.Author = [comarray[j] objectForKey:@"Author"];
                                   dc.Body = [comarray[j] objectForKey:@"Body"];
                                   dc.OwnerId = [[comarray[j] objectForKey:@"OwnerId"] intValue];
                                   dc.ToUserId = [[comarray[j] objectForKey:@"ToUserId"] intValue];
                                   dc.ParentId = [[comarray[j] objectForKey:@"ParentId"] intValue];
                                   dc.ToUserDisplayName = [comarray[j] objectForKey:@"ToUserDisplayName"];
                                   dc.CommenId = [[comarray[j] objectForKey:@"CommenId"] intValue];
                                   [Comments addObject:dc];
                               }
                               if (successBlock) {
                                   successBlock (Comments);
                               }
                           }
                       } else{
                           if (failedBlock) {
                               failedBlock(@"");
                           }
                       }
                       
                   } failed:^(NSString *message) {
                       if (failedBlock) {
                           failedBlock(message);
                       }
                   }];
    
}
#pragma mark -- 班级文章详情
#pragma mark --
- (void)classArticleDetails:(NSString *)archiveId
                     userid:(NSString *)userid
                    success:(void(^)(NSMutableArray *data))successBlock
                     failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://nmapi.%@/class/GetArchiveDetail?archiveId=%@&userid=%@",
                            aedudomain,archiveId, userid];
    NSString * encodedString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)requestUrl, NULL, NULL,  kCFStringEncodingUTF8 );
    [self handerGetRequest:encodedString
                parameters:nil
                      body:nil
                   success:^(NSDictionary *data) {
                       NSInteger statusCode = [[data objectForKey:@"result"] intValue];
                       if (statusCode == 1) {
                           NSDictionary *dic = [data objectForKey:@"detail"];
                           NSMutableArray *myDynamicArray = [NSMutableArray arrayWithCapacity:[dic count]];
                           if (dic && [dic count] > 0) {
                               LogModel *LM = [[LogModel alloc] init];
                               LM.UserName = [dic objectForKey:@"UserName"];
                               LM.DateTime = [dic objectForKey:@"PubTime"];
                               LM.PictureUrl = [dic objectForKey:@"UserFace"];
                               LM.Body = [dic objectForKey:@"ArchiveText"];
                               LM.Title = [dic objectForKey:@"ArchiveTitle"];
                               LM.ObjectId = [dic objectForKey:@"ArchiveId"];
                               LM.IsPraise = [[dic objectForKey:@"IsPraise"] boolValue];
                               LM.PraiseCount = [[dic objectForKey:@"PraiseCount"] intValue];
                               // 赞的人数头像
                               NSArray * PraiseUsersArray = [dic objectForKey:@"praise"];
                               if ([PraiseUsersArray count] > 0) {
                                   NSMutableArray *praiseArray = [[NSMutableArray alloc] init];
                                   for (int k = 0; k < [PraiseUsersArray count]; k ++) {
                                       DynamicComments *DC = [[DynamicComments alloc] init];
                                       DC.PictureUrl = [PraiseUsersArray[k] objectForKey:@"UserFace"];
                                       [praiseArray addObject:DC];
                                   }
                                   LM.praisePopulationURLs = praiseArray;
                               }
                               [myDynamicArray addObject:LM];
                               if (successBlock) {
                                   successBlock(myDynamicArray);
                               } else{
                                   if (failedBlock) {
                                       failedBlock(@"获取不到详情");
                                   }
                               }
                           }
                       } else if (statusCode == 0){
                           if (failedBlock) {
                               failedBlock(@"文章不存在或者已被删除");
                           }
                       }
                   } failed:^(NSString *message) {
                       if (failedBlock) {
                           failedBlock(message);
                       }
                   }];
}

#pragma mark -- 好友动态
#pragma mark --

- (void)GoodFriendTendencyDetails:(NSString *)token
                           typeId:(NSString *)typeId
                        pageIndex:(int)pageIndex
                          success:(void(^)(NSMutableArray *data))successBlock
                           failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://home.%@/api/GetHomeActivity?toKen=%@&typeId=%@&pageIndex=%d",
                            aedudomain,token, typeId,pageIndex];
    NSString * encodedString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)requestUrl, NULL, NULL,  kCFStringEncodingUTF8 );
    [self handerGetRequest:encodedString
                parameters:nil
                      body:nil
                   success:^(NSDictionary *data) {
                       NSInteger statusCode = [[data objectForKey:@"st"] intValue];
                       if (statusCode == 0) {
                           NSArray *array = [[data objectForKey:@"msg"] objectForKey:@"list"];
                           NSMutableArray *myDynamicArray = [NSMutableArray arrayWithCapacity:[array count]];
                           if (array && [array count] > 0) {
                               for (int i = 0; i < [array count]; i ++) {
                                   VisitorModel *VM = [[VisitorModel alloc] init];
                                   VM.UserName = [array[i] objectForKey:@"UserName"];
                                   VM.DateTime = [array[i] objectForKey:@"DateTime"];
                                   VM.PictureUrl = [array[i] objectForKey:@"PictureUrl"];
                                   VM.TypeId = [[array[i] objectForKey:@"TypeId"] intValue];
                                   VM.hasImage = [[array[i] objectForKey:@"HasPhoto"] boolValue];
                                   VM.ObjectId = [array[i] objectForKey:@"ObjectId"];
                                   VM.IsPraise = [[array[i] objectForKey:@"IsPraise"] boolValue];
                                   VM.LinkUrl = [array[i] objectForKey:@"LinkUrl"];
                                   //相片
                                   NSArray *tempArray = [array[i] objectForKey:@"ImagesUrl"];
                                   if ([array[i] objectForKey:@"ImagesUrl"] && [tempArray count] > 0) {
                                       VM.ImagesUrl = [array[i] objectForKey:@"ImagesUrl"];
                                   }
                                   // 赞
                                   VM.PraiseCount = [[array[i] objectForKey:@"PraiseCount"] intValue];
                                   
                                   switch (VM.TypeId) {
                                       case 1:
                                       {
                                           VM.Body = [array[i] objectForKey:@"Body"];
                                       }
                                           break;
                                       case 2:
                                       {
                                           VM.Body = [array[i] objectForKey:@"Body"];
                                           VM.Title = [array[i] objectForKey:@"Title"];
                                       }
                                           break;
                                       case 3:
                                       {
                                           VM.Body = [array[i] objectForKey:@"Body"];
                                       }
                                           break;
                                       case 4:
                                       {
                                           VM.Body = [array[i] objectForKey:@"Body"];
                                       }
                                           break;
                                       case 5:
                                       {
                                           VM.Body = [array[i] objectForKey:@"Body"];
                                       }
                                           break;
                                       case 6:
                                       {
                                           VM.Body = [array[i] objectForKey:@"Body"];
                                       }
                                           break;
                                           
                                       default:
                                           break;
                                   }
                                   
                                   // 赞的人数头像
                                   NSArray * PraiseUsersArray = [array[i] objectForKey:@"PraiseUsers"];
                                   if ([PraiseUsersArray count] > 0) {
                                       NSMutableArray *praiseArray = [[NSMutableArray alloc] init];
                                       for (int k = 0; k < [PraiseUsersArray count]; k ++) {
                                           DynamicComments *DC = [[DynamicComments alloc] init];
                                           DC.PictureUrl = [PraiseUsersArray[k] objectForKey:@"PictureUrl"];
                                           [praiseArray addObject:DC];
                                       }
                                       VM.praisePopulationURLs = praiseArray;
                                   }
                                   // 评论
                                   NSArray* comarray = [array[i] objectForKey:@"CommentCentent"];
                                   
                                   if ([comarray count] > 0) {
                                       NSMutableArray* Comments = [[NSMutableArray alloc]init];
                                       for (int j = 0; j < [comarray count]; j ++) {
                                           DynamicComments* dc = [[DynamicComments alloc]  init];
                                           dc.Author = [comarray[j] objectForKey:@"Author"];
                                           dc.Body = [comarray[j] objectForKey:@"Body"];
                                           dc.OwnerId = [[comarray[j] objectForKey:@"OwnerId"] intValue];
                                           dc.ToUserId = [[comarray[j] objectForKey:@"ToUserId"] intValue];
                                           dc.ParentId = [[comarray[j] objectForKey:@"ParentId"] intValue];
                                           dc.ToUserDisplayName = [comarray[j] objectForKey:@"ToUserDisplayName"];
                                           dc.CommenId = [[comarray[j] objectForKey:@"CommenId"] intValue];
                                           [Comments addObject:dc];
                                           
                                       }
                                       VM.CommentCentent = Comments;
                                   }
                                   [myDynamicArray addObject:VM];
                               }
                               if (successBlock) {
                                   successBlock(myDynamicArray);
                               } else{
                                   if (failedBlock) {
                                       failedBlock(@"没有更多的动态了哦！");
                                   }
                               }
                               
                           }
                       } else{
                           if (failedBlock) {
                               failedBlock([data objectForKey:@"msg"]);
                           }
                       }
                       
                   } failed:^(NSString *message) {
                       if (failedBlock) {
                           failedBlock(message);
                       }
                   }];
    
}

#pragma mark -- 我的动态
#pragma mark --
- (void)MyselfTendencyDetails:(NSString *)userId
                       typeId:(NSString *)typeId
                    pageIndex:(int)pageIndex
                      success:(void(^)(NSMutableArray *data))successBlock
                       failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://home.%@/api/GetMyActivity?userId=%@&typeId=%@&pageIndex=%d",
                            aedudomain,userId, typeId,pageIndex];
    NSString * encodedString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)requestUrl, NULL, NULL,  kCFStringEncodingUTF8);
    [self handerGetRequest:encodedString
                parameters:nil
                      body:nil
                   success:^(NSDictionary *data) {
                       NSInteger statusCode = [[data objectForKey:@"st"] intValue];
                       if (statusCode == 0) {
                           NSArray *array = [[data objectForKey:@"msg"] objectForKey:@"list"];
                           NSMutableArray *myDynamicArray = [NSMutableArray arrayWithCapacity:[array count]];
                           if (array && [array count] > 0) {
                               for (int i = 0; i < [array count]; i ++) {
                                   VisitorModel *VM = [[VisitorModel alloc] init];
                                   VM.UserName = [array[i] objectForKey:@"UserName"];
                                   VM.DateTime = [array[i] objectForKey:@"DateTime"];
                                   VM.PictureUrl = [array[i] objectForKey:@"PictureUrl"];
                                   VM.TypeId = [[array[i] objectForKey:@"TypeId"] intValue];
                                   VM.hasImage = [[array[i] objectForKey:@"HasPhoto"] boolValue];
                                   VM.ObjectId = [array[i] objectForKey:@"ObjectId"];
                                   VM.IsPraise = [[array[i] objectForKey:@"IsPraise"] boolValue];
                                   VM.LinkUrl = [array[i] objectForKey:@"LinkUrl"];
                                   //相片
                                   NSArray *tempArray = [array[i] objectForKey:@"ImagesUrl"];
                                   if ([array[i] objectForKey:@"ImagesUrl"] && [tempArray count] > 0) {
                                       VM.ImagesUrl = [array[i] objectForKey:@"ImagesUrl"];
                                   }
                                   // 赞
                                   VM.PraiseCount = [[array[i] objectForKey:@"PraiseCount"] intValue];
                                   
                                   switch (VM.TypeId) {
                                       case 1:
                                       {
                                           VM.Body = [array[i] objectForKey:@"Body"];
                                       }
                                           break;
                                       case 2:
                                       {
                                           VM.Body = [array[i] objectForKey:@"Body"];
                                           VM.Title = [array[i] objectForKey:@"Title"];
                                       }
                                           break;
                                       case 3:
                                       {
                                           VM.Body = [array[i] objectForKey:@"Body"];
                                       }
                                           break;
                                       case 4:
                                       {
                                           VM.Body = [array[i] objectForKey:@"Body"];
                                       }
                                           break;
                                       case 5:
                                       {
                                           VM.Body = [array[i] objectForKey:@"Body"];
                                       }
                                           break;
                                       case 6:
                                       {
                                           VM.Body = [array[i] objectForKey:@"Body"];
                                       }
                                           break;
                                           
                                       default:
                                           break;
                                   }
                                   
                                   // 赞的人数头像
                                   NSArray * PraiseUsersArray = [array[i] objectForKey:@"PraiseUsers"];
                                   if ([PraiseUsersArray count] > 0) {
                                       NSMutableArray *praiseArray = [[NSMutableArray alloc] init];
                                       for (int k = 0; k < [PraiseUsersArray count]; k ++) {
                                           DynamicComments *DC = [[DynamicComments alloc] init];
                                           DC.PictureUrl = [PraiseUsersArray[k] objectForKey:@"PictureUrl"];
                                           [praiseArray addObject:DC];
                                       }
                                       VM.praisePopulationURLs = praiseArray;
                                   }
                                   // 评论
                                   NSArray* comarray = [array[i] objectForKey:@"CommentCentent"];
                                   
                                   if ([comarray count] > 0) {
                                       NSMutableArray* Comments = [[NSMutableArray alloc]init];
                                       for (int j = 0; j < [comarray count]; j ++) {
                                           DynamicComments* dc = [[DynamicComments alloc]  init];
                                           dc.Author = [comarray[j] objectForKey:@"Author"];
                                           dc.Body = [comarray[j] objectForKey:@"Body"];
                                           dc.OwnerId = [[comarray[j] objectForKey:@"OwnerId"] intValue];
                                           dc.ToUserId = [[comarray[j] objectForKey:@"ToUserId"] intValue];
                                           dc.ParentId = [[comarray[j] objectForKey:@"ParentId"] intValue];
                                           dc.ToUserDisplayName = [comarray[j] objectForKey:@"ToUserDisplayName"];
                                           dc.CommenId = [[comarray[j] objectForKey:@"CommenId"] intValue];
                                           [Comments addObject:dc];
                                           
                                       }
                                       VM.CommentCentent = Comments;
                                   }
                                   [myDynamicArray addObject:VM];
                               }
                               if (successBlock) {
                                   successBlock(myDynamicArray);
                               } else{
                                   if (failedBlock) {
                                       failedBlock(@"没有更多的动态了哦！");
                                   }
                               }
                           }
                       } else{
                           if (failedBlock) {
                               failedBlock([data objectForKey:@"msg"]);
                           }
                       }
                   } failed:^(NSString *message) {
                       if (failedBlock) {
                           failedBlock(message);
                       }
                   }];
    
}

#pragma mark -- 教育资讯
#pragma mark --

- (void)educationInformation:(NSString *)count
                     success:(void(^)(NSMutableArray *data))successBlock
                      failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://nmapi.%@/home/GetNewsList?count=%@",
                            aedudomain,count];
    NSString * encodedString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)requestUrl, NULL, NULL,  kCFStringEncodingUTF8);
    [self handerGetRequest:encodedString
                parameters:nil
                      body:nil
                   success:^(NSDictionary *data) {
                       NSInteger statusCode = [[data objectForKey:@"result"] intValue];
                       if (statusCode == 1) {
                           NSArray *array = [data objectForKey:@"items"];
                           NSMutableArray *myDynamicArray = [NSMutableArray arrayWithCapacity:[array count]];
                           if (array && [array count] > 0) {
                               for (int i = 0; i < [array count]; i ++) {
                                   EducationInformation *EI = [[EducationInformation alloc] init];
                                   EI.PublishDate = [array[i] objectForKey:@"PublishDate"];
                                   EI.Detail = [array[i] objectForKey:@"Detail"];
                                   EI.Title = [array[i] objectForKey:@"Title"];
                                   [myDynamicArray addObject:EI];
                                   // 缓存
                                   NSMutableArray * dataArray = [NSMutableArray array];
                                   NSData *data = [NSKeyedArchiver archivedDataWithRootObject:EI];
                                   [dataArray addObject:data];
                                   [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"EducationInformation"];
                               }
                               if (successBlock) {
                                   successBlock(myDynamicArray);
                               }
                           }
                       } else{
                           if (failedBlock) {
                               failedBlock(@"获取教育资讯失败");
                           }
                       }
                   } failed:^(NSString *message) {
                       if (failedBlock) {
                           failedBlock(@"获取教育资讯失败");
                       }
                   }];
    
}

#pragma mark -- 我的班级最新动态
#pragma mark --

- (void)myClassNewTendencyDetails:(NSString *)toKen
                         pageSize:(int)pageSize
                        pageIndex:(int)pageIndex
                          success:(void(^)(NSMutableArray *data))successBlock
                           failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://home.%@/api/GetMyClassActivity?toKen=%@&pageSize=%d&pageIndex=%d",
                            aedudomain,toKen,pageSize,pageIndex];
    NSString * encodedString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)requestUrl, NULL, NULL,  kCFStringEncodingUTF8);
    [self handerGetRequest:encodedString
                parameters:nil
                      body:nil
                   success:^(NSDictionary *data) {
                       NSInteger statusCode = [[data objectForKey:@"st"] intValue];
                       if (statusCode == 0) {
                           NSArray *array = [[data objectForKey:@"msg"] objectForKey:@"list"];
                           NSMutableArray *myDynamicArray = [NSMutableArray arrayWithCapacity:[array count]];
                           if (array && [array count] > 0) {
                               MyClassNewActivity *MN = [[MyClassNewActivity alloc] init];
                               MN.UserName = [array[0] objectForKey:@"UserName"];
                               MN.Body = [array[0] objectForKey:@"Body"];
                               MN.DateTime = [array[0] objectForKey:@"DateTime"];
                               MN.TypeId = [array[0] objectForKey:@"TypeId"];
                               [myDynamicArray addObject:MN];
                               // 缓存
                               NSMutableArray * dataArray = [NSMutableArray array];
                               NSData *data = [NSKeyedArchiver archivedDataWithRootObject:MN];
                               [dataArray addObject:data];
                               [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"myClassNewTendencyDetails"];
                               
                               if (successBlock) {
                                   successBlock(myDynamicArray);
                               }
                           }
                       } else{
                           if (failedBlock) {
                               failedBlock(@"获取不到我的班级最新动态");
                           }
                       }
                       
                   } failed:^(NSString *message) {
                       if (failedBlock) {
                           failedBlock(message);
                       }
                   }];
}

#pragma mark -- 我的班级最新动态
#pragma mark --

- (void)getStudentHomeAndSchoolMessage:(NSString *)uid
                              pageSize:(int)pageSize
                             pageIndex:(int)pageIndex
                               success:(void(^)(NSDictionary *data))successBlock
                                failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://home.%@/Api/GetSMSMessage?userId=%@&userRole=1&pageSize=%d&pageIndex=%d",
                            aedudomain,uid,pageSize,pageIndex];
    NSString * encodedString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)requestUrl, NULL, NULL,  kCFStringEncodingUTF8);
    [self handerGetRequest:encodedString
                parameters:nil
                      body:nil
                   success:^(NSDictionary *data) {
                       NSInteger statusCode = [[data objectForKey:@"st"] intValue];
                       if (statusCode == 0) {
                           if (successBlock) {
                               successBlock(data);
                           }
                       } else{
                           if (failedBlock) {
                               failedBlock(@"未获取到家校消息");
                           }
                       }
                       
                   } failed:^(NSString *message) {
                       if (failedBlock) {
                           failedBlock(message);
                       }
                   }];
}

@end
