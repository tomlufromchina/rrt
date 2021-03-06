// Generated by the protocol buffer compiler.  DO NOT EDIT!

#import "ProtocolBuffers.h"

// @@protoc_insertion_point(imports)

@class MessageBody;
@class MessageBodyBuilder;
@class MessagePacket;
@class MessagePacketBuilder;
#ifndef __has_feature
  #define __has_feature(x) 0 // Compatibility with non-clang compilers.
#endif // __has_feature

#ifndef NS_RETURNS_NOT_RETAINED
  #if __has_feature(attribute_ns_returns_not_retained)
    #define NS_RETURNS_NOT_RETAINED __attribute__((ns_returns_not_retained))
  #else
    #define NS_RETURNS_NOT_RETAINED
  #endif
#endif

typedef NS_ENUM(SInt32, MessageType) {
  MessageTypeChat = 0,
  MessageTypeGroupChat = 1,
  MessageTypeHeadLine = 2,
  MessageTypePush = 3,
  MessageTypeRecommend = 4,
};

BOOL MessageTypeIsValidValue(MessageType value);

typedef NS_ENUM(SInt32, MessageContentType) {
  MessageContentTypePlain = 0,
  MessageContentTypeAudio = 1,
  MessageContentTypePicture = 2,
  MessageContentTypeFile = 3,
  MessageContentTypeAll = 4,
  MessageContentTypeUrl = 5,
};

BOOL MessageContentTypeIsValidValue(MessageContentType value);

typedef NS_ENUM(SInt32, PushType) {
  PushTypeNone = -1,
  PushTypePushAll = 0,
  PushTypeLeaveMessage = 1,
  PushTypeScore = 2,
  PushTypeSafety = 3,
  PushTypeAttendance = 4,
  PushTypeFriendApply = 5,
  PushTypeSmallNote = 6,
  PushTypeSystemMessage = 7,
  PushTypeJob = 8,
  PushTypeBlessing = 9,
  PushTypeManifestation = 10,
  PushTypeNotification = 11,
  PushTypeReply = 15,
  PushTypeOfflineInform = 16,
  PushTypeOpenAccount = 17,
  PushTypeServiceExpirationReminder = 18,
  PushTypeForgotPassword = 19,
  PushTypeTestInfo = 20,
  PushTypeMsgCountRechargeSuccess = 21,
  PushTypeMsgStoragePrompt = 22,
  PushTypeLoginValidateCode = 23,
};

BOOL PushTypeIsValidValue(PushType value);


@interface MessageRoot : NSObject {
}
+ (PBExtensionRegistry*) extensionRegistry;
+ (void) registerAllExtensions:(PBMutableExtensionRegistry*) registry;
@end

@interface MessagePacket : PBGeneratedMessage {
@private
  BOOL hasAutoid_:1;
  BOOL hasState_:1;
  BOOL hasGuid_:1;
  BOOL hasBody_:1;
  BOOL hasType_:1;
  SInt64 autoid;
  SInt32 state;
  NSString* guid;
  MessageBody* body;
  MessageType type;
}
- (BOOL) hasGuid;
- (BOOL) hasAutoid;
- (BOOL) hasType;
- (BOOL) hasBody;
- (BOOL) hasState;
@property (readonly, strong) NSString* guid;
@property (readonly) SInt64 autoid;
@property (readonly) MessageType type;
@property (readonly, strong) MessageBody* body;
@property (readonly) SInt32 state;

+ (MessagePacket*) defaultInstance;
- (MessagePacket*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (MessagePacketBuilder*) builder;
+ (MessagePacketBuilder*) builder;
+ (MessagePacketBuilder*) builderWithPrototype:(MessagePacket*) prototype;
- (MessagePacketBuilder*) toBuilder;

+ (MessagePacket*) parseFromData:(NSData*) data;
+ (MessagePacket*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (MessagePacket*) parseFromInputStream:(NSInputStream*) input;
+ (MessagePacket*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (MessagePacket*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (MessagePacket*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface MessagePacketBuilder : PBGeneratedMessageBuilder {
@private
  MessagePacket* result;
}

- (MessagePacket*) defaultInstance;

- (MessagePacketBuilder*) clear;
- (MessagePacketBuilder*) clone;

- (MessagePacket*) build;
- (MessagePacket*) buildPartial;

- (MessagePacketBuilder*) mergeFrom:(MessagePacket*) other;
- (MessagePacketBuilder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (MessagePacketBuilder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasGuid;
- (NSString*) guid;
- (MessagePacketBuilder*) setGuid:(NSString*) value;
- (MessagePacketBuilder*) clearGuid;

- (BOOL) hasAutoid;
- (SInt64) autoid;
- (MessagePacketBuilder*) setAutoid:(SInt64) value;
- (MessagePacketBuilder*) clearAutoid;

- (BOOL) hasType;
- (MessageType) type;
- (MessagePacketBuilder*) setType:(MessageType) value;
- (MessagePacketBuilder*) clearType;

- (BOOL) hasBody;
- (MessageBody*) body;
- (MessagePacketBuilder*) setBody:(MessageBody*) value;
- (MessagePacketBuilder*) setBodyBuilder:(MessageBodyBuilder*) builderForValue;
- (MessagePacketBuilder*) mergeBody:(MessageBody*) value;
- (MessagePacketBuilder*) clearBody;

- (BOOL) hasState;
- (SInt32) state;
- (MessagePacketBuilder*) setState:(SInt32) value;
- (MessagePacketBuilder*) clearState;
@end

@interface MessageBody : PBGeneratedMessage {
@private
  BOOL hasContent_:1;
  BOOL hasAudiouri_:1;
  BOOL hasPictureuri_:1;
  BOOL hasFileuri_:1;
  BOOL hasSender_:1;
  BOOL hasReceiver_:1;
  BOOL hasSendtime_:1;
  BOOL hasReceivetime_:1;
  BOOL hasGroupid_:1;
  BOOL hasGroupname_:1;
  BOOL hasGrouptype_:1;
  BOOL hasUrl_:1;
  BOOL hasUrlpic_:1;
  BOOL hasUrldesc_:1;
  BOOL hasType_:1;
  BOOL hasPushmsgtype_:1;
  NSString* content;
  NSString* audiouri;
  NSString* pictureuri;
  NSString* fileuri;
  NSString* sender;
  NSString* receiver;
  NSString* sendtime;
  NSString* receivetime;
  NSString* groupid;
  NSString* groupname;
  NSString* grouptype;
  NSString* url;
  NSString* urlpic;
  NSString* urldesc;
  MessageContentType type;
  PushType pushmsgtype;
}
- (BOOL) hasType;
- (BOOL) hasContent;
- (BOOL) hasAudiouri;
- (BOOL) hasPictureuri;
- (BOOL) hasFileuri;
- (BOOL) hasSender;
- (BOOL) hasReceiver;
- (BOOL) hasSendtime;
- (BOOL) hasReceivetime;
- (BOOL) hasPushmsgtype;
- (BOOL) hasGroupid;
- (BOOL) hasGroupname;
- (BOOL) hasGrouptype;
- (BOOL) hasUrl;
- (BOOL) hasUrlpic;
- (BOOL) hasUrldesc;
@property (readonly) MessageContentType type;
@property (readonly, strong) NSString* content;
@property (readonly, strong) NSString* audiouri;
@property (readonly, strong) NSString* pictureuri;
@property (readonly, strong) NSString* fileuri;
@property (readonly, strong) NSString* sender;
@property (readonly, strong) NSString* receiver;
@property (readonly, strong) NSString* sendtime;
@property (readonly, strong) NSString* receivetime;
@property (readonly) PushType pushmsgtype;
@property (readonly, strong) NSString* groupid;
@property (readonly, strong) NSString* groupname;
@property (readonly, strong) NSString* grouptype;
@property (readonly, strong) NSString* url;
@property (readonly, strong) NSString* urlpic;
@property (readonly, strong) NSString* urldesc;

+ (MessageBody*) defaultInstance;
- (MessageBody*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (MessageBodyBuilder*) builder;
+ (MessageBodyBuilder*) builder;
+ (MessageBodyBuilder*) builderWithPrototype:(MessageBody*) prototype;
- (MessageBodyBuilder*) toBuilder;

+ (MessageBody*) parseFromData:(NSData*) data;
+ (MessageBody*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (MessageBody*) parseFromInputStream:(NSInputStream*) input;
+ (MessageBody*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (MessageBody*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (MessageBody*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface MessageBodyBuilder : PBGeneratedMessageBuilder {
@private
  MessageBody* result;
}

- (MessageBody*) defaultInstance;

- (MessageBodyBuilder*) clear;
- (MessageBodyBuilder*) clone;

- (MessageBody*) build;
- (MessageBody*) buildPartial;

- (MessageBodyBuilder*) mergeFrom:(MessageBody*) other;
- (MessageBodyBuilder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (MessageBodyBuilder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasType;
- (MessageContentType) type;
- (MessageBodyBuilder*) setType:(MessageContentType) value;
- (MessageBodyBuilder*) clearType;

- (BOOL) hasContent;
- (NSString*) content;
- (MessageBodyBuilder*) setContent:(NSString*) value;
- (MessageBodyBuilder*) clearContent;

- (BOOL) hasAudiouri;
- (NSString*) audiouri;
- (MessageBodyBuilder*) setAudiouri:(NSString*) value;
- (MessageBodyBuilder*) clearAudiouri;

- (BOOL) hasPictureuri;
- (NSString*) pictureuri;
- (MessageBodyBuilder*) setPictureuri:(NSString*) value;
- (MessageBodyBuilder*) clearPictureuri;

- (BOOL) hasFileuri;
- (NSString*) fileuri;
- (MessageBodyBuilder*) setFileuri:(NSString*) value;
- (MessageBodyBuilder*) clearFileuri;

- (BOOL) hasSender;
- (NSString*) sender;
- (MessageBodyBuilder*) setSender:(NSString*) value;
- (MessageBodyBuilder*) clearSender;

- (BOOL) hasReceiver;
- (NSString*) receiver;
- (MessageBodyBuilder*) setReceiver:(NSString*) value;
- (MessageBodyBuilder*) clearReceiver;

- (BOOL) hasSendtime;
- (NSString*) sendtime;
- (MessageBodyBuilder*) setSendtime:(NSString*) value;
- (MessageBodyBuilder*) clearSendtime;

- (BOOL) hasReceivetime;
- (NSString*) receivetime;
- (MessageBodyBuilder*) setReceivetime:(NSString*) value;
- (MessageBodyBuilder*) clearReceivetime;

- (BOOL) hasPushmsgtype;
- (PushType) pushmsgtype;
- (MessageBodyBuilder*) setPushmsgtype:(PushType) value;
- (MessageBodyBuilder*) clearPushmsgtype;

- (BOOL) hasGroupid;
- (NSString*) groupid;
- (MessageBodyBuilder*) setGroupid:(NSString*) value;
- (MessageBodyBuilder*) clearGroupid;

- (BOOL) hasGroupname;
- (NSString*) groupname;
- (MessageBodyBuilder*) setGroupname:(NSString*) value;
- (MessageBodyBuilder*) clearGroupname;

- (BOOL) hasGrouptype;
- (NSString*) grouptype;
- (MessageBodyBuilder*) setGrouptype:(NSString*) value;
- (MessageBodyBuilder*) clearGrouptype;

- (BOOL) hasUrl;
- (NSString*) url;
- (MessageBodyBuilder*) setUrl:(NSString*) value;
- (MessageBodyBuilder*) clearUrl;

- (BOOL) hasUrlpic;
- (NSString*) urlpic;
- (MessageBodyBuilder*) setUrlpic:(NSString*) value;
- (MessageBodyBuilder*) clearUrlpic;

- (BOOL) hasUrldesc;
- (NSString*) urldesc;
- (MessageBodyBuilder*) setUrldesc:(NSString*) value;
- (MessageBodyBuilder*) clearUrldesc;
@end


// @@protoc_insertion_point(global_scope)
