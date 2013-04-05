//
//  IFToastingRoom.h
//  IFToastingKit
//
//  Created by Fabio Pelosin on 05/04/13.
//  Copyright (c) 2013 Fabio Angelog Pelosin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IFToastingRoom : NSObject

@property NSString   *roomID;
@property NSString   *name;
@property NSString   *topic;
@property NSUInteger  membershipLimit;
@property Boolean     full;
@property Boolean     openToGuests;
@property NSString   *activeTokenValue;
@property NSDate     *createdAt;
@property NSDate     *updatedAt;

@property NSArray    *users;


- (id)initWithAttributes:(NSDictionary *)attributes;

@end
