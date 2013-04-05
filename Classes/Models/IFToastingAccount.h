//
//  IFToastingAccount.h
//  IFToastingKit
//
//  Created by Fabio Pelosin on 05/04/13.
//  Copyright (c) 2013 Fabio Angelog Pelosin. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface IFToastingAccount : NSObject

@property NSString   *accountID;
@property NSString   *name;
@property NSString   *subdomain;
@property NSString   *plan;
@property NSString   *ownerID;
@property NSString   *timeZone;
@property NSUInteger  storage;
@property NSDate     *createdAt;
@property NSDate     *updatedAt;

- (id)initWithAttributes:(NSDictionary *)attributes;

@end
