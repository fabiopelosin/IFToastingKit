//
//  IFToastingUpload.m
//  IFToastingKit
//
//  Created by Fabio Pelosin on 05/04/13.
//  Copyright (c) 2013 Fabio Angelog Pelosin. All rights reserved.
//

#import "IFToastingUpload.h"
#import "IFModelCategories.h"

/**
 <upload>
 <byte-size type="integer">135</byte-size>
 <content-type>application/octet-stream</content-type>
 <created-at type="datetime">2009-11-20T23:26:51Z</created-at>
 <id type="integer">1</id>
 <name>char.rb</name>
 <room-id type="integer">1</room-id>
 <user-id type="integer">1</user-id>
 <full-url>https://account.campfirenow.com/room/1/uploads/4/char.rb</full-url>
 </upload>
 */

@implementation IFToastingUpload

- (id)initWithAttributes:(NSDictionary *)attributes {
  self = [super init];
  if (!self) {
    return nil;
  }

  _byteSize = [attributes[@"byte_size"] integerValue];
  _uploadID = [attributes safeStringForKey:@"id"];
  _roomID = [attributes safeStringForKey:@"room_id"];
  _userID = [attributes safeStringForKey:@"user_id"];

  _contenType = attributes[@"content_type"];
  _name = attributes[@"name"];

  _fullURL = [NSURL URLWithString:attributes[@"full_url"]];

  _createdAt = [NSDate dateWithString:attributes[@"created_at"]];

  return self;
}

-(NSString*)description {
  return [NSString stringWithFormat:@"<%@ name:\"%@\" uploadID:\"%@\"", [self class], self.name, self.uploadID];
}


@end
