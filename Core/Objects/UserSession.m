//
//  UserSession.m
//  AsianEducation
//
//  Created by apple on 13-3-12.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "UserSession.h"

@implementation UserSession
static UserSession* instance=nil;
+(UserSession*)shareUserSession{
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

- (void)dealloc
{
    NSLog(@"%@  %@",NSStringFromClass([self class]),NSStringFromSelector(_cmd));
}




@end
