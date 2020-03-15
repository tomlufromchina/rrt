// Generated by the protocol buffer compiler.  DO NOT EDIT!

#import "ProtocolBuffers.h"

// @@protoc_insertion_point(imports)

@class IqAction;
@class IqActionBuilder;
@class IqActionResponse;
@class IqActionResponseBuilder;
@class IqPacket;
@class IqPacketBuilder;
@class LoginAction;
@class LoginActionBuilder;
@class LoginResponse;
@class LoginResponseBuilder;
@class PushNotice;
@class PushNoticeBuilder;
@class ServerNodesPush;
@class ServerNodesPushBuilder;
@class StDLoginAction;
@class StDLoginActionBuilder;
@class StDLoginResponse;
@class StDLoginResponseBuilder;
@class StSLoginAction;
@class StSLoginActionBuilder;
@class StSLoginResponse;
@class StSLoginResponseBuilder;
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

typedef NS_ENUM(SInt32, IqType) {
  IqTypeGet = 0,
  IqTypeSet = 1,
  IqTypeResult = 2,
};

BOOL IqTypeIsValidValue(IqType value);

typedef NS_ENUM(SInt32, Device) {
  DeviceIphone = 0,
  DeviceAndroid = 1,
  DeviceWindowsPhone = 2,
  DevicePc = 3,
  DeviceWeb = 4,
};

BOOL DeviceIsValidValue(Device value);

typedef NS_ENUM(SInt32, Heartbeat) {
  HeartbeatRequest = 0,
  HeartbeatResponse = 1,
};

BOOL HeartbeatIsValidValue(Heartbeat value);

typedef NS_ENUM(SInt32, ServerNodePushType) {
  ServerNodePushTypeJoin = 0,
  ServerNodePushTypeExit = 1,
};

BOOL ServerNodePushTypeIsValidValue(ServerNodePushType value);


@interface IqRoot : NSObject {
}
+ (PBExtensionRegistry*) extensionRegistry;
+ (void) registerAllExtensions:(PBMutableExtensionRegistry*) registry;
@end

@interface IqPacket : PBGeneratedMessage {
@private
  BOOL hasAction_:1;
  BOOL hasActionresponse_:1;
  BOOL hasType_:1;
  IqAction* action;
  IqActionResponse* actionresponse;
  IqType type;
}
- (BOOL) hasType;
- (BOOL) hasAction;
- (BOOL) hasActionresponse;
@property (readonly) IqType type;
@property (readonly, strong) IqAction* action;
@property (readonly, strong) IqActionResponse* actionresponse;

+ (IqPacket*) defaultInstance;
- (IqPacket*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (IqPacketBuilder*) builder;
+ (IqPacketBuilder*) builder;
+ (IqPacketBuilder*) builderWithPrototype:(IqPacket*) prototype;
- (IqPacketBuilder*) toBuilder;

+ (IqPacket*) parseFromData:(NSData*) data;
+ (IqPacket*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (IqPacket*) parseFromInputStream:(NSInputStream*) input;
+ (IqPacket*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (IqPacket*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (IqPacket*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface IqPacketBuilder : PBGeneratedMessageBuilder {
@private
  IqPacket* result;
}

- (IqPacket*) defaultInstance;

- (IqPacketBuilder*) clear;
- (IqPacketBuilder*) clone;

- (IqPacket*) build;
- (IqPacket*) buildPartial;

- (IqPacketBuilder*) mergeFrom:(IqPacket*) other;
- (IqPacketBuilder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (IqPacketBuilder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasType;
- (IqType) type;
- (IqPacketBuilder*) setType:(IqType) value;
- (IqPacketBuilder*) clearType;

- (BOOL) hasAction;
- (IqAction*) action;
- (IqPacketBuilder*) setAction:(IqAction*) value;
- (IqPacketBuilder*) setActionBuilder:(IqActionBuilder*) builderForValue;
- (IqPacketBuilder*) mergeAction:(IqAction*) value;
- (IqPacketBuilder*) clearAction;

- (BOOL) hasActionresponse;
- (IqActionResponse*) actionresponse;
- (IqPacketBuilder*) setActionresponse:(IqActionResponse*) value;
- (IqPacketBuilder*) setActionresponseBuilder:(IqActionResponseBuilder*) builderForValue;
- (IqPacketBuilder*) mergeActionresponse:(IqActionResponse*) value;
- (IqPacketBuilder*) clearActionresponse;
@end

@interface IqAction : PBGeneratedMessage {
@private
  BOOL hasLoginaction_:1;
  BOOL hasStdloginaction_:1;
  BOOL hasStsloginaction_:1;
  BOOL hasServernodes_:1;
  BOOL hasPushnotice_:1;
  BOOL hasHeartbeatRequest_:1;
  LoginAction* loginaction;
  StDLoginAction* stdloginaction;
  StSLoginAction* stsloginaction;
  ServerNodesPush* servernodes;
  PushNotice* pushnotice;
  Heartbeat heartbeatRequest;
}
- (BOOL) hasHeartbeatRequest;
- (BOOL) hasLoginaction;
- (BOOL) hasStdloginaction;
- (BOOL) hasStsloginaction;
- (BOOL) hasServernodes;
- (BOOL) hasPushnotice;
@property (readonly) Heartbeat heartbeatRequest;
@property (readonly, strong) LoginAction* loginaction;
@property (readonly, strong) StDLoginAction* stdloginaction;
@property (readonly, strong) StSLoginAction* stsloginaction;
@property (readonly, strong) ServerNodesPush* servernodes;
@property (readonly, strong) PushNotice* pushnotice;

+ (IqAction*) defaultInstance;
- (IqAction*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (IqActionBuilder*) builder;
+ (IqActionBuilder*) builder;
+ (IqActionBuilder*) builderWithPrototype:(IqAction*) prototype;
- (IqActionBuilder*) toBuilder;

+ (IqAction*) parseFromData:(NSData*) data;
+ (IqAction*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (IqAction*) parseFromInputStream:(NSInputStream*) input;
+ (IqAction*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (IqAction*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (IqAction*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface IqActionBuilder : PBGeneratedMessageBuilder {
@private
  IqAction* result;
}

- (IqAction*) defaultInstance;

- (IqActionBuilder*) clear;
- (IqActionBuilder*) clone;

- (IqAction*) build;
- (IqAction*) buildPartial;

- (IqActionBuilder*) mergeFrom:(IqAction*) other;
- (IqActionBuilder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (IqActionBuilder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasHeartbeatRequest;
- (Heartbeat) heartbeatRequest;
- (IqActionBuilder*) setHeartbeatRequest:(Heartbeat) value;
- (IqActionBuilder*) clearHeartbeatRequest;

- (BOOL) hasLoginaction;
- (LoginAction*) loginaction;
- (IqActionBuilder*) setLoginaction:(LoginAction*) value;
- (IqActionBuilder*) setLoginactionBuilder:(LoginActionBuilder*) builderForValue;
- (IqActionBuilder*) mergeLoginaction:(LoginAction*) value;
- (IqActionBuilder*) clearLoginaction;

- (BOOL) hasStdloginaction;
- (StDLoginAction*) stdloginaction;
- (IqActionBuilder*) setStdloginaction:(StDLoginAction*) value;
- (IqActionBuilder*) setStdloginactionBuilder:(StDLoginActionBuilder*) builderForValue;
- (IqActionBuilder*) mergeStdloginaction:(StDLoginAction*) value;
- (IqActionBuilder*) clearStdloginaction;

- (BOOL) hasStsloginaction;
- (StSLoginAction*) stsloginaction;
- (IqActionBuilder*) setStsloginaction:(StSLoginAction*) value;
- (IqActionBuilder*) setStsloginactionBuilder:(StSLoginActionBuilder*) builderForValue;
- (IqActionBuilder*) mergeStsloginaction:(StSLoginAction*) value;
- (IqActionBuilder*) clearStsloginaction;

- (BOOL) hasServernodes;
- (ServerNodesPush*) servernodes;
- (IqActionBuilder*) setServernodes:(ServerNodesPush*) value;
- (IqActionBuilder*) setServernodesBuilder:(ServerNodesPushBuilder*) builderForValue;
- (IqActionBuilder*) mergeServernodes:(ServerNodesPush*) value;
- (IqActionBuilder*) clearServernodes;

- (BOOL) hasPushnotice;
- (PushNotice*) pushnotice;
- (IqActionBuilder*) setPushnotice:(PushNotice*) value;
- (IqActionBuilder*) setPushnoticeBuilder:(PushNoticeBuilder*) builderForValue;
- (IqActionBuilder*) mergePushnotice:(PushNotice*) value;
- (IqActionBuilder*) clearPushnotice;
@end

@interface IqActionResponse : PBGeneratedMessage {
@private
  BOOL hasLoginresponse_:1;
  BOOL hasStdloginresponse_:1;
  BOOL hasStsloginresponse_:1;
  BOOL hasServernodes_:1;
  BOOL hasPushnotice_:1;
  BOOL hasHeartbeatResponse_:1;
  LoginResponse* loginresponse;
  StDLoginResponse* stdloginresponse;
  StSLoginResponse* stsloginresponse;
  ServerNodesPush* servernodes;
  PushNotice* pushnotice;
  Heartbeat heartbeatResponse;
}
- (BOOL) hasHeartbeatResponse;
- (BOOL) hasLoginresponse;
- (BOOL) hasStdloginresponse;
- (BOOL) hasStsloginresponse;
- (BOOL) hasServernodes;
- (BOOL) hasPushnotice;
@property (readonly) Heartbeat heartbeatResponse;
@property (readonly, strong) LoginResponse* loginresponse;
@property (readonly, strong) StDLoginResponse* stdloginresponse;
@property (readonly, strong) StSLoginResponse* stsloginresponse;
@property (readonly, strong) ServerNodesPush* servernodes;
@property (readonly, strong) PushNotice* pushnotice;

+ (IqActionResponse*) defaultInstance;
- (IqActionResponse*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (IqActionResponseBuilder*) builder;
+ (IqActionResponseBuilder*) builder;
+ (IqActionResponseBuilder*) builderWithPrototype:(IqActionResponse*) prototype;
- (IqActionResponseBuilder*) toBuilder;

+ (IqActionResponse*) parseFromData:(NSData*) data;
+ (IqActionResponse*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (IqActionResponse*) parseFromInputStream:(NSInputStream*) input;
+ (IqActionResponse*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (IqActionResponse*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (IqActionResponse*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface IqActionResponseBuilder : PBGeneratedMessageBuilder {
@private
  IqActionResponse* result;
}

- (IqActionResponse*) defaultInstance;

- (IqActionResponseBuilder*) clear;
- (IqActionResponseBuilder*) clone;

- (IqActionResponse*) build;
- (IqActionResponse*) buildPartial;

- (IqActionResponseBuilder*) mergeFrom:(IqActionResponse*) other;
- (IqActionResponseBuilder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (IqActionResponseBuilder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasHeartbeatResponse;
- (Heartbeat) heartbeatResponse;
- (IqActionResponseBuilder*) setHeartbeatResponse:(Heartbeat) value;
- (IqActionResponseBuilder*) clearHeartbeatResponse;

- (BOOL) hasLoginresponse;
- (LoginResponse*) loginresponse;
- (IqActionResponseBuilder*) setLoginresponse:(LoginResponse*) value;
- (IqActionResponseBuilder*) setLoginresponseBuilder:(LoginResponseBuilder*) builderForValue;
- (IqActionResponseBuilder*) mergeLoginresponse:(LoginResponse*) value;
- (IqActionResponseBuilder*) clearLoginresponse;

- (BOOL) hasStdloginresponse;
- (StDLoginResponse*) stdloginresponse;
- (IqActionResponseBuilder*) setStdloginresponse:(StDLoginResponse*) value;
- (IqActionResponseBuilder*) setStdloginresponseBuilder:(StDLoginResponseBuilder*) builderForValue;
- (IqActionResponseBuilder*) mergeStdloginresponse:(StDLoginResponse*) value;
- (IqActionResponseBuilder*) clearStdloginresponse;

- (BOOL) hasStsloginresponse;
- (StSLoginResponse*) stsloginresponse;
- (IqActionResponseBuilder*) setStsloginresponse:(StSLoginResponse*) value;
- (IqActionResponseBuilder*) setStsloginresponseBuilder:(StSLoginResponseBuilder*) builderForValue;
- (IqActionResponseBuilder*) mergeStsloginresponse:(StSLoginResponse*) value;
- (IqActionResponseBuilder*) clearStsloginresponse;

- (BOOL) hasServernodes;
- (ServerNodesPush*) servernodes;
- (IqActionResponseBuilder*) setServernodes:(ServerNodesPush*) value;
- (IqActionResponseBuilder*) setServernodesBuilder:(ServerNodesPushBuilder*) builderForValue;
- (IqActionResponseBuilder*) mergeServernodes:(ServerNodesPush*) value;
- (IqActionResponseBuilder*) clearServernodes;

- (BOOL) hasPushnotice;
- (PushNotice*) pushnotice;
- (IqActionResponseBuilder*) setPushnotice:(PushNotice*) value;
- (IqActionResponseBuilder*) setPushnoticeBuilder:(PushNoticeBuilder*) builderForValue;
- (IqActionResponseBuilder*) mergePushnotice:(PushNotice*) value;
- (IqActionResponseBuilder*) clearPushnotice;
@end

@interface LoginAction : PBGeneratedMessage {
@private
  BOOL hasAccount_:1;
  BOOL hasPassword_:1;
  BOOL hasPhone_:1;
  NSString* account;
  NSString* password;
  NSString* phone;
}
- (BOOL) hasAccount;
- (BOOL) hasPassword;
- (BOOL) hasPhone;
@property (readonly, strong) NSString* account;
@property (readonly, strong) NSString* password;
@property (readonly, strong) NSString* phone;

+ (LoginAction*) defaultInstance;
- (LoginAction*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (LoginActionBuilder*) builder;
+ (LoginActionBuilder*) builder;
+ (LoginActionBuilder*) builderWithPrototype:(LoginAction*) prototype;
- (LoginActionBuilder*) toBuilder;

+ (LoginAction*) parseFromData:(NSData*) data;
+ (LoginAction*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (LoginAction*) parseFromInputStream:(NSInputStream*) input;
+ (LoginAction*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (LoginAction*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (LoginAction*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface LoginActionBuilder : PBGeneratedMessageBuilder {
@private
  LoginAction* result;
}

- (LoginAction*) defaultInstance;

- (LoginActionBuilder*) clear;
- (LoginActionBuilder*) clone;

- (LoginAction*) build;
- (LoginAction*) buildPartial;

- (LoginActionBuilder*) mergeFrom:(LoginAction*) other;
- (LoginActionBuilder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (LoginActionBuilder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasAccount;
- (NSString*) account;
- (LoginActionBuilder*) setAccount:(NSString*) value;
- (LoginActionBuilder*) clearAccount;

- (BOOL) hasPassword;
- (NSString*) password;
- (LoginActionBuilder*) setPassword:(NSString*) value;
- (LoginActionBuilder*) clearPassword;

- (BOOL) hasPhone;
- (NSString*) phone;
- (LoginActionBuilder*) setPhone:(NSString*) value;
- (LoginActionBuilder*) clearPhone;
@end

@interface LoginResponse : PBGeneratedMessage {
@private
  BOOL hasStatecode_:1;
  BOOL hasResponsemsg_:1;
  SInt32 statecode;
  NSString* responsemsg;
}
- (BOOL) hasStatecode;
- (BOOL) hasResponsemsg;
@property (readonly) SInt32 statecode;
@property (readonly, strong) NSString* responsemsg;

+ (LoginResponse*) defaultInstance;
- (LoginResponse*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (LoginResponseBuilder*) builder;
+ (LoginResponseBuilder*) builder;
+ (LoginResponseBuilder*) builderWithPrototype:(LoginResponse*) prototype;
- (LoginResponseBuilder*) toBuilder;

+ (LoginResponse*) parseFromData:(NSData*) data;
+ (LoginResponse*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (LoginResponse*) parseFromInputStream:(NSInputStream*) input;
+ (LoginResponse*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (LoginResponse*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (LoginResponse*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface LoginResponseBuilder : PBGeneratedMessageBuilder {
@private
  LoginResponse* result;
}

- (LoginResponse*) defaultInstance;

- (LoginResponseBuilder*) clear;
- (LoginResponseBuilder*) clone;

- (LoginResponse*) build;
- (LoginResponse*) buildPartial;

- (LoginResponseBuilder*) mergeFrom:(LoginResponse*) other;
- (LoginResponseBuilder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (LoginResponseBuilder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasStatecode;
- (SInt32) statecode;
- (LoginResponseBuilder*) setStatecode:(SInt32) value;
- (LoginResponseBuilder*) clearStatecode;

- (BOOL) hasResponsemsg;
- (NSString*) responsemsg;
- (LoginResponseBuilder*) setResponsemsg:(NSString*) value;
- (LoginResponseBuilder*) clearResponsemsg;
@end

@interface StDLoginAction : PBGeneratedMessage {
@private
  BOOL hasNodeid_:1;
  NSString* nodeid;
}
- (BOOL) hasNodeid;
@property (readonly, strong) NSString* nodeid;

+ (StDLoginAction*) defaultInstance;
- (StDLoginAction*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (StDLoginActionBuilder*) builder;
+ (StDLoginActionBuilder*) builder;
+ (StDLoginActionBuilder*) builderWithPrototype:(StDLoginAction*) prototype;
- (StDLoginActionBuilder*) toBuilder;

+ (StDLoginAction*) parseFromData:(NSData*) data;
+ (StDLoginAction*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (StDLoginAction*) parseFromInputStream:(NSInputStream*) input;
+ (StDLoginAction*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (StDLoginAction*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (StDLoginAction*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface StDLoginActionBuilder : PBGeneratedMessageBuilder {
@private
  StDLoginAction* result;
}

- (StDLoginAction*) defaultInstance;

- (StDLoginActionBuilder*) clear;
- (StDLoginActionBuilder*) clone;

- (StDLoginAction*) build;
- (StDLoginAction*) buildPartial;

- (StDLoginActionBuilder*) mergeFrom:(StDLoginAction*) other;
- (StDLoginActionBuilder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (StDLoginActionBuilder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasNodeid;
- (NSString*) nodeid;
- (StDLoginActionBuilder*) setNodeid:(NSString*) value;
- (StDLoginActionBuilder*) clearNodeid;
@end

@interface StDLoginResponse : PBGeneratedMessage {
@private
  BOOL hasStatecode_:1;
  BOOL hasNode_:1;
  SInt32 statecode;
  NSString* node;
}
- (BOOL) hasStatecode;
- (BOOL) hasNode;
@property (readonly) SInt32 statecode;
@property (readonly, strong) NSString* node;

+ (StDLoginResponse*) defaultInstance;
- (StDLoginResponse*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (StDLoginResponseBuilder*) builder;
+ (StDLoginResponseBuilder*) builder;
+ (StDLoginResponseBuilder*) builderWithPrototype:(StDLoginResponse*) prototype;
- (StDLoginResponseBuilder*) toBuilder;

+ (StDLoginResponse*) parseFromData:(NSData*) data;
+ (StDLoginResponse*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (StDLoginResponse*) parseFromInputStream:(NSInputStream*) input;
+ (StDLoginResponse*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (StDLoginResponse*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (StDLoginResponse*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface StDLoginResponseBuilder : PBGeneratedMessageBuilder {
@private
  StDLoginResponse* result;
}

- (StDLoginResponse*) defaultInstance;

- (StDLoginResponseBuilder*) clear;
- (StDLoginResponseBuilder*) clone;

- (StDLoginResponse*) build;
- (StDLoginResponse*) buildPartial;

- (StDLoginResponseBuilder*) mergeFrom:(StDLoginResponse*) other;
- (StDLoginResponseBuilder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (StDLoginResponseBuilder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasStatecode;
- (SInt32) statecode;
- (StDLoginResponseBuilder*) setStatecode:(SInt32) value;
- (StDLoginResponseBuilder*) clearStatecode;

- (BOOL) hasNode;
- (NSString*) node;
- (StDLoginResponseBuilder*) setNode:(NSString*) value;
- (StDLoginResponseBuilder*) clearNode;
@end

@interface StSLoginAction : PBGeneratedMessage {
@private
  BOOL hasNodeid_:1;
  BOOL hasNode_:1;
  NSString* nodeid;
  NSString* node;
}
- (BOOL) hasNodeid;
- (BOOL) hasNode;
@property (readonly, strong) NSString* nodeid;
@property (readonly, strong) NSString* node;

+ (StSLoginAction*) defaultInstance;
- (StSLoginAction*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (StSLoginActionBuilder*) builder;
+ (StSLoginActionBuilder*) builder;
+ (StSLoginActionBuilder*) builderWithPrototype:(StSLoginAction*) prototype;
- (StSLoginActionBuilder*) toBuilder;

+ (StSLoginAction*) parseFromData:(NSData*) data;
+ (StSLoginAction*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (StSLoginAction*) parseFromInputStream:(NSInputStream*) input;
+ (StSLoginAction*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (StSLoginAction*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (StSLoginAction*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface StSLoginActionBuilder : PBGeneratedMessageBuilder {
@private
  StSLoginAction* result;
}

- (StSLoginAction*) defaultInstance;

- (StSLoginActionBuilder*) clear;
- (StSLoginActionBuilder*) clone;

- (StSLoginAction*) build;
- (StSLoginAction*) buildPartial;

- (StSLoginActionBuilder*) mergeFrom:(StSLoginAction*) other;
- (StSLoginActionBuilder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (StSLoginActionBuilder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasNodeid;
- (NSString*) nodeid;
- (StSLoginActionBuilder*) setNodeid:(NSString*) value;
- (StSLoginActionBuilder*) clearNodeid;

- (BOOL) hasNode;
- (NSString*) node;
- (StSLoginActionBuilder*) setNode:(NSString*) value;
- (StSLoginActionBuilder*) clearNode;
@end

@interface StSLoginResponse : PBGeneratedMessage {
@private
  BOOL hasStatecode_:1;
  BOOL hasNode_:1;
  SInt32 statecode;
  NSString* node;
}
- (BOOL) hasStatecode;
- (BOOL) hasNode;
@property (readonly) SInt32 statecode;
@property (readonly, strong) NSString* node;

+ (StSLoginResponse*) defaultInstance;
- (StSLoginResponse*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (StSLoginResponseBuilder*) builder;
+ (StSLoginResponseBuilder*) builder;
+ (StSLoginResponseBuilder*) builderWithPrototype:(StSLoginResponse*) prototype;
- (StSLoginResponseBuilder*) toBuilder;

+ (StSLoginResponse*) parseFromData:(NSData*) data;
+ (StSLoginResponse*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (StSLoginResponse*) parseFromInputStream:(NSInputStream*) input;
+ (StSLoginResponse*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (StSLoginResponse*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (StSLoginResponse*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface StSLoginResponseBuilder : PBGeneratedMessageBuilder {
@private
  StSLoginResponse* result;
}

- (StSLoginResponse*) defaultInstance;

- (StSLoginResponseBuilder*) clear;
- (StSLoginResponseBuilder*) clone;

- (StSLoginResponse*) build;
- (StSLoginResponse*) buildPartial;

- (StSLoginResponseBuilder*) mergeFrom:(StSLoginResponse*) other;
- (StSLoginResponseBuilder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (StSLoginResponseBuilder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasStatecode;
- (SInt32) statecode;
- (StSLoginResponseBuilder*) setStatecode:(SInt32) value;
- (StSLoginResponseBuilder*) clearStatecode;

- (BOOL) hasNode;
- (NSString*) node;
- (StSLoginResponseBuilder*) setNode:(NSString*) value;
- (StSLoginResponseBuilder*) clearNode;
@end

@interface PushNotice : PBGeneratedMessage {
@private
  BOOL hasBatchid_:1;
  BOOL hasServerNodes_:1;
  NSString* batchid;
  NSString* serverNodes;
}
- (BOOL) hasBatchid;
- (BOOL) hasServerNodes;
@property (readonly, strong) NSString* batchid;
@property (readonly, strong) NSString* serverNodes;

+ (PushNotice*) defaultInstance;
- (PushNotice*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (PushNoticeBuilder*) builder;
+ (PushNoticeBuilder*) builder;
+ (PushNoticeBuilder*) builderWithPrototype:(PushNotice*) prototype;
- (PushNoticeBuilder*) toBuilder;

+ (PushNotice*) parseFromData:(NSData*) data;
+ (PushNotice*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (PushNotice*) parseFromInputStream:(NSInputStream*) input;
+ (PushNotice*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (PushNotice*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (PushNotice*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface PushNoticeBuilder : PBGeneratedMessageBuilder {
@private
  PushNotice* result;
}

- (PushNotice*) defaultInstance;

- (PushNoticeBuilder*) clear;
- (PushNoticeBuilder*) clone;

- (PushNotice*) build;
- (PushNotice*) buildPartial;

- (PushNoticeBuilder*) mergeFrom:(PushNotice*) other;
- (PushNoticeBuilder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (PushNoticeBuilder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasBatchid;
- (NSString*) batchid;
- (PushNoticeBuilder*) setBatchid:(NSString*) value;
- (PushNoticeBuilder*) clearBatchid;

- (BOOL) hasServerNodes;
- (NSString*) serverNodes;
- (PushNoticeBuilder*) setServerNodes:(NSString*) value;
- (PushNoticeBuilder*) clearServerNodes;
@end

@interface ServerNodesPush : PBGeneratedMessage {
@private
  BOOL hasCount_:1;
  BOOL hasNode_:1;
  BOOL hasType_:1;
  SInt32 count;
  NSString* node;
  ServerNodePushType type;
}
- (BOOL) hasType;
- (BOOL) hasCount;
- (BOOL) hasNode;
@property (readonly) ServerNodePushType type;
@property (readonly) SInt32 count;
@property (readonly, strong) NSString* node;

+ (ServerNodesPush*) defaultInstance;
- (ServerNodesPush*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (ServerNodesPushBuilder*) builder;
+ (ServerNodesPushBuilder*) builder;
+ (ServerNodesPushBuilder*) builderWithPrototype:(ServerNodesPush*) prototype;
- (ServerNodesPushBuilder*) toBuilder;

+ (ServerNodesPush*) parseFromData:(NSData*) data;
+ (ServerNodesPush*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (ServerNodesPush*) parseFromInputStream:(NSInputStream*) input;
+ (ServerNodesPush*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (ServerNodesPush*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (ServerNodesPush*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface ServerNodesPushBuilder : PBGeneratedMessageBuilder {
@private
  ServerNodesPush* result;
}

- (ServerNodesPush*) defaultInstance;

- (ServerNodesPushBuilder*) clear;
- (ServerNodesPushBuilder*) clone;

- (ServerNodesPush*) build;
- (ServerNodesPush*) buildPartial;

- (ServerNodesPushBuilder*) mergeFrom:(ServerNodesPush*) other;
- (ServerNodesPushBuilder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (ServerNodesPushBuilder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasType;
- (ServerNodePushType) type;
- (ServerNodesPushBuilder*) setType:(ServerNodePushType) value;
- (ServerNodesPushBuilder*) clearType;

- (BOOL) hasCount;
- (SInt32) count;
- (ServerNodesPushBuilder*) setCount:(SInt32) value;
- (ServerNodesPushBuilder*) clearCount;

- (BOOL) hasNode;
- (NSString*) node;
- (ServerNodesPushBuilder*) setNode:(NSString*) value;
- (ServerNodesPushBuilder*) clearNode;
@end


// @@protoc_insertion_point(global_scope)