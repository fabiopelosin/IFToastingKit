//
//  IFToastingAccount.m
//  IFToastingKit
//
//  Created by Fabio Pelosin on 05/04/13.
//  Copyright (c) 2013 Fabio Angelog Pelosin. All rights reserved.
//

#import "IFToastingAccount.h"
#import "IFModelCategories.h"


/**

 <account>
 <id type="integer">1</id>
 <name>Your Company</name>
 <subdomain>yourco</subdomain>
 <plan>premium</plan>
 <owner-id type="integer">#{user_id of account owner}</owner-id>
 <time-zone>America/Chicago</time-zone>
 <storage type="integer">17374444</storage>
 <created-at type="datetime">2011-01-12T15:00:00Z</created-at>
 <updated-at type="datetime">2011-01-12T15:00:00Z</updated-at>
 </account>

 */

@implementation IFToastingAccount

- (id)initWithAttributes:(NSDictionary *)attributes {
  self = [super init];
  if (!self) {
    return nil;
  }

  _storage = [attributes[@"storage"] integerValue];

  _accountID = [attributes safeStringForKey:@"id"];
  _ownerID = [attributes safeStringForKey:@"owner_id"];
  _name = attributes[@"_name"];
  _subdomain = attributes[@"subdomain"];
  _plan = attributes[@"plan"];
  _plan = attributes[@"time_zone"];

  _createdAt = [NSDate dateWithString:attributes[@"created_at"]];
  _updatedAt = [NSDate dateWithString:attributes[@"updated_at"]];

  return self;
}

-(NSString*)description {
  return [NSString stringWithFormat:@"<%@ subdomain:\"%@\" accountID:\"%@\"", [self class], self.subdomain, self.accountID];
}

- (NSUInteger)hash {
  return self.name.hash;
}

- (BOOL)isEqual:(id)otherObject {
  if ([otherObject isKindOfClass:[self class]]) {
    IFToastingAccount *other = otherObject;
    return [self.name isEqualToString:other.name];
  } else {
    return NO;
  }
}

@end
