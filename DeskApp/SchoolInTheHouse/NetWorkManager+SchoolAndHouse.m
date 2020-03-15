//
//  NetWorkManager+SchoolAndHouse.m
//  RenrenTong
//
//  Created by 符其彬 on 14-10-22.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "NetWorkManager+SchoolAndHouse.h"
#import "AFNetworking.h"
#import "AFHTTPRequestOperationManager.h"
#import "ISingHTTPRequestOperationManager.h"

@implementation NetWorkManager(SchoolAndHouse)

//Get 放入后台线程
-(void)requestGetWithUrl:(NSString*)url requestDone:(SEL)requestDone{
    BaseRequest* baseRequest=[[BaseRequest alloc] init];
    baseRequest.url=url;
    baseRequest.sel=requestDone;
    [self performSelectorInBackground:@selector(requestGetWithBaseRequest:) withObject:baseRequest];
}
//Post 放入后台线程
-(void)requestPostWithUrl:(NSString*)url postdata:(NSMutableArray*)postdata requestDone:(SEL)requestDone{
    BaseRequest* baseRequest=[[BaseRequest alloc] init];
    baseRequest.url=url;
    baseRequest.postdata=postdata;
    baseRequest.sel=requestDone;
    [self performSelectorInBackground:@selector(requestPostWithBaseRequest:) withObject:baseRequest];
}

//Get 后台线程同步get请求
-(void)requestGetWithBaseRequest:(BaseRequest*)baseRequest{
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:baseRequest.url]];
    request.Done=baseRequest.sel;
    [request setDelegate:self];
    if ([self isValidNetWork]) {
        [request startSynchronous];
    }
}
//Post 后台线程同步post请求
-(void)requestPostWithBaseRequest:(BaseRequest*)baseRequest{
    ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:[NSURL URLWithString:baseRequest.url]];
    request.Done=baseRequest.sel;
    if (baseRequest.postdata!=nil&&[baseRequest.postdata count]>0) {
        for (NSMutableDictionary *dic in baseRequest.postdata) {
            for(NSString * akey in dic)
            {
                [request setPostValue:[dic objectForKey:akey] forKey:akey];
            }
        }
    }
    [request setDelegate:self];
    if ([self isValidNetWork]) {
        [request startSynchronous];
    }
}

#pragma mark 网络判断

-(BOOL)isValidNetWork{
    Reachability *  wStatus = [Reachability reachabilityWithHostName:@"www.apple.com"];
    if ([wStatus currentReachabilityStatus] == NotReachable) {//这是没有网络 的情况
        return NO;
    }else {
        return YES;
    }
}

// 新本家校沟通:
#pragma mark -- 教师发送记录

- (void)theTeacherSendRecords:(NSString *)userID
                        Token:(NSString *)Token
                     pageSize:(int)pageSize
                    pageIndex:(int)pageIndex
                      success:(void (^)(NSMutableArray *data))successBlock
                       failed:(void (^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://nmapi.%@/Push/GetUserSendMessage?userId=%@&Token=%@&pageSize=%d&pageIndex=%d", aedudomain,userID,Token,pageSize,pageIndex];
    NSString * encodedString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)requestUrl, NULL, NULL,  kCFStringEncodingUTF8 );
    [self handerGetRequest:encodedString
                parameters:nil
                      body:nil
                   success:^(NSDictionary *data) {
                       NSInteger statusCode = [[data objectForKey:@"result"] intValue];
                       if (statusCode == 0) {
                           NSArray *array = [data objectForKey:@"msg"];
                           NSMutableArray *myRecordsArray = [NSMutableArray arrayWithCapacity:[array count]];
                           if (array && [array count] > 0 ) {
                               for (int i = 0; i < [array count]; i ++) {
                                   TheTeacherSendRecords *TTSR = [[TheTeacherSendRecords alloc] init];
                                   TTSR.PubUserName = [array[i] objectForKey:@"PubUserName"];
                                   TTSR.MsgContent = [array[i] objectForKey:@"MsgContent"];
                                   TTSR.PubTime = [array[i] objectForKey:@"PubTime"];
                                   TTSR.SendType = [array[i] objectForKey:@"SendType"];
                                   TTSR.MsgType = [NSString stringWithFormat:@"%@",[array[i] objectForKey:@"MsgType"]];
                                   TTSR.ObjectId = [array[i] objectForKey:@"ObjectId"];
                                   TTSR.PubUserId = [array[i] objectForKey:@"PubUserId"];
                                   TTSR.CreateTimeFormat = [array[i] objectForKey:@"CreateTimeFormat"];
                                   if (![[array[i] objectForKey:@"Audioes"] isKindOfClass:[NSNull class]] )
                                   {
                                       TTSR.Audioes = [array[i] objectForKey:@"Audioes"];
 
                                   }
                                   if (![[array[i] objectForKey:@"Pictures"] isKindOfClass:[NSNull class]]) {
                                       TTSR.Pictures = [array[i] objectForKey:@"Pictures"];
                                   }
                                   if (![[array[i] objectForKey:@"Files"] isKindOfClass:[NSNull class]]) {
                                       TTSR.Files = [array[i] objectForKey:@"Files"];
                                   }

                                   TTSR.IsRead = [[array[i] objectForKey:@"IsRead"] boolValue];
                                   [myRecordsArray addObject:TTSR];
                               }
                               if (successBlock) {
                                   successBlock(myRecordsArray);
                               }
                           } else{
                               if (successBlock) {
                                   failedBlock(@"获取对应数据失败！");
                               }
                           }
                       } else{
                           if (successBlock) {
                               failedBlock(@"获取对应数据失败！");
                           }
                       }
                       
                   } failed:^(NSString *message) {
                       if (successBlock) {
                           failedBlock(@"获取对应数据失败！");
                       }
                   }];
    
}

#pragma mark -- 获取老师担当的角色
- (void)getTeacherRole:(NSString *)Token
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

#pragma mark - 获取自己受到的短信记录
#pragma mark -

- (void)getMessageCounts:(NSString *)Token
                  userId:(NSString *)userId
                userRole:(NSString *)userRole
             messageType:(int)messageType
                pageSize:(int)pageSize
               pageIndex:(int)pageIndex
                 success:(void(^)(NSMutableArray* data))successBlock
                  failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://nmapi.%@/Push/GetUserAllMessage?Token=%@&userId=%@&userRole=%@&pageSize=%d&pageIndex=%d", aedudomain, Token,userId,userRole,pageSize,pageIndex];
    NSString * encodedString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)requestUrl, NULL, NULL,  kCFStringEncodingUTF8 );
    
    [self handerGetRequest:encodedString parameters:nil body:nil success:^(NSDictionary *data) {
        NSInteger statusCode = [[data objectForKey:@"result"] intValue];
        if (statusCode == 0) {
            NSMutableArray *array = (NSMutableArray *)[data objectForKey:@"msg"];
            if (array && [array count] > 0) {
                NSMutableArray *getMessageArray = [NSMutableArray arrayWithCapacity:[array count]];
                for (int i = 0; i < [array count]; i ++) {
                    
                    GetMessage *GM = [[GetMessage alloc] init];
                    GM.BatchSerial = [[array[i] objectForKey:@"BatchSerial"] intValue];
                    GM.SchoolId = [[array[i] objectForKey:@"SchoolId"] intValue];
                    GM.PubUserId = [[array[i] objectForKey:@"PubUserId"] intValue];
                    GM.PubUserType = [[array[i] objectForKey:@"PubUserType"] intValue];
                    GM.SendScope = [[array[i] objectForKey:@"SendScope"] intValue];
                    GM.UserRole = [[array[i] objectForKey:@"UserRole"] intValue];
                    GM.MsgCount = [[array[i] objectForKey:@"MsgCount"] intValue];
                    GM.ObjectCount = [[array[i] objectForKey:@"ObjectCount"] intValue];
                    GM.UserCount = [[array[i] objectForKey:@"UserCount"] intValue];
                    GM.PublishUserCount = [[array[i] objectForKey:@"PublishUserCount"] intValue];
                    GM.MsgType = [[array[i] objectForKey:@"MsgType"] intValue];
                    GM.SendType = [[array[i] objectForKey:@"SendType"] intValue];
                    GM.StatusId = [[array[i] objectForKey:@"StatusId"] intValue];GM.UserScopeProperty = [[array[i] objectForKey:@"UserScopeProperty"] intValue];
                    GM.PublishResult = [[array[i] objectForKey:@"PublishResult"] intValue];
                    
                    GM.BatchId = [array[i] objectForKey:@"BatchId"];
                    GM.SchoolName = [array[i] objectForKey:@"SchoolName"];
                    GM.MsgContent = [array[i] objectForKey:@"MsgContent"];
                    GM.CreateBy = [array[i] objectForKey:@"CreateBy"];
//                    // 过滤
//                    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"@/:;()¥「」＂、[]{}#%-*+=_\\|~＜＞$€^•'@#$%^&*()_+'\""];
//                    NSString *String = [array[i] objectForKey:@"CreateTime"];
//                    NSString *trimmedString = [String stringByTrimmingCharactersInSet:set];
//                    NSString *newStr = [trimmedString stringByReplacingOccurrencesOfString:@"(" withString:@""];
//                    NSString *newwStr = [newStr stringByReplacingOccurrencesOfString:@"Date" withString:@""];
//                    NSString *b = [newwStr substringToIndex:10];
//                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//                    NSDate*confromTimesp = [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)[b intValue]];
//                    [formatter setDateFormat:@"yyyy年-MM月-dd日"];
//                    NSString *newStr1 = [formatter stringFromDate:confromTimesp];
                    GM.CreateTime = [array[i] objectForKey:@"CreateTimeFormat"];
                    GM.PubUserName = [array[i] objectForKey:@"PubUserName"];
                    [getMessageArray addObject:GM];
                    
                }
                if (successBlock) {
                    successBlock(getMessageArray);
                }
            } else {
                if (failedBlock) {
                    failedBlock(@"没有短信！");
                }
            }
            
        } else{
            if (failedBlock) {
                failedBlock(@"暂无数据...");
            }
        }
        
    } failed:^(NSString *message) {
        failedBlock(@"暂无数据...");
    }];
    
}

#pragma mark - 获取自己发送的短信记录
#pragma mark -

- (void)getMyselfMessageCounts:(NSString *)Token
                        userId:(NSString *)userId
                      pageSize:(int)pageSize
                     pageIndex:(int)pageIndex
                       success:(void(^)(NSMutableArray* data))successBlock
                        failed:(void(^)(NSString *errorMSG))failedBlock

{
    NSString *requestUrl = [NSString stringWithFormat:@"http://nmapi.%@/Push/GetUserSendMessage?Token=%@&userId=%@&pageSize=%d&pageIndex=%d", aedudomain, Token,userId,pageSize,pageIndex];
    NSString * encodedString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)requestUrl, NULL, NULL,  kCFStringEncodingUTF8 );
    
    [self handerGetRequest:encodedString
                parameters:nil
                      body:nil
                   success:^(NSDictionary *data) {
        NSInteger statusCode = [[data objectForKey:@"result"] intValue];
        if (statusCode == 0) {
            NSMutableArray *array = (NSMutableArray *)[data objectForKey:@"msg"];
            if (array && [array count] > 0) {
                NSMutableArray *getMessageArray = [NSMutableArray arrayWithCapacity:[array count]];
                for (int i = 0; i < [array count]; i ++) {
                    
                    SendMessage *GM = [[SendMessage alloc] init];
                    GM.BatchSerial = [[array[i] objectForKey:@"BatchSerial"] intValue];
                    GM.SchoolId = [[array[i] objectForKey:@"SchoolId"] intValue];
                    GM.PubUserId = [[array[i] objectForKey:@"PubUserId"] intValue];
                    GM.PubUserType = [[array[i] objectForKey:@"PubUserType"] intValue];
                    GM.SendScope = [[array[i] objectForKey:@"SendScope"] intValue];
                    GM.UserRole = [[array[i] objectForKey:@"UserRole"] intValue];
                    GM.MsgCount = [[array[i] objectForKey:@"MsgCount"] intValue];
                    GM.ObjectCount = [[array[i] objectForKey:@"ObjectCount"] intValue];
                    GM.UserCount = [[array[i] objectForKey:@"UserCount"] intValue];
                    GM.PublishUserCount = [[array[i] objectForKey:@"PublishUserCount"] intValue];
                    GM.MsgType = [[array[i] objectForKey:@"MsgType"] intValue];
                    GM.SendType = [[array[i] objectForKey:@"SendType"] intValue];
                    GM.StatusId = [[array[i] objectForKey:@"StatusId"] intValue];GM.UserScopeProperty = [[array[i] objectForKey:@"UserScopeProperty"] intValue];
                    GM.PublishResult = [[array[i] objectForKey:@"PublishResult"] intValue];
                    
                    GM.BatchId = [array[i] objectForKey:@"BatchId"];
                    GM.SchoolName = [array[i] objectForKey:@"SchoolName"];
                    GM.MsgContent = [array[i] objectForKey:@"MsgContent"];
                    GM.CreateBy = [array[i] objectForKey:@"CreateBy"];
                    // 过滤
                    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"@/:;()¥「」＂、[]{}#%-*+=_\\|~＜＞$€^•'@#$%^&*()_+'\""];
                    NSString *String = [array[i] objectForKey:@"CreateTime"];
                    NSString *trimmedString = [String stringByTrimmingCharactersInSet:set];
                    NSString *newStr = [trimmedString stringByReplacingOccurrencesOfString:@"(" withString:@""];
                    NSString *newwStr = [newStr stringByReplacingOccurrencesOfString:@"Date" withString:@""];
                    NSString *b = [newwStr substringToIndex:10];
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    NSDate*confromTimesp = [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)[b intValue]];
                    [formatter setDateFormat:@"yyyy年-MM月-dd日"];
                    NSString *newStr1 = [formatter stringFromDate:confromTimesp];
                    GM.CreateTime = newStr1;
                    [getMessageArray addObject:GM];
                }
                // 返回的数据一定要放在for循环外面
                if (successBlock) {
                    successBlock(getMessageArray);
                }
            } else {
                if (failedBlock) {
                    failedBlock(@"没有短信了！");
                }
            }
            
        } else{
            if (failedBlock) {
                failedBlock(@"暂无数据...");
            }
        }
        
    } failed:^(NSString *message) {
        failedBlock(@"暂无数据...");
    }];
}

#pragma mark -- 获取教师绑定班级列表
#pragma mark --

- (void)getTeacherClassCounts:(NSString *)Token
                    teacherId:(NSString *)teacherId
                      success:(void(^)(NSMutableArray* data))successBlock
                       failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://nmapi.%@/Push/GetTeacherAllClass?Token=%@&teacherId=%@", aedudomain, Token,teacherId];
    NSString * encodedString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)requestUrl, NULL, NULL,  kCFStringEncodingUTF8 );
    [self handerGetRequest:encodedString
                parameters:nil
                      body:nil
                   success:^(NSDictionary *data) {
                       NSInteger statusCode = [[data objectForKey:@"result"] intValue];
                       if (statusCode == 0) {
                           
                           NSMutableDictionary *dict = (NSMutableDictionary *)[data objectForKey:@"msg"];
                           if (dict) {
                               NSMutableArray *array = (NSMutableArray *)[dict objectForKey:@"t"];
                               if (array && [array count] > 0) {
                                   if (successBlock) {
                                       successBlock(array);
                                   }
                               } else {
                                   if (failedBlock) {
                                       failedBlock(@"暂无数据...");
                                   }
                               }
                           } else {
                               if (failedBlock) {
                                   failedBlock(@"暂无数据...");
                               }
                               
                           }
                           
                       }
    } failed:^(NSString *message) {
        failedBlock(@"暂无数据...");
    }];
    
}

#pragma mark -- 获取班级学生列表

- (void)getClassStudentCounts:(NSString *)Token
                      classId:(long long)classId
                      success:(void(^)(NSMutableArray* data))successBlock
                       failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://nmapi.%@/Push/GetClassMember?Token=%@&classId=%lld", aedudomain, Token,classId];
    NSString * encodedString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)requestUrl, NULL, NULL,  kCFStringEncodingUTF8 );
    [self handerGetRequest:encodedString
                parameters:nil
                      body:nil
                   success:^(NSDictionary *data) {
                       NSInteger statusCode = [[data objectForKey:@"result"] intValue];
                       if (statusCode == 0) {
                           
                           NSMutableArray *array = (NSMutableArray *)[data objectForKey:@"msg"];
                           if (array && [array count] > 0) {
                               NSMutableArray *theSDArray = [NSMutableArray arrayWithCapacity:[array count]];
                               for (int i = 0; i <[array count]; i ++) {
                                   CurrentStudent *currentStudent = [[CurrentStudent alloc] init];
                                   currentStudent.StudentId = [[array[i] objectForKey:@"StudentId"] longLongValue];
                                   currentStudent.StudentName = [array[i] objectForKey:@"StudentName"];
                                   currentStudent.IsOnCampus = [[array[i] objectForKey:@"IsOnCampus"] intValue];
                                   currentStudent.UserService = [[array[i] objectForKey:@"UserService"] intValue];
                                   [theSDArray addObject:currentStudent];
                               }
                               
                               if (successBlock) {
                                   successBlock(theSDArray);
                               }
                               
                           } else {
                               if (failedBlock ) {
                                   failedBlock(@"暂无数据...");
                               }
                           }
                       } else {
                           if (failedBlock) {
                               failedBlock(@"暂无数据...");
                           }
                       }
                       
        
    } failed:^(NSString *message) {
        failedBlock(@"暂无数据...");
    }];
    
}

#pragma mark -- 获取教师创建的群组

- (void)getTeacherGroupCounts:(NSString *)Token
                    teacherId:(NSString *)teacherId
                      success:(void(^)(NSMutableArray* data))successBlock
                       failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://nmapi.%@/Push/GetGroupListByTeacher?Token=%@&teacherId=%@", aedudomain, Token,teacherId];
    NSString * encodedString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)requestUrl, NULL, NULL,  kCFStringEncodingUTF8 );
    [self handerGetRequest:encodedString
                parameters:nil
                      body:nil
                   success:^(NSDictionary *data) {
                       NSInteger statusCode = [[data objectForKey:@"result"] intValue];
                       if (statusCode == 0) {
                           NSMutableArray *array = (NSMutableArray *)[data objectForKey:@"msg"];
                           if (array && [array count] > 0) {
                               if (successBlock) {
                                   successBlock(array);
                               }
                           } else {
                               if (failedBlock) {
                                   failedBlock(@"暂无数据...");
                               }
                           }
                           
                           
                       } else {
                           if (failedBlock) {
                               failedBlock(@"暂无数据...");
                           }
                       }
        
    } failed:^(NSString *message) {
        failedBlock(@"暂无数据...");
    }];
}

#pragma mark -- 获取群组成员

- (void)getGroupMember:(NSString *)Token
               groupId:(long long)groupId
               success:(void(^)(NSMutableArray* data))successBlock
                failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://nmapi.%@/Push/GetGroupMemberList?Token=%@&groupId=%lld", aedudomain, Token,groupId];
    NSString * encodedString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)requestUrl, NULL, NULL,  kCFStringEncodingUTF8 );
    [self handerGetRequest:encodedString
                parameters:nil
                      body:nil
                   success:^(NSDictionary *data) {
                       NSInteger statusCode = [[data objectForKey:@"result"] intValue];
                       if (statusCode == 0) {
                           NSMutableArray *array = (NSMutableArray *)[data objectForKey:@"msg"];
                           if (array && [array count] > 0) {
                               if (successBlock) {
                                   successBlock(array);
                               }
                           } else {
                               if (failedBlock) {
                                   failedBlock(@"为获取到对应的成员...");
                               }
                           }
                           
                           
                       } else {
                           if (failedBlock) {
                               failedBlock(@"为获取到对应的成员...");
                           }
                       }
        
    } failed:^(NSString *message) {
        failedBlock(@"暂无数据...");
    }];
    
}

#pragma mark -- 通过教师ID获取教师列表

- (void)getTeacherList:(NSString *)Token
             teacherId:(NSString *)teacherId
               success:(void(^)(NSMutableArray* data))successBlock
                failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://nmapi.%@/Push/GetTeacherListByTeacher?Token=%@&teacherId=%@", aedudomain, Token,teacherId];
    NSString * encodedString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)requestUrl, NULL, NULL,  kCFStringEncodingUTF8 );
    [self handerGetRequest:encodedString
                parameters:nil
                      body:nil
                   success:^(NSDictionary *data) {
                       NSInteger statusCode = [[data objectForKey:@"result"] intValue];
                       if (statusCode == 0) {
                           NSMutableArray *array = (NSMutableArray *)[data objectForKey:@"msg"];
                           if (array && [array count] > 0) {
                               NSMutableArray *theSDArray = [NSMutableArray arrayWithCapacity:[array count]];
                               for (int i = 0; i <[array count]; i ++) {
                                   CurrentTeacher *currentTeacher = [[CurrentTeacher alloc] init];
                                   currentTeacher.TeacherId = [[array[i] objectForKey:@"TeacherId"] longLongValue];
                                   currentTeacher.TeacherName = [array[i] objectForKey:@"TeacherName"];
                                   currentTeacher.UserService = [[array[i] objectForKey:@"UserService"] intValue];
                                   [theSDArray addObject:currentTeacher];
                               }
                               
                               if (successBlock) {
                                   successBlock(theSDArray);
                               }
                               
                           } else{
                               if (failedBlock) {
                                   failedBlock(@"暂无数据...");
                               }
                           }
                           
                       } else {
                           if (failedBlock) {
                               failedBlock(@"暂无数据...");
                           }
                       }
                       
                   } failed:^(NSString *message) {
                       failedBlock(@"暂无数据...");
                   }];
    
}

#pragma mark -- 教师给群组发短信

- (void)teacherSendMessageForGroup:(NSString *)Token
                         teacherId:(NSString *)teacherId
                       messageType:(int)messageType
                           message:(NSString *)message
                      objectIdList:(NSString *)objectIdList
                           success:(void(^)(NSMutableArray* data))successBlock
                            failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://nmapi.%@/Push/SendGroupByTeacher?Token=%@&teacherId=%@&messageType=%d&message=%@&%@", aedudomain, Token,teacherId,messageType,message,objectIdList];
    NSString * encodedString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)requestUrl, NULL, NULL,  kCFStringEncodingUTF8);
    [self handerPostRequest:encodedString
                 parameters:nil
                       body:nil
                    success:^(NSDictionary *data) {
                        NSInteger statusCode = [[data objectForKey:@"result"] intValue];
                        NSMutableArray *groupArray = [[NSMutableArray alloc] init];
                        if (statusCode == 0) {
                            NSString *presentationStr = (NSString *)[data objectForKey:@"msg"];
                            [groupArray addObject:presentationStr];
                            if (successBlock) {
                                successBlock(groupArray);
                            }
                            
                        } else {
                            if (failedBlock) {
                                failedBlock(@"发送信息失败 ⊙︿⊙");
                            }
                        }
        
    } failed:^(NSString *message) {
        failedBlock(@"发送信息失败 ⊙︿⊙");
    }];
    
}

#pragma mark -- 教师给群组发短信(短信)

- (void)teacherSendNextMessageForGroup:(NSString *)Token
                             teacherId:(NSString *)teacherId
                           messageType:(int)messageType
                               message:(NSString *)message
                          objectIdList:(NSString *)objectIdList
                               success:(void (^)(NSMutableArray *data))successBlock
                                failed:(void (^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://vv.%@/TeacherApi/PostPublishToGroup?Token=%@&teacherId=%@&messageType=%d&message=%@&%@", aedudomain, Token,teacherId,messageType,message,objectIdList];
    NSString * encodedString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)requestUrl, NULL, NULL,  kCFStringEncodingUTF8);
    [self handerPostRequest:encodedString
                 parameters:nil
                       body:nil
                    success:^(NSDictionary *data) {
                        BOOL statusCode = [[data objectForKey:@"Result"] boolValue];
                        NSMutableArray *groupArray = [[NSMutableArray alloc] init];
                        if (statusCode == true) {
                            NSString *presentationStr = (NSString *)[data objectForKey:@"Message"];
                            [groupArray addObject:presentationStr];
                            if (successBlock) {
                                successBlock(groupArray);
                            }
                            
                        } else {
                            if (failedBlock) {
                                failedBlock(@"发送信息失败 ⊙︿⊙");
                            }
                        }
                        
                    } failed:^(NSString *message) {
                        failedBlock(@"发送信息失败 ⊙︿⊙");
                    }];
    
}

#pragma mark -- 教师给个别成员发送短信（网页）

- (void)teacherSendMessageForSeveralMenver:(NSString *)Token
                                 teacherId:(NSString *)teacherId
                               messageType:(int)messageType
                                   message:(NSString *)message
                                   groupId:(NSString *)groupId
                              objectIdList:(NSString *)objectIdList
                                   success:(void (^)(NSMutableArray *data))successBlock
                                    failed:(void (^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://nmapi.%@/Push/SendGroupMemberByTeacher?Token=%@&teacherId=%@&messageType=%d&message=%@&groupId=%@&%@", aedudomain, Token,teacherId,messageType,message,groupId,objectIdList];
    NSString * encodedString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)requestUrl, NULL, NULL,  kCFStringEncodingUTF8);
    [self handerPostRequest:encodedString
                 parameters:nil
                       body:nil
                    success:^(NSDictionary *data) {
                        NSInteger statusCode = [[data objectForKey:@"result"] intValue];
                        NSMutableArray *groupArray = [[NSMutableArray alloc] init];
                        if (statusCode == 0) {
                            NSString *presentationStr = (NSString *)[data objectForKey:@"msg"];
                            [groupArray addObject:presentationStr];
                            if (successBlock) {
                                successBlock(groupArray);
                            }
                            
                        } else {
                            if (failedBlock) {
                                failedBlock(@"发送信息失败 ⊙︿⊙");
                            }
                        }
        
    } failed:^(NSString *message) {
        failedBlock(@"发送信息失败 ⊙︿⊙");
    }];
    
}

#pragma mark -- 教师给个别成员发送短信（短信）

- (void)teacherSendNextMessageForSeveralMenber:(NSString *)Token
                                   messageType:(int)messageType
                                       message:(NSString *)message
                                       groupId:(NSString *)groupId
                                  objectIdList:(NSString *)objectIdList
                                       success:(void (^)(NSMutableArray *data))successBlock
                                        failed:(void (^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://vv.%@/TeacherApi/PostPublishToGroupSome?Token=%@&messageType=%d&message=%@&groupId=%@&%@", aedudomain, Token,messageType,message,groupId,objectIdList];
    NSString * encodedString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)requestUrl, NULL, NULL,  kCFStringEncodingUTF8);
    [self handerPostRequest:encodedString
                 parameters:nil
                       body:nil
                    success:^(NSDictionary *data) {
                        BOOL statusCode = [[data objectForKey:@"Result"] boolValue];
                        NSMutableArray *groupArray = [[NSMutableArray alloc] init];
                        if (statusCode == true) {
                            NSString *presentationStr = (NSString *)[data objectForKey:@"Message"];
                            [groupArray addObject:presentationStr];
                            if (successBlock) {
                                successBlock(groupArray);
                            }
                            
                        } else {
                            if (failedBlock) {
                                failedBlock(@"当前群组下没有你指定的群组成员");
                            }
                        }
                        
                    } failed:^(NSString *message) {
                        failedBlock(@"发送信息失败 ⊙︿⊙");
                    }];
    
}

#pragma mark -- 教师给班级发送短信（网页）

- (void)teacherSendMessageForClass:(NSString *)Token
                         teacherId:(NSString *)teacherId
                       messageType:(int)messageType
                           message:(NSString *)message
                      objectIdList:(NSString *)objectIdList
                           success:(void (^)(NSMutableArray *data))successBlock
                            failed:(void (^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://nmapi.%@/Push/SendClassByTeacher?Token=%@&teacherId=%@&messageType=%d&message=%@&%@", aedudomain, Token,teacherId,messageType,message,objectIdList];
    NSString * encodedString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)requestUrl, NULL, NULL,  kCFStringEncodingUTF8);
    [self handerPostRequest:encodedString
                 parameters:nil
                       body:nil
                    success:^(NSDictionary *data) {
                        NSInteger statusCode = [[data objectForKey:@"result"] intValue];
                        NSMutableArray *groupArray = [[NSMutableArray alloc] init];
                        if (statusCode == 0) {
                            NSString *presentationStr = (NSString *)[data objectForKey:@"msg"];
                            [groupArray addObject:presentationStr];
                            if (successBlock) {
                                successBlock(groupArray);
                            }
                            
                        } else {
                            if (failedBlock) {
                                failedBlock(@"发送信息失败 ⊙︿⊙");
                            }
                        }
                        
                    } failed:^(NSString *message) {
                        failedBlock(@"发送信息失败 ⊙︿⊙");
                    }];
    
}

#pragma mark -- 教师给班级发送短信（短信）

- (void)teacherSendNextMessageForClass:(NSString *)Token
                           messageType:(int)messageType
                               message:(NSString *)message
                               classId:(NSString *)classId
                               success:(void (^)(NSMutableArray *data))successBlock
                                failed:(void (^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://vv.%@/TeacherApi/PostPublishToClass?Token=%@&messageType=%d&message=%@&classId=%@", aedudomain, Token,messageType,message,classId];
    NSString * encodedString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)requestUrl, NULL, NULL,  kCFStringEncodingUTF8);
    [self handerPostRequest:encodedString
                 parameters:nil
                       body:nil
                    success:^(NSDictionary *data) {
                        BOOL statusCode = [[data objectForKey:@"Result"] boolValue];
                        NSMutableArray *groupArray = [[NSMutableArray alloc] init];
                        if (statusCode == true) {
                            NSString *presentationStr = (NSString *)[data objectForKey:@"Message"];
                            [groupArray addObject:presentationStr];
                            if (successBlock) {
                                successBlock(groupArray);
                            }
                            
                        } else {
                            if (failedBlock) {
                                failedBlock(@"当前群组下没有你指定的群组成员");
                            }
                        }
                        
                    } failed:^(NSString *message) {
                        failedBlock(@"发送信息失败 ⊙︿⊙");
                    }];
    
}

#pragma mark -- 给个别家长发送短信（网页）

- (void)teacherSendMessageForSeveralParents:(NSString *)Token
                                  teacherId:(NSString *)teacherId
                                messageType:(int)messageType
                                    message:(NSString *)message
                               objectIdList:(NSString *)objectIdList
                                    success:(void (^)(NSMutableArray *data))successBlock
                                     failed:(void (^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://nmapi.%@/Push/SendStudentByTeacher?Token=%@&teacherId=%@&messageType=%d&message=%@&%@", aedudomain, Token,teacherId,messageType,message,objectIdList];
    NSString * encodedString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)requestUrl, NULL, NULL,  kCFStringEncodingUTF8);
    [self handerPostRequest:encodedString
                 parameters:nil
                       body:nil
                    success:^(NSDictionary *data) {
                        NSInteger statusCode = [[data objectForKey:@"result"] intValue];
                        NSMutableArray *groupArray = [[NSMutableArray alloc] init];
                        if (statusCode == 0) {
                            NSString *presentationStr = (NSString *)[data objectForKey:@"msg"];
                            [groupArray addObject:presentationStr];
                            if (successBlock) {
                                successBlock(groupArray);
                            }
                            
                        } else {
                            if (failedBlock) {
                                failedBlock(@"发送信息失败 ⊙︿⊙");
                            }
                        }
                        
                    } failed:^(NSString *message) {
                        failedBlock(@"发送信息失败 ⊙︿⊙");
                    }];
    
}

#pragma mark -- 给个别家长发送短信（短信）

- (void)teacherSendNextMessageForSeveralParents:(NSString *)Token
                                    messageType:(int)messageType
                                        message:(NSString *)message
                                        classId:(NSString *)classId
                                   objectIdList:(NSString *)objectIdList
                                        success:(void (^)(NSMutableArray *data))successBlock
                                         failed:(void (^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://vv.%@/TeacherApi/PostPublishToClassSome?Token=%@&messageType=%d&message=%@&classId=%@&%@", aedudomain, Token,messageType,message,classId,objectIdList];
    NSString * encodedString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)requestUrl, NULL, NULL,  kCFStringEncodingUTF8);
    [self handerPostRequest:encodedString
                 parameters:nil
                       body:nil
                    success:^(NSDictionary *data) {
                        BOOL statusCode = [[data objectForKey:@"Result"] boolValue];
                        NSMutableArray *groupArray = [[NSMutableArray alloc] init];
                        if (statusCode == true) {
                            NSString *presentationStr = (NSString *)[data objectForKey:@"Message"];
                            [groupArray addObject:presentationStr];
                            if (successBlock) {
                                successBlock(groupArray);
                            }
                            
                        } else {
                            if (failedBlock) {
                                failedBlock(@"选定用户手机号码未开通短信服务或号码格式不正确");
                            }
                        }
                        
                    } failed:^(NSString *message) {
                        failedBlock(@"发送信息失败 ⊙︿⊙");
                        
                    }];
    
}

#pragma mark -- 校领导给个别教师发送短信（网页）

- (void)bossSendMessageForTeachers:(NSString *)Token
                     SenderAccount:(NSString *)SenderAccount
                       messageType:(int)messageType
                           Message:(NSString *)Message
                      ObjectIdList:(NSString *)ObjectIdList
                           success:(void (^)(NSMutableArray *data))successBlock
                            failed:(void (^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://nmapi.%@/Push/SendTeacherByTeacher?Token=%@&teacherId=%@&messageType=%d&message=%@&%@", aedudomain, Token,SenderAccount,messageType,Message,ObjectIdList];
    NSString * encodedString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)requestUrl, NULL, NULL,  kCFStringEncodingUTF8);
    [self handerPostRequest:encodedString
                 parameters:nil
                       body:nil
                    success:^(NSDictionary *data) {
                        NSInteger statusCode = [[data objectForKey:@"result"] intValue];
                        NSMutableArray *groupArray = [[NSMutableArray alloc] init];
                        if (statusCode == 0) {
                            NSString *presentationStr = (NSString *)[data objectForKey:@"msg"];
                            [groupArray addObject:presentationStr];
                            if (successBlock) {
                                successBlock(groupArray);
                            }
                            
                        } else {
                            if (failedBlock) {
                                failedBlock(@"发送信息失败 ⊙︿⊙");
                            }
                        }
                        
                    } failed:^(NSString *message) {
                        failedBlock(@"发送信息失败 ⊙︿⊙");
                    }];
    
}

#pragma mark -- 校领导给个别教师发送短信（短信）

- (void)bossSendNextMessageForTeachers:(NSString *)Token
                           messageType:(int)messageType
                               Message:(NSString *)Message
                          ObjectIdList:(NSString *)ObjectIdList
                               success:(void (^)(NSMutableArray *data))successBlock
                                failed:(void (^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://vv.%@/TeacherApi/PostPublishToTeacher?Token=%@&messageType=%d&message=%@&%@", aedudomain, Token,messageType,Message,ObjectIdList];
    NSString * encodedString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)requestUrl, NULL, NULL,  kCFStringEncodingUTF8);
    [self handerPostRequest:encodedString
                 parameters:nil
                       body:nil
                    success:^(NSDictionary *data) {
                        BOOL statusCode = [[data objectForKey:@"Result"] boolValue];
                        NSMutableArray *groupArray = [[NSMutableArray alloc] init];
                        if (statusCode == true) {
                            NSString *presentationStr = (NSString *)[data objectForKey:@"Message"];
                            [groupArray addObject:presentationStr];
                            if (successBlock) {
                                successBlock(groupArray);
                            }
                            
                        } else {
                            if (failedBlock) {
                                failedBlock(@"短信余额不足!");
                            }
                        }
                        
                    } failed:^(NSString *message) {
                        failedBlock(@"发送信息失败 ⊙︿⊙");
                    }];
    
}

#pragma mark -- 通过教师获取学校短信字数限制

- (void)limitMessageCount:(NSString *)Token
                  userId:(NSString *)userId
                  success:(void (^)(NSString *data))successBlock
                   failed:(void (^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://nmapi.%@/Push/GetSchoolMsgNum?Token=%@&userId=%@", aedudomain, Token,userId];
    NSString * encodedString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)requestUrl, NULL, NULL,  kCFStringEncodingUTF8);

    [self handerGetRequest:encodedString
                parameters:nil
                      body:nil
                   success:^(NSDictionary *data) {
                       NSInteger statusCode = [[data objectForKey:@"result"] intValue];
                       if (statusCode == 0) {
                           NSDictionary *tmpDcit = [data objectForKey:@"msg"];
                           if (tmpDcit && [tmpDcit count] > 0) {
                               NSString *numStr = [NSString stringWithFormat:@"%@",[tmpDcit objectForKey:@"MsgContentSize"]];
                               if (successBlock) {
                                   successBlock(numStr);
                               }
                           }
                       } else{
                           if (failedBlock) {
                               failedBlock(@"");
                           }
                       }

                       
                   } failed:^(NSString *message) {
                       failedBlock(@"");
                   }];
}

// 新版家校沟通
#pragma mark -- 给班级发送

- (void)forTheClassSendMessag:(NSString *)token
                      message:(NSString *)message
                      classId:(NSString *)classId
                  messageType:(int)messageType
                   isSendName:(int)isSendName
                     sendType:(int)sendType
       isPublishToClassMaster:(int)isPublishToClassMaster
                  studentType:(int)studentType
                      audioes:(NSString *)audioes
                     pictures:(NSString *)pictures
                      success:(void (^)(NSString *data))successBlock
                       failed:(void (^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://vv.%@/TeacherApi/PostPublishToClass?token=%@&message=%@&%@&messageType=%d&isSendName=%d&sendType=%d&isPublishToClassMaster=%d&studentType=%d&audioes=%@&pictures=%@", aedudomain, token,message,classId,messageType,isSendName,sendType,isPublishToClassMaster,studentType,audioes,pictures];
    NSString * encodedString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)requestUrl, NULL, NULL,  kCFStringEncodingUTF8);
    [self handerPostRequest:encodedString
                 parameters:nil
                       body:nil
                    success:^(NSDictionary *data) {
                        BOOL isTrue = [[data objectForKey:@"Result"] boolValue];
                        if (isTrue == 1) {
                            if (successBlock) {
                                successBlock(@"发送成功");
                            }
                            
                        } else{
                            if (failedBlock) {
                                failedBlock(@"发送失败");
                            }
                        }
                    } failed:^(NSString *message) {
                        if (failedBlock) {
                            failedBlock(@"发送失败");
                        }
                    }];
}

#pragma mark -- 给班级成员发送

- (void)forTheClassMenberSendMessag:(NSString *)token
                            message:(NSString *)message
                            classId:(NSString *)classId
                       objectIdList:(NSString *)objectIdList
                        messageType:(int)messageType
                         isSendName:(int)isSendName
                           sendType:(int)sendType
             isPublishToClassMaster:(int)isPublishToClassMaster
                            audioes:(NSString *)audioes
                           pictures:(NSString *)pictures
                            success:(void (^)(NSString *data))successBlock
                             failed:(void (^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://vv.%@/TeacherApi/PostPublishToClassSome?token=%@&message=%@&classId=%@&%@&messageType=%d&isSendName=%d&sendType=%d&isPublishToClassMaster=%d&audioes=%@&pictures=%@", aedudomain, token,message,classId,objectIdList,messageType,isSendName,sendType,isPublishToClassMaster,audioes,pictures];
    NSString * encodedString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)requestUrl, NULL, NULL,  kCFStringEncodingUTF8);
    [self handerPostRequest:encodedString
                 parameters:nil
                       body:nil
                    success:^(NSDictionary *data) {
                        BOOL isTrue = [[data objectForKey:@"Result"] boolValue];
                        if (isTrue == 1) {
                            if (successBlock) {
                                successBlock(@"发送成功");
                            }
                            
                        } else{
                            if (failedBlock) {
                                failedBlock(@"发送失败");
                            }
                        }
                    } failed:^(NSString *message) {
                        if (failedBlock) {
                            failedBlock(@"发送失败");
                        }
                    }];
    
}
#pragma mark -- 给群组发送

- (void)forTheGroupSendMessag:(NSString *)token
                      message:(NSString *)message
                      groupId:(NSString *)groupId
                  messageType:(int)messageType
                   isSendName:(int)isSendName
                     sendType:(int)sendType
                      audioes:(NSString *)audioes
                     pictures:(NSString *)pictures
                      success:(void (^)(NSString *data))successBlock
                       failed:(void (^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://vv.%@/TeacherApi/PostPublishToGroup?token=%@&message=%@&%@&messageType=%d&isSendName=%d&sendType=%d&audioes=%@&pictures=%@", aedudomain, token,message,groupId,messageType,isSendName,sendType,audioes,pictures];
    NSString * encodedString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)requestUrl, NULL, NULL,  kCFStringEncodingUTF8);
    [self handerPostRequest:encodedString
                 parameters:nil
                       body:nil
                    success:^(NSDictionary *data) {
                        BOOL isTrue = [[data objectForKey:@"Result"] boolValue];
                        if (isTrue == 1) {
                            if (successBlock) {
                                successBlock(@"发送成功");
                            }
                        } else{
                            if (failedBlock) {
                                failedBlock(@"发送失败");
                            }
                        }
                    } failed:^(NSString *message) {
                        if (failedBlock) {
                            failedBlock(@"发送失败");
                        }
                    }];
    
}

#pragma mark -- 给群组成员发送
- (void)forTheGroupMenberSendMessag:(NSString *)token
                            message:(NSString *)message
                            groupId:(NSString *)groupId
                       objectIdList:(NSString *)objectIdList
                        messageType:(int)messageType
                         isSendName:(int)isSendName
                           sendType:(int)sendType
                            audioes:(NSString *)audioes
                           pictures:(NSString *)pictures
                            success:(void (^)(NSString *data))successBlock
                             failed:(void (^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://vv.%@/TeacherApi/PostPublishToGroupSome?token=%@&message=%@&groupId=%@&%@&messageType=%d&isSendName=%d&sendType=%d&audioes=%@&pictures=%@", aedudomain, token,message,groupId,objectIdList,messageType,isSendName,sendType,audioes,pictures];
    NSString * encodedString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)requestUrl, NULL, NULL,  kCFStringEncodingUTF8);
    [self handerPostRequest:encodedString
                 parameters:nil
                       body:nil
                    success:^(NSDictionary *data) {
                        BOOL isTrue = [[data objectForKey:@"Result"] boolValue];
                        if (isTrue == 1) {
                            if (successBlock) {
                                successBlock(@"发送成功");
                            }
                        } else{
                            if (failedBlock) {
                                failedBlock(@"发送失败");
                            }
                        }
                    } failed:^(NSString *message) {
                        if (failedBlock) {
                            failedBlock(@"发送失败");
                        }
                    }];
    
}

#pragma mark -- 给老师发送
- (void)forTheTeachersSendMessag:(NSString *)token
                         message:(NSString *)message
                    objectIdList:(NSString *)objectIdList
                     messageType:(int)messageType
                      isSendName:(int)isSendName
                        sendType:(int)sendType
                         audioes:(NSString *)audioes
                        pictures:(NSString *)pictures
                         success:(void (^)(NSString *data))successBlock
                          failed:(void (^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://vv.%@/TeacherApi/PostPublishToTeacher?token=%@&message=%@&%@&messageType=%d&isSendName=%d&sendType=%d&audioes=%@&pictures=%@", aedudomain, token,message,objectIdList,messageType,isSendName,sendType,audioes,pictures];
    NSString * encodedString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)requestUrl, NULL, NULL,  kCFStringEncodingUTF8);
    [self handerPostRequest:encodedString
                 parameters:nil
                       body:nil
                    success:^(NSDictionary *data) {
                        BOOL isTrue = [[data objectForKey:@"Result"] boolValue];
                        if (isTrue == 1) {
                            if (successBlock) {
                                successBlock(@"发送成功");
                            }
                        } else{
                            if (failedBlock) {
                                failedBlock(@"发送失败");
                            }
                        }
                    } failed:^(NSString *message) {
                        if (failedBlock) {
                            failedBlock(@"发送失败");
                        }
                    }];
}

#pragma mark -- 获取教师权限
- (void)getTeacherMsgPermission:(NSString *)Token
                      teacherId:(NSString *)teacherId
                        success:(void(^)(NSMutableArray* data))successBlock
                         failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://nmapi.%@/Push/GetTeacherMsgPermission?token=%@&teacherId=%@", aedudomain, Token,teacherId];
    NSString * encodedString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)requestUrl, NULL, NULL,  kCFStringEncodingUTF8);
    [self handerGetRequest:encodedString
                 parameters:nil
                       body:nil
                    success:^(NSDictionary *data) {
                        NSInteger statusCode = [[data objectForKey:@"result"] intValue];
                        if (statusCode == 0) {
                            NSMutableArray *array = (NSMutableArray *)[data objectForKey:@"msg"];
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

#pragma mark -- 家长或学生获取未读数据
- (void)GetMessagesWithUserId:(NSString *)userId
                     FromOrTo:(int)fromOrTo newOrOld:(NSString *)yesOrNo type:(int)type
                      success:(void(^)(NSMutableArray* data))successBlock
                       failed:(void(^)(NSString *errorMSG))failedBlock
{

    NSString *requestUrl = [NSString stringWithFormat:@"http://pushservice.%@/message/GetMessages?UserId=%@&FromOrTo=%d&type=%d&new=%@", aedudomain,userId,fromOrTo,type,yesOrNo];
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
}

#pragma mark -- 家长或学生获取更多未读数据
- (void)getMoreMessagesWithUserId:(NSString *)userId HeadType:(int)headType
                         FromOrTo:(int)fromOrTo newOrOld:(NSString *)yesOrNo type:(int)type LineId:(NSString *)lineId
                      success:(void(^)(NSMutableArray* data))successBlock
                       failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://pushservice.%@/message/GetMessages?HeadType=%d&UserId=%@&FromOrTo=%d&type=%d&new=%@&MessageDetailId=%@", aedudomain, headType,userId,fromOrTo,type,yesOrNo,lineId];
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
}

#pragma mark -- 根据家长获取学生ID
- (void) getStudentIdWithUserId:(NSString *)userId
                        success:(void(^)(NSString* data))successBlock
                         failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://home.%@/Api/GetStudentId?UserId=%@",aedudomain, userId];
    NSString * encodedString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)requestUrl, NULL, NULL,  kCFStringEncodingUTF8);
    [self handerGetRequest:encodedString
                parameters:nil
                      body:nil
                   success:^(NSDictionary *data) {
                       NSInteger statusCode = [[data objectForKey:@"st"] intValue];
                       if (statusCode == 0) {
                           NSDictionary *dic = (NSDictionary *)[data objectForKey:@"msg"];
                           if (dic && [dic count] > 0) {
                               NSArray *student = [dic objectForKey:@"list"];
                               NSDictionary *studentDic = student[0];
                               NSString *studentId = [NSString stringWithFormat:@"%@",[studentDic objectForKey:@"UserId"]];
                               if (successBlock) {
                                   successBlock(studentId);
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

@end
