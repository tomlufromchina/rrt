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
                
                NSLog(@"The response xml is:%@", dict);
                
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
        
        NSLog(@"The response xml is:%@", dict);
        
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

#pragma mark - login and registe
#pragma mark -
- (void)loginWithUserName:(NSString *)user
             withPassword:(NSString *)password
                  success:(void(^)(Login *login))successBlock
                   failed:(void(^)(NSString *errorMSG))failedBlock;
{
    NSString *url = @"http://passport.aedu.cn/api/login";

    NSString *requestUrl = [NSString stringWithFormat:@"%@?uid=%@&pwd=%@", url, user, password];
    
    [self handerPostRequest:requestUrl parameters:nil body:nil success:^(NSDictionary *data) {
        
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
            
            if (successBlock) {
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

#pragma mark - 注册
#pragma mark -
- (void)registerWithUserName:(NSString *)account
                withPassword:(NSString *)password
                    username:(NSString *)username
                    usertype:(NSString *)usertype
                     success:(void(^)(NSDictionary* data))successBlock
                      failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *url = @"http://passport.aedu.cn/api/register";
    NSString *requestUrl = [NSString stringWithFormat:@"%@?UserAccount=%@&Password=%@&UserName=%@&UserType=%@", url, account, password,username,usertype];
    NSString * encodedString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)requestUrl, NULL, NULL,  kCFStringEncodingUTF8 );

    [self handerPostRequest:encodedString parameters:nil body:nil success:^(NSDictionary *data) {
        NSInteger statusCode = [[data objectForKey:@"status"] intValue];
        if (statusCode == 0) {
            if (successBlock) {
                successBlock(data);
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

#pragma mark - 获取用户角色
#pragma mark -

- (void)getUserOfRole:(NSString *)userId
              success:(void(^)(NSDictionary* data))successBlock
               failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *url = @"http://home.aedu.cn/Api/GetParentId";
    NSString *requestUrl = [NSString stringWithFormat:@"%@?userId=%@", url, userId];
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
    NSString *url = @"http://home.aedu.cn/Api/GetUserTactics";
    NSString *requestUrl = [NSString stringWithFormat:@"%@?token=%@", url, token];
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
             TypeId:(NSString *)TypeId
               File:(NSString *)File
{
    NSString *url = @"http://home.aedu.cn/Api/PostUploadImages";
    NSString *requestUrl = [NSString stringWithFormat:@"%@?UserId=%@&TypeId=%@&File=%@",
                            url, UserId, TypeId, File];
     NSString * encodedString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)requestUrl, NULL, NULL,  kCFStringEncodingUTF8 );
    
    [self handerPostRequest:encodedString parameters:nil body:nil success:^(NSDictionary *data) {
        
    } failed:^(NSString *message) {
        
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
    NSString *url = @"http://home.aedu.cn/Api/GetHomeActivity";
    NSString *requestUrl = [NSString stringWithFormat:@"%@?ToKen=%@&TypeId=%@&GroupId=%@&PageIndex=%d",
                            url, tokenId, typeId, groupId, pageIndex];
    
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
    NSString *url = @"http://home.aedu.cn/Api/GetHomeNewActivity";
    NSString *requestUrl = [NSString stringWithFormat:@"%@?ToKen=%@&TypeId=%@&GroupId=%@&LastActivityId=%@",
                            url, tokenId, typeId, groupId, activityId];
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
    NSString *url = @"http://home.aedu.cn/Api/PostActivityFavorited";
    NSString *requestUrl = [NSString stringWithFormat:@"%@?ToKen=%@&ObjectId=%@&TypeId=%@",
                            url, tokenId, objectId, typeId];
    
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
    NSString *url = @"http://home.aedu.cn/Api/PostActivityForwarded";
    NSString *requestUrl = [NSString stringWithFormat:@"%@?UserId=%@&MicroblogId=%@&Body=%@",
                            url, userId, objectId, body];
    
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
    NSString *url = @"http://home.aedu.cn/Api/PostActivityShare";
    NSString *requestUrl = [NSString stringWithFormat:@"%@?UserId=%@&ActivityId=%@&Body=%@",
                            url, userId, objectId, body];
    
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
    NSString *url = @"http://home.aedu.cn/Api/PostScreenActivity";
    NSString *requestUrl = [NSString stringWithFormat:@"%@?ToKen=%@&ActivityId=%@",
                            url, tokenId, activityId];
    
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
    NSString *url = @"http://home.aedu.cn/Api/PostReportActivity";
    NSString *requestUrl = [NSString stringWithFormat:@"%@?ToKen=%@&ActivityId=%@&Body=%@&TypeId=%d",
                            url, tokenId, activityId, body, type];
    
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
    NSString *url = @"http://interface.aedu.cn/sjrrt/GetMicroBlogById";
    NSString *requestUrl = [NSString stringWithFormat:@"%@?MicroblogId=%@",
                            url, weiboId];
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
    NSString *url = @"http://home.aedu.cn/Api/GetMicroblogComment";
    NSString *requestUrl = [NSString stringWithFormat:@"%@?ToKen=%@&MicroblogId=%@",
                            url, tokenId, weiboId];
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
    NSString *url = @"http://home.aedu.cn/Api/GetMicroblogNewComment";
    NSString *requestUrl = [NSString stringWithFormat:@"%@?MicroblogId=%@&LastCommentId=%@",
                            url, weiboId, lastCommentId];
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
    NSString *url = @"http://home.aedu.cn/Api/GetMicroblogForwarded";
    NSString *requestUrl = [NSString stringWithFormat:@"%@?MicroblogId=%@&PageSize=%d&PageIndex=%d",
                            url, weiboId, pageSize, pageIndex];
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
    NSString *url = @"http://home.aedu.cn/Api/GetMicroblogNewForwarded";
    NSString *requestUrl = [NSString stringWithFormat:@"%@?MicroblogId=%@&LastForwardedId=%@&PageIndex=%d",
                            url, weiboId, lastForwardedId, pageIndex];
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
    NSString *url = @"http://home.aedu.cn/Api/GetMicroblogFavorited";
    NSString *requestUrl = [NSString stringWithFormat:@"%@?MicroblogId=%@&PageIndex=%d",
                            url, weiboId, pageIndex];
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
         HasPhoto:(NSString *)HasPhoto
         ImageUrl:(NSString *)ImageUrl
          success:(void(^)(NSDictionary* data))successBlock
           failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *url = @"http://home.aedu.cn/Api/PostCreateMicroblog";
    
    NSString *requestUrl = nil;
    if (!HasPhoto || !ImageUrl) {
        requestUrl = [NSString stringWithFormat:@"%@?UserId=%@&Body=%@", url, userId,body];
    } else {
        requestUrl = [NSString stringWithFormat:@"%@?UserId=%@&Body=%@&HasPhoto=%@&ImageUrl=%@",
         url, userId,body,HasPhoto,ImageUrl];
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
    NSString *url = @"http://home.aedu.cn/Api/GetActivityBlogThread";
    NSString *requestUrl = [NSString stringWithFormat:@"%@?BlogThreadsId=%@",
                            url, blogId];
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
    NSString *url = @"http://home.aedu.cn/Api/GetBlogThreadsComment";
    NSString *requestUrl = [NSString stringWithFormat:@"%@?BlogThreadsId=%@&pageIndex=%d",
                            url, blogId, pageIndex];
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
    NSString *url = @"http://home.aedu.cn/Api/GetBlogThreadsForwarded";
    NSString *requestUrl = [NSString stringWithFormat:@"%@?BlogThreadsId=%@&pageIndex=%d",
                            url, blogId, pageIndex];
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
    NSString *url = @"http://home.aedu.cn/Api/GetBlogThreadsFavorited";
    NSString *requestUrl = [NSString stringWithFormat:@"%@?BlogThreadsId=%@&pageIndex=%d",
                            url, blogId, pageIndex];
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
    NSString *url = @"http://home.aedu.cn/Api/PostCreateBlogThreads";
    NSString *requestUrl = [NSString stringWithFormat:@"%@?UserId=%@&Subject=%@&Body=%@",
                            url, UserId, pageIndex,Body];
    
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

#pragma mark - Message
#pragma mark -


/*
#pragma mark - Contact
#pragma mark -
//role:  学生1，家长2，老师3，领导4
//type:  家庭1，老师2，同学3，朋友4
- (void)fetchContactFor:(int)type
               withRole:(int)role
              withToken:(NSString *)tokenId
               withUser:(NSString*)userId
                success:(void(^)(NSArray* data))successBlock
                 failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = nil;
    
    if (type == 1) { //家庭
        if (role == 1) {
            requestUrl = [NSString stringWithFormat:
                          @"http://home.aedu.cn/Api/GetParentId?userid=%@", userId];
        } else if (role == 2) {
            requestUrl = [NSString stringWithFormat:
                          @"http://home.aedu.cn/Api/GetStudentId?userid=%@", userId];
        }
    } else if (type == 2) { //老师
        if (role == 1) {
            requestUrl = [NSString stringWithFormat:
                          @"http://home.aedu.cn/Api/GetTeaches?userid=%@", userId];
        } else if (role == 2) {
            requestUrl = [NSString stringWithFormat:
                          @"http://home.aedu.cn/Api/GetTeachesByParent?toKen=%@", tokenId];
        } else if (role == 3 || role == 4) {
            requestUrl = [NSString stringWithFormat:
                          @"http://home.aedu.cn/Api/GetSchoolTeacherByTeacher?toKen=%@", tokenId];
        }
    } else if (type == 3) {//同学
        if (role == 1) {
            requestUrl = [NSString stringWithFormat:
                          @"http://home.aedu.cn/Api/GetClassmateByStudent?toKen=%@", tokenId];
        } else if (role == 2) {
            requestUrl = [NSString stringWithFormat:
                          @"http://home.aedu.cn/Api/GetClassmateByParent?toKen=%@", tokenId];
        } else if (role == 3 || role == 4) {
            requestUrl = [NSString stringWithFormat:
                          @"http://home.aedu.cn/Api/GetClassmateByTeacher?toKen=%@", tokenId];
        }
    } else if (type == 4) {//朋友
        requestUrl = [NSString stringWithFormat:
        @"http://home.aedu.cn/Api/GetFollows?userid=%@&pageindex=1&pagesize=100000", userId];
    }
    
    if (requestUrl) {
        [self handerGetRequest:requestUrl parameters:nil body:nil success:^(NSDictionary *data) {
            NSInteger statusCode = [[data objectForKey:@"st"] intValue];
            if (statusCode == 0) {
                NSDictionary *dict = (NSDictionary*)[data objectForKey:@"msg"];
                if (dict) {
                    NSArray *array = (NSArray *)[dict objectForKey:@"list"];
                    NSMutableArray *contacts = [NSMutableArray arrayWithCapacity:[array count]];
                    for (int i = 0; i < [array count]; i++) {
                        Contact *contact = [[Contact alloc] init];
                        NSDictionary *info = [array objectAtIndex:i];
                        
                        contact.userId = [info objectForKey:@"UserId"];
                        contact.userName = [info objectForKey:@"UserName"];
                        contact.sex = [[info objectForKey:@"Sex"] intValue];
                        contact.school = [info objectForKey:@"Schools"];
                        contact.role = [info objectForKey:@"Roles"];
                        contact.imageUrl = [info objectForKey:@"PictureUrl"];
                        contact.bFollowed = [[info objectForKey:@"IsFollowed"] boolValue];
                        contact.introduction = [info objectForKey:@"Introduction"];
                        contact.followsCount = [[info objectForKey:@"FollowsCount"] intValue];
                        
                        [contacts addObject:contact];
                    }//end for
                    
                    if (successBlock) {
                        successBlock(contacts);
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
}
*/

/*
- (void)fetchContactDetailById:(NSString*)userId
                     withToken:(NSString *)tokenId
                       success:(void(^)(Contact* data))successBlock
                        failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *url = @"http://home.aedu.cn/Api/GetUserById";
    NSString *requestUrl = [NSString stringWithFormat:@"%@?Token=%@&UserId=%@",
                            url, tokenId, userId];
    [self handerGetRequest:requestUrl parameters:nil body:nil success:^(NSDictionary *data) {
        NSInteger statusCode = [[data objectForKey:@"st"] intValue];
        if (statusCode == 0) {
            NSDictionary *dict = (NSDictionary*)[data objectForKey:@"msg"];
            if (dict) {
                NSDictionary *info = (NSDictionary *)[dict objectForKey:@"list"];
                if (info) {
                    Contact *contact = [[Contact alloc] init];
                    
                    contact.userId = [info objectForKey:@"UserId"];
                    contact.userName = [info objectForKey:@"UserName"];
                    contact.sex = [[info objectForKey:@"Sex"] intValue];
                    contact.school = [info objectForKey:@"Schools"];
                    contact.role = [info objectForKey:@"Roles"];
                    contact.imageUrl = [info objectForKey:@"PictureUrl"];
                    contact.bFollowed = [[info objectForKey:@"IsFollowed"] boolValue];
                    contact.introduction = [info objectForKey:@"Introduction"];
                    contact.followsCount = [[info objectForKey:@"FollowsCount"] intValue];
                    
                    if (successBlock) {
                        successBlock(contact);
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
 */

#pragma mark - 点赞
#pragma mark -

- (void)clickPraise:(NSString *)Token
           ObjectId:(NSString *)ObjectId
       ObjectTypeId:(NSString *)ObjectTypeId
             UserId:(NSString *)UserId
           UserName:(NSString *)UserName
            success:(void(^)(NSDictionary* data))successBlock
             failed:(void(^)(NSString *errorMSG))failedBlock
{
    
    NSString *url = @"http://interface.aedu.cn/sjrrt/ClickPraseAct";
    NSString *requestUrl = [NSString stringWithFormat:@"%@?Token=%@&ObjectId=%@&ObjectTypeId=%@&UserId=%@&UserName=%@",
                            url, Token, ObjectId, ObjectTypeId , UserId, UserName];
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

- (void)clickComment:(NSString *)CommentedObjectId
              UserId:(NSString *)UserId
                Body:(NSString *)Body
              TypeId:(NSString *)TypeId
             success:(void(^)(NSDictionary* data))successBlock
              failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *url = @"http://home.aedu.cn/Api/PostReplyComments";
    NSString *requestUrl = [NSString stringWithFormat:@"%@?CommentedObjectId=%@&UserId=%@&Body=%@&TypeId=%@",
                            url, CommentedObjectId, UserId, Body , TypeId];
    //URL汉字转码：
    NSString * encodedString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)requestUrl, NULL, NULL,  kCFStringEncodingUTF8 );
    [self handerPostRequest:encodedString parameters:nil body:nil success:^(NSDictionary *data) {
        NSInteger statusCode = [[data objectForKey:@"st"] intValue];
        if (statusCode == 0) {
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
    NSString *url = @"http://interface.aedu.cn/sjrrt/AddDynComment";
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@?Token=%@&CommentedObjectId=%@&OwnerId=%@&UserId=%@&Author=%@&subject=%@&body=%@",
                      url, Token, CommentedObjectId, OwnerId, UserId, Author, subject, body];
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
    NSString *url = @"http://interface.aedu.cn/sjrrt/AddDynComment";
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@?Token=%@&CommentedObjectId=%@&OwnerId=%@&UserId=%@&Author=%@&subject=%@&body=%@&ToUserId=%@&ToUserName=%@",
                            url, Token, CommentedObjectId, OwnerId, UserId, Author, subject, body, ToUserId, ToUserName];
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

- (void)clickReply:(NSString *)CommentedObjectId
            UserId:(NSString *)UserId
              Body:(NSString *)Body
            TypeId:(NSString *)TypeId
          ParentId:(NSString *)ParentId
           success:(void(^)(NSDictionary* data))successBlock
            failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *url = @"http://home.aedu.cn/Api/PostReplyComments";
    NSString *requestUrl = [NSString stringWithFormat:@"%@?CommentedObjectId=%@&UserId=%@&Body=%@&TypeId=%@&ParentId=%@",
                            url, CommentedObjectId, UserId, Body ,TypeId,ParentId];
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
    NSString *url = @"http://interface.aedu.cn/sjrrt/GetPraseSummary";
    NSString *requestUrl = [NSString stringWithFormat:@"%@?ObjectId=%@",
                            url, ObjectId];
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
    NSString *url = @"http://interface.aedu.cn/sjrrt/SetForbidVisitSpace";
    NSString *requestUrl = [NSString stringWithFormat:@"%@?Token=%@&VUserId=%@&OUserId=%@&IsForbid=%@",
                            url, Token, VUserId, OUserId, IsForbid];
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
    NSString *url = @"http://interface.aedu.cn/sjrrt/SetPBActivities";
    NSString *requestUrl = [NSString stringWithFormat:@"%@?Token=%@&VUserId=%@&OUserId=%@&OUserName=%@&IsPb=%@",
                            url, Token, VUserId, OUserId, OUserName,IsPb];
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
    NSString *url = @"http://interface.aedu.cn/sjrrt/GetUserSpacePower";
    NSString *requestUrl = [NSString stringWithFormat:@"%@?vuserid=%@&OUserId=%@",
                            url, vuserid,OUserId];
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
    NSString *url = @"http://interface.aedu.cn/sjrrt/CancelFriends";
    NSString *requestUrl = [NSString stringWithFormat:@"%@?Token=%@&FriendUserId=%@",
                            url, Token,FriendUserId];
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

- (void)addFriends:(NSString *)Token
            UserId:(NSString *)UserId
      SenderUserId:(NSString *)SenderUserId
            Sender:(NSString *)Sender
         InviteTxt:(NSString *)InviteTxt
           success:(void(^)(NSDictionary* data))successBlock
            failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *url = @"http://interface.aedu.cn/sjrrt/addfriendapply";
    NSString *requestUrl = [NSString stringWithFormat:@"%@?Token=%@&UserId=%@&SenderUserId=%@&Sender=%@&InviteTxt=%@",
                            url, Token, UserId, SenderUserId, Sender,InviteTxt];
    //带汉字编码
    NSString * encodingString = [requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    请求后，返回的数据，如何显示的是这样的格式：%3A%2F%2F，此时需要我们进行UTF-8解码，用到的方法是：
//    NSString *str = [model.album_name stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
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

#pragma mark - 好友动态
#pragma mark -

- (void)friendsDynamicDetail:(NSString *)UserId pageIndex:(int)pageIndex pageSize:(int)pageSize
                     success:(void(^)(NSMutableArray *friendDynamic))successBlock
                      failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *url = @"http://interface.aedu.cn/sjrrt/GetMyMobileTimeline";
    NSString *requestUrl = [NSString stringWithFormat:@"%@?UserId=%@&pageIndex=%d&pageSize=%d",
                            url, UserId,pageIndex,pageSize];
    
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
- (void)personalDataWithDetail:(NSString *)vuserid
                        OUserId:(NSString *)OUserId
                       success:(void(^)(NdividualData *ndividual))successBlock
                        failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *url = @"http://interface.aedu.cn/sjrrt/GetUserInfoBySJ";
    NSString *requestUrl = [NSString stringWithFormat:@"%@?vuserid=%@&OUserId=%@",
                            url, vuserid, OUserId];
    
    [self handerGetRequest:requestUrl parameters:nil body:nil success:^(NSDictionary *data) {
        NSInteger statusCode = [[data objectForKey:@"st"] intValue];
        if (statusCode == 0) {
            NSArray *dict = (NSArray *)[data objectForKey:@"msg"];
            NSLog(@"dict=%@",dict);//数组
            NdividualData *ndividual = [[NdividualData alloc] init];
            ndividual.NickName = [dict[0] objectForKey:@"NickName"];
            ndividual.TrueName = [dict[0] objectForKey:@"TrueName"];
            ndividual.SchoolName = [dict[0] objectForKey:@"SchoolName"];
            if ([ndividual.SchoolName isKindOfClass:[NSNull class]]) {
                ndividual.SchoolName = nil;
            }
            ndividual.NowAreaName = [dict[0] objectForKey:@"NowAreaName"];
            ndividual.NowAreaCode = [dict[0] objectForKey:@"NowAreaCode"];
            ndividual.PicInfo = [dict[0] objectForKey:@"PicInfo"];
            if ([ndividual.PicInfo isKindOfClass:[NSNull class]]) {
                ndividual.SchoolName = nil;
            }else{
                NSString *photos = [dict[0] objectForKey:@"PicInfo"];
                //于“,”分割放进数组里
                NSArray *array2 = [photos componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]];
                NSMutableArray *ImageAddress = [NSMutableArray array];
                for (int i = 0; i < [array2 count]; i ++) {
                    NSArray *array = [array2[i] componentsSeparatedByString:@"|"];
//                    NSLog(@"%@",array[2]);//取出图片地址
                    ndividual.photoID = array[0];//相片ID
                    ndividual.albumID = array[1];//相册id
                    [ImageAddress addObject:array[2]];
                }
                ndividual.photoAddress = [NSMutableArray arrayWithArray:ImageAddress];
                NSLog(@"%@",ndividual.photoAddress);
            
            }
            
            ndividual.UserAccount = [dict[0] objectForKey:@"UserAccount"];
            if ([ndividual.UserAccount isKindOfClass:[NSNull class]]) {
                ndividual.UserAccount = nil;
            }
            ndividual.isFriend = [[dict[0] objectForKey:@"isFriend"] boolValue];
            ndividual.UserId = [dict[0] objectForKey:@"UserId"];
            ndividual.parentName = [dict [0] objectForKey:@"ParentName"];
            
            if ([ndividual.parentName isKindOfClass:[NSNull class]]) {
                ndividual.parentName = nil;
            }
            ndividual.LatestNews = [dict[0] objectForKey:@"LatestNews"];
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

#pragma mark - 联系人列表
#pragma mark -
- (void)AddressBookDetail:(NSString *)Token
                  success:(void(^)(NSDictionary *data))successBlock
                   failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *url = @"http://interface.aedu.cn/sjrrt/GetMyTalkObjList";
    NSString *requestUrl = [NSString stringWithFormat:@"%@?Token=%@",url, Token];
    
    [self handerGetRequest:requestUrl parameters:nil body:nil success:^(NSDictionary *data) {
        NSInteger statusCode = [[data objectForKey:@"result"] intValue];
        if (statusCode == 0) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
#if 0
            //公众号
            NSArray *gzObj = (NSArray*)[data objectForKey:@"resultGZ"];
            if (gzObj) {
                NSMutableArray *gzArray = [NSMutableArray array];
                
                for (int i = 0; i < [gzObj count]; i++) {
                    NSDictionary *gzDict = [gzObj objectAtIndex:i];
                    
                    Contact *contact = [[Contact alloc] init];
                    contact.face = [gzDict objectForKey:@"Face"];
                    contact.contactId = [gzDict objectForKey:@"Id"];
                    contact.name = [gzDict objectForKey:@"Name"];
                    contact.py = [gzDict objectForKey:@"PY"];
                    contact.objType = [gzDict objectForKey:@"objType"];
                    
                    contact.avatarUrl = [NSString stringWithFormat:@"%@%@%@?lq=123456",appHeadImage,contact.contactId,@".jpg"];
                    //                contact.avatarUrl = [NSString stringWithFormat:@"%@%@%@",appHeadImage,[gzDict objectForKey:@"Face"],@".jpg"];
                    //                NSLog(@"********-----%@",contact.avatarUrl);
                    //将对象添加进数组
                    [gzArray addObject:contact];
                    //                NSLog(@"********:%@",gzDict);
                }
                
                [dict setObject:gzArray forKey:@"GZ"];
                
            }
            //群聊
            gzObj = (NSArray*)[data objectForKey:@"resultQL"];
            if (gzObj) {
                NSMutableArray *gzArray = [NSMutableArray array];
                
                for (int i = 0; i < [gzObj count]; i++) {
                    NSDictionary *gzDict = [gzObj objectAtIndex:i];
                    
                    Contact *contact = [[Contact alloc] init];
                    contact.face = [gzDict objectForKey:@"Face"];
                    contact.contactId = [gzDict objectForKey:@"Id"];
                    contact.name = [gzDict objectForKey:@"Name"];
                    contact.py = [gzDict objectForKey:@"PY"];
                    contact.objType = [gzDict objectForKey:@"objType"];
                    contact.avatarUrl = [NSString stringWithFormat:@"%@%@%@?lq=123456",appHeadImage,contact.contactId,@".jpg"];
                    //                contact.avatarUrl = [NSString stringWithFormat:@"%@%@%@",appHeadImage,[gzDict objectForKey:@"Face"],@".jpg"];
                    //                NSLog(@"********-----%@",contact.avatarUrl);
                    
                    [gzArray addObject:contact];
                }
                
                [dict setObject:gzArray forKey:@"QL"];
                
            }
            //分组
            gzObj = (NSArray*)[data objectForKey:@"resultFZ"];
            if (gzObj) {
                NSMutableArray *gzArray = [NSMutableArray array];
                
                for (int i = 0; i < [gzObj count]; i++) {
                    NSDictionary *gzDict = [gzObj objectAtIndex:i];
                    
                    Contact *contact = [[Contact alloc] init];
                    contact.face = [gzDict objectForKey:@"Face"];
                    contact.contactId = [gzDict objectForKey:@"Id"];
                    contact.name = [gzDict objectForKey:@"Name"];
                    contact.py = [gzDict objectForKey:@"PY"];
                    contact.objType = [gzDict objectForKey:@"objType"];
                    contact.avatarUrl = [NSString stringWithFormat:@"%@%@%@?lq=123456",appHeadImage,contact.contactId,@".jpg"];
                    //                contact.avatarUrl = [NSString stringWithFormat:@"%@%@%@",appHeadImage,[gzDict objectForKey:@"Face"],@".jpg"];
                    
                    [gzArray addObject:contact];
                }
                
                [dict setObject:gzArray forKey:@"FZ"];
                
            }
#endif
            //好友
            NSArray *firends = (NSArray*)[data objectForKey:@"resultHY"];
            if (firends) {
                NSMutableArray *allKey = [[NSMutableArray alloc] initWithCapacity:26];
                
                NSMutableDictionary *friendsDictionary = [[NSMutableDictionary alloc] init];
                //解析数据(personMSG)，将所有的数据进行分类，放入字典中
                for (int i = 0 ; i < firends.count; i++) {
                    
                    NSDictionary *contactDict = [firends objectAtIndex:i];
                    
                    Contact *contact = [[Contact alloc] init];
                    contact.face = [contactDict objectForKey:@"Face"];
                    contact.contactId = [contactDict objectForKey:@"Id"];
                    contact.name = [contactDict objectForKey:@"Name"];
                    contact.py = [contactDict objectForKey:@"PY"];
                    contact.objType = [contactDict objectForKey:@"objType"];
                    contact.avatarUrl = [NSString stringWithFormat:@"%@%@%@?lq=123456",appHeadImage,contact.contactId,@".jpg"];
                    //                contact.avatarUrl = [NSString stringWithFormat:@"%@%@%@",appHeadImage,[contactDict objectForKey:@"Face"],@".jpg"];
                    //取出A-Z作为key
                    NSString *firstLetter = [firends[i] valueForKey:@"PY"];
                    
                    NSMutableArray *array = friendsDictionary[firstLetter];
                    if (array == nil) {
                        
                        NSMutableArray *personNameArray = [[NSMutableArray alloc] initWithObjects:contact, nil];
                        
                        [friendsDictionary setObject:personNameArray forKey:firstLetter];
                    }else{
                        [array addObject:contact];
                    }
                    NSLog(@"********%@",array);
                    
                }
                
                [allKey addObjectsFromArray:[[friendsDictionary allKeys] sortedArrayUsingSelector:@selector(compare:)]];
                
                [dict setObject:friendsDictionary forKey:@"HY"];
            }
            
            if (successBlock) {
                successBlock(dict);
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
    NSString *url = @"http://home.aedu.cn/api/GetMicroblogByUserId";
    NSString *requestUrl = [NSString stringWithFormat:@"%@?UserId=%@&PageIndex=%d",url,UserId,PageIndex];
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


#pragma mark - 相册列表
#pragma mark -

- (void)photoList:(NSString *)ToKen
           UserId:(NSString *)UserId
         PageSize:(int)PageSize
        PageIndex:(int)PageIndex
          success:(void(^)(NSArray *photoListArray))successBlock
           failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *url = @"http://home.aedu.cn/Api/GetAlbumList";
    NSString *requestUrl = [NSString stringWithFormat:@"%@?ToKen=%@&UserId=%@&PageSize=%d&PageIndex=%d",url,ToKen,UserId,PageSize,PageIndex];
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
    NSString *url = @"http://home.aedu.cn/api/PostDeletePhoto";
    
    NSMutableString *photoIdStr = [NSMutableString string];
    for (int i = 0; i < [photoIds count]; i++) {
        [photoIdStr appendString:[photoIds objectAtIndex:i]];
        if (i != [photoIds count] - 1) {
            [photoIdStr appendString:@","];
        }
    }
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@?ToKen=%@&PhotoIdStr=%@",url,token,photoIdStr];
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
    NSString *url = @"http://home.aedu.cn/Api/GetPhotoList";
    NSString *requestUrl = [NSString stringWithFormat:@"%@?ToKen=%@&UserId=%@&AlbumId=%@&PageSize=%d&PageIndex=%d",url,ToKen,UserId,AlbumId,PageSize,PageIndex];
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
    NSString *url = @"http://home.aedu.cn/Api/PostCreateAlbums";
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@?UserId=%@&AlbumsName=%@",url,UserId,AlbumsName];
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
    NSString *url = @"http://interface.aedu.cn/sjrrt/myLastestPhotosAndAttachPic";
    NSString *requestUrl = [NSString stringWithFormat:@"%@?Token=%@&pageIndex=%d&pageSize=%d&TopCount=%d",url,Token,pageIndex,pageSize,TopCount];
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
                                if (photosArray && [photosArray count] > 0) {
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
    NSString *url = @"http://interface.aedu.cn/sjrrt/GetMyPersonTimeLine";
    NSString *requestUrl = [NSString stringWithFormat:@"%@?UserId=%@&typeId=%d&PageIndex=%d&PageSize=%d",url,UserId,typeId,PageIndex,PageSize];
    NSString * encodingString = [requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self handerGetRequest:encodingString parameters:nil body:nil success:^(NSDictionary *data) {
        NSInteger statusCode = [[data objectForKey:@"st"] intValue];
        if (statusCode == 0) {
//            MyDynamic *Md = [[MyDynamic alloc] init];
            NSArray *array = [data objectForKey:@"msg"];
            if ([array count] > 0) {
                NSMutableArray *myDynamicArray = [NSMutableArray arrayWithCapacity:[array count]];
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

#pragma mark - 微博详情
#pragma mark -
- (void)weiboDetail:(NSString *)MicroblogId
            success:(void(^)(NSArray *micArray))successBlock
             failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *url = @"http://interface.aedu.cn/sjrrt/GetMicroBlogById";
    NSString *requestUrl = [NSString stringWithFormat:@"%@?MicroblogId=%@",url, MicroblogId];
    
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
    NSString *url = @"http://home.aedu.cn/api/GetBlogThreadByUserId";
    NSString *requestUrl = [NSString stringWithFormat:@"%@?Token=%@&UserId=%@&PageIndex=%d&PageSize=%d",url, Token,UserId,PageIndex,PageSize];
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
    NSString *url = @"http://interface.aedu.cn/sjrrt/GetBlogThreadsById";
    NSString *requestUrl = [NSString stringWithFormat:@"%@?ThreadId=%@",url, ThreadId];
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
- (void)newFriends:(NSString *)Token
            typeId:(NSString *)typeId
         pageIndex:(int)pageIndex
          pageSize:(int)pageSize
           success:(void(^)(NSArray *newFriend))successBlock
            failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *url = @"http://interface.aedu.cn/sjrrt/GetParBindMessage";
    NSString *requestUrl = [NSString stringWithFormat:@"%@?Token=%@&Type=%@&pageIndex=%d&pageSize=%d",url, Token,typeId,pageIndex,pageSize];
    [self handerGetRequest:requestUrl parameters:nil body:nil success:^(NSDictionary *data) {
        NSInteger statusCode = [[data objectForKey:@"st"] intValue];
        if (statusCode == 1) {
            NSArray *array = [data valueForKey:@"msg"];
            NSMutableArray *friendsArray = [NSMutableArray arrayWithCapacity:[array count]];
            
            for (int i = 0; i < array.count; i++) {
                NSDictionary *dict = array[i];
                NewFriends *friend = [[NewFriends alloc] init];
                friend.InvitationId = [dict valueForKey:@"InvitationId"];
                friend.dateTime = [dict valueForKey:@"CreateTimeStr"];
                friend.SenderUserName = [dict valueForKey:@"FromUserName"];
                friend.userId = [dict valueForKey:@"ToUserId"];
                friend.userName = [dict valueForKey:@"ToUserName"];
                friend.SenderPictureUrl = [NSString stringWithFormat:@"%@%@%@",appHeadImage,[dict valueForKey:@"FromUserId"],@".jpg"];
                friend.body = [dict valueForKey:@"ValidTxt"];
                if ([friend.body isKindOfClass:[NSNull class]]) {
                    friend.body = @"";
                }
                friend.IsFollows = [dict valueForKey:@"DealStatus"];
                friend.SenderUserId = [dict valueForKey:@"FromUserId"];
                friend.Type = [dict valueForKey:@"Type"];
                friend.Id = [dict valueForKey:@"Id"];
                
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
    NSString *url = @"http://home.aedu.cn/Api/PostAcceptInvitation";
    NSString *requestUrl = [NSString stringWithFormat:@"%@?InvitationId=%@",url, InvitationId];
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
    NSString *url = @"http://interface.aedu.cn/sjrrt/AcceptBinding";
    NSString *requestUrl = [NSString stringWithFormat:@"%@?Token=%@&Type=%@&ChildrenUserId=%@",url, Token,Type,ChildrenUserId];
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
    NSString *url = @"http://interface.aedu.cn/sjrrt/GetUserInfoBySJ_Search";
    NSString *requestUrl = [NSString stringWithFormat:@"%@?Token=%@&UserOrEmailName=%@",url,Token,ParUserAccount];
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
            detail.UserId = [array[0] objectForKey:@"UserId"];
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
    NSString *url = @"http://interface.aedu.cn/sjrrt/BindParent_Search";
    NSString *requestUrl = [NSString stringWithFormat:@"%@?Token=%@&ParUserAccount=%@",url,Token,ParUserAccount];
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

#pragma mark - 绑定家长发送
#pragma mark -

- (void)FamilySendValidation:(NSString *)Token
              ParUserAccount:(NSString *)ParUserAccount
                    ValidTxt:(NSString *)ValidTxt
                     success:(void(^)(NSDictionary* data))successBlock
                      failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *url = @"http://interface.aedu.cn/sjrrt/BindParent_Apply";
    NSString *requestUrl = [NSString stringWithFormat:@"%@?Token=%@&ParUserAccount=%@&ValidTxt=%@",url,Token,ParUserAccount,ValidTxt];
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

#pragma mark - 上传IM产生的语音文件或者图片 multipart/form-data方式
#pragma mark -
//ASIFormDataRequest方式 POST上传图片
//- (void)uploadFile:(NSString*)filePath
//           success:(void(^)(NSDictionary *data))successBlock
//            failed:(void(^)(NSString *errorMSG))failedBlock
//{
//    
////    NSDictionary *tempDic=nil;
//    
//    NSString *url=[NSString stringWithFormat:@"http://nmapi.aedu.cn/MobilePush/PostMessageFileForSJ"];
//    
//    NSDictionary *sugestDic = [NSDictionary dictionaryWithObjectsAndKeys:
//                               @"Token", [RRTManager manager].loginManager.loginInfo.tokenId,
//                               nil];
//    
//    
//    //分界线的标识符
//    NSString *TWITTERFON_FORM_BOUNDARY = @"AaB03x";
//    //分界线 --AaB03x
//    NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
//    //结束符 AaB03x--
//    NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
//
//    
//    NSData *data = [NSData dataWithContentsOfFile:filePath];
//    //http body的字符串
//    NSMutableString *body=[[NSMutableString alloc]init];
//    //参数的集合的所有key的集合
//    NSArray *keys= [sugestDic allKeys];
//    
//    //遍历keys
//    for(int i = 0; i < [keys count]; i++)
//    {
//        //得到当前key
//        NSString *key=[keys objectAtIndex:i];
//        //如果key不是pic，说明value是字符类型，比如name：Boris
//        if(![key isEqualToString:@"file"])
//        {
//            //添加分界线，换行
//            [body appendFormat:@"%@\r\n",MPboundary];
//            //添加字段名称，换2行
//            [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
//            //添加字段的值
//            [body appendFormat:@"%@\r\n",[sugestDic objectForKey:key]];
//        }
//    }
//
//    if (data) {
//        ////添加分界线，换行
//        [body appendFormat:@"%@\r\n",MPboundary];
//        //声明pic字段，文件名为boris.png
//        [body appendFormat:@"Content-Disposition: form-data; name=\"file\"; filename=\"%@\"\r\n", @"boris.png"];
//        //声明上传文件的格式
//        [body appendFormat:@"Content-Type: image/png\r\n\r\n"];
//    }
//    
//    //声明结束符：--AaB03x--
//    NSString *end=[[NSString alloc]initWithFormat:@"\r\n%@",endMPboundary];
//    //声明myRequestData，用来放入http body
//    NSMutableData *myRequestData=[NSMutableData data];
//    //将body字符串转化为UTF8格式的二进制
//    [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
//    //将image的data加入
//    [myRequestData appendData:[@"123" dataUsingEncoding:NSUTF8StringEncoding]];
//    //加入结束符--AaB03x--
//    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
//    //设置HTTPHeader中Content-Type的值
//    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
//    
//    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    [dict setObject:content forKey:@"Content-Type"];
//    [dict setObject:[NSString stringWithFormat:@"%d", [myRequestData length]] forKey:@"Content-Length"];
//    
//    [self handerPostRequest:url parameters:dict body:myRequestData success:^(NSDictionary *data) {
//        if (successBlock) {
//            successBlock(data);
//        }
//    } failed:^(NSString *message) {
//        if (failedBlock) {
//            failedBlock(message);
//        }
//    }];
//}

@end
