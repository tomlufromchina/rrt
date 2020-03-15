//
//  Microblog.h
//  RenrenTong
//
//  Created by aedu on 15/3/27.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Microblog : NSObject
/**
*  话题id
*/
@property(nonatomic, strong)NSNumber *MicroblogId;
/**
 *  话题内容
 */
@property(nonatomic, strong)NSString *Body;
/**
 *  评论数
 */
@property(nonatomic, assign)int CommentCount;
/**
 *  日期
 */
@property(nonatomic, strong)NSString *DateTime;
/**
 *  转发数
 */
@property(nonatomic, assign)int ForwardedCount;
/**
 *  喜欢数
 */
@property(nonatomic, assign)int FavoriteCount;
/**
 *  点赞数
 */
@property(nonatomic, assign)int PraiseCount;
/**
 *  是否已赞
 */
@property(nonatomic, assign)int IsPraise;
/**
 *  来源
 */
@property(nonatomic, assign)int From;

/**
 *  用户头像
 */
@property(nonatomic, strong)NSString *PictureUrl;
/**
 *  用户id
 */
@property(nonatomic, strong)NSString *UserId;
/**
 *  用户名
 */
@property(nonatomic, strong)NSString *UserName;
/**
 *  评论内容
 */
@property(nonatomic, strong)NSArray *CommentCentent;
/**
 *  点赞者
 */
@property(nonatomic, strong)NSArray *PraiseUsers;
/**
 *  话题图片
 */
@property(nonatomic, strong)NSArray *ImagesUrl;

@end
