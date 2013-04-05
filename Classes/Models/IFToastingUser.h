//
//  IFToastingUser.h
//  IFToastingKit
//
//  Created by Fabio Pelosin on 05/04/13.
//  Copyright (c) 2013 Fabio Angelog Pelosin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IFToastingUser : NSObject

@property BOOL        admin;
@property NSURL      *avatarURL;
@property NSDate     *createdAt;
@property NSString   *emailAddress;
@property NSString   *userID;
@property NSString   *name;
@property NSString   *type;
@property NSImage    *avatar;

- (id)initWithAttributes:(NSDictionary *)attributes;

@end

