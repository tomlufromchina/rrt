//
//  ISingHTTPRequestOperationManager.m
//  nextSing
//
//  Created by nannan liu on 14-3-20.
//  Copyright (c) 2014年 iflytek. All rights reserved.
//

#import "ISingHTTPRequestOperationManager.h"

@implementation ISingHTTPRequestOperationManager

+ (instancetype)getManager{
    return [[[self class] alloc] initWithBaseURL:nil];
}

- (instancetype)initWithBaseURL:(NSURL *)url{
    self = [super initWithBaseURL:url];
    if (self) {
        self.shouldCompressRequestBody = NO;
        self.shouldDesEncrypt = NO;
    }
    return self;
}
- (instancetype)init{
    self = [super init];
    if (self) {
        self.shouldDesEncrypt = NO;
        self.shouldCompressRequestBody = NO;
    }
    return self;
}
@end
