// Generated by the protocol buffer compiler.  DO NOT EDIT!

#import <ProtocolBuffers/ProtocolBuffers.h>

// @@protoc_insertion_point(imports)

@class Transmission;
@class TransmissionBuilder;
@class TransmissionChangeItem;
@class TransmissionChangeItemBuilder;
@class TransmissionDocument;
@class TransmissionDocumentBuilder;
@class TransmissionQueueItem;
@class TransmissionQueueItemBuilder;
@class TransmissionUser;
@class TransmissionUserBuilder;
@class TransmissionUserState;
@class TransmissionUserStateBuilder;


typedef NS_ENUM(SInt32, TransmissionMessageType) {
  TransmissionMessageTypeInitial = 0,
  TransmissionMessageTypeState = 1,
  TransmissionMessageTypeSequence = 2,
  TransmissionMessageTypeAck = 3,
  TransmissionMessageTypeReqQueue = 4,
  TransmissionMessageTypeReqState = 5,
  TransmissionMessageTypeUpdateQueue = 6,
  TransmissionMessageTypeUpdateState = 7,
  TransmissionMessageTypeForceText = 8,
  TransmissionMessageTypeUserList = 9,
};

BOOL TransmissionMessageTypeIsValidValue(TransmissionMessageType value);
NSString *NSStringFromTransmissionMessageType(TransmissionMessageType value);


@interface TransmissionMessageRoot : NSObject {
}
+ (PBExtensionRegistry*) extensionRegistry;
+ (void) registerAllExtensions:(PBMutableExtensionRegistry*) registry;
@end

@interface Transmission : PBGeneratedMessage<GeneratedMessageProtocol> {
@private
  BOOL hasSequenceId_:1;
  BOOL hasAckSender_:1;
  BOOL hasServerName_:1;
  BOOL hasUserName_:1;
  BOOL hasDocument_:1;
  BOOL hasChangeItem_:1;
  BOOL hasType_:1;
  SInt32 sequenceId;
  SInt32 ackSender;
  NSString* serverName;
  NSString* userName;
  TransmissionDocument* document;
  TransmissionChangeItem* changeItem;
  TransmissionMessageType type;
  NSMutableArray * userListArray;
  NSMutableArray * queueItemsArray;
  NSMutableArray * statesArray;
}
- (BOOL) hasType;
- (BOOL) hasSequenceId;
- (BOOL) hasServerName;
- (BOOL) hasUserName;
- (BOOL) hasDocument;
- (BOOL) hasAckSender;
- (BOOL) hasChangeItem;
@property (readonly) TransmissionMessageType type;
@property (readonly) SInt32 sequenceId;
@property (readonly, strong) NSString* serverName;
@property (readonly, strong) NSString* userName;
@property (readonly, strong) NSArray * userList;
@property (readonly, strong) TransmissionDocument* document;
@property (readonly) SInt32 ackSender;
@property (readonly, strong) NSArray * queueItems;
@property (readonly, strong) TransmissionChangeItem* changeItem;
@property (readonly, strong) NSArray * states;
- (TransmissionUser*)userListAtIndex:(NSUInteger)index;
- (TransmissionQueueItem*)queueItemsAtIndex:(NSUInteger)index;
- (TransmissionUserState*)statesAtIndex:(NSUInteger)index;

+ (instancetype) defaultInstance;
- (instancetype) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (TransmissionBuilder*) builder;
+ (TransmissionBuilder*) builder;
+ (TransmissionBuilder*) builderWithPrototype:(Transmission*) prototype;
- (TransmissionBuilder*) toBuilder;

+ (Transmission*) parseFromData:(NSData*) data;
+ (Transmission*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (Transmission*) parseFromInputStream:(NSInputStream*) input;
+ (Transmission*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (Transmission*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (Transmission*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface TransmissionUser : PBGeneratedMessage<GeneratedMessageProtocol> {
@private
  BOOL hasId_:1;
  BOOL hasUserName_:1;
  BOOL hasColor_:1;
  NSString* id;
  NSString* userName;
  NSString* color;
}
- (BOOL) hasId;
- (BOOL) hasUserName;
- (BOOL) hasColor;
@property (readonly, strong) NSString* id;
@property (readonly, strong) NSString* userName;
@property (readonly, strong) NSString* color;

+ (instancetype) defaultInstance;
- (instancetype) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (TransmissionUserBuilder*) builder;
+ (TransmissionUserBuilder*) builder;
+ (TransmissionUserBuilder*) builderWithPrototype:(TransmissionUser*) prototype;
- (TransmissionUserBuilder*) toBuilder;

+ (TransmissionUser*) parseFromData:(NSData*) data;
+ (TransmissionUser*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (TransmissionUser*) parseFromInputStream:(NSInputStream*) input;
+ (TransmissionUser*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (TransmissionUser*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (TransmissionUser*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface TransmissionUserBuilder : PBGeneratedMessageBuilder {
@private
  TransmissionUser* resultUser;
}

- (TransmissionUser*) defaultInstance;

- (TransmissionUserBuilder*) clear;
- (TransmissionUserBuilder*) clone;

- (TransmissionUser*) build;
- (TransmissionUser*) buildPartial;

- (TransmissionUserBuilder*) mergeFrom:(TransmissionUser*) other;
- (TransmissionUserBuilder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (TransmissionUserBuilder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasId;
- (NSString*) id;
- (TransmissionUserBuilder*) setId:(NSString*) value;
- (TransmissionUserBuilder*) clearId;

- (BOOL) hasUserName;
- (NSString*) userName;
- (TransmissionUserBuilder*) setUserName:(NSString*) value;
- (TransmissionUserBuilder*) clearUserName;

- (BOOL) hasColor;
- (NSString*) color;
- (TransmissionUserBuilder*) setColor:(NSString*) value;
- (TransmissionUserBuilder*) clearColor;
@end

@interface TransmissionDocument : PBGeneratedMessage<GeneratedMessageProtocol> {
@private
  BOOL hasDocumentText_:1;
  BOOL hasDocumentName_:1;
  NSString* documentText;
  NSString* documentName;
}
- (BOOL) hasDocumentText;
- (BOOL) hasDocumentName;
@property (readonly, strong) NSString* documentText;
@property (readonly, strong) NSString* documentName;

+ (instancetype) defaultInstance;
- (instancetype) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (TransmissionDocumentBuilder*) builder;
+ (TransmissionDocumentBuilder*) builder;
+ (TransmissionDocumentBuilder*) builderWithPrototype:(TransmissionDocument*) prototype;
- (TransmissionDocumentBuilder*) toBuilder;

+ (TransmissionDocument*) parseFromData:(NSData*) data;
+ (TransmissionDocument*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (TransmissionDocument*) parseFromInputStream:(NSInputStream*) input;
+ (TransmissionDocument*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (TransmissionDocument*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (TransmissionDocument*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface TransmissionDocumentBuilder : PBGeneratedMessageBuilder {
@private
  TransmissionDocument* resultDocument;
}

- (TransmissionDocument*) defaultInstance;

- (TransmissionDocumentBuilder*) clear;
- (TransmissionDocumentBuilder*) clone;

- (TransmissionDocument*) build;
- (TransmissionDocument*) buildPartial;

- (TransmissionDocumentBuilder*) mergeFrom:(TransmissionDocument*) other;
- (TransmissionDocumentBuilder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (TransmissionDocumentBuilder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasDocumentText;
- (NSString*) documentText;
- (TransmissionDocumentBuilder*) setDocumentText:(NSString*) value;
- (TransmissionDocumentBuilder*) clearDocumentText;

- (BOOL) hasDocumentName;
- (NSString*) documentName;
- (TransmissionDocumentBuilder*) setDocumentName:(NSString*) value;
- (TransmissionDocumentBuilder*) clearDocumentName;
@end

@interface TransmissionQueueItem : PBGeneratedMessage<GeneratedMessageProtocol> {
@private
  BOOL hasSequenceId_:1;
  BOOL hasDiff_:1;
  SInt32 sequenceId;
  NSData* diff;
}
- (BOOL) hasSequenceId;
- (BOOL) hasDiff;
@property (readonly) SInt32 sequenceId;
@property (readonly, strong) NSData* diff;

+ (instancetype) defaultInstance;
- (instancetype) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (TransmissionQueueItemBuilder*) builder;
+ (TransmissionQueueItemBuilder*) builder;
+ (TransmissionQueueItemBuilder*) builderWithPrototype:(TransmissionQueueItem*) prototype;
- (TransmissionQueueItemBuilder*) toBuilder;

+ (TransmissionQueueItem*) parseFromData:(NSData*) data;
+ (TransmissionQueueItem*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (TransmissionQueueItem*) parseFromInputStream:(NSInputStream*) input;
+ (TransmissionQueueItem*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (TransmissionQueueItem*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (TransmissionQueueItem*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface TransmissionQueueItemBuilder : PBGeneratedMessageBuilder {
@private
  TransmissionQueueItem* resultQueueItem;
}

- (TransmissionQueueItem*) defaultInstance;

- (TransmissionQueueItemBuilder*) clear;
- (TransmissionQueueItemBuilder*) clone;

- (TransmissionQueueItem*) build;
- (TransmissionQueueItem*) buildPartial;

- (TransmissionQueueItemBuilder*) mergeFrom:(TransmissionQueueItem*) other;
- (TransmissionQueueItemBuilder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (TransmissionQueueItemBuilder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasSequenceId;
- (SInt32) sequenceId;
- (TransmissionQueueItemBuilder*) setSequenceId:(SInt32) value;
- (TransmissionQueueItemBuilder*) clearSequenceId;

- (BOOL) hasDiff;
- (NSData*) diff;
- (TransmissionQueueItemBuilder*) setDiff:(NSData*) value;
- (TransmissionQueueItemBuilder*) clearDiff;
@end

@interface TransmissionChangeItem : PBGeneratedMessage<GeneratedMessageProtocol> {
@private
  BOOL hasLastSequence_:1;
  BOOL hasDiff_:1;
  SInt32 lastSequence;
  NSData* diff;
}
- (BOOL) hasLastSequence;
- (BOOL) hasDiff;
@property (readonly) SInt32 lastSequence;
@property (readonly, strong) NSData* diff;

+ (instancetype) defaultInstance;
- (instancetype) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (TransmissionChangeItemBuilder*) builder;
+ (TransmissionChangeItemBuilder*) builder;
+ (TransmissionChangeItemBuilder*) builderWithPrototype:(TransmissionChangeItem*) prototype;
- (TransmissionChangeItemBuilder*) toBuilder;

+ (TransmissionChangeItem*) parseFromData:(NSData*) data;
+ (TransmissionChangeItem*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (TransmissionChangeItem*) parseFromInputStream:(NSInputStream*) input;
+ (TransmissionChangeItem*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (TransmissionChangeItem*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (TransmissionChangeItem*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface TransmissionChangeItemBuilder : PBGeneratedMessageBuilder {
@private
  TransmissionChangeItem* resultChangeItem;
}

- (TransmissionChangeItem*) defaultInstance;

- (TransmissionChangeItemBuilder*) clear;
- (TransmissionChangeItemBuilder*) clone;

- (TransmissionChangeItem*) build;
- (TransmissionChangeItem*) buildPartial;

- (TransmissionChangeItemBuilder*) mergeFrom:(TransmissionChangeItem*) other;
- (TransmissionChangeItemBuilder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (TransmissionChangeItemBuilder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasLastSequence;
- (SInt32) lastSequence;
- (TransmissionChangeItemBuilder*) setLastSequence:(SInt32) value;
- (TransmissionChangeItemBuilder*) clearLastSequence;

- (BOOL) hasDiff;
- (NSData*) diff;
- (TransmissionChangeItemBuilder*) setDiff:(NSData*) value;
- (TransmissionChangeItemBuilder*) clearDiff;
@end

@interface TransmissionUserState : PBGeneratedMessage<GeneratedMessageProtocol> {
@private
  BOOL hasUserName_:1;
  BOOL hasState_:1;
  NSString* userName;
  NSData* state;
}
- (BOOL) hasUserName;
- (BOOL) hasState;
@property (readonly, strong) NSString* userName;
@property (readonly, strong) NSData* state;

+ (instancetype) defaultInstance;
- (instancetype) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (TransmissionUserStateBuilder*) builder;
+ (TransmissionUserStateBuilder*) builder;
+ (TransmissionUserStateBuilder*) builderWithPrototype:(TransmissionUserState*) prototype;
- (TransmissionUserStateBuilder*) toBuilder;

+ (TransmissionUserState*) parseFromData:(NSData*) data;
+ (TransmissionUserState*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (TransmissionUserState*) parseFromInputStream:(NSInputStream*) input;
+ (TransmissionUserState*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (TransmissionUserState*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (TransmissionUserState*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface TransmissionUserStateBuilder : PBGeneratedMessageBuilder {
@private
  TransmissionUserState* resultUserState;
}

- (TransmissionUserState*) defaultInstance;

- (TransmissionUserStateBuilder*) clear;
- (TransmissionUserStateBuilder*) clone;

- (TransmissionUserState*) build;
- (TransmissionUserState*) buildPartial;

- (TransmissionUserStateBuilder*) mergeFrom:(TransmissionUserState*) other;
- (TransmissionUserStateBuilder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (TransmissionUserStateBuilder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasUserName;
- (NSString*) userName;
- (TransmissionUserStateBuilder*) setUserName:(NSString*) value;
- (TransmissionUserStateBuilder*) clearUserName;

- (BOOL) hasState;
- (NSData*) state;
- (TransmissionUserStateBuilder*) setState:(NSData*) value;
- (TransmissionUserStateBuilder*) clearState;
@end

@interface TransmissionBuilder : PBGeneratedMessageBuilder {
@private
  Transmission* resultTransmission;
}

- (Transmission*) defaultInstance;

- (TransmissionBuilder*) clear;
- (TransmissionBuilder*) clone;

- (Transmission*) build;
- (Transmission*) buildPartial;

- (TransmissionBuilder*) mergeFrom:(Transmission*) other;
- (TransmissionBuilder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (TransmissionBuilder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasType;
- (TransmissionMessageType) type;
- (TransmissionBuilder*) setType:(TransmissionMessageType) value;
- (TransmissionBuilder*) clearType;

- (BOOL) hasSequenceId;
- (SInt32) sequenceId;
- (TransmissionBuilder*) setSequenceId:(SInt32) value;
- (TransmissionBuilder*) clearSequenceId;

- (BOOL) hasServerName;
- (NSString*) serverName;
- (TransmissionBuilder*) setServerName:(NSString*) value;
- (TransmissionBuilder*) clearServerName;

- (BOOL) hasUserName;
- (NSString*) userName;
- (TransmissionBuilder*) setUserName:(NSString*) value;
- (TransmissionBuilder*) clearUserName;

- (NSMutableArray *)userList;
- (TransmissionUser*)userListAtIndex:(NSUInteger)index;
- (TransmissionBuilder *)addUserList:(TransmissionUser*)value;
- (TransmissionBuilder *)setUserListArray:(NSArray *)array;
- (TransmissionBuilder *)clearUserList;

- (BOOL) hasDocument;
- (TransmissionDocument*) document;
- (TransmissionBuilder*) setDocument:(TransmissionDocument*) value;
- (TransmissionBuilder*) setDocumentBuilder:(TransmissionDocumentBuilder*) builderForValue;
- (TransmissionBuilder*) mergeDocument:(TransmissionDocument*) value;
- (TransmissionBuilder*) clearDocument;

- (BOOL) hasAckSender;
- (SInt32) ackSender;
- (TransmissionBuilder*) setAckSender:(SInt32) value;
- (TransmissionBuilder*) clearAckSender;

- (NSMutableArray *)queueItems;
- (TransmissionQueueItem*)queueItemsAtIndex:(NSUInteger)index;
- (TransmissionBuilder *)addQueueItems:(TransmissionQueueItem*)value;
- (TransmissionBuilder *)setQueueItemsArray:(NSArray *)array;
- (TransmissionBuilder *)clearQueueItems;

- (BOOL) hasChangeItem;
- (TransmissionChangeItem*) changeItem;
- (TransmissionBuilder*) setChangeItem:(TransmissionChangeItem*) value;
- (TransmissionBuilder*) setChangeItemBuilder:(TransmissionChangeItemBuilder*) builderForValue;
- (TransmissionBuilder*) mergeChangeItem:(TransmissionChangeItem*) value;
- (TransmissionBuilder*) clearChangeItem;

- (NSMutableArray *)states;
- (TransmissionUserState*)statesAtIndex:(NSUInteger)index;
- (TransmissionBuilder *)addStates:(TransmissionUserState*)value;
- (TransmissionBuilder *)setStatesArray:(NSArray *)array;
- (TransmissionBuilder *)clearStates;
@end


// @@protoc_insertion_point(global_scope)