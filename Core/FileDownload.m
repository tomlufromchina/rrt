//
//  FileDownload.m
//  RenrenTong
//
//  Created by 唐彬 on 15-2-5.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "FileDownload.h"

@implementation FileDownload
+(NSString*)download:(NSString*)url{
    if (url==nil||url.length<=0) {
        return nil;
    }
    NSString* filepath = [[IMCache shareIMCache] queryFile:url];
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    if (filepath==nil) {
        NSURL    *downloadurl = [NSURL URLWithString:url];
        NSURLRequest *request = [NSURLRequest requestWithURL:downloadurl];
        NSError *error = nil;
        NSHTTPURLResponse* response=nil;
        NSData   *data = [NSURLConnection sendSynchronousRequest:request
                                               returningResponse:&response
                                                           error:&error];
        if (error==nil) {
            int statusCode = [response statusCode ];
            if (statusCode == 200)
            {
                if (data != nil){
                    NSArray *array = [url componentsSeparatedByString:@"/"];
                    filepath=[docPath stringByAppendingPathComponent:[array lastObject]];
                    if ([data writeToFile:filepath atomically:YES]) {
                        BOOL b=[[IMCache shareIMCache] saveAudio:url filename:[array lastObject]];
                        if (b) {
                            return filepath;
                        }else{
                            return nil;
                        }
                    }
                    else
                    {
                        return nil;
                    }
                }else{
                    return nil;
                }
            } else {
                return nil;
            }
        }
        else{
            return nil;
        }
    }
    else{
        filepath=[docPath stringByAppendingPathComponent:filepath];
        NSFileManager* filemanager= [NSFileManager defaultManager];
        BOOL b= [filemanager fileExistsAtPath:filepath];
        if (b) {
            return filepath;
        }else{
            return nil;
        }
    }
}


@end
