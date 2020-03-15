//
//  ReceiveMessage.h
//  RenrenTong
//
//  Created by aedu on 15/3/6.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReceiveMessage : NSObject
/**
 *  消息内容
 */
@property(nonatomic, strong)NSString *MessageContent;
/**
 *  音频
 */
@property(nonatomic, strong)NSArray *Audio;
/**
 *  图片
 */
@property(nonatomic, strong)NSArray *Pic;
/**
 *  发送者信息
 */
@property(nonatomic, strong)NSDictionary *PubUser;
/**
 *  接收者信息
 */
@property(nonatomic, strong)NSDictionary *RecieveUser;

/**
 *  时间
 */
@property(nonatomic, strong)NSString *PubTime;

/**
 *  消息ID
 */
@property(nonatomic, strong)NSString *MessageId;
/**
 *  数据库的ID
 */
@property(nonatomic, strong)NSString *LineId;
/**
 *  消息状态
 */
@property(nonatomic, assign)int StatusId;
/**
 *  消息类型
 */
@property(nonatomic, assign)int Type;
/**
 *  消息类型
 */
@property(nonatomic, assign)int HeadType;
/**
 *  消息类型
 */
@property(nonatomic, assign)int BodyType;
/**
 *  数据库的ID
 */
@property(nonatomic, strong)NSString *GroupId;
/**
 *  数据库的ID
 */
@property(nonatomic, strong)NSString *GroupName;
/**
 *  数据库的ID
 */
@property(nonatomic, strong)NSString *GroupType;
/**
 *  推送消息url
 */
@property(nonatomic,strong) NSString *Url;
/**
 *  推送消息描述
 */
@property(nonatomic,strong) NSString *UrlDescription;
/**
 *  推送消息图片
 */
@property(nonatomic,strong) NSString *UrlPicture;
@end
