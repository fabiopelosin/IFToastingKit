//
//  IFToastingUser.m
//  IFToastingKit
//
//  Created by Fabio Pelosin on 05/04/13.
//  Copyright (c) 2013 Fabio Angelog Pelosin. All rights reserved.
//

#import "IFToastingUser.h"
#import "IFModelCategories.h"

/**
 <user>
 <id type="integer">1</id>
 <name>Jason Fried</name>
 <email-address>jason@37signals.com</email-address>
 <admin type="boolean">true</admin>
 <created-at type="datetime">2009-11-20T16:41:39Z</created-at>
 <type>Member</type>
 <avatar-url>https://asset0.37img.com/global/.../avatar.png</avatar-url>
 </user>
 */

@implementation IFToastingUser

- (id)initWithAttributes:(NSDictionary *)attributes {
  self = [super init];
  if (!self) {
    return nil;
  }

  _userID = [attributes safeStringForKey:@"id"];

  _admin = [attributes[@"admin"] boolValue];
  _avatarURL = [NSURL URLWithString:attributes[@"avatar_url"]];
  _emailAddress = attributes[@"email_address"];
  _name = attributes[@"name"];
  _type = attributes[@"type"];

  _createdAt = [NSDate dateWithString:attributes[@"created_at"]];


  return self;
}

-(NSString*)description {
  return [NSString stringWithFormat:@"<%@ name:\"%@\" userID:\"%@\"", [self class], self.name, self.userID];
}

@end
