//
//  IFToastingMessage.h
//  CampfireTest
//
//  Created by Fabio Pelosin on 31/01/13.
//  Copyright (c) 2013 Discontinuity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IFToastingTweetDescription.h"

@interface IFToastingMessage : NSObject

typedef NS_ENUM(NSUInteger, IFToastingMessageTypeGroup) {
  IFToastingMessageTypeGroupUnknown    = 0,
  IFToastingMessageTypeGroupUserPost   = 1,
  IFToastingMessageTypeGroupUserEvent  = 2,
  IFToastingMessageTypeGroupRoomEvent  = 3,
  IFToastingMessageTypeGroupOther      = 4,
};

typedef NS_ENUM(NSUInteger, IFToastingMessageUnknownType) {
  IFToastingMessageTypeUnknown = 0,
};

typedef NS_ENUM(NSUInteger, IFToastingMessageUserPostType) {
  IFToastingMessageTypeText   = 1 << 0,
  IFToastingMessageTypePaste  = 1 << 1,
  IFToastingMessageTypeSound  = 1 << 2,
  IFToastingMessageTypeTweet  = 1 << 3,
  IFToastingMessageTypeUpload = 1 << 4,
};

typedef NS_ENUM(NSUInteger, IFToastingMessageUserEventType) {
  IFToastingMessageTypeIdle   = 1 << 5,
  IFToastingMessageTypeUnidle = 1 << 6,
  IFToastingMessageTypeEnter  = 1 << 7,
  IFToastingMessageTypeLeave  = 1 << 8,
  IFToastingMessageTypeKick   = 1 << 9,
};

typedef NS_ENUM(NSUInteger, IFToastingMessageRoomEventType) {
  IFToastingMessageTypeAllowGuests         = 1 << 10,
  IFToastingMessageTypeDisallowGuests      = 1 << 11,
  IFToastingMessageTypeLock                = 1 << 12,
  IFToastingMessageTypeUnlock              = 1 << 13,
  IFToastingMessageTypeTopicChange         = 1 << 14,
  IFToastingMessageTypeConferenceCreated   = 1 << 15,
  IFToastingMessageTypeConferenceFinished  = 1 << 16,
  IFToastingMessageTypeTimestamp           = 1 << 17,
};

typedef NS_ENUM(NSUInteger, IFToastingMessageOtherType) {
  IFToastingMessageTypeAdvertisement  = 1 << 18,
  IFToastingMessageTypeSystem         = 1 << 19,
};

@property NSDate     *createdAt;
@property NSString   *messageID;

@property NSString   *body;
@property NSString   *roomID;
@property NSString   *starred;
@property NSString   *userID;
@property NSString   *stringType;

@property IFToastingMessageTypeGroup     typeGroup;
@property IFToastingMessageUserPostType  userPostType;
@property IFToastingMessageUserEventType userEventType;
@property IFToastingMessageRoomEventType roomEventType;
@property IFToastingMessageOtherType     otherEventType;

/**
 The type of the message
 */
@property NSUInteger type;

@property IFToastingTweetDescription *tweet;

- (id)initWithAttributes:(NSDictionary *)attributes;

+ (NSString*)userPostTypeToString:(IFToastingMessageUserPostType)type;

@end
