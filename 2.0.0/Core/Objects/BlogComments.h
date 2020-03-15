//
//  BlogComments.h
//  RenrenTong
//
//  Created by 符其彬 on 14-8-24.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BlogComments : NSObject
@property (nonatomic, copy)NSString *AtNickName;
@property (nonatomic, assign)int AtUserId;
@property (nonatomic, assign)int UserId;
@property (nonatomic, copy)NSString *Author;
@property (nonatomic, copy)NSString *Body;
@property (nonatomic, copy)NSString *DateCreatedStr;
@property (nonatomic, assign)int Id;
@property (nonatomic, assign)int OwnerId;
@property (nonatomic, assign)int ParentId;
@property (nonatomic, copy)NSString *Subject;
@property (nonatomic, assign)int TenantTypeId;
@property (nonatomic, assign) int CommentedObjectId;

@end
