//
//  Microblog.m
//  RenrenTong
//
//  Created by aedu on 15/3/27.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "Microblog.h"
#import "MJExtension.h"
#import "PraiseUsers.h"
#import "CommentCentent.h"

@implementation Microblog
- (NSDictionary *)objectClassInArray
{
    return @{@"PraiseUsers": [PraiseUsers class],@"CommentCentent": [CommentCentent class],};
}


@end
