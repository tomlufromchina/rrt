//
//  NetWorkManager+NetworkTool.m
//  RenrenTong
//
//  Created by aedu on 15/2/5.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "NetWorkManager+NetworkTool.h"

@implementation NetWorkManager (NetworkTool)

#pragma mark -- 获取教师绑定班级列表

- (void)getTeacherClassCount:(NSString *)Token
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

#pragma mark -- 获取教师所在学校学段

- (void)getSchoolType:(NSString *)Token
                    teacherId:(NSString *)teacherId
                      success:(void(^)(NSMutableArray* data))successBlock
                       failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://nmapi.%@/Push/GetSchoolType?Token=%@&teacherId=%@", aedudomain, Token,teacherId];
    NSString * encodedString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)requestUrl, NULL, NULL,  kCFStringEncodingUTF8 );
    [self handerGetRequest:encodedString
                parameters:nil
                      body:nil
                   success:^(NSDictionary *data) {
                       NSInteger statusCode = [[data objectForKey:@"result"] intValue];
                       if (statusCode == 0) {
                           NSMutableArray *array = (NSMutableArray *)[data objectForKey:@"msg"];
                           if (array) {
                                if (successBlock)
                                    successBlock(array);
                           }
                       }
                   } failed:^(NSString *message) {
                       failedBlock(@"暂无数据...");
                   }];
    
}

#pragma mark -- 获取班级学生列表

- (void)getClassStudents:(NSString *)Token
                      classId:(NSNumber *)classId
                      success:(void(^)(NSMutableArray* data))successBlock
                       failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://nmapi.%@/Push/GetClassMember?Token=%@&classId=%@", aedudomain, Token,classId];
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
- (void)getTeacherGroups:(NSString *)Token
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

- (void)getGroupMembers:(NSString *)Token
               groupId:(NSNumber *)groupId
               success:(void(^)(NSMutableArray* data))successBlock
                failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://nmapi.%@/Push/GetGroupMemberList?Token=%@&groupId=%@", aedudomain, Token,groupId];
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

- (void)getTeacherLists:(NSString *)Token
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
                               if (successBlock) {
                                   successBlock(array);
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




@end
