//
//  RRTManager.m
//  RenrenTong
//
//  Created by jeffrey on 14-5-21.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "RRTManager.h"

static RRTManager *instance = nil;

@implementation RRTManager

+ (instancetype)manager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[RRTManager alloc] init];
    });

    return instance;
}

- (id)init
{
    self= [super init];
    if (self) {
        _loginManager = [[LoginManager alloc] init];
    }

    return  self;
}




@end
