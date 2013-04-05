//
//  IFToastingUpload.h
//  IFToastingKit
//
//  Created by Fabio Pelosin on 05/04/13.
//  Copyright (c) 2013 Fabio Angelog Pelosin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IFToastingUpload : NSObject

@property NSUInteger  byteSize;
@property NSString   *contenType;
@property NSDate     *createdAt;
@property NSString   *uploadID;
@property NSString   *name;
@property NSString   *roomID;
@property NSString   *userID;
@property NSURL      *fullURL;

- (id)initWithAttributes:(NSDictionary *)attributes;

@end
