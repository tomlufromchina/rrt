// Generated by the protocol buffer compiler.  DO NOT EDIT!

#import "BasePacket.pb.h"
// @@protoc_insertion_point(imports)

@implementation BasePacketRoot
static PBExtensionRegistry* extensionRegistry = nil;
+ (PBExtensionRegistry*) extensionRegistry {
  return extensionRegistry;
}

+ (void) initialize {
  if (self == [BasePacketRoot class]) {
    PBMutableExtensionRegistry* registry = [PBMutableExtensionRegistry registry];
    [self registerAllExtensions:registry];
    [IqRoot registerAllExtensions:registry];
    [PresenceRoot registerAllExtensions:registry];
    [MessageRoot registerAllExtensions:registry];
    extensionRegistry = registry;
  }
}
+ (void) registerAllExtensions:(PBMutableExtensionRegistry*) registry {
}
@end

@interface Packet ()
@property (strong) NSString* from;
@property (strong) NSString* to;
@property (strong) NSString* error;
@property (strong) IqPacket* iq;
@property (strong) PresencePacket* presence;
@property (strong) MessagePacket* message;
@end

@implementation Packet

- (BOOL) hasFrom {
  return !!hasFrom_;
}
- (void) setHasFrom:(BOOL) value_ {
  hasFrom_ = !!value_;
}
@synthesize from;
- (BOOL) hasTo {
  return !!hasTo_;
}
- (void) setHasTo:(BOOL) value_ {
  hasTo_ = !!value_;
}
@synthesize to;
- (BOOL) hasError {
  return !!hasError_;
}
- (void) setHasError:(BOOL) value_ {
  hasError_ = !!value_;
}
@synthesize error;
- (BOOL) hasIq {
  return !!hasIq_;
}
- (void) setHasIq:(BOOL) value_ {
  hasIq_ = !!value_;
}
@synthesize iq;
- (BOOL) hasPresence {
  return !!hasPresence_;
}
- (void) setHasPresence:(BOOL) value_ {
  hasPresence_ = !!value_;
}
@synthesize presence;
- (BOOL) hasMessage {
  return !!hasMessage_;
}
- (void) setHasMessage:(BOOL) value_ {
  hasMessage_ = !!value_;
}
@synthesize message;
- (id) init {
  if ((self = [super init])) {
    self.from = @"";
    self.to = @"";
    self.error = @"";
    self.iq = [IqPacket defaultInstance];
    self.presence = [PresencePacket defaultInstance];
    self.message = [MessagePacket defaultInstance];
  }
  return self;
}
static Packet* defaultPacketInstance = nil;
+ (void) initialize {
  if (self == [Packet class]) {
    defaultPacketInstance = [[Packet alloc] init];
  }
}
+ (Packet*) defaultInstance {
  return defaultPacketInstance;
}
- (Packet*) defaultInstance {
  return defaultPacketInstance;
}
- (BOOL) isInitialized {
  if (!self.hasFrom) {
    return NO;
  }
  if (!self.hasTo) {
    return NO;
  }
  if (self.hasIq) {
    if (!self.iq.isInitialized) {
      return NO;
    }
  }
  if (self.hasPresence) {
    if (!self.presence.isInitialized) {
      return NO;
    }
  }
  if (self.hasMessage) {
    if (!self.message.isInitialized) {
      return NO;
    }
  }
  return YES;
}
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output {
  if (self.hasFrom) {
    [output writeString:1 value:self.from];
  }
  if (self.hasTo) {
    [output writeString:2 value:self.to];
  }
  if (self.hasError) {
    [output writeString:3 value:self.error];
  }
  if (self.hasIq) {
    [output writeMessage:4 value:self.iq];
  }
  if (self.hasPresence) {
    [output writeMessage:5 value:self.presence];
  }
  if (self.hasMessage) {
    [output writeMessage:6 value:self.message];
  }
  [self.unknownFields writeToCodedOutputStream:output];
}
- (SInt32) serializedSize {
  __block SInt32 size_ = memoizedSerializedSize;
  if (size_ != -1) {
    return size_;
  }

  size_ = 0;
  if (self.hasFrom) {
    size_ += computeStringSize(1, self.from);
  }
  if (self.hasTo) {
    size_ += computeStringSize(2, self.to);
  }
  if (self.hasError) {
    size_ += computeStringSize(3, self.error);
  }
  if (self.hasIq) {
    size_ += computeMessageSize(4, self.iq);
  }
  if (self.hasPresence) {
    size_ += computeMessageSize(5, self.presence);
  }
  if (self.hasMessage) {
    size_ += computeMessageSize(6, self.message);
  }
  size_ += self.unknownFields.serializedSize;
  memoizedSerializedSize = size_;
  return size_;
}
+ (Packet*) parseFromData:(NSData*) data {
  return (Packet*)[[[Packet builder] mergeFromData:data] build];
}
+ (Packet*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (Packet*)[[[Packet builder] mergeFromData:data extensionRegistry:extensionRegistry] build];
}
+ (Packet*) parseFromInputStream:(NSInputStream*) input {
  return (Packet*)[[[Packet builder] mergeFromInputStream:input] build];
}
+ (Packet*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (Packet*)[[[Packet builder] mergeFromInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (Packet*) parseFromCodedInputStream:(PBCodedInputStream*) input {
  return (Packet*)[[[Packet builder] mergeFromCodedInputStream:input] build];
}
+ (Packet*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (Packet*)[[[Packet builder] mergeFromCodedInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (PacketBuilder*) builder {
  return [[PacketBuilder alloc] init];
}
+ (PacketBuilder*) builderWithPrototype:(Packet*) prototype {
  return [[Packet builder] mergeFrom:prototype];
}
- (PacketBuilder*) builder {
  return [Packet builder];
}
- (PacketBuilder*) toBuilder {
  return [Packet builderWithPrototype:self];
}
- (void) writeDescriptionTo:(NSMutableString*) output withIndent:(NSString*) indent {
  if (self.hasFrom) {
    [output appendFormat:@"%@%@: %@\n", indent, @"from", self.from];
  }
  if (self.hasTo) {
    [output appendFormat:@"%@%@: %@\n", indent, @"to", self.to];
  }
  if (self.hasError) {
    [output appendFormat:@"%@%@: %@\n", indent, @"error", self.error];
  }
  if (self.hasIq) {
    [output appendFormat:@"%@%@ {\n", indent, @"iq"];
    [self.iq writeDescriptionTo:output
                         withIndent:[NSString stringWithFormat:@"%@  ", indent]];
    [output appendFormat:@"%@}\n", indent];
  }
  if (self.hasPresence) {
    [output appendFormat:@"%@%@ {\n", indent, @"presence"];
    [self.presence writeDescriptionTo:output
                         withIndent:[NSString stringWithFormat:@"%@  ", indent]];
    [output appendFormat:@"%@}\n", indent];
  }
  if (self.hasMessage) {
    [output appendFormat:@"%@%@ {\n", indent, @"message"];
    [self.message writeDescriptionTo:output
                         withIndent:[NSString stringWithFormat:@"%@  ", indent]];
    [output appendFormat:@"%@}\n", indent];
  }
  [self.unknownFields writeDescriptionTo:output withIndent:indent];
}
- (BOOL) isEqual:(id)other {
  if (other == self) {
    return YES;
  }
  if (![other isKindOfClass:[Packet class]]) {
    return NO;
  }
  Packet *otherMessage = other;
  return
      self.hasFrom == otherMessage.hasFrom &&
      (!self.hasFrom || [self.from isEqual:otherMessage.from]) &&
      self.hasTo == otherMessage.hasTo &&
      (!self.hasTo || [self.to isEqual:otherMessage.to]) &&
      self.hasError == otherMessage.hasError &&
      (!self.hasError || [self.error isEqual:otherMessage.error]) &&
      self.hasIq == otherMessage.hasIq &&
      (!self.hasIq || [self.iq isEqual:otherMessage.iq]) &&
      self.hasPresence == otherMessage.hasPresence &&
      (!self.hasPresence || [self.presence isEqual:otherMessage.presence]) &&
      self.hasMessage == otherMessage.hasMessage &&
      (!self.hasMessage || [self.message isEqual:otherMessage.message]) &&
      (self.unknownFields == otherMessage.unknownFields || (self.unknownFields != nil && [self.unknownFields isEqual:otherMessage.unknownFields]));
}
- (NSUInteger) hash {
  __block NSUInteger hashCode = 7;
  if (self.hasFrom) {
    hashCode = hashCode * 31 + [self.from hash];
  }
  if (self.hasTo) {
    hashCode = hashCode * 31 + [self.to hash];
  }
  if (self.hasError) {
    hashCode = hashCode * 31 + [self.error hash];
  }
  if (self.hasIq) {
    hashCode = hashCode * 31 + [self.iq hash];
  }
  if (self.hasPresence) {
    hashCode = hashCode * 31 + [self.presence hash];
  }
  if (self.hasMessage) {
    hashCode = hashCode * 31 + [self.message hash];
  }
  hashCode = hashCode * 31 + [self.unknownFields hash];
  return hashCode;
}
@end

@interface PacketBuilder()
@property (strong) Packet* result;
@end

@implementation PacketBuilder
@synthesize result;
- (id) init {
  if ((self = [super init])) {
    self.result = [[Packet alloc] init];
  }
  return self;
}
- (PBGeneratedMessage*) internalGetResult {
  return result;
}
- (PacketBuilder*) clear {
  self.result = [[Packet alloc] init];
  return self;
}
- (PacketBuilder*) clone {
  return [Packet builderWithPrototype:result];
}
- (Packet*) defaultInstance {
  return [Packet defaultInstance];
}
- (Packet*) build {
  [self checkInitialized];
  return [self buildPartial];
}
- (Packet*) buildPartial {
  Packet* returnMe = result;
  self.result = nil;
  return returnMe;
}
- (PacketBuilder*) mergeFrom:(Packet*) other {
  if (other == [Packet defaultInstance]) {
    return self;
  }
  if (other.hasFrom) {
    [self setFrom:other.from];
  }
  if (other.hasTo) {
    [self setTo:other.to];
  }
  if (other.hasError) {
    [self setError:other.error];
  }
  if (other.hasIq) {
    [self mergeIq:other.iq];
  }
  if (other.hasPresence) {
    [self mergePresence:other.presence];
  }
  if (other.hasMessage) {
    [self mergeMessage:other.message];
  }
  [self mergeUnknownFields:other.unknownFields];
  return self;
}
- (PacketBuilder*) mergeFromCodedInputStream:(PBCodedInputStream*) input {
  return [self mergeFromCodedInputStream:input extensionRegistry:[PBExtensionRegistry emptyRegistry]];
}
- (PacketBuilder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  PBUnknownFieldSetBuilder* unknownFields = [PBUnknownFieldSet builderWithUnknownFields:self.unknownFields];
  while (YES) {
    SInt32 tag = [input readTag];
    switch (tag) {
      case 0:
        [self setUnknownFields:[unknownFields build]];
        return self;
      default: {
        if (![self parseUnknownField:input unknownFields:unknownFields extensionRegistry:extensionRegistry tag:tag]) {
          [self setUnknownFields:[unknownFields build]];
          return self;
        }
        break;
      }
      case 10: {
        [self setFrom:[input readString]];
        break;
      }
      case 18: {
        [self setTo:[input readString]];
        break;
      }
      case 26: {
        [self setError:[input readString]];
        break;
      }
      case 34: {
        IqPacketBuilder* subBuilder = [IqPacket builder];
        if (self.hasIq) {
          [subBuilder mergeFrom:self.iq];
        }
        [input readMessage:subBuilder extensionRegistry:extensionRegistry];
        [self setIq:[subBuilder buildPartial]];
        break;
      }
      case 42: {
        PresencePacketBuilder* subBuilder = [PresencePacket builder];
        if (self.hasPresence) {
          [subBuilder mergeFrom:self.presence];
        }
        [input readMessage:subBuilder extensionRegistry:extensionRegistry];
        [self setPresence:[subBuilder buildPartial]];
        break;
      }
      case 50: {
        MessagePacketBuilder* subBuilder = [MessagePacket builder];
        if (self.hasMessage) {
          [subBuilder mergeFrom:self.message];
        }
        [input readMessage:subBuilder extensionRegistry:extensionRegistry];
        [self setMessage:[subBuilder buildPartial]];
        break;
      }
    }
  }
}
- (BOOL) hasFrom {
  return result.hasFrom;
}
- (NSString*) from {
  return result.from;
}
- (PacketBuilder*) setFrom:(NSString*) value {
  result.hasFrom = YES;
  result.from = value;
  return self;
}
- (PacketBuilder*) clearFrom {
  result.hasFrom = NO;
  result.from = @"";
  return self;
}
- (BOOL) hasTo {
  return result.hasTo;
}
- (NSString*) to {
  return result.to;
}
- (PacketBuilder*) setTo:(NSString*) value {
  result.hasTo = YES;
  result.to = value;
  return self;
}
- (PacketBuilder*) clearTo {
  result.hasTo = NO;
  result.to = @"";
  return self;
}
- (BOOL) hasError {
  return result.hasError;
}
- (NSString*) error {
  return result.error;
}
- (PacketBuilder*) setError:(NSString*) value {
  result.hasError = YES;
  result.error = value;
  return self;
}
- (PacketBuilder*) clearError {
  result.hasError = NO;
  result.error = @"";
  return self;
}
- (BOOL) hasIq {
  return result.hasIq;
}
- (IqPacket*) iq {
  return result.iq;
}
- (PacketBuilder*) setIq:(IqPacket*) value {
  result.hasIq = YES;
  result.iq = value;
  return self;
}
- (PacketBuilder*) setIqBuilder:(IqPacketBuilder*) builderForValue {
  return [self setIq:[builderForValue build]];
}
- (PacketBuilder*) mergeIq:(IqPacket*) value {
  if (result.hasIq &&
      result.iq != [IqPacket defaultInstance]) {
    result.iq =
      [[[IqPacket builderWithPrototype:result.iq] mergeFrom:value] buildPartial];
  } else {
    result.iq = value;
  }
  result.hasIq = YES;
  return self;
}
- (PacketBuilder*) clearIq {
  result.hasIq = NO;
  result.iq = [IqPacket defaultInstance];
  return self;
}
- (BOOL) hasPresence {
  return result.hasPresence;
}
- (PresencePacket*) presence {
  return result.presence;
}
- (PacketBuilder*) setPresence:(PresencePacket*) value {
  result.hasPresence = YES;
  result.presence = value;
  return self;
}
- (PacketBuilder*) setPresenceBuilder:(PresencePacketBuilder*) builderForValue {
  return [self setPresence:[builderForValue build]];
}
- (PacketBuilder*) mergePresence:(PresencePacket*) value {
  if (result.hasPresence &&
      result.presence != [PresencePacket defaultInstance]) {
    result.presence =
      [[[PresencePacket builderWithPrototype:result.presence] mergeFrom:value] buildPartial];
  } else {
    result.presence = value;
  }
  result.hasPresence = YES;
  return self;
}
- (PacketBuilder*) clearPresence {
  result.hasPresence = NO;
  result.presence = [PresencePacket defaultInstance];
  return self;
}
- (BOOL) hasMessage {
  return result.hasMessage;
}
- (MessagePacket*) message {
  return result.message;
}
- (PacketBuilder*) setMessage:(MessagePacket*) value {
  result.hasMessage = YES;
  result.message = value;
  return self;
}
- (PacketBuilder*) setMessageBuilder:(MessagePacketBuilder*) builderForValue {
  return [self setMessage:[builderForValue build]];
}
- (PacketBuilder*) mergeMessage:(MessagePacket*) value {
  if (result.hasMessage &&
      result.message != [MessagePacket defaultInstance]) {
    result.message =
      [[[MessagePacket builderWithPrototype:result.message] mergeFrom:value] buildPartial];
  } else {
    result.message = value;
  }
  result.hasMessage = YES;
  return self;
}
- (PacketBuilder*) clearMessage {
  result.hasMessage = NO;
  result.message = [MessagePacket defaultInstance];
  return self;
}
@end


// @@protoc_insertion_point(global_scope)
