//
//  HttpUtil.m
//  RenrenTong
//
//  Created by 符其彬 on 15/5/14.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "HttpUtil.h"

@implementation HttpUtil

+ (void)netWorkStatus:(void (^)(BOOL status))network
{
    network([HttpUtil isConnectionAvailable]);
}


+(BOOL) isConnectionAvailable{
    BOOL isExistenceNetwork = NO;
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.apple.com"];
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:
            isExistenceNetwork = NO;
            //NSLog(@"notReachable");
            break;
        case ReachableViaWiFi:
            isExistenceNetwork = YES;
            //NSLog(@"WIFI");
            break;
        case ReachableViaWWAN:
            isExistenceNetwork = YES;
            //NSLog(@"3G");
            break;
        default:
            isExistenceNetwork=NO;
            break;
    }
    return isExistenceNetwork;
}

+ (void)GetWithUrl:(NSString *)url parameters:(NSDictionary*)parameters success:(void (^)(id json))  success fail:(void (^)(id error))fail cache:(void (^)(id cache))cache
{
    cache([HttpUtil QueryCacheWithUrl:url parameters:parameters]);
    
    [HttpUtil netWorkStatus:^(BOOL status) {
        if (status) {
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            // 网络访问是异步的,回调是主线程的,因此程序员不用管在主线程更新UI的事情
            [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                if (success) {
                    NSString *json = [[NSString alloc] initWithData:responseObject  encoding:NSUTF8StringEncoding];
                    [self SaveCacheWithUrl:url parameters:parameters json:json];
                    success(json);
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"%@", error);
                if (fail) {
                    fail(error.localizedDescription);
                }
            }];
        }else{
            fail(NoNetworkingMsg);
            
        }
    }];
}

+ (void)PostWithUrl:(NSString *)url parameters:(NSDictionary*)parameters success:(void (^)(id json))success fail:(void (^)(id error))fail cache:(void (^)(id cache))cache
{
    cache([HttpUtil QueryCacheWithUrl:url parameters:parameters]);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    // 设置请求格式
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    // 设置返回格式
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [HttpUtil netWorkStatus:^(BOOL status) {
        if (status) {
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            // 网络访问是异步的,回调是主线程的,因此程序员不用管在主线程更新UI的事情
            [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                if (success) {
                    NSString *json = [[NSString alloc] initWithData:responseObject  encoding:NSUTF8StringEncoding];
                    success(json);
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"%@", error);
                if (fail) {
                    fail(error.localizedDescription);
                }
            }];
        }else{
            fail(NoNetworkingMsg);
        }
    }];
}

+ (void)sessionDownloadWithUrl:(NSString *)fileurl success:(void (^)(NSURL *filepath))success fail:(void (^)(id error))fail
{
    [HttpUtil netWorkStatus:^(BOOL status) {
        if (status) {
            NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
            AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:config];
            NSString *urlString = [fileurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSURL *url = [NSURL URLWithString:urlString];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
                // 指定下载文件保存的路径
                //        NSLog(@"%@ %@", targetPath, response.suggestedFilename);
                // 将下载文件保存在缓存路径中
                NSString *cacheDir = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
                NSString *path = [cacheDir stringByAppendingPathComponent:response.suggestedFilename];
                
                // URLWithString返回的是网络的URL,如果使用本地URL,需要注意
                //        NSURL *fileURL1 = [NSURL URLWithString:path];
                NSURL *filepath = [NSURL fileURLWithPath:path];
                
                //        NSLog(@"== %@ |||| %@", fileURL1, fileURL);
                if (success) {
                    success(filepath);
                }                return filepath;
            } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
                NSLog(@"%@ %@", filePath, error);
                if (fail) {
                    fail(error.localizedDescription);
                }
            }];
            
            [task resume];
        }else{
            fail(NoNetworkingMsg);
        }
    }];
}

+ (void)UploadFileWithUrl:(NSString *)url filepath:(NSURL *)filepath fileName:(NSString *)fileName fileType:(NSString *)fileTye success:(void (^)(id json))success fail:(void (^)(id error))fail
{
    [HttpUtil netWorkStatus:^(BOOL status) {
        if (status) {
            // 本地上传给服务器时,没有确定的URL,不好用MD5的方式处理
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            //@"http://localhost/demo/upload.php"
            [manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                //        NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"头像1.png" withExtension:nil];
                // 要上传保存在服务器中的名称
                // 使用时间来作为文件名 2014-04-30 14:20:57.png
                // 让不同的用户信息,保存在不同目录中
                //        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                //        // 设置日期格式
                //        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
                //        NSString *fileName = [formatter stringFromDate:[NSDate date]];
                //@"image/png"
                [formData appendPartWithFileURL:filepath name:@"uploadFile" fileName:fileName mimeType:fileTye error:NULL];
                
            } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                if (success) {
                    success(responseObject);
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (fail) {
                    fail(error.localizedDescription);
                }
            }];
        }else{
            fail(NoNetworkingMsg);
        }
    }];
}

//获取数据库
+(FMDatabase *)GetDataBase{
    //获取Document文件夹下的数据库文件，没有则创建
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *dbPath = [docPath stringByAppendingPathComponent:@"httpcache.db"];
    //获取数据库并打开
    FMDatabase *database  = [FMDatabase databaseWithPath:dbPath];
    if (![database open]) {
        NSLog(@"Open database failed");
        return nil;
    }
    //创建表（FMDB中只有update和query操作，出了查询其他都是update操作）
    [database executeUpdate:@"create table if not exists jsoncache (urlkey text,arg text,json text)"];
    return database;
}

//合并参数并过滤Token
+(NSString*)MergeParameters:(NSDictionary*)parameters{
    NSString* arg=@"";
    if (parameters!=nil&&[parameters count]>0) {
        for(id key in parameters) {
            if ([[key lowercaseString] isEqualToString:@"token"]) {
                break;
            }
            arg=[NSString stringWithFormat:@"%@key:%@value:%@", arg,key, [parameters objectForKey:key]];
        }
    }
    return arg;
}

//过滤Token
+(NSString*)FilterTokenWithUrl:(NSString*)url{
    url=[url lowercaseString];
    NSArray *params =[url componentsSeparatedByString:@"?"];
    url=@"";
    if (params) {
        for (int i=0; i<[params count]; i++) {
            NSString *param =[params objectAtIndex:i];
            if (i==0) {
                url=[url stringByAppendingString:[NSString stringWithFormat:@"%@?",param]];
                continue;
            }
            NSArray *kvs =[param componentsSeparatedByString:@"&"];
            for (NSString *kv in kvs) {
                if (![kv hasPrefix:@"token"]) {
                    if ([url hasSuffix:@"?"]) {
                        url=[url stringByAppendingString:[NSString stringWithFormat:@"%@",kv]];
                    }else{
                        url=[url stringByAppendingString:[NSString stringWithFormat:@"&%@",kv]];
                    }
                }
            }
        }
    }
    return url;
}

//查询缓存
+(NSString*)QueryCacheWithUrl:(NSString*)url parameters:(NSDictionary*)parameters{
    NSString* json=nil;
    NSString* arg=[HttpUtil MergeParameters:parameters];
    url=[HttpUtil FilterTokenWithUrl:url];
    FMDatabase *database = [HttpUtil GetDataBase];
    FMResultSet *resultSet = [database executeQuery:@"select * from jsoncache where urlkey = ? and arg = ?",url,arg];
    while ([resultSet next]) {
        json = [resultSet stringForColumn:@"json"];
        break;
    }
    [database close];
    return json;
}

//保存缓存
+(BOOL)SaveCacheWithUrl:(NSString*)url parameters:(NSDictionary*)parameters json:(NSString*)json{
    //插入以前判断是否存在该数据 因为可能插入多条数据，如果存在做更新操作
    NSString* queryjson=[self QueryCacheWithUrl:url parameters:parameters];
    if (queryjson!=nil&&[queryjson length]>0) {
        return [HttpUtil UpdateCacheWithUrl:url parameters:parameters json:json];
    }
    NSString* arg=[HttpUtil MergeParameters:parameters];
    url=[HttpUtil FilterTokenWithUrl:url];
    //获取数据库并打开
    FMDatabase *database  = [HttpUtil GetDataBase];
    //创建表（FMDB中只有update和query操作，出了查询其他都是update操作）
    [database executeUpdate:@"create table if not exists jsoncache (urlkey text,arg text,json text)"];
    //插入数据
    BOOL insert = [database executeUpdate:@"insert into jsoncache values (?,?,?)",url,arg,json];
    [database close];
    return insert;
    
}

//更新缓存
+ (BOOL)UpdateCacheWithUrl:(NSString*)url parameters:(NSDictionary*)parameters json:(NSString*)json {
    
    FMDatabase *database = [HttpUtil GetDataBase];
    NSString* arg=[HttpUtil MergeParameters:parameters];
    url=[HttpUtil FilterTokenWithUrl:url];
    //参数必须是NSObject的子类，int,double,bool这种基本类型，需要封装成对应的包装类才可以
    BOOL update = [database executeUpdate:@"update jsoncache set json = ? where urlkey = ? and arg = ?",json,url,arg];
    [database close];
    return update;
}
@end
