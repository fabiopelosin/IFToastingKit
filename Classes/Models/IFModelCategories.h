//
//  IFModelCategories.h
//  CampfireTest
//
//  Created by Fabio Pelosin on 31/01/13.
//  Copyright (c) 2013 Discontinuity. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Utility)

- (NSString*)safeStringForKey:(NSString*)key;
- (BOOL)safeBooleanForKey:(NSString*)key;
- (NSUInteger)safeUnsignedIntegerForKey:(NSString*)key;

@end
