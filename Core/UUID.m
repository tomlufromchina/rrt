//
//  UUID.m
//  IM
//
//  Created by 唐彬 on 15-1-19.
//  Copyright (c) 2015年 唐彬. All rights reserved.
//

#import "UUID.h"

@implementation UUID
+(NSString *) uuid
{
    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    CFStringRef uuid_string_ref= CFUUIDCreateString(NULL, uuid_ref);
    CFRelease(uuid_ref);
    NSString *uuid = [NSString stringWithString:(__bridge NSString*)uuid_string_ref];
    CFRelease(uuid_string_ref);
    uuid=[uuid stringByReplacingOccurrencesOfString:@"-" withString:@""];
    return uuid;
}
@end
