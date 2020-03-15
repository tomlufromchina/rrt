//
//  CommentCentent.h
//  RenrenTong
//
//  Created by aedu on 15/3/27.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentCentent : NSObject

@property(nonatomic, strong)NSString *Author; ///评论人的名字
@property(nonatomic, strong)NSString *Body; //内容
@property(nonatomic, assign)int ChildCount;
@property(nonatomic, strong)NSNumber *CommentedObjectId; //内容
@property(nonatomic, strong)NSString *DateCreated; //时间
@property(nonatomic, assign)int Id;
@property(nonatomic, assign)BOOL IsAnonymous;
@property(nonatomic, assign)BOOL IsPrivate;
@property(nonatomic, assign)int OwnerId;  //拥有人id
@property(nonatomic, assign)int ParentId; ;//上级id
@property(nonatomic, strong)NSString *TenantTypeId;
@property(nonatomic, strong)NSString *ToUserDisplayName; //回复对象姓名
@property(nonatomic, assign)int ToUserId; //id
@property(nonatomic, assign)int UserId; //自己

@end
