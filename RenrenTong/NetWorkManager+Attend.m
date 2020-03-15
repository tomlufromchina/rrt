//
//  NetWorkManager+Attend.m
//  RenrenTong
//
//  Created by 符其彬 on 14-9-25.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "NetWorkManager+Attend.h"
#import "AFNetworking.h"
#import "AFHTTPRequestOperationManager.h"
#import "ISingHTTPRequestOperationManager.h"

@implementation NetWorkManager (Attend)

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

#pragma mark - 平安考勤首页（老师）
#pragma mark -

- (void)getCheckingOfTearchs:(NSString *)masterid
                     success:(void(^)(NSMutableArray* data))successBlock
                      failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *url = @"http://interface.aedu.cn/classinfo/GetClassInfo";
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@?masterid=%@", url, masterid];
    NSString * encodedString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)requestUrl, NULL, NULL,  kCFStringEncodingUTF8 );
    [self handerGetRequest:encodedString parameters:nil body:nil success:^(NSDictionary *data) {
        NSInteger statusCode = [[data objectForKey:@"st"] intValue];
        if (statusCode == 0) {
            NSMutableArray *array = (NSMutableArray *)[data objectForKey:@"msg"];
            if (array && [array count] > 0) {
                NSMutableArray *checkingArray = [NSMutableArray arrayWithCapacity:[array count]];
                for (int i = 0; i < [array count]; i ++) {
                    CheckingForTeachers *CFT = [[CheckingForTeachers alloc] init];
                    NSDictionary *infoDict = [array objectAtIndex:i];
                    CFT.classId = [[infoDict objectForKey:@"ClassId"] intValue];
                    CFT.gradeId = [[infoDict objectForKey:@"GradeId"] intValue];
                    CFT.studentCount = [[infoDict objectForKey:@"StudentCount"] intValue];
                    CFT.memberCount = [[infoDict objectForKey:@"MemberCount"] intValue];
                    CFT.schoolId = [[infoDict objectForKey:@"SchoolId"] intValue];
                    CFT.masterId = [[infoDict objectForKey:@"MasterId"] intValue];
                    CFT.classType = [[infoDict objectForKey:@"ClassType"] intValue];
                    CFT.className = [infoDict objectForKey:@"ClassName"];
                    if (![[infoDict objectForKey:@"MasterAccount"] isKindOfClass:[NSNull class]]) {
                        CFT.masterAccount = [[infoDict objectForKey:@"MasterAccount"] intValue];
                    } else {
                        CFT.masterAccount = 0;
                    }
                    if (![[infoDict objectForKey:@"ClassLayer"] isKindOfClass:[NSNull class]]) {
                        CFT.classLayer = [infoDict objectForKey:@"ClassLayer"];
                    } else {
                        CFT.classLayer = @"";
                    }
                    [checkingArray addObject:CFT];
                    if (successBlock) {
                        successBlock(checkingArray);
                    }
                }
            }
        } else {
            if (failedBlock) {
                failedBlock(@"没有数据。。。");
            }
        }
        
    } failed:^(NSString *message) {
        
    }];
}


@end
