//
//  IFToastingRoomStreamClient.m
//  CampfireTest
//
//  Created by Fabio Pelosin on 23/01/13.
//  Copyright (c) 2013 Discontinuity. All rights reserved.
//

#import "IFToastingRoomStreamClient.h"
#import "SBJson.h"
#import "AFHTTPClient.h"

NSString *const kIFToastingRoomStreamClientBaseURL = @"https://streaming.campfirenow.com/";

///-----------------------------------------------------------------------------

@interface IFToastingRoomStreamClient () <SBJsonStreamParserAdapterDelegate>

@property NSString *room;
@property SBJsonStreamParserAdapter *adapter;
@property SBJsonStreamParser *parser;
@property NSURLConnection *connection;

@end

///-----------------------------------------------------------------------------

@implementation IFToastingRoomStreamClient

- (id)initWithRoom:(NSString *)room {
  self = [super init];
  if (!self) {
    return nil;
  }

  _room = room;

  return self;
}

///-----------------------------------------------------------------------------
#pragma mark - Public methods
///-----------------------------------------------------------------------------

- (void)openConnectionWithSuccess:(void (^)())success failure:(void (^)(NSError *error))failure {
	self.adapter = [[SBJsonStreamParserAdapter alloc] init];
	self.adapter.delegate = self;
	self.parser = [[SBJsonStreamParser alloc] init];
	self.parser.delegate = self.adapter;
	self.parser.supportMultipleDocuments = YES;
	self.connection = [[NSURLConnection alloc] initWithRequest:[self request] delegate:self];
}

- (void)openConnection {
  [self openConnectionWithSuccess:nil failure:nil];
}

- (void)closeConnection {
  [self.connection cancel];
}

///-----------------------------------------------------------------------------
#pragma mark - Private helpers
///-----------------------------------------------------------------------------

- (NSURLRequest*)request {
  NSURL *url = [NSURL URLWithString:kIFToastingRoomStreamClientBaseURL];
  NSString *path = [NSString stringWithFormat:@"room/%@/live.json", self.room];

  AFHTTPClient *apiClient = [[AFHTTPClient alloc] initWithBaseURL:url];
  [apiClient clearAuthorizationHeader];
  [apiClient setAuthorizationHeaderWithUsername:self.authorizationToken password:@"X"];

  NSURLRequest *request = [apiClient requestWithMethod:@"GET" path:path parameters:nil];
  return request;
}

///-----------------------------------------------------------------------------
#pragma mark SBJsonStreamParserAdapterDelegate methods
///-----------------------------------------------------------------------------

- (void)parser:(SBJsonStreamParser *)parser foundArray:(NSArray *)array {
  [NSException raise:NSInternalInconsistencyException format:@"Unexpected Array"];
}

- (void)parser:(SBJsonStreamParser *)parser foundObject:(NSDictionary *)dict {
  IFToastingMessage *message = [[IFToastingMessage alloc] initWithAttributes:dict];
  [self.delegate client:self didReceiveMessage:message];
}

///-----------------------------------------------------------------------------
#pragma mark NSURLConnectionDelegate
///-----------------------------------------------------------------------------

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	SBJsonStreamParserStatus status = [self.parser parse:data];

	if (status == SBJsonStreamParserError) {
    NSDictionary *userInfo = @{ NSLocalizedDescriptionKey: self.parser.error };
    NSError *error = [NSError errorWithDomain:@"ERRORDOMAIN" code:0001 userInfo:userInfo];
    [self.delegate client:self didFailWithError:error];
	}
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
  [self openConnection];
  [self.delegate client:self didFailWithError:error];
}

@end
