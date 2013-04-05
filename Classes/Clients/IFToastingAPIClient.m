//
//  DSCampfireAPIClient.m
//  CampfireTest
//
//  Created by Fabio Pelosin on 18/01/13.
//  Copyright (c) 2013 Discontinuity. All rights reserved.
//

#import "IFToastingAPIClient.h"
#import "AFJSONRequestOperation.h"


@implementation IFToastingAPIClient

- (id)initWithBaseURL:(NSURL *)url {
  self = [super initWithBaseURL:url];
  if (!self) {
    return nil;
  }

  [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
	[self setDefaultHeader:@"Accept" value:@"application/json"];
  [self setParameterEncoding:AFJSONParameterEncoding];

  return self;
}

@end
