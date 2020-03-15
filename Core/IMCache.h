//
//  IMCache.h
//  IM
//
//  Created by 唐彬 on 15-1-4.
//  Copyright (c) 2015年 唐彬. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "BasePacket.pb.h"

@interface IMCache : NSObject
+(IMCache*)shareIMCache;
- (BOOL)savePacket:(Packet*)packet sessionid:(NSString*)sessionid;
/**
 *  获取资源推荐数组数据
 *
 *  @return 返回数据
 */
- (NSMutableArray*)queryPacketRecomment:(BOOL)isLatest uid:(NSString*)uid;
- (NSMutableArray*)queryPacketFriendID:(NSString*)friendid userid:(NSString*)userid;
/**
 *获取群组消息
 */
- (NSMutableArray*)queryPacketGroupID:(NSString*)groupid userid:(NSString*)userid;
/**
 *根据登陆用户id获取会话列表
 */
- (NSMutableArray*)queryPacketFriendSessionList:(NSString*)userid;
/**
 *保存语音
 */
- (BOOL)saveAudio:(NSString*)url filename:(NSString*)filename;
/**
 *读取语音
 */
- (NSString*)queryFile:(NSString*)url;
//获取推送类型飘红数量
-(int)getPushBrage:(NSString*)uid;
//获取所有好友消息飘红数量
-(int)getAllFriendBrage:(NSString*)uid;
//获取会话消息飘红数量
-(int)getSessionBrageFriendID:(NSString*)friendid userid:(NSString*)userid;
//获取群聊会话消息飘红数量
-(int)getSessionBrageGroupid:(NSString*)groupid userid:(NSString*)userid;
//获取好友聊天未读消息
-(NSMutableArray*)getUnReadPacket:(NSString*)friendid userid:(NSString*)userid;
//获取群组聊天未读消息
-(NSMutableArray*)getGroupUnReadPacket:(NSString*)groupid userid:(NSString*)userid;
//更新消息状态
-(BOOL)updatePacketState:(NSString*)guid state:(int)state;
//获取未读推送
-(NSMutableArray*)getUnReadPushPacket:(NSString*)userid;
//获取需要同步的消息
-(NSMutableArray*)getUnSynPacket:(NSString*)userid;
/**
 *根据guid获取消息
 */
- (Packet*)queryPacketWithGuid:(NSString*)guid;
/**
 *获取最后一条家校通消息
 **/
-(Packet*)queryLastPushPacket:(NSString*)uid;
//是否有群聊消息
-(BOOL)hasGroupMessage:(NSString*)userid groupid:(NSString*)groupid;
@end
