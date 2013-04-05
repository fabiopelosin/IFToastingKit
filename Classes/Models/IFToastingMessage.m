//
//  IFToastingMessage.m
//  CampfireTest
//
//  Created by Fabio Pelosin on 31/01/13.
//  Copyright (c) 2013 Discontinuity. All rights reserved.
//

#import "IFToastingMessage.h"
#import "IFModelCategories.h"

@implementation IFToastingMessage

- (id)initWithAttributes:(NSDictionary *)attributes {
  self = [super init];
  if (!self) {
    return nil;
  }

  _messageID  = [attributes safeStringForKey:@"id"];
  _createdAt  = [NSDate dateWithString:attributes[@"created_at"]];

  _body       = [attributes safeStringForKey:@"body"];
  _starred    = attributes[@"starred"];
  _userID     = [attributes safeStringForKey:@"user_id"];
  _roomID     = [attributes safeStringForKey:@"room_id"];

  _stringType = [attributes safeStringForKey:@"type"];
  _type       = _typeFromString(_stringType);
  _typeGroup  = _groupFromType(_type);

  switch (_typeGroup) {
    case IFToastingMessageTypeGroupUserPost:
      _userPostType = _type;
      break;
      
    case IFToastingMessageTypeGroupUserEvent:
      _userEventType = _type;
      break;

    case IFToastingMessageTypeGroupRoomEvent:
      _roomEventType = _type;
      break;

    case IFToastingMessageTypeGroupOther:
      _otherEventType = _type;
      break;

    case IFToastingMessageTypeGroupUnknown:
      break;
  }

  if (_type == IFToastingMessageTypeTweet) {
    _tweet = _tweetDescriptionFromAttributes(attributes[@"tweet"]);
  }

  return self;
}

//------------------------------------------------------------------------------
#pragma mark - Private Helpers
//------------------------------------------------------------------------------

IFToastingTweetDescription* _tweetDescriptionFromAttributes(NSDictionary *tweetAttributes) {
  IFToastingTweetDescription *tweet = [IFToastingTweetDescription new];
  tweet.authorAvatarUrl = tweetAttributes[@"author_avatar_url"];
  tweet.authorUsername = tweetAttributes[@"author_username"];
  tweet.tweetID = [tweetAttributes safeStringForKey:@"id"];
  tweet.message = tweetAttributes[@"message"];
  return tweet;
}

IFToastingMessageTypeGroup _groupFromType(NSUInteger type) {
  IFToastingMessageTypeGroup group;
  switch (type) {
    case IFToastingMessageTypeUnknown:
      group = IFToastingMessageTypeGroupUnknown;
      break;

    case IFToastingMessageTypeText:
    case IFToastingMessageTypePaste:
    case IFToastingMessageTypeSound:
    case IFToastingMessageTypeTweet:
    case IFToastingMessageTypeUpload:
      group = IFToastingMessageTypeGroupUserPost;
      break;

    case IFToastingMessageTypeIdle:
    case IFToastingMessageTypeUnidle:
    case IFToastingMessageTypeEnter:
    case IFToastingMessageTypeLeave:
    case IFToastingMessageTypeKick:
      group = IFToastingMessageTypeGroupUserEvent;
      break;

    case IFToastingMessageTypeAllowGuests:
    case IFToastingMessageTypeDisallowGuests:
    case IFToastingMessageTypeLock:
    case IFToastingMessageTypeUnlock:
    case IFToastingMessageTypeTopicChange:
    case IFToastingMessageTypeConferenceCreated:
    case IFToastingMessageTypeConferenceFinished:
    case IFToastingMessageTypeTimestamp:
      group = IFToastingMessageTypeGroupRoomEvent;
      break;

    case IFToastingMessageTypeAdvertisement:
    case IFToastingMessageTypeSystem:
      group = IFToastingMessageTypeGroupOther;
      break;

    default:
      [NSException raise:@"Invalid Message Type" format:@""];
  };
  return group;
}

#define kIFToastingMessageTextTypeString   @"TextMessage"
#define kIFToastingMessagePasteTypeString  @"PasteMessage"
#define kIFToastingMessageSoundTypeString  @"SoundMessage"
#define kIFToastingMessageTweetTypeString  @"TweetMessage"
#define kIFToastingMessageUploadTypeString @"UploadMessage"

NSUInteger _typeFromString(NSString* type)
{
  NSUInteger result = IFToastingMessageTypeUnknown;

  if ([type isEqualToString:kIFToastingMessageTextTypeString]) {
    result = IFToastingMessageTypeText;
  }
  else if ([type isEqualToString:@"PasteMessage"]) {
    result = IFToastingMessageTypePaste;
  }
  else if ([type isEqualToString:@"SoundMessage"]) {
    result = IFToastingMessageTypeSound;
  }
  else if ([type isEqualToString:@"TweetMessage"]) {
    result = IFToastingMessageTypeTweet;
  }
  else if ([type isEqualToString:@"UploadMessage"]) {
    result = IFToastingMessageTypeUpload;
  }
  else if ([type isEqualToString:@"AdvertisementMessage"]) {
    result = IFToastingMessageTypeAdvertisement;
  }
  else if ([type isEqualToString:@"AllowGuestsMessage"]) {
    result = IFToastingMessageTypeAllowGuests;
  }
  else if ([type isEqualToString:@"DisallowGuestsMessage"]) {
    result = IFToastingMessageTypeDisallowGuests;
  }
  else if ([type isEqualToString:@"IdleMessage"]) {
    result = IFToastingMessageTypeIdle;
  }
  else if ([type isEqualToString:@"KickMessage"]) {
    result = IFToastingMessageTypeKick;
  }
  else if ([type isEqualToString:@"LeaveMessage"]) {
    result = IFToastingMessageTypeLeave;
  }
  else if ([type isEqualToString:@"EnterMessage"]) {
    result = IFToastingMessageTypeEnter;
  }
  else if ([type isEqualToString:@"SystemMessage"]) {
    result = IFToastingMessageTypeSystem;
  }
  else if ([type isEqualToString:@"TimestampMessage"]) {
    result = IFToastingMessageTypeTimestamp;
  }
  else if ([type isEqualToString:@"TopicChangeMessage"]) {
    result = IFToastingMessageTypeTopicChange;
  }
  else if ([type isEqualToString:@"UnidleMessage"]) {
    result = IFToastingMessageTypeUnidle;
  }
  else if ([type isEqualToString:@"LockMessage"]) {
    result = IFToastingMessageTypeLock;
  }
  else if ([type isEqualToString:@"UnlockMessage"]) {
    result = IFToastingMessageTypeUnlock;
  }
  else if ([type isEqualToString:@"ConferenceCreatedMessage"]) {
    result = IFToastingMessageTypeConferenceCreated;
  }
  else if ([type isEqualToString:@"ConferenceFinishedMessage"]) {
    result = IFToastingMessageTypeConferenceFinished;
  }
  if (result == IFToastingMessageTypeUnknown) {
    [NSException raise:NSInternalInconsistencyException format:@"Unknown message type: %@", type];
  }

  return result;
}

+ (NSString*)userPostTypeToString:(IFToastingMessageUserPostType)type; {
  NSString* result;
  
  switch (type) {
    case IFToastingMessageTypeText:
      result = kIFToastingMessageTextTypeString;
      break;

    case IFToastingMessageTypePaste:
      result = kIFToastingMessagePasteTypeString;
      break;

    case IFToastingMessageTypeTweet:
      result = kIFToastingMessageTweetTypeString;
      break;

    case IFToastingMessageTypeUpload:
      result = kIFToastingMessageUploadTypeString;
      break;

    case IFToastingMessageTypeSound:
      result = kIFToastingMessageSoundTypeString;
      break;
  }

  return result;
}


//------------------------------------------------------------------------------
#pragma mark - NSObject
//------------------------------------------------------------------------------

- (NSString*)description
{
  return [NSString stringWithFormat:@"<%@ type:\"%@\" messageID:\"%@\" body:\"%@\"", [self class], self.stringType, self.messageID, self.body];
}

@end
