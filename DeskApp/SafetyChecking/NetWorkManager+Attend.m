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

#pragma mark - 平安考勤首页（老师）
#pragma mark -

- (void)getCheckingOfTearchs:(NSString *)toKen
                   teacherId:(NSString *)teacherId
                     success:(void(^)(NSMutableArray* data))successBlock
                      failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *url = [NSString stringWithFormat:@"http://nmapi.%@/Push/GetManagerClassByTeacher",aedudomain];
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@?toKen=%@&teacherId=%@", url, toKen,teacherId];
    NSString * encodedString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)requestUrl, NULL, NULL,  kCFStringEncodingUTF8 );
    [self handerGetRequest:encodedString parameters:nil body:nil success:^(NSDictionary *data) {
        NSInteger statusCode = [[data objectForKey:@"result"] intValue];
        if (statusCode == 0) {
            NSMutableArray *array = (NSMutableArray *)[data objectForKey:@"msg"];
            if (array && [array count] > 0 && [array isKindOfClass:[NSMutableArray class]]) {
                NSMutableArray *checkingArray = [NSMutableArray arrayWithCapacity:[array count]];
                for (int i = 0; i < [array count]; i ++) {
                    CheckingForTeachers *CFT = [[CheckingForTeachers alloc] init];
                    NSDictionary *infoDict = [array objectAtIndex:i];
                    CFT.classId = [[infoDict objectForKey:@"ClassId"] longLongValue];
                    CFT.gradeId = [[infoDict objectForKey:@"GradeId"] intValue];
                    CFT.studentCount = [[infoDict objectForKey:@"StudentCount"] intValue];
                    CFT.memberCount = [[infoDict objectForKey:@"MemberCount"] intValue];
                    CFT.schoolId = [[infoDict objectForKey:@"SchoolId"] intValue];
                    CFT.masterId = [[infoDict objectForKey:@"MasterId"] intValue];
                    CFT.classType = [[infoDict objectForKey:@"ClassType"] intValue];
                    CFT.className = [infoDict objectForKey:@"ClassName"];
                    CFT.classAlias = [infoDict objectForKey:@"ClassAlias"];
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
                }
                if (successBlock) {
                    successBlock(checkingArray);
                }
            }
        } else {
            if (failedBlock) {
                failedBlock(@"没有获取到所在班级数据...");
            }
        }
    } failed:^(NSString *message) {
        failedBlock(@"暂无数据...");
    }];
}

#pragma mark -- 今日考勤接口（老师）
#pragma mark --

- (void)todayAttendance:(NSString *)masterId
                 mydate:(NSString *)mydate
                success:(void(^)(NSMutableArray* data))successBlock
                 failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://interface.%@/ClassInfo/GetTodayClassAttendance?masterid=%@&mydate=%@", aedudomain, masterId,mydate];
    NSString * encodedString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)requestUrl, NULL, NULL,  kCFStringEncodingUTF8 );
    [self handerGetRequest:encodedString parameters:nil body:nil success:^(NSDictionary *data) {
        NSInteger statusCode = [[data objectForKey:@"st"] intValue];
        if (statusCode == 0) {
            NSMutableArray *array = (NSMutableArray *)[data objectForKey:@"msg"];
            if (array && [array count] > 0 ) {
                NSMutableArray *TodayArray = [NSMutableArray arrayWithCapacity:[array count]];
                for (int i = 0; i < [array count]; i ++) {
                    TodayAttendance *TA = [[TodayAttendance alloc] init];
                    NSDictionary *infoDic = [array objectAtIndex:i];
                    if (infoDic && ![infoDic isKindOfClass:[NSNull class]]) {
                        TA.ClassId = [[infoDic objectForKey:@"ClassId"] longLongValue];
                        TA.MasterId = [[infoDic objectForKey:@"MasterId"] intValue];
                        TA.cidaoNum = [[infoDic objectForKey:@"cidaoNum"] intValue];
                        TA.zaotuiNum = [[infoDic objectForKey:@"zaotuiNum"] intValue];
                        TA.zhengchangNum = [[infoDic objectForKey:@"zhengchangNum"] intValue];
                        TA.noRecordNum = [[infoDic objectForKey:@"noRecordNum"] intValue];
                        TA.ClassName = [infoDic objectForKey:@"ClassName"];
                        NSString *dateStr = [infoDic objectForKey:@"mydate"];
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
                        TA.mydate = result;
                        TA.MasterName = [infoDic objectForKey:@"MasterName"];
                        [TodayArray addObject:TA];
                        
                    } else{
                        TA.ClassId = 0;
                        TA.MasterId = 0;
                        TA.cidaoNum = 0;
                        TA.zaotuiNum = 0;
                        TA.zhengchangNum = 0;
                        TA.noRecordNum = 0;
                        TA.ClassName = @"";
                        TA.mydate = @"";
                        TA.MasterName = @"";
                        [TodayArray addObject:TA];
                    }
                }
                if (successBlock) {
                    successBlock(TodayArray);
                }
            }
        } else {
            if (failedBlock) {
                failedBlock(@"没有获取到数据。。。");
            }
        }
    } failed:^(NSString *message) {
        failedBlock(@"暂无数据。。。");
    }];
}

#pragma mark -- 某日某班级考勤详情（老师）
#pragma mark --

- (void)classAttendanceDetails:(long long)classId
                        mydate:(NSString *)mydate
                       success:(void(^)(NSMutableArray* data))successBlock
                        failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *url = [NSString stringWithFormat:@"http://interface.%@/ClassInfo/NewGetMyClassAttendance",aedudomain];
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@?classId=%lld&mydate=%@", url, classId,mydate];
    NSString * encodedString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)requestUrl, NULL, NULL,  kCFStringEncodingUTF8 );
    [self handerGetRequest:encodedString parameters:nil body:nil success:^(NSDictionary *data) {
        NSInteger statusCode = [[data objectForKey:@"st"] intValue];
        if (statusCode == 0) {
            NSMutableDictionary *dict = (NSMutableDictionary *)[data objectForKey:@"msg"];
            if (dict && [dict count] > 0) {
                NSMutableArray *classAttendanceArray = [NSMutableArray arrayWithCapacity:[dict count]];
                ClassAttendance *CA = [[ClassAttendance alloc] init];
                CA.ClassId = [[dict objectForKey:@"ClassId"] longLongValue];
                CA.cidaoNum = [[dict objectForKey:@"cidaoNum"] intValue];
                CA.zaotuiNum = [[dict objectForKey:@"zaotuiNum"] intValue];
                CA.zhengchangNum = [[dict objectForKey:@"zhengchangNum"] intValue];
                CA.noRecordNum = [[dict objectForKey:@"noRecordNum"] intValue];
                NSString *dateStr = [dict objectForKey:@"mydate"];
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
                CA.mydate = result;
                // 学生基本信息列表
                NSArray *StudentListArray = [dict objectForKey:@"UserAttList"];
                if (StudentListArray && [StudentListArray count] > 0) {
                    NSMutableArray *SLArray = [[NSMutableArray alloc] init];
                    NSMutableArray *SADArray = [[NSMutableArray alloc] init];
                    for (int i = 0; i < [StudentListArray count]; i ++) {
                        StudentAttList *SAL = [[StudentAttList alloc] init];
                        SAL.UserName = [StudentListArray[i] objectForKey:@"UserName"];
                        SAL.ClassId = [[StudentListArray[i] objectForKey:@"ClassId"] longLongValue];
                        SAL.UserId = [[StudentListArray[i] objectForKey:@"UserId"] intValue];
                        // 学生考勤情况
                        NSMutableArray *SADArray1 = [StudentListArray[i] objectForKey:@"myAttendanceList"];
                        for (int j = 0; j < [SADArray1 count]; j ++) {
                            StudentAttDetails *SAD = [[StudentAttDetails alloc] init];
                            SAD.dtype = [[SADArray1[j] objectForKey:@"dtype"] intValue];
                            SAD.count = [[SADArray1[j] objectForKey:@"count"] intValue];
                            SAD.Memo = [SADArray1[j] objectForKey:@"Memo"];
                            [SADArray addObject:SAD];
                            [SLArray addObject:SAL];
                        }
                    }
                    CA.myAttendanceListArray = SADArray;
                    CA.UserAttListArray = SLArray;
                }
                [classAttendanceArray addObject:CA];
                if (successBlock) {
                    successBlock(classAttendanceArray);
                }
            } else {
                if (failedBlock) {
                    failedBlock(@"没有获取到数据。。");
                }
            }
        } else{
            if (failedBlock) {
                failedBlock(@"暂无数据");
            }
        }
    } failed:^(NSString *message) {
        failedBlock(@"暂无数据。。。");
    }];
}

#pragma mark -- 某个学生的考勤详情（老师）
#pragma mark --

- (void)otherStudentsAttenanceDetails:(long long)classId
                               mydate:(NSString *)mydate
                               userid:(NSString *)userid
                             username:(NSString *)username
                              success:(void(^)(NSMutableArray* data))successBlock
                               failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *url = [NSString stringWithFormat:@"http://interface.%@/ClassInfo/GetNewAttendanceByUserId",aedudomain];
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@?classId=%lld&mydate=%@&userid=%@&username=%@", url, classId,mydate,userid,username];
    NSString * encodedString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)requestUrl, NULL, NULL,  kCFStringEncodingUTF8 );
    [self handerGetRequest:encodedString parameters:nil body:nil success:^(NSDictionary *data) {
        NSInteger statusCode = [[data objectForKey:@"st"] intValue];
        if (statusCode == 0) {
            NSMutableDictionary *dict = (NSMutableDictionary *)[data objectForKey:@"msg"];
            NSMutableArray *array = (NSMutableArray *)[dict objectForKey:@"myAttendanceList"];
            if (array && [array count] > 0) {
                NSMutableArray *studentAttendanceArray = [NSMutableArray arrayWithCapacity:[array count]];
                for (int k = 0; k < [array count]; k ++) {
                    StudentAttDetails *SAD = [[StudentAttDetails alloc] init];
                    SAD.dtype = [[array[k] objectForKey:@"dtype"] intValue];
                    SAD.count = [[array[k] objectForKey:@"count"] intValue];
                    NSString *substr = [array[k] objectForKey:@"Memo"];
                    NSString *newStr = [substr stringByReplacingOccurrencesOfString:@"|" withString:@""];
                    SAD.Memo = newStr;                    
                    [studentAttendanceArray addObject:SAD];
                }
                
                if (successBlock) {
                    successBlock(studentAttendanceArray);
                }
            } else{
                if (failedBlock) {
                    failedBlock(@"没有获取到数据。。。");
                }
            }
        } else{
            if (failedBlock) {
                failedBlock(@"暂无数据");
            }
        }
        
    } failed:^(NSString *message) {
        failedBlock(@"暂无数据。。。");
    }];
    
}

#pragma mark -- 一个班级一个时间段内的未刷卡考勤计数统计
#pragma mark --

- (void)noSwipingCardNumber:(long long)classId
                mybegindate:(NSString *)mybegindate
                  myenddate:(NSString *)myenddate
                   UserType:(int)UserType
                    success:(void(^)(NSMutableArray* data))successBlock
                     failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *url = [NSString stringWithFormat:@"http://interface.%@/ClassInfo/GetNoRecordAttendanceByDatePeriod",aedudomain];
    NSString *requestUrl = [NSString stringWithFormat:@"%@?classId=%lld&mybegindate=%@&myenddate=%@&UserType=%d", url, classId,mybegindate,myenddate,UserType];
    NSString * encodedString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)requestUrl, NULL, NULL,  kCFStringEncodingUTF8 );
    [self handerGetRequest:encodedString parameters:nil body:nil success:^(NSDictionary *data) {
        @try {
            NSString* st=[data objectForKey:@"st"];
            if ([st isEqual:@"-?"]) {
                failedBlock(@"参数错误");
            }else{
                NSInteger statusCode = [st intValue];
                if (statusCode==0) {
                   NSArray* array= [data objectForKey:@"msg"];
                    NSMutableArray* result=[[NSMutableArray alloc] init];
                    for (int i=0; i<[array count]; i++) {
                        NSDictionary* dic=[array objectAtIndex:i];
                        ClassNoSwipingCardNumber* cnsc=[[ClassNoSwipingCardNumber alloc] init];
                        cnsc.ClassId=[[dic objectForKey:@"ClassId"] longLongValue];
                        cnsc.ClassName=@"";
                        cnsc.dType=[[dic objectForKey:@"dType"] intValue];
                        cnsc.Num=[[dic objectForKey:@"Num"] intValue];
                        cnsc.UserNames=(NSString *)[dic objectForKey:@"UserNames"];
                        cnsc.PopNum=[[dic objectForKey:@"PopNum"] intValue];
                        cnsc.PopMemo=(NSString *)[dic objectForKey:@"PopMemo"];
                        cnsc.UsersList= [dic objectForKey:@"UsersList"];
                        [result addObject:cnsc];
                    }
                    successBlock(result);
                }else{
                    failedBlock(@"暂无数据");
                }
            }
        }
        @catch (NSException *exception) {
            failedBlock(@"请求出现错误");
        }
    } failed:^(NSString *message) {
        failedBlock(@"请求出现错误");
    }];
}


#pragma mark -- 一个班级一个时间段内的异常考勤计数统计
#pragma mark --

- (void)YCAttendance:(long long)classId
                mybegindate:(NSString *)mybegindate
                  myenddate:(NSString *)myenddate
                   UserType:(int)UserType
                    success:(void(^)(NSMutableArray* data))successBlock
                     failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *url = [NSString stringWithFormat:@"http://interface.%@/ClassInfo/GetYCAttendanceNumByDatePeriod",aedudomain];
    NSString *requestUrl = [NSString stringWithFormat:@"%@?classId=%lld&mybegindate=%@&myenddate=%@&UserType=%d", url, classId,mybegindate,myenddate,UserType];
    NSString * encodedString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)requestUrl, NULL, NULL,  kCFStringEncodingUTF8 );
    [self handerGetRequest:encodedString parameters:nil body:nil success:^(NSDictionary *data) {
        @try {
            NSString* st=[data objectForKey:@"st"];
            if ([st isEqual:@"-?"]) {
                failedBlock(@"参数错误");
            }else{
                NSInteger statusCode = [st intValue];
                if (statusCode==0) {
                    NSArray* array= [data objectForKey:@"msg"];
                    NSMutableArray* result=[[NSMutableArray alloc] init];
                    for (int i=0; i<[array count]; i++) {
                        NSDictionary* dic=[array objectAtIndex:i];
                        ClassNoSwipingCardNumber* cnsc=[[ClassNoSwipingCardNumber alloc] init];
                        cnsc.ClassId=[[dic objectForKey:@"ClassId"] longLongValue];
                        cnsc.ClassName=@"";
                        cnsc.dType=[[dic objectForKey:@"dType"] intValue];
                        cnsc.Num=[[dic objectForKey:@"Num"] intValue];
                        cnsc.UserNames=(NSString *)[dic objectForKey:@"UserNames"];
                        cnsc.PopNum=[[dic objectForKey:@"PopNum"] intValue];
                        cnsc.PopMemo=(NSString *)[dic objectForKey:@"PopMemo"];
                        cnsc.UsersList= [dic objectForKey:@"UsersList"];
                        [result addObject:cnsc];
                    }
                    successBlock(result);
                }else{
                    failedBlock(@"暂无数据");
                }
            }
        }
        @catch (NSException *exception) {
            failedBlock(@"请求出现错误");
        }
    } failed:^(NSString *message) {
        failedBlock(@"请求出现错误");
    }];
}


#pragma mark -- 一个班级一个时间段内的正常考勤计数统计
#pragma mark --

- (void)ZCAttendance:(long long)classId
         mybegindate:(NSString *)mybegindate
           myenddate:(NSString *)myenddate
            UserType:(int)UserType
             success:(void(^)(int data))successBlock
              failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *url = [NSString stringWithFormat:@"http://interface.%@/ClassInfo/GetZCAttendanceNumByDatePeriod",aedudomain];
    NSString *requestUrl = [NSString stringWithFormat:@"%@?classId=%lld&mybegindate=%@&myenddate=%@&UserType=%d", url, classId,mybegindate,myenddate,UserType];
    NSString * encodedString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)requestUrl, NULL, NULL,  kCFStringEncodingUTF8 );
    [self handerGetRequest:encodedString parameters:nil body:nil success:^(NSDictionary *data) {
        @try {
            NSString* st=[data objectForKey:@"st"];
            if ([st isEqual:@"-?"]) {
                failedBlock(@"参数错误");
            }else{
                NSInteger statusCode = [st intValue];
                if (statusCode==0) {
                    int result= [[data objectForKey:@"msg"] intValue];
                    successBlock(result);
                }else{
                    failedBlock(@"暂无数据");
                }
            }
        }
        @catch (NSException *exception) {
            failedBlock(@"请求出现错误");
        }
    } failed:^(NSString *message) {
        failedBlock(@"请求出现错误");
    }];
}



#pragma mark -- 刷卡记录（老师）
#pragma mark -- 
- (void)SwipingCardRecordNumber:(long long)classId
                    mybegindate:(NSString *)mybegindate
                      myenddate:(NSString *)myenddate
                        success:(void(^)(NSMutableArray* data))successBlock
                         failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *url = [NSString stringWithFormat:@"http://interface.%@/ClassInfo/GetUserAttendanceInfoListByDatePer",aedudomain];
    NSString *requestUrl = [NSString stringWithFormat:@"%@?classId=%lld&mybegindate=%@&myenddate=%@", url, classId,mybegindate,myenddate];
    NSString * encodedString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)requestUrl, NULL, NULL,  kCFStringEncodingUTF8 );
    [self handerGetRequest:encodedString parameters:nil body:nil success:^(NSDictionary *data) {
        NSInteger statusCode = [[data objectForKey:@"st"] intValue];
        if (statusCode == 0) {
            NSMutableArray *array = [data objectForKey:@"msg"];
            if (array && [array count] > 0) {
                NSMutableArray *studentSwipingCardArray = [NSMutableArray arrayWithCapacity:[array count]];
                for (int i = 0; i < [array count]; i ++) {
                    SwipingCardRecor *SCR = [[SwipingCardRecor alloc] init];
                    SCR.LineId = [[array[i] objectForKey:@"LineId"] intValue];
                    SCR.SchoolId = [[array[i] objectForKey:@"SchoolId"] intValue];
                    SCR.ClassId = [[array[i] objectForKey:@"ClassId"] longLongValue];
                    SCR.UserId = [[array[i] objectForKey:@"UserId"] intValue];
                    SCR.UserType = [[array[i] objectForKey:@"UserType"] intValue];
                    SCR.UserName = [array[i] objectForKey:@"UserName"];
                    SCR.usertypename = [array[i] objectForKey:@"usertypename"];
                    NSString *dateStr = [array[i] objectForKey:@"swingtime"];
                    NSString *newStr = [dateStr stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
                    SCR.swingtime = newStr;
                    [studentSwipingCardArray addObject:SCR];
                }
                if (successBlock) {
                    successBlock(studentSwipingCardArray);
                }
            }
        } else {
            if (failedBlock) {
                failedBlock(@"暂无数据");
            }
        }
    } failed:^(NSString *message) {
        if (failedBlock) {
            failedBlock(@"暂无数据");
        }
    }];
    
    
}

#pragma mark -- 一个班级一个时间段内的正常考勤计数统计
#pragma mark --

- (void)GetChildInfoWithPid:(NSString*)parentid
             success:(void(^)(NSDictionary* data))successBlock
              failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *url = [NSString stringWithFormat:@"http://home.%@/Api/GetStudentId?userid=",aedudomain];
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@",url, parentid];
    NSString * encodedString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)requestUrl, NULL, NULL,  kCFStringEncodingUTF8 );
    [self handerGetRequest:encodedString parameters:nil body:nil success:^(NSDictionary *data) {
        @try {
            NSString* st=[data objectForKey:@"st"];
            if ([st isEqual:@"-?"]) {
                failedBlock(@"参数错误");
            }else{
                NSInteger statusCode = [st intValue];
                if (statusCode==0) {
                    NSDictionary* dic= [data objectForKey:@"msg"];
                    int totalCount=[[dic objectForKey:@"totalCount"] intValue];
                    if (totalCount==1) {
                        NSArray* arr=[dic objectForKey:@"list"];
                        dic=arr[0];
                        successBlock(dic);
                    }else{
                        failedBlock(@"暂无数据");
                    }
                }else{
                    failedBlock(@"暂无数据");
                }
            }
        }
        @catch (NSException *exception) {
            failedBlock(@"请求出现错误");
        }
    } failed:^(NSString *message) {
        failedBlock(@"请求出现错误");
    }];
}

#pragma mark -- 获取某个学生某个月有考勤异常的日期
#pragma mark --

- (void)GetYCByDate:(NSDate*)date uid:(NSString*)uid
                    success:(void(^)(NSArray* data))successBlock
                     failed:(void(^)(NSString *errorMSG))failedBlock
{
    
    NSDateComponents *dateComponent=[self getComponentsWithDate:date];
    int y=dateComponent.year;
    int m=dateComponent.month;
    int d=01;
    NSString* datestr=[NSString stringWithFormat:@"%d-%d-%d",y,m,d];
    NSString *requestUrl = [NSString stringWithFormat:@"http://interface.%@/classinfo/GetYCDateByUserIdMonth?UserId=%@&myDate=%@",aedudomain,uid,datestr];
    NSString * encodedString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)requestUrl, NULL, NULL,  kCFStringEncodingUTF8 );
    [self handerGetRequest:encodedString parameters:nil body:nil success:^(NSDictionary *data) {
        @try {
            NSString* st=[data objectForKey:@"st"];
            NSInteger statusCode = [st intValue];
            if (statusCode==0) {
                NSArray* arr= [data objectForKey:@"msg"];
                successBlock(arr);
            }else{
                failedBlock(@"暂无数据");
            }
        }
        @catch (NSException *exception) {
            failedBlock(@"请求出现错误");
        }
    } failed:^(NSString *message) {
        failedBlock(@"请求出现错误");
    }];
}

#pragma mark -- 个人时间段内的考勤详情
#pragma mark --

- (void)CertainTimeAttendanceDetails:(int)userid
                         mybegindate:(NSString *)mybegindate
                           myenddate:(NSString *)myenddate
                             success:(void(^)(NSMutableArray* data))successBlock
                              failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *url = [NSString stringWithFormat:@"http://interface.%@/classinfo/GetAttendancesByDatePeriod",aedudomain];
    NSString *requestUrl = [NSString stringWithFormat:@"%@?userid=%d&mybegindate=%@&myenddate=%@", url, userid,mybegindate,myenddate];
    NSString * encodedString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)requestUrl, NULL, NULL,  kCFStringEncodingUTF8 );
    [self handerGetRequest:encodedString parameters:nil body:nil success:^(NSDictionary *data) {
        NSInteger statusCode = [[data objectForKey:@"st"] intValue];
        if (statusCode == 0) {
            NSMutableArray *array = [data objectForKey:@"msg"];
            if (array && [array count] > 0) {
                NSMutableArray *studentSwipingCardArray = [NSMutableArray arrayWithCapacity:[array count]];
                for (int i = 0; i < [array count]; i ++) {
                    ChildATTRecord * CAR = [[ChildATTRecord alloc] init];
                    CAR.ClassId = [[array[i] objectForKey:@"ClassId"] longLongValue];
                    CAR.UserId = [[array[i] objectForKey:@"UserId"] intValue];
                    if (![[array[i] objectForKey:@"UserName"] isKindOfClass:[NSNull class]]) {
                        CAR.UserName = [array[i] objectForKey:@"UserName"];
                    } else {
                        CAR.UserName = @"";
                    }
                    CAR.mydate=[array[i] objectForKey:@"mydate"];
                    NSMutableArray *CARArray = [array[i] objectForKey:@"myAttendanceList"];
                    NSMutableArray *SADArray = [[NSMutableArray alloc] init];
                    for (int j = 0; j < [CARArray count]; j ++) {
                        StudentAttDetails *SAD = [[StudentAttDetails alloc] init];
                        SAD.dtype = [[CARArray[j] objectForKey:@"dtype"] intValue];
                        SAD.count = [[CARArray[j] objectForKey:@"count"] intValue];
                        NSString *substr = [CARArray[j] objectForKey:@"Memo"];
                        NSString *newStr = [substr stringByReplacingOccurrencesOfString:@"|" withString:@""];
                        SAD.Memo = newStr;
                        [SADArray addObject:SAD];
                    }
                    CAR.myAttendanceList = SADArray;
                    [studentSwipingCardArray addObject:CAR];
                }
                if (successBlock) {
                    successBlock(studentSwipingCardArray);
                }
            }else{
                if (failedBlock) {
                    failedBlock(@"暂无数据...");
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


#pragma mark -- 获取学生所在班级
#pragma mark -- 
- (void)GetStudentClassDetails:(int)studentid
                       success:(void(^)(NSMutableArray* data))successBlock
                        failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *url = [NSString stringWithFormat:@"http://interface.%@/classinfo/GetClassInfoByStuId",aedudomain];
    NSString *requestUrl = [NSString stringWithFormat:@"%@?studentid=%d", url, studentid];
    NSString * encodedString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)requestUrl, NULL, NULL,  kCFStringEncodingUTF8 );
    [self handerGetRequest:encodedString parameters:nil body:nil success:^(NSDictionary *data) {
        NSInteger statusCode = [[data objectForKey:@"st"] intValue];
        if (statusCode == 0) {
            // 不做数据结构分析，直接传原数据到界面（涂方便）
            NSMutableArray *studentArray = [data objectForKey:@"msg"];
            if (successBlock) {
                successBlock(studentArray);
            }
        } else {
            if (failedBlock) {
                failedBlock(@"暂无数据...");
            }
        }
    } failed:^(NSString *message) {
        if (failedBlock) {
            failedBlock(@"暂无数据...");
        }
    }];
}


#pragma mark -- 获取学生考勤统计（家长）
#pragma mark --

- (void)GetStudentCheckingRecords:(long long)classId
                           mydate:(NSString *)mydate
                           userid:(int)userid
                          success:(void(^)(NSMutableArray* data))successBlock
                           failed:(void(^)(NSString *errorMSG))failedBlock
{
    NSString *url = [NSString stringWithFormat:@"http://interface.%@/ClassInfo/GetNewAttendanceByUserId",aedudomain];
    NSString *requestUrl = [NSString stringWithFormat:@"%@?classId=%lld&mydate=%@&userid=%d", url, classId,mydate,userid];
    NSString * encodedString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)requestUrl, NULL, NULL,  kCFStringEncodingUTF8 );
    [self handerGetRequest:encodedString parameters:nil body:nil success:^(NSDictionary *data) {
        NSInteger statusCode = [[data objectForKey:@"st"] intValue];
        if (statusCode == 0) {
            NSMutableDictionary *dict = [data objectForKey:@"msg"];
            NSMutableArray *studentCheckingRecordsArray = [NSMutableArray arrayWithCapacity:[dict count]];
            ChildATTRecord * CAR = [[ChildATTRecord alloc] init];
            if (dict && [dict count] > 0) {
                NSMutableArray *SADArray = [[NSMutableArray alloc] init];
                for (int i = 0; i < [dict count]; i ++) {
                    CAR.UserId = [[dict objectForKey:@"UserId"] intValue];
                    CAR.UserName = [dict objectForKey:@"UserName"];
                    CAR.ClassId = [[dict objectForKey:@"ClassId"] longLongValue];
                    // 学生考勤情况
                    NSMutableArray *CARArray = [dict objectForKey:@"myAttendanceList"];
                    if (CARArray && [CARArray count] > 0) {
                        for (int j = 0; j < [CARArray count]; j ++) {
                            StudentAttDetails *SAD = [[StudentAttDetails alloc] init];
                            SAD.dtype = [[CARArray[j] objectForKey:@"dtype"] intValue];
                            SAD.count = [[CARArray[j] objectForKey:@"count"] intValue];
                            NSString *substr = [CARArray[j] objectForKey:@"Memo"];
                            NSString *newStr = [substr stringByReplacingOccurrencesOfString:@"|" withString:@""];
                            SAD.Memo = newStr;
                            [SADArray addObject:SAD];
                        }
                    }
                }
                CAR.myAttendanceList = SADArray;
            }
            
            [studentCheckingRecordsArray addObject:CAR];
            if (successBlock) {
                successBlock(studentCheckingRecordsArray);
            }
        } else{
            if (failedBlock) {
                failedBlock(@"暂无数据...");
            }
        }
    } failed:^(NSString *message) {
        if (failedBlock) {
            failedBlock(@"暂无数据...");
        }
    }];
    
}

//===================================================时间操作工具==============================================

-(NSDate*)setDate:(NSDate*)date withSecond:(int)second{
    NSTimeInterval seconds=second;
    date = [date dateByAddingTimeInterval: seconds];
    return date;
}

-(NSDate*)setDate:(NSDate*)date withMinute:(int)minute{
    return [self setDate:date withSecond:minute*60];
}

-(NSDate*)setDate:(NSDate*)date withHour:(int)hour{
    return [self setDate:date withMinute:hour*60];
}

-(NSDate*)setDate:(NSDate*)date withDay:(int)day{
    return [self setDate:date withHour:day*24];
}

-(NSDateComponents*)getComponentsWithDate:(NSDate*)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:date];
    return dateComponent;
}

-(int)getYearByDate:(NSDate*)date{
    NSDateComponents *dateComponent=[self getComponentsWithDate:date];
    return [dateComponent year];
}

-(int)getMonthByDate:(NSDate*)date{
    NSDateComponents *dateComponent=[self getComponentsWithDate:date];
    return [dateComponent month];
}

-(int)getDayByDate:(NSDate*)date{
    NSDateComponents *dateComponent=[self getComponentsWithDate:date];
    return [dateComponent day];
}

-(int)getHourByDate:(NSDate*)date{
    NSDateComponents *dateComponent=[self getComponentsWithDate:date];
    return [dateComponent hour];
}

-(int)getMinuteByDate:(NSDate*)date{
    NSDateComponents *dateComponent=[self getComponentsWithDate:date];
    return [dateComponent minute];
}

-(int)getSecondByDate:(NSDate*)date{
    NSDateComponents *dateComponent=[self getComponentsWithDate:date];
    return [dateComponent second];
}

-(int)getWeekByDate:(NSDate*)date{
    NSDateComponents *dateComponent=[self getComponentsWithDate:date];
    return [dateComponent weekday]-1;
}

-(int)getDaysForMonthWithDate:(NSDate*)date{
    NSCalendar *c = [NSCalendar currentCalendar];
    NSRange days = [c rangeOfUnit:NSCalendarUnitDay
                           inUnit:NSCalendarUnitMonth
                          forDate:date];
    return days.length;
}


@end
