//
//  IFModelCategories.m
//  CampfireTest
//
//  Created by Fabio Pelosin on 31/01/13.
//  Copyright (c) 2013 Discontinuity. All rights reserved.
//

#import "IFModelCategories.h"

@implementation NSDictionary (Utility)

- (NSString*)safeStringForKey:(NSString*)key {
  id object = [self objectForKey:key];

  if (!object) {
    [NSException raise:@"Unable to find the key"
                format:@"key: %@, dictionary:%@", key, self];
  }
  
  if ([object isKindOfClass:[NSString class]]) {
    return object;
  }
  else if (object == [NSNull null]) {
    return nil;
  }
  else if ([object isKindOfClass:[NSNumber class]]) {
    return [object stringValue];
  }

  [NSException raise:@"Invalid object type"
              format:@"key: %@, object: %@, dictionary:%@", key, object, self];
  return nil;
}

- (BOOL)safeBooleanForKey:(NSString*)key {
  id object = [self objectForKey:key];

  if (object == [NSNull null]) {
    return FALSE;
  }
  else if ([object isKindOfClass:[NSNumber class]]) {
    return [object boolValue];
  }

  [NSException raise:@"Invalid object type"
              format:@"key: %@, object: %@, dictionary:%@", key, object, self];
  return FALSE;
}

- (NSUInteger)safeUnsignedIntegerForKey:(NSString*)key {
  id object = [self objectForKey:key];

  if (object == [NSNull null]) {
    return 0;
  }
  else if ([object isKindOfClass:[NSNumber class]]) {
    return [object unsignedIntegerValue];
  }

  [NSException raise:@"Invalid object type"
              format:@"key: %@, object: %@, dictionary:%@", key, object, self];
  return 0;
}


@end
