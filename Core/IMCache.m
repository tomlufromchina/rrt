//
//  IMCache.m
//  IM
//
//  Created by 唐彬 on 15-1-4.
//  Copyright (c) 2015年 唐彬. All rights reserved.
//

#import "IMCache.h"

@implementation IMCache
static IMCache* instance=nil;
+(IMCache*)shareIMCache{
    @synchronized(self){
        if (instance==nil) {
            instance=[[super alloc] init];
        }
        return instance;
    }
}

-(void)createMessageTable:(FMDatabase *)database{
    
//        [database executeUpdate:@"DROP TABLE messagecache"];
    NSString* sql=@"create table if not exists messagecache ";
    sql=[sql stringByAppendingString:@"(fromcln text not null"];
    sql=[sql stringByAppendingString:@",tocln text not null"];
    sql=[sql stringByAppendingString:@",errorcln text null"];
    sql=[sql stringByAppendingString:@",guid text primary key not null"];
    sql=[sql stringByAppendingString:@",autoid text null"];
    sql=[sql stringByAppendingString:@",mtype text not null"];
    sql=[sql stringByAppendingString:@",state text not null"];
    sql=[sql stringByAppendingString:@",mctype text not null"];
    sql=[sql stringByAppendingString:@",content text null"];
    sql=[sql stringByAppendingString:@",audiouri text null"];
    sql=[sql stringByAppendingString:@",pictureuri text null"];
    sql=[sql stringByAppendingString:@",fileuri text null"];
    sql=[sql stringByAppendingString:@",sender text not null"];
    sql=[sql stringByAppendingString:@",receiver text not null"];
    sql=[sql stringByAppendingString:@",sendtime text not null"];
    sql=[sql stringByAppendingString:@",receivetime text null"];
    sql=[sql stringByAppendingString:@",pushmsgtype text null"];
    sql=[sql stringByAppendingString:@",sessionid text not null"];
    sql=[sql stringByAppendingString:@",groupid text"];
    sql=[sql stringByAppendingString:@",groupname text"];
    sql=[sql stringByAppendingString:@",grouptype text"];
    sql=[sql stringByAppendingString:@",url text"];
    sql=[sql stringByAppendingString:@",urlpic text"];
    sql=[sql stringByAppendingString:@",urldesc text"];
    sql=[sql stringByAppendingString:@")"];
    //创建表（FMDB中只有update和query操作，出了查询其他都是update操作）
    [database executeUpdate:sql];
    sql=@"create table if not exists audiocache ";
    sql=[sql stringByAppendingString:@"(url text not null"];
    sql=[sql stringByAppendingString:@",filename text not null"];
    sql=[sql stringByAppendingString:@")"];
    //创建表（FMDB中只有update和query操作，出了查询其他都是update操作）
    [database executeUpdate:sql];
    
    [self upDateTable:database];
}

-(void)upDateTable:(FMDatabase *)database{
    //群消息支持--添加字段
    NSMutableArray* columns=[[NSMutableArray alloc] init];
    [columns addObject:@"groupid"];
    [columns addObject:@"groupname"];
    [columns addObject:@"grouptype"];
    [columns addObject:@"url"];
    [columns addObject:@"urlpic"];
    [columns addObject:@"urldesc"];
    for (NSString *column in columns) {
        BOOL b=[self checkColumnExists:database tablename:@"messagecache" columnName:column];
        if (!b) {
            [database executeUpdate:[NSString stringWithFormat:@"ALTER TABLE '%@' ADD '%@'",@"messagecache",column]];
        }
    }
}


/**
 *
 *检查表下是否存在列
 *
 */
-(BOOL)checkColumnExists:(FMDatabase *)database tablename:(NSString*)tablename columnName:(NSString*)columnName{
    NSString*sql=[NSString stringWithFormat:@"select * from %@",tablename];
    FMResultSet *rs=[database executeQuery:sql];
    for (int i=0;i<rs.columnCount;i++){
        if ([[rs columnNameForIndex:i] isEqualToString:columnName]){
            return YES;
        }
    }
    return NO;
}

-(FMDatabase*)getDataBase{
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *dbPath = [docPath stringByAppendingPathComponent:@"imcache.db"];
    
    //获取数据库并打开
    FMDatabase *database  = [FMDatabase databaseWithPath:dbPath];
    return database;
}

/**
 *保存消息
 */
- (BOOL)savePacket:(Packet*)packet sessionid:(NSString*)sessionid {
    if (packet==nil||!packet.hasMessage||sessionid==nil) {
        return NO;
    }
    //插入以前判断是否存在该数据 因为可能插入多条数据，如果存在做更新操作
    Packet* querypacket=[self queryPacketWithGuid:packet.message.guid];
    if (querypacket!=nil) {
        return [self update:packet];
    }
    
    //获取数据库并打开
    FMDatabase *database  = [self getDataBase];
    if (![database open]) {
        NSLog(@"Open database failed");
        return NO;
    }
    
    [self createMessageTable:database];
    NSString* from=packet.from;
    NSString* to=packet.to;
    NSString* error=@"";
    if (packet.hasError) {
        error=packet.error;
    }
    MessagePacket* mp= packet.message;
    NSString* guid=mp.guid;
    NSString* autoid=@"0";
    if (mp.hasAutoid) {
        autoid=[NSString stringWithFormat:@"%lli",mp.autoid];
    }
    NSString* mtype=[NSString stringWithFormat:@"%li", mp.type];
    NSString* state=[NSString stringWithFormat:@"%i",(int)mp.state];
    NSString* mctype=[NSString stringWithFormat:@"%li", mp.body.type];
    NSString* content=@"";
    if (mp.body.hasContent) {
        content=mp.body.content;
    }
    NSString* audiouri=@"";
    if (mp.body.hasAudiouri) {
        audiouri=mp.body.audiouri;
    }
    NSString* pictureuri=@"";
    if (mp.body.hasPictureuri) {
        pictureuri=mp.body.pictureuri;
    }
    NSString* fileuri=@"";
    if (mp.body.hasFileuri) {
        fileuri=mp.body.fileuri;
    }
    NSString* sender=mp.body.sender;
    NSString* receiver=mp.body.receiver;
    NSString* sendtime=mp.body.sendtime;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    NSString* receivetime=currentDateStr;
    if (mp.body.hasReceivetime) {
        receivetime=mp.body.receivetime;
    }
    NSString* pushmsgtype=@"";
    if (mp.body.hasPushmsgtype) {
        if (mp.body.pushmsgtype!=2&&mp.body.pushmsgtype!=8&&mp.body.pushmsgtype!=11) {
            pushmsgtype=@"11";
        } else {
            pushmsgtype=[NSString stringWithFormat:@"%li", mp.body.pushmsgtype];
        }
    }
    NSString* groupid=@"";
    NSString* groupname=@"";
    NSString* grouptype=@"";
    if (mp.body.hasGroupid&&mp.body.hasGroupname&&mp.body.hasGrouptype) {
        groupid=mp.body.groupid;
        groupname=mp.body.groupname;
        grouptype=mp.body.grouptype;
    }
    
    NSString* url=@"";
    NSString* urlpic=@"";
    NSString* urldesc=@"";
    
    if (mp.body.hasUrl&&mp.body.hasUrlpic&&mp.body.hasUrldesc) {
        url=mp.body.url;
        urlpic=mp.body.urlpic;
        urldesc=mp.body.urldesc;
    }
    //插入数据
    BOOL insert = [database executeUpdate:@"insert into messagecache values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",from,to,error,guid,autoid,mtype,state,mctype,content,audiouri,pictureuri,fileuri,sender,receiver,sendtime,receivetime,pushmsgtype,sessionid,groupid,groupname,grouptype,url,urlpic,urldesc];
    [database close];
    
    if (insert) {
        NSLog(@"%@添加成功",packet);
    }else{
        NSLog(@"%@添加失败",packet);
    }
    return insert;
}

-(BOOL)update:(Packet*)packet{
    if (packet==nil||!packet.hasMessage) {
        return NO;
    }
    //插入以前判断是否存在该数据 因为可能插入多条数据，如果存在做更新操作
    Packet* querypacket=[self queryPacketWithGuid:packet.message.guid];
    if (querypacket!=nil) {    //获取数据库并打开
        FMDatabase *database  = [self getDataBase];
        if (![database open]) {
            NSLog(@"Open database failed");
            return NO;
        }
        
        [self createMessageTable:database];
        NSString* from=packet.from;
        NSString* to=packet.to;
        NSString* error=@"";
        if (packet.hasError) {
            error=packet.error;
        }
        MessagePacket* mp= packet.message;
        NSString* guid=mp.guid;
        NSString* autoid=@"0";
        if (mp.hasAutoid) {
            autoid=[NSString stringWithFormat:@"%lli",mp.autoid];
        }
        NSString* mtype=[NSString stringWithFormat:@"%li", mp.type];
        NSString* state=[NSString stringWithFormat:@"%i",(int)mp.state];
        NSString* mctype=[NSString stringWithFormat:@"%li", mp.body.type];
        NSString* content=@"";
        if (mp.body.hasContent) {
            content=mp.body.content;
        }
        NSString* audiouri=@"";
        if (mp.body.hasAudiouri) {
            audiouri=mp.body.audiouri;
        }
        NSString* pictureuri=@"";
        if (mp.body.hasPictureuri) {
            pictureuri=mp.body.pictureuri;
        }
        NSString* fileuri=@"";
        if (mp.body.hasFileuri) {
            fileuri=mp.body.fileuri;
        }
        NSString* sender=mp.body.sender;
        NSString* receiver=mp.body.receiver;
        NSString* sendtime=mp.body.sendtime;
        NSString* receivetime=@"";
        if (mp.body.hasReceivetime) {
            receivetime=mp.body.receivetime;
        }
        NSString* pushmsgtype=@"";
        if (mp.body.hasPushmsgtype) {
            if (mp.body.pushmsgtype!=2&&mp.body.pushmsgtype!=8&&mp.body.pushmsgtype!=11) {
                pushmsgtype=@"11";
            } else {
                pushmsgtype=[NSString stringWithFormat:@"%li", mp.body.pushmsgtype];
            }
        }
        NSString* groupid=@"";
        NSString* groupname=@"";
        NSString* grouptype=@"";
        if (mp.body.hasGroupid&&mp.body.hasGroupname&&mp.body.hasGrouptype) {
            groupid=mp.body.groupid;
            groupname=mp.body.groupname;
            grouptype=mp.body.grouptype;
        }
        
        NSString* url=@"";
        NSString* urlpic=@"";
        NSString* urldesc=@"";
        
        if (mp.body.hasUrl&&mp.body.hasUrlpic&&mp.body.hasUrldesc) {
            url=mp.body.url;
            urlpic=mp.body.urlpic;
            urldesc=mp.body.urldesc;
        }
        //插入数据
        BOOL insert = [database executeUpdate:@"UPDATE messagecache SET fromcln=?,tocln=?,errorcln=?,guid=?,autoid=?,mtype=?,mctype=?,state=?,content=?,audiouri=?,pictureuri=?,fileuri=?,sender=?,receiver=?,sendtime=?,pushmsgtype=?,groupid=?,groupname=?,grouptype=?,url=?,urlpic=?,urldesc=? WHERE guid=?",from,to,error,guid,autoid,mtype,mctype,state,content,audiouri,pictureuri,fileuri,sender,receiver,sendtime,pushmsgtype,groupid,groupname,grouptype,url,urlpic,urldesc,guid];
        [database close];
        if (insert) {
            NSLog(@"%@保存成功",packet);
        }else{
            NSLog(@"%@保存失败",packet);
        }
        return insert;
    }else{
        return NO;
    }
}

/**
 *根据登陆用户id获取会话列表
 */
- (NSMutableArray*)queryPacketFriendSessionList:(NSString*)userid{
    if (userid==nil||userid.length<=0) {
        return nil;
    }
    FMDatabase *database = [self getDataBase];
    if (![database open]) {
        return nil;
    }
    NSMutableArray* sessionids=[[NSMutableArray alloc] init];
    NSMutableArray* groupids=[[NSMutableArray alloc] init];
    [self createMessageTable:database];
    FMResultSet *resultSet = [database executeQuery:@"SELECT sessionid FROM messagecache WHERE (fromcln=? OR tocln=?) and sessionid!=? and mtype=0 GROUP BY sessionid;",userid,userid,userid];
    while ([resultSet next]) {
        NSString* sessionid=[resultSet stringForColumn:@"sessionid"];
        [sessionids addObject:sessionid];
    }
    
    
    resultSet = [database executeQuery:@"SELECT groupid FROM messagecache WHERE (fromcln=? OR tocln=?) and mtype=1 and groupid !='' GROUP BY groupid;",userid,userid];
    while ([resultSet next]) {
        NSString* groupid=[resultSet stringForColumn:@"groupid"];
        [groupids addObject:groupid];
    }
    
    NSMutableArray* packets=[[NSMutableArray alloc] init];
    
    for (NSString *groupid in groupids) {
        FMResultSet *resultSet = [database executeQuery:@"SELECT * FROM messagecache WHERE (fromcln=? OR tocln=?) and groupid=? and mtype=1 ORDER BY sendtime DESC LIMIT 0,1;",userid,userid,groupid];
        while ([resultSet next]) {
            Packet *packet;
            packet = [self valueToObject:resultSet];
            [packets addObject:packet];
        }
    }
    for (NSString *sessionid in sessionids) {
        FMResultSet *resultSet = [database executeQuery:@"SELECT * FROM messagecache WHERE (fromcln=? OR tocln=?) and sessionid=? and mtype=0 ORDER BY sendtime DESC LIMIT 0,1;",userid,userid,sessionid];
        while ([resultSet next]) {
            Packet *packet;
            packet = [self valueToObject:resultSet];
            [packets addObject:packet];
        }
    }
    [database close];
    return packets;
}

/**
 *根据guid获取消息
 */
- (Packet*)queryPacketWithGuid:(NSString*)guid {
    if (guid==nil||guid.length<=0) {
        return nil;
    }
    FMDatabase *database = [self getDataBase];
    if (![database open]) {
        return nil;
    }
    Packet* packet=nil;
    [self createMessageTable:database];
    FMResultSet *resultSet = [database executeQuery:@"select * from messagecache where guid = ?",guid];
    if ([resultSet next]) {
        packet = [self valueToObject:resultSet];
    }
    [database close];
    return packet;
}
/**
 *数据填充
 */
- (Packet *)valueToObject:(FMResultSet *)resultSet {
    Packet* packet=nil;
    PacketBuilder* packetPacketBuilder =[Packet builder];
    MessagePacketBuilder* messagePacketBuilder=[MessagePacket builder];
    MessageBodyBuilder* messageBodyBuilder=[MessageBody builder];
    NSString* from=[resultSet stringForColumn:@"fromcln"];
    NSString* to=[resultSet stringForColumn:@"tocln"];
    [packetPacketBuilder setFrom:from];
    [packetPacketBuilder setTo:to];
    NSString* error=[resultSet stringForColumn:@"errorcln"];
    if (![error isEqualToString:@""]) {
        [packetPacketBuilder setError:error];
    }
    NSString* guid=[resultSet stringForColumn:@"guid"];
    [messagePacketBuilder setGuid:guid];
    NSString* autoid=[resultSet stringForColumn:@"autoid"];
    if (![autoid isEqualToString:@""]) {
        [messagePacketBuilder setAutoid:[autoid longLongValue]];
    }
    NSString* mtype=[resultSet stringForColumn:@"mtype"];
    [messagePacketBuilder setType:[mtype intValue]];
    NSString* state=[resultSet stringForColumn:@"state"];
    [messagePacketBuilder setState:[state integerValue]];
    NSString* mctype=[resultSet stringForColumn:@"mctype"];
    [messageBodyBuilder setType:[mctype intValue]];
    NSString* content=[resultSet stringForColumn:@"content"];
    if (![content isEqualToString:@""]) {
        [messageBodyBuilder setContent:content];
    }
    NSString* audiouri=[resultSet stringForColumn:@"audiouri"];
    if (![audiouri isEqualToString:@""]) {
        [messageBodyBuilder setAudiouri:audiouri];
    }
    NSString* pictureuri=[resultSet stringForColumn:@"pictureuri"];
    if (![pictureuri isEqualToString:@""]) {
        [messageBodyBuilder setPictureuri:pictureuri];
    }
    NSString* fileuri=[resultSet stringForColumn:@"fileuri"];
    if (![fileuri isEqualToString:@""]) {
        [messageBodyBuilder setFileuri:fileuri];
    }
    NSString* sender=[resultSet stringForColumn:@"sender"];
    [messageBodyBuilder setSender:sender];
    NSString* receiver=[resultSet stringForColumn:@"receiver"];
    [messageBodyBuilder setReceiver:receiver];
    NSString* sendtime=[resultSet stringForColumn:@"sendtime"];
    [messageBodyBuilder setSendtime:sendtime];
    NSString* receivetime=[resultSet stringForColumn:@"receivetime"];
    if (![receivetime isEqualToString:@""]) {
        [messageBodyBuilder setReceivetime:receivetime];
    }
    NSString* pushmsgtype=[resultSet stringForColumn:@"pushmsgtype"];
    if (![pushmsgtype isEqualToString:@""]) {
        [messageBodyBuilder setPushmsgtype:[pushmsgtype intValue]];
    }
    NSString* groupid=[resultSet stringForColumn:@"groupid"];
    if (![groupid isEqualToString:@""]) {
        [messageBodyBuilder setGroupid:groupid];
    }
    NSString* groupname=[resultSet stringForColumn:@"groupname"];
    if (![groupname isEqualToString:@""]) {
        [messageBodyBuilder setGroupname:groupname];
    }
    NSString* grouptype=[resultSet stringForColumn:@"grouptype"];
    if (![grouptype isEqualToString:@""]) {
        [messageBodyBuilder setGrouptype:grouptype];
    }
    NSString* url=[resultSet stringForColumn:@"url"];
    if (![url isEqualToString:@""]) {
        [messageBodyBuilder setUrl:url];
    }
    NSString* urlpic=[resultSet stringForColumn:@"urlpic"];
    if (![urlpic isEqualToString:@""]) {
        [messageBodyBuilder setUrlpic:urlpic];
    }
    NSString* urldesc=[resultSet stringForColumn:@"urldesc"];
    if (![urldesc isEqualToString:@""]) {
        [messageBodyBuilder setUrldesc:urldesc];
    }
    [messagePacketBuilder setBodyBuilder:messageBodyBuilder];
    
    [packetPacketBuilder setMessageBuilder:messagePacketBuilder];
    packet=[packetPacketBuilder build];
    return packet;
}
/**
 *获取最后一条家校通消息
 *
 **/
-(Packet*)queryLastPushPacket:(NSString*)uid{
    if (uid==nil||uid.length<=0) {
        return nil;
    }
    FMDatabase *database = [self getDataBase];
    if (![database open]) {
        return nil;
    }
    [self createMessageTable:database];
    FMResultSet *resultSet = [database executeQuery:@"SELECT * FROM messagecache WHERE tocln=? and mtype=3 ORDER BY sendtime DESC LIMIT 0,1;",uid];
    Packet *packet=nil;
    if  ([resultSet next]) {
        packet = [self valueToObject:resultSet];
    }
    [database close];
    return packet;
}
/**
 *  获取资源推荐数组数据
 *
 *  @return 返回数据
 */
- (NSMutableArray*)queryPacketRecomment:(BOOL)isLatest uid:(NSString*)uid{
    FMDatabase *database = [self getDataBase];
    if (![database open]) {
        return nil;
    }
    NSMutableArray* packets=[[NSMutableArray alloc] init];
    [self createMessageTable:database];
    FMResultSet *resultSet;
    if (isLatest) {
       resultSet  = [database executeQuery:@"select * from messagecache where  mtype=4 and  tocln=? ORDER BY sendtime DESC LIMIT 0,1",uid];
    }else{
        resultSet  = [database executeQuery:@"select * from messagecache where  mtype=4 and  tocln=? ORDER BY sendtime DESC",uid];
    }
    while ([resultSet next]) {
        Packet *packet;
        packet = [self valueToObject:resultSet];
        [packets addObject:packet];
    }
    [database close];
    return packets;
}
/**
 *获取好友消息
 */
- (NSMutableArray*)queryPacketFriendID:(NSString*)friendid userid:(NSString*)userid {
    if (friendid==nil||friendid.length<=0||userid==nil||userid.length<=0) {
        return nil;
    }
    FMDatabase *database = [self getDataBase];
    if (![database open]) {
        return nil;
    }
    NSMutableArray* packets=[[NSMutableArray alloc] init];
    [self createMessageTable:database];
    FMResultSet *resultSet = [database executeQuery:@"select * from messagecache where  mtype=0 and ((fromcln = ? and tocln = ?) or (fromcln = ? and tocln = ? ))  ",friendid,userid,userid,friendid];
    while ([resultSet next]) {
        Packet *packet;
        packet = [self valueToObject:resultSet];
        [packets addObject:packet];
    }
    [database close];
    return packets;
}

/**
 *获取群组消息
 */
- (NSMutableArray*)queryPacketGroupID:(NSString*)groupid userid:(NSString*)userid {
    if (groupid==nil||groupid.length<=0||userid==nil||userid.length<=0) {
        return nil;
    }
    FMDatabase *database = [self getDataBase];
    if (![database open]) {
        return nil;
    }
    NSMutableArray* packets=[[NSMutableArray alloc] init];
    [self createMessageTable:database];
    FMResultSet *resultSet = [database executeQuery:@"select * from messagecache where  mtype=1 and groupid=? and sessionid=?",groupid,[NSString stringWithFormat:@"%@%@",groupid,userid]];
    while ([resultSet next]) {
        Packet *packet;
        packet = [self valueToObject:resultSet];
        [packets addObject:packet];
    }
    [database close];
    return packets;
}


/**
 *保存语音
 */
- (BOOL)saveAudio:(NSString*)url filename:(NSString*)filename {
    if (url==nil||filename==nil) {
        return NO;
    }
    //插入以前判断是否存在该数据 因为可能插入多条数据，如果存在做更新操作
    NSString* filepath=[self queryFile:url];
    if (filepath!=nil) {
        return true;
    }
    
    //获取数据库并打开
    FMDatabase *database  = [self getDataBase];
    if (![database open]) {
        NSLog(@"Open database failed");
        return NO;
    }
    
    [self createMessageTable:database];
    
    BOOL insert = [database executeUpdate:@"insert into audiocache values (?,?)",url,filename];
    [database close];
    return insert;
}
/**
 *读取语音
 */
- (NSString*)queryFile:(NSString*)url {
    if (url==nil||url.length<=0) {
        return nil;
    }
    FMDatabase *database = [self getDataBase];
    if (![database open]) {
        return nil;
    }
    NSString* filename=nil;
    [self createMessageTable:database];
    FMResultSet *resultSet = [database executeQuery:@"select * from audiocache where url = ?",url];
    if ([resultSet next]) {
        filename=[resultSet stringForColumn:@"filename"];
    }
    [database close];
    return filename;
}
//获取推送类型飘红数量
-(int)getPushBrage:(NSString*)uid{
    if (uid==nil||uid.length<=0) {
        return 0;
    }
    FMDatabase *database = [self getDataBase];
    if (![database open]) {
        return 0;
    }
    int result=0;
    [self createMessageTable:database];
    FMResultSet *resultSet = [database executeQuery:@"SELECT count(*) FROM messagecache WHERE tocln=? and mtype=3 and state<3",uid];
    if ([resultSet next]) {
       result= [resultSet intForColumn:@"count(*)"];
        
    }
    [database close];
    return result;
}

//是否有群聊消息
-(BOOL)hasGroupMessage:(NSString*)userid groupid:(NSString*)groupid{
    if (userid==nil||userid.length<=0||groupid==nil||groupid.length<=0) {
        return false;
    }
    FMDatabase *database = [self getDataBase];
    if (![database open]) {
        return false;
    }
    BOOL result=false;
    [self createMessageTable:database];
    FMResultSet *resultSet = [database executeQuery:@"SELECT count(*) FROM messagecache WHERE (fromcln=? or tocln=?) and mtype=1 and groupid=?",userid,userid,groupid];
    int count=0;
    if ([resultSet next]) {
        count= [resultSet intForColumn:@"count(*)"];
    }
    [database close];
    if (count>0) {
        result=true;
    }else{
        result=false;
    }
    return result;
}

//获取所有好友消息飘红数量
-(int)getAllFriendBrage:(NSString*)uid{
    if (uid==nil||uid.length<=0) {
        return 0;
    }
    FMDatabase *database = [self getDataBase];
    if (![database open]) {
        return 0;
    }
    int result=0;
    [self createMessageTable:database];
    FMResultSet *resultSet = [database executeQuery:@"SELECT count(*) FROM messagecache WHERE tocln=? and mtype=0 and state<3",uid];
    if ([resultSet next]) {
       result= [resultSet intForColumn:@"count(*)"];
        
    }
    [database close];
    return result;
}

//获取会话消息飘红数量
-(int)getSessionBrageFriendID:(NSString*)friendid userid:(NSString*)userid{
    if (friendid==nil||friendid<=0||userid==nil||userid.length<=0) {
        return 0;
    }
    FMDatabase *database = [self getDataBase];
    if (![database open]) {
        return 0;
    }
    int result=0;
    [self createMessageTable:database];
    FMResultSet *resultSet = [database executeQuery:@"SELECT count(*) FROM messagecache WHERE fromcln=? and tocln=? and state<3 and mtype=0",friendid,userid];
    if ([resultSet next]) {
        result= [resultSet intForColumn:@"count(*)"];
        
    }
    [database close];
    return result;
}

//获取群聊会话消息飘红数量
-(int)getSessionBrageGroupid:(NSString*)groupid userid:(NSString*)userid{
    if (groupid==nil||groupid.length<=0||userid==nil||userid.length<=0) {
        return 0;
    }
    FMDatabase *database = [self getDataBase];
    if (![database open]) {
        return 0;
    }
    int result=0;
    [self createMessageTable:database];
    FMResultSet *resultSet = [database executeQuery:@"SELECT count(*) FROM messagecache WHERE fromcln!=? and groupid=? and tocln=? and state<3 and mtype=1",userid,groupid,userid];
    if ([resultSet next]) {
        result= [resultSet intForColumn:@"count(*)"];
        
    }
    [database close];
    return result;
}

//获取好友聊天未读消息
-(NSMutableArray*)getUnReadPacket:(NSString*)friendid userid:(NSString*)userid{
    if (friendid==nil||friendid.length<=0||userid==nil||userid.length<=0) {
        return nil;
    }
    FMDatabase *database = [self getDataBase];
    if (![database open]) {
        return nil;
    }
    [self createMessageTable:database];
    
    NSMutableArray* packets=[[NSMutableArray alloc] init];
    FMResultSet *resultSet = [database executeQuery:@"SELECT * FROM messagecache WHERE fromcln=? and tocln=? and state<3 and mtype=0",friendid,userid];
    while ([resultSet next]) {
        Packet *packet;
        packet = [self valueToObject:resultSet];
        [packets addObject:packet];
        
    }
    [database close];
    return packets;
}

//获取群组聊天未读消息
-(NSMutableArray*)getGroupUnReadPacket:(NSString*)groupid userid:(NSString*)userid{
    if (groupid==nil||groupid.length<=0||userid==nil||userid.length<=0) {
        return nil;
    }
    FMDatabase *database = [self getDataBase];
    if (![database open]) {
        return nil;
    }
    [self createMessageTable:database];
    
    NSMutableArray* packets=[[NSMutableArray alloc] init];
    FMResultSet *resultSet = [database executeQuery:@"SELECT * FROM messagecache WHERE groupid=? and tocln=? and state<3 and mtype=1",groupid,userid];
    while ([resultSet next]) {
        Packet *packet;
        packet = [self valueToObject:resultSet];
        [packets addObject:packet];
        
    }
    [database close];
    return packets;
}


//获取推送未读消息
-(NSMutableArray*)getUnReadPushPacket:(NSString*)userid{
    if (userid==nil||userid.length<=0) {
        return nil;
    }
    FMDatabase *database = [self getDataBase];
    if (![database open]) {
        return nil;
    }
    [self createMessageTable:database];
    
    NSMutableArray* packets=[[NSMutableArray alloc] init];
    FMResultSet *resultSet = [database executeQuery:@"SELECT * FROM messagecache WHERE tocln=? and state<3 and mtype=3",userid];
    while ([resultSet next]) {
        Packet *packet;
        packet = [self valueToObject:resultSet];
        [packets addObject:packet];
        
    }
    [database close];
    return packets;
}


//获取好友聊天未读消息
-(NSMutableArray*)getUnSynPacket:(NSString*)userid{
    if (userid==nil||userid.length<=0) {
        return nil;
    }
    FMDatabase *database = [self getDataBase];
    if (![database open]) {
        return nil;
    }
    [self createMessageTable:database];
    
    NSMutableArray* packets=[[NSMutableArray alloc] init];
    FMResultSet *resultSet = [database executeQuery:@"SELECT * FROM messagecache WHERE tocln=? and state=3",userid];
    while ([resultSet next]) {
        Packet *packet;
        packet = [self valueToObject:resultSet];
        [packets addObject:packet];
        
    }
    [database close];
    return packets;
}



//更新消息状态
-(BOOL)updatePacketState:(NSString*)guid state:(int)state{
    if (guid==nil) {
        return NO;
    }
    //插入以前判断是否存在该数据 因为可能插入多条数据，如果存在做更新操作
    Packet* querypacket=[self queryPacketWithGuid:guid];
    if (querypacket!=nil) {    //获取数据库并打开
        FMDatabase *database  = [self getDataBase];
        if (![database open]) {
            NSLog(@"Open database failed");
            return NO;
        }
        [self createMessageTable:database];
        //插入数据
        BOOL insert = [database executeUpdate:@"UPDATE messagecache SET state=? WHERE guid=?",[NSString stringWithFormat:@"%i",state],guid];
        [database close];
        return insert;
    }else{
        return NO;
    }
}

@end
