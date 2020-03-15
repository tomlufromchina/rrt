//
//  FileDownload.h
//  RenrenTong
//
//  Created by 唐彬 on 15-2-5.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMCache.h"
@interface FileDownload : NSObject<NSURLConnectionDelegate>
+(NSString*)download:(NSString*)url;
@end
