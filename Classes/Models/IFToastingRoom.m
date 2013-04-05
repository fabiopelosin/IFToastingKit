//
//  IFToastingRoom.m
//  IFToastingKit
//
//  Created by Fabio Pelosin on 05/04/13.
//  Copyright (c) 2013 Fabio Angelog Pelosin. All rights reserved.
//

#import "IFToastingRoom.h"
#import "IFToastingUser.h"
#import "IFModelCategories.h"

/**

 <room>
 <id type="integer">1</id>
 <name>North May St.</name>
 <topic>37signals HQ</topic>
 <membership-limit type="integer">60</membership-limit>
 <full type="boolean">false</full>
 <open-to-guests type="boolean">true</open-to-guests>
 <active-token-value>#{ 4c8fb -- requires open-to-guests is true}</active-token-value>
 <updated-at type="datetime">2009-11-17T19:41:38Z</updated-at>
 <created-at type="datetime">2009-11-17T19:41:38Z</created-at>
 </room>

 */

@implementation IFToastingRoom

- (id)initWithAttributes:(NSDictionary *)attributes {
  self = [super init];
  if (!self) {
    return nil;
  }

  _roomID           = [attributes safeStringForKey:@"id"];
  _createdAt        = [NSDate dateWithString:attributes[@"created_at"]];
  _updatedAt        = [NSDate dateWithString:attributes[@"updated_at"]];

  _name             = [attributes safeStringForKey:@"name"];
  _topic            = [attributes safeStringForKey:@"topic"];

  _membershipLimit  = [attributes safeUnsignedIntegerForKey:@"membership_limit"];
  _full             = [attributes safeBooleanForKey:@"full"];
  _openToGuests     = [attributes safeBooleanForKey:@"open_to_guests"];

  if (_openToGuests) {
    _activeTokenValue = [attributes safeStringForKey:@"active-token-value"];
  }

  NSArray *usersAttributes = attributes[@"users"];
  NSMutableArray *users = [NSMutableArray new];
  [usersAttributes enumerateObjectsUsingBlock:^(NSDictionary *userAttributes, NSUInteger idx, BOOL *stop) {
    IFToastingUser *user = [[IFToastingUser alloc] initWithAttributes:userAttributes];
    [users addObject:user];
  }];
  _users = users;

  return self;
}

-(NSString*)description
{
  return [NSString stringWithFormat:@"<%@ name:\"%@\" roomID:\"%@\"", [self class], self.name, self.roomID];
}

@end
