//
//  Advert.m
//  RenrenTong
//
//  Created by 符其彬 on 14/12/24.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "Advert.h"

@implementation Advert
static Advert* instance=nil;
+(Advert*)shareAdvert{
    @synchronized(self){
        if (instance==nil) {
            instance=[[super alloc] init];
        }
        return instance;
    }
}

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

//从网络下载图片(登录页面)
-(void) getImageFromURL:(NSString *)fileURL {
    
    NSString * documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSLog(@"保存路径:%@",documentsDirectoryPath);
    NSLog(@"执行图片下载函数");
    UIImage * result;
    
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    result = [UIImage imageWithData:data];
    [self saveImage:result withFileName:@"MyImage" ofType:@"jpg" inDirectory:documentsDirectoryPath];
    //取得目录下所有文件名
    NSArray *file = [[[NSFileManager alloc] init] subpathsAtPath:documentsDirectoryPath];
    NSLog(@"沙盒下所有的保存文件：%@",file);
}

//从网络下载图片（首页）
-(void) getImageFromURL1:(NSString *)fileURL {
    
    NSString * documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSLog(@"保存路径:%@",documentsDirectoryPath);
    NSLog(@"执行图片下载函数");
    UIImage * result;
    
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    result = [UIImage imageWithData:data];
    [self saveImage:result withFileName:@"TheMyImage" ofType:@"png" inDirectory:documentsDirectoryPath];
    //取得目录下所有文件名
    NSArray *file = [[[NSFileManager alloc] init] subpathsAtPath:documentsDirectoryPath];
    NSLog(@"沙盒下所有的保存文件：%@",file);
}

//将所下载的图片保存到本地
- (void)saveImage:(UIImage *)image withFileName:(NSString *)imageName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath {
    if ([[extension lowercaseString] isEqualToString:@"png"]) {
        [UIImagePNGRepresentation(image) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"png"]] options:NSAtomicWrite error:nil];
    } else if ([[extension lowercaseString] isEqualToString:@"jpg"] || [[extension lowercaseString] isEqualToString:@"jpeg"]) {
        [UIImageJPEGRepresentation(image, 1.0) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"jpg"]] options:NSAtomicWrite error:nil];
    } else {
        NSLog(@"文件后缀不认识");
    }
}

- (void)dealloc
{
    NSLog(@"%@  %@",NSStringFromClass([self class]),NSStringFromSelector(_cmd));
}

@end
