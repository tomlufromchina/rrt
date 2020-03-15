#import "XMPPMessageArchiving_Message_CoreDataObject.h"


@interface XMPPMessageArchiving_Message_CoreDataObject ()

@property(nonatomic,strong) XMPPMessage * primitiveMessage;
@property(nonatomic,strong) NSString * primitiveMessageStr;

@property(nonatomic,strong) XMPPJID * primitiveBareJid;
@property(nonatomic,strong) NSString * primitiveBareJidStr;

@end

@implementation XMPPMessageArchiving_Message_CoreDataObject

@dynamic message, primitiveMessage;
@dynamic messageStr, primitiveMessageStr;
@dynamic bareJid, primitiveBareJid;
@dynamic bareJidStr, primitiveBareJidStr;
@dynamic body;
@dynamic thread;
@dynamic outgoing;
@dynamic composing;
@dynamic timestamp;
@dynamic streamBareJidStr;
@dynamic bRead;

#pragma mark Transient message

- (XMPPMessage *)message
{
	// Create and cache on demand
	
	[self willAccessValueForKey:@"message"];
	XMPPMessage *message = self.primitiveMessage;
	[self didAccessValueForKey:@"message"];
	
	if (message == nil)
	{
		NSString *messageStr = self.messageStr;
		if (messageStr)
		{
			NSXMLElement *element = [[NSXMLElement alloc] initWithXMLString:messageStr error:nil];
			message = [XMPPMessage messageFromElement:element];
			self.primitiveMessage = message;
		}
    }
	
    return message;
}

- (void)setMessage:(XMPPMessage *)message
{
	[self willChangeValueForKey:@"message"];
	[self willChangeValueForKey:@"messageStr"];
	
	self.primitiveMessage = message;
	self.primitiveMessageStr = [message compactXMLString];
	
	[self didChangeValueForKey:@"message"];
	[self didChangeValueForKey:@"messageStr"];
}

- (void)setMessageStr:(NSString *)messageStr
{
	[self willChangeValueForKey:@"message"];
	[self willChangeValueForKey:@"messageStr"];
	
	NSXMLElement *element = [[NSXMLElement alloc] initWithXMLString:messageStr error:nil];
	self.primitiveMessage = [XMPPMessage messageFromElement:element];
	self.primitiveMessageStr = messageStr;
	
	[self didChangeValueForKey:@"message"];
	[self didChangeValueForKey:@"messageStr"];
}

#pragma mark Transient bareJid

- (XMPPJID *)bareJid
{
	// Create and cache on demand
	
	[self willAccessValueForKey:@"bareJid"];
	XMPPJID *tmp = self.primitiveBareJid;
	[self didAccessValueForKey:@"bareJid"];
	
	if (tmp == nil)
	{
		NSString *bareJidStr = self.bareJidStr;
		if (bareJidStr)
		{
			tmp = [XMPPJID jidWithString:bareJidStr];
			self.primitiveBareJid = tmp;
		}
	}
	
	return tmp;
}

- (void)setBareJid:(XMPPJID *)bareJid
{
	if ([self.bareJid isEqualToJID:bareJid options:XMPPJIDCompareBare])
	{
		return; // No change
	}
	
	[self willChangeValueForKey:@"bareJid"];
	[self willChangeValueForKey:@"bareJidStr"];
	
	self.primitiveBareJid = [bareJid bareJID];
	self.primitiveBareJidStr = [bareJid bare];
	
	[self didChangeValueForKey:@"bareJid"];
	[self didChangeValueForKey:@"bareJidStr"];
}

- (void)setBareJidStr:(NSString *)bareJidStr
{
	if ([self.bareJidStr isEqualToString:bareJidStr])
	{
		return; // No change
	}
	
	[self willChangeValueForKey:@"bareJid"];
	[self willChangeValueForKey:@"bareJidStr"];
	
	XMPPJID *bareJid = [[XMPPJID jidWithString:bareJidStr] bareJID];
	
	self.primitiveBareJid = bareJid;
	self.primitiveBareJidStr = [bareJid bare];
	
	[self didChangeValueForKey:@"bareJid"];
	[self didChangeValueForKey:@"bareJidStr"];
}

#pragma mark Convenience properties

- (BOOL)isOutgoing
{
	return [self.outgoing boolValue];
}

- (void)setIsOutgoing:(BOOL)flag
{
	self.outgoing = [NSNumber numberWithBool:flag];
}

- (BOOL)isComposing
{
	return [self.composing boolValue];
}

- (void)setIsComposing:(BOOL)flag
{
	self.composing = [NSNumber numberWithBool:flag];
}

#pragma mark Hooks

- (void)willInsertObject
{
	// If you extend XMPPMessageArchiving_Message_CoreDataObject,
	// you can override this method to use as a hook to set your own custom properties.
}

- (void)didUpdateObject
{
	// If you extend XMPPMessageArchiving_Message_CoreDataObject,
	// you can override this method to use as a hook to set your own custom properties.
}


+(NSCache*)shareCacheForMessage;
{
    static NSCache * cache=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cache=[[NSCache alloc]init];
        cache.totalCostLimit=0.1*1024*1024;
    });
    return cache;
}

-(MatchParser*)getMatch
{
    if (_match&&[_match isKindOfClass:[MatchParser class]]) {
        _match.data=self;
        return _match;
    }else{
        NSString *key=[NSString stringWithFormat:@"timestamp%@", self.timestamp];
        MatchParser *parser=[[XMPPMessageArchiving_Message_CoreDataObject shareCacheForMessage] objectForKey:key];
        if (parser) {
            _match = parser;
            //            self.height=parser.height;
            //            self.heightOflimit=parser.heightOflimit;
            //            self.miniWidth=parser.miniWidth;
            //            self.numberOfLinesTotal=parser.numberOfTotalLines;
            //            self.numberOfLineLimit=parser.numberOfLimitLines;
            parser.data = self;
            //            if (_match.numberOfTotalLines>_match.numberOfLimitLines) {
            //                self.shouldExtend=YES;
            //            }else{
            //                self.shouldExtend=NO;
            //            }
            return parser;
        }else{
            MatchParser *parser=[self createMatch:220];
            if (parser) {
                [[XMPPMessageArchiving_Message_CoreDataObject shareCacheForMessage]  setObject:parser forKey:key];
            }
            return parser;
        }
    }
}

-(MatchParser*)getMatch:(void(^)(MatchParser *parser,id data))complete data:(id)data
{
    if (_match&&[_match isKindOfClass:[MatchParser class]]) {
        _match.data=self;
        return _match;
    }else{
        NSString *key=[NSString stringWithFormat:@"timestamp%@", self.timestamp];
        MatchParser *parser=[[XMPPMessageArchiving_Message_CoreDataObject shareCacheForMessage] objectForKey:key];
        if (parser) {
            _match = parser;
            //            self.height=parser.height;
            //            self.heightOflimit=parser.heightOflimit;
            //            self.miniWidth=parser.miniWidth;
            //            self.numberOfLinesTotal=parser.numberOfTotalLines;
            //            self.numberOfLineLimit=parser.numberOfLimitLines;
            parser.data = self;
            //            if (_match.numberOfTotalLines>_match.numberOfLimitLines) {
            //                self.shouldExtend=YES;
            //            }else{
            //                self.shouldExtend=NO;
            //            }
            return parser;
        }else{
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                MatchParser*parser=[self createMatch:200];
                if (parser) {
                    _match = parser;
                    [[XMPPMessageArchiving_Message_CoreDataObject shareCacheForMessage]  setObject:parser forKey:key];
                    if (complete) {
                        complete(parser,data);
                    }
                }
            });
            return nil;
        }
    }
}

-(void)setMatch
{
    if (_match&&[_match isKindOfClass:[MatchParser class]]) {
        _match.data=self;
        return;
    }else{
        NSString *key=[NSString stringWithFormat:@"timestamp%@", self.timestamp];
        MatchParser *parser=[[XMPPMessageArchiving_Message_CoreDataObject shareCacheForMessage] objectForKey:key];
        if (parser) {
            _match = parser;
            //            self.height=parser.height;
            //            self.heightOflimit=parser.heightOflimit;
            //            self.miniWidth=parser.miniWidth;
            //            self.numberOfLinesTotal=parser.numberOfTotalLines;
            //            self.numberOfLineLimit=parser.numberOfLimitLines;
            parser.data = self;
            //            if (_match.numberOfTotalLines>_match.numberOfLimitLines) {
            //                self.shouldExtend=YES;
            //            }else{
            //                self.shouldExtend=NO;
            //            }
            parser.data=self;
        }else{
            MatchParser* parser=[self createMatch:200];
            if (parser) {
                [[XMPPMessageArchiving_Message_CoreDataObject shareCacheForMessage]  setObject:parser forKey:key];
            }
        }
    }
}

-(void)setMatch:(MatchParser *)match
{
    _match=match;
}

-(MatchParser*)createMatch:(float)width
{
    MatchParser * parser=[[MatchParser alloc]init];
    parser.keyWorkColor=[UIColor blueColor];
    parser.width=width;
    parser.numberOfLimitLines=5;
    //    self.numberOfLineLimit=5;
    parser.font = [UIFont systemFontOfSize:18.0f];
    
//    if (self.activityType == Activity_Type_Blog) {//日志，有title
//        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:appColor,
//                              NSForegroundColorAttributeName, nil];
//        NSAttributedString *title = self.title ?
//        [[NSAttributedString alloc] initWithString:self.title attributes:dict] :
//        nil;
//        
//        [parser match:self.activityBody
//           atCallBack:^BOOL(NSString * string) {
//               return NO;
//           }
//                title:title];
//    } else {
    
        [parser match:self.body atCallBack:^BOOL(NSString * string) {
            //        NSString *partInStr;
            //        if (![tMans isKindOfClass:[NSString class]]) {
            //            partInStr = [tMans JSONString];
            //        } else {
            //            partInStr = (NSString*)tMans;
            //        }
            return NO;
        }];
//    }
    _match=parser;
    //    self.height=_match.height;
    //    self.heightOflimit=parser.heightOflimit;
    //    self.miniWidth=parser.miniWidth;
    //    self.numberOfLinesTotal=parser.numberOfTotalLines;
    parser.data=self;
    //    if (_match.numberOfTotalLines>_match.numberOfLimitLines) {
    //        self.shouldExtend=YES;
    //    }else{
    //        self.shouldExtend=NO;
    //    }
    return parser;
}
-(void)updateMatch:(void(^)(NSMutableAttributedString * string, NSRange range))link
{
    [_match match:self.body atCallBack:^BOOL(NSString * string) {
        //        NSString *partInStr;
        //        if (![tMans isKindOfClass:[NSString class]]) {
        //            partInStr = [tMans JSONString];
        //        } else {
        //            partInStr = (NSString*)tMans;
        //        }
        return NO;
    } title:nil link:link];
}

@end
