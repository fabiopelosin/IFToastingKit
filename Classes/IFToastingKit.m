//
//  CFApiClient.m
//  CampfireTest
//
//  Created by Fabio Pelosin on 19/01/13.
//  Copyright (c) 2013 Discontinuity. All rights reserved.
//

#import "IFToastingKit.h"
#import "IFToastingAPIClient.h"
#import "AFJSONRequestOperation.h"

static NSString * const kDSCampfireAPIBaseURLString = @"https://%@.campfirenow.com/";


@interface IFToastingKit ()
@property IFToastingAPIClient* apiClient;
@end

@implementation IFToastingKit {
}

- (id)initWithSubDomain:(NSString *)subdomain {

  self = [super init];
  if (!self) {
    return nil;
  }

  NSString *URLWithDomain = [NSString stringWithFormat:kDSCampfireAPIBaseURLString, subdomain];
  NSURL* baseURL = [NSURL URLWithString:URLWithDomain];
  self.apiClient = [[IFToastingAPIClient alloc] initWithBaseURL:baseURL];

  return self;
}

///-----------------------------------------------------------------------------
#pragma mark - Authorization
///-----------------------------------------------------------------------------

/**
 Sets the authorization token of the current user.
 */

- (void)setAuthorizationToken:(NSString *)authorizationToken;
{
  _authorizationToken = authorizationToken;
  [self.apiClient clearAuthorizationHeader];
  [self.apiClient setAuthorizationHeaderWithUsername:authorizationToken password:@"X"];
}

/**
 Retives and stores the authentication token for the given user.
 */

- (void)authenticateUserWithName:(NSString*)username password:(NSString*)password
                         success:(void (^)(IFToastingUser *user))success
                         failure:(void (^)(NSError *error))failure;
{
  [self.apiClient setAuthorizationHeaderWithUsername:username password:password];
  [self.apiClient getPath:@"users/me.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id JSON) {
    IFToastingUser *user = [[IFToastingUser alloc] initWithAttributes:JSON[@"user"]];
    NSString *authorizationToken = JSON[@"user"][@"api_auth_token"];
    [self setAuthorizationToken:authorizationToken];
    success(user);
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    failure(error);
  }];
}

/*
 Requires registration with: https://integrate.37signals.com.
 */
//- (void)authenticateWithOAuthWithsuccess:(void (^)(AFHTTPRequestOperation *operation, IFToastingUser *user))success
//                         failure:(void (^)(NSError *error))failure;
//{
//  NSURL *url = [NSURL URLWithString:@"https://launchpad.37signals.com/"];
//  NSString *kClientID = nil;
//  NSString *kClientSecret = nil;
//
//  AFOAuth2Client *oauthClient = [AFOAuth2Client clientWithBaseURL:url clientID:kClientID secret:kClientSecret];
//
//  NSString *authURL = @"authorization/new";
//  NSString *updateURL = @"authorization/token";
//  NSString *code = nil;
//  NSString *redirectURI = nil;
//  [oauthClient authenticateUsingOAuthWithPath:authURL code:code redirectURI:redirectURI success:^(AFOAuthCredential *credential) {
//    NSLog(@"I have a token! %@", credential.accessToken);
//    [AFOAuthCredential storeCredential:credential withIdentifier:oauthClient.serviceProviderIdentifier];
//
//  } failure:failure];
//}


/*
 {
 "expires_at": "2012-03-22T16:56:48-05:00",
 "identity": {
 "id": 9999999,
 "name": "Jason Fried",
 "email_address": "jason@37signals.com",
 },
 "accounts": [
 {
 "product": "bcx",
 "id": 88888888,
 "name": "Wayne Enterprises, Ltd.",
 "href": "https://basecamp.com/88888888/api/v1",
 },
 {
 "product": "bcx",
 "id": 77777777,
 "name": "Veidt, Inc",
 "href": "https://basecamp.com/77777777/api/v1",
 },
 {
 "product": "campfire",
 "id": 44444444,
 "name": "Acme Shipping Co.",
 "href": "https://acme4444444.campfirenow.com"
 }
 ]
 }
 */


///-----------------------------------------------------------------------------
#pragma mark - Account
///-----------------------------------------------------------------------------

/** 
 Returns info about the current account.
 */

- (void)getAccountWithsuccess:(void (^)(IFToastingAccount *account))success
           failure:(void (^)(NSError *error))failure
{
  NSString *path = [NSString stringWithFormat:@"account.json"];
  [self.apiClient getPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *accountAttributes) {
    IFToastingAccount *account = [[IFToastingAccount alloc] initWithAttributes:accountAttributes];
    success(account);
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    failure(error);
  }];
}

///-----------------------------------------------------------------------------
#pragma mark - Rooms
///-----------------------------------------------------------------------------

/**
 Returns a collection of the rooms that are visible to the authenticated user. 
 */

- (void)getRoomsWithSuccess:(void (^)(NSArray *rooms))success
                    failure:(void (^)(NSError *error))failure
{
  NSString *path = @"rooms.json";
  [self.apiClient getPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *JSON) {
    NSArray *rooms = [self convertJsonToRooms:JSON];
    success(rooms);
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    failure(error);
  }];
}

/**
 Returns a collection of the rooms that the authenticated user is present in. 
 */

- (void)getPresenceWithSuccess:(void (^)(NSArray *rooms))success
                       failure:(void (^)(NSError *error))failure
{
  NSString *path = @"presence.json";
  [self.apiClient getPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *JSON) {
    NSArray *rooms = [self convertJsonToRooms:JSON];
    success(rooms);
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    failure(error);
  }];
}

/** 
 Returns an existing room. 
 */

- (void)getRoomWithID:(NSString*)roomID
              success:(void (^)(IFToastingRoom *room))success
              failure:(void (^)(NSError *error))failure
{
  NSString *path = [NSString stringWithFormat:@"room/%@.json", roomID];
  [self.apiClient getPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id JSON) {
    IFToastingRoom *room = [[IFToastingRoom alloc] initWithAttributes:JSON[@"room"]];
    success(room);
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    if (failure) {
      failure(error);
    }
  }];
}

/**
 Updates an existing room. 
 */

- (void)updateRoom:(NSString*)roomID name:(NSString*)name topic:(NSString*)topic
            success:(void (^)())success
            failure:(void (^)(NSError *error))failure
{
  NSMutableDictionary *params = [NSMutableDictionary new];
  params[@"room"] = [NSMutableDictionary new];

  if (name) {
    params[@"room"][@"name"] = name;
  }

  if (topic) {
    params[@"room"][@"topic"] = topic;
  }

  NSString *path = [NSString stringWithFormat:@"room/%@.json", roomID];
  [self.apiClient putPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
    success(operation);
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    failure(error);
  }];
}

/** 
 Joins the room for the current user.
 */

- (void)joinRoom:(NSString*)roomID
         success:(void (^)())success
         failure:(void (^)(NSError *error))failure
{
  NSString *path = [NSString stringWithFormat:@"room/%@/join.json", roomID];
  [self.apiClient postPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    success(operation);
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    failure(error);
  }];
}

/** 
 Leaves the room for the current user.
 */

- (void)leaveRoom:(NSString*)roomID
         success:(void (^)())success
         failure:(void (^)(NSError *error))failure
{
  NSString *path = [NSString stringWithFormat:@"room/%@/leave.json", roomID];
  [self.apiClient postPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    success(operation);
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    failure(error);
  }];
}

/** 
 Locks a room, preventing others from joining and stops transcripts from being logged.
 */

- (void)lockRoom:(NSString*)roomID
          success:(void (^)())success
          failure:(void (^)(NSError *error))failure
{
  NSString *path = [NSString stringWithFormat:@"room/%@/lock.json", roomID];
  [self.apiClient postPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    success(operation);
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    failure(error);
  }];
}

/** 
 Unlocks a room, allowing others to join and re-enables transcripts.
 */

- (void)unlockRoom:(NSString*)roomID
         success:(void (^)())success
         failure:(void (^)(NSError *error))failure
{
  NSString *path = [NSString stringWithFormat:@"room/%@/unlock.json", roomID];
  [self.apiClient postPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    success(operation);
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    failure(error);
  }];
}

///-----------------------------------------------------------------------------
#pragma mark - Search
///-----------------------------------------------------------------------------

/** 
 Returns all the messages across all rooms on this account containing the supplied term.
 */

- (void)getMessagesIncludingSearchTerm:(NSString*)searchTerm
                               success:(void (^)(NSArray *messages))success
                               failure:(void (^)(NSError *error))failure
{
  // GET /search?q=#{term}&format=xml same as above, but avoids issues with periods (".") in the term.
  NSString *path = [NSString stringWithFormat:@"search/%@.json", searchTerm];
  [self.apiClient getPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *JSON) {
    NSArray *messages = [self convertJsonToMessages:JSON];
    success(messages);
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    failure(error);
  }];
}

///-----------------------------------------------------------------------------
#pragma mark - Messages
///-----------------------------------------------------------------------------

/** 
 Sends a new message with the currently authenticated user as the sender.
 */

- (void)createMessageWithBody:(NSString*)body type:(IFToastingMessageUserPostType)type room:(NSString*)roomID
  success:(void (^)(IFToastingMessage *message))success
  failure:(void (^)(NSError *error))failure
{
  assert(type != IFToastingMessageTypeUpload);

  NSDictionary *params = @{
    @"message": @{
        @"type": [IFToastingMessage userPostTypeToString:type],
        @"body": body,
      }
    };

  NSString *path = [NSString stringWithFormat:@"room/%@/speak.json", roomID];
  [self.apiClient postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id JSON) {
    IFToastingMessage *message = [[IFToastingMessage alloc] initWithAttributes:JSON[@"message"]];
    success(message);

  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    failure(error);
  }];
}

/** 
 Returns a collection of upto 100 recent messages in the room.
*/

- (void)getRecentMessagesForRoom:(NSString*)roomID
  success:(void (^)(NSArray *messages))success
  failure:(void (^)(NSError *error))failure
{
  NSString *path = [NSString stringWithFormat:@"room/%@/recent.json", roomID];
  [self.apiClient getPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *JSON) {
    NSArray *messages = [self convertJsonToMessages:JSON];
    success(messages);
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    failure(error);
  }];
}

/** 
 Highlights a message in the room's transcript.
*/

- (void)highlightMessage:(NSString*)messageID
         success:(void (^)())success
         failure:(void (^)(NSError *error))failure
{
  NSString *path = [NSString stringWithFormat:@"messages/%@/star.json", messageID];
  [self.apiClient postPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    success(operation);
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    failure(error);
  }];
}

/** 
 Removes a message highlight from the room's transcript.
*/

- (void)unhighlightMessage:(NSString*)messageID
                 success:(void (^)())success
                 failure:(void (^)(NSError *error))failure
{
  NSString *path = [NSString stringWithFormat:@"messages/%@/star.json", messageID];
  [self.apiClient deletePath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    success(operation);
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    failure(error);
  }];
}

///-----------------------------------------------------------------------------
#pragma mark - Transcripts
///-----------------------------------------------------------------------------

/** 
 Returns all the messages sent today to a room.
*/

- (void)getTodayMessagesForRoom:(NSString*)roomID
  success:(void (^)(NSArray *messages))success
  failure:(void (^)(NSError *error))failure
{
  NSString *path = [NSString stringWithFormat:@"room/%@/transcript.json", roomID];
  [self.apiClient getPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *JSON) {
    NSArray *messages = [self convertJsonToMessages:JSON];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"notification" object:self userInfo:@{ @"key" : @"doc" }];
    success(messages);
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    failure(error);
  }];
}

/** 
 Returns all the messages sent on a specific date to a room.
*/

- (void)getMessagesForRoom:(NSString*)roomID
                      year:(NSString*)year
                     month:(NSString*)month
                       day:(NSString*)day
                   success:(void (^)(NSArray *messages))success
                   failure:(void (^)(NSError *error))failure
{
  NSString *date_url = [NSString stringWithFormat:@"%@/%@/%@", year, month, day];
  NSString *path = [NSString stringWithFormat:@"room/%@/transcript/%@.json", roomID, date_url];
  [self.apiClient getPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *JSON) {
    NSArray *messages = [self convertJsonToMessages:JSON];
    success(messages);
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    failure(error);
  }];
}


///-----------------------------------------------------------------------------
#pragma mark - Users
///-----------------------------------------------------------------------------

/** 
 Returns an existing user.
*/

- (void)getUserWithID:(NSString*)userID
              success:(void (^)(IFToastingUser *user))success
              failure:(void (^)(NSError *error))failure
{
  NSString *path = [NSString stringWithFormat:@"users/%@.json", userID];
  [self.apiClient getPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id JSON) {
    IFToastingUser *user = [[IFToastingUser alloc] initWithAttributes:JSON[@"user"]];
    success(user);
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    failure(error);
  }];
}

/** 
 Returns the user making the API request.
*/

- (void)getSelfWithSuccess:(void (^)(IFToastingUser *user))success
  failure:(void (^)(NSError *error))failure
{
  [self.apiClient getPath:@"users/me.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id JSON) {
    IFToastingUser *user = [[IFToastingUser alloc] initWithAttributes:JSON[@"user"]];
    success(user);
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    failure(error);
  }];
}

///-----------------------------------------------------------------------------
#pragma mark - Uploads
///-----------------------------------------------------------------------------

/** 
 Uploads a file to the room.
*/

- (void)createUploadForRoomWithID:(NSString*)roomID
                          fileURL:(NSURL*)fileURL
                          success:(void (^)(IFToastingUpload *upload))success
                          failure:(void (^)(NSError *error))failure
{
  NSString *path = [NSString stringWithFormat:@"room/%@/uploads.json", roomID];

  NSURLRequest *request = [self.apiClient multipartFormRequestWithMethod:@"POST" path:path parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    NSError *error;
    BOOL result = [formData appendPartWithFileURL:fileURL name:@"upload" error:&error];
    if (!result) {
      failure(error);
    }
  }];

  [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *json_request, NSHTTPURLResponse *response, id JSON) {
    IFToastingUpload *upload = [[IFToastingUpload alloc] initWithAttributes:JSON[@"upload"]];
    success(upload);
  } failure:^(NSURLRequest *j_request, NSHTTPURLResponse *response, NSError *error, id JSON) {
    failure(error);
  }];
}

/** 
 Returns a collection of upto 5 recently uploaded files in the room.
 */

- (void)getUploadsForRoomWithID:(NSString*)roomID
  success:(void (^)(NSArray *uploads))success
  failure:(void (^)(NSError *error))failure
{
  NSString *path = [NSString stringWithFormat:@"room/%@/uploads.json", roomID];
  [self.apiClient getPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *JSON) {
    NSArray *messages = [self convertJsonToUploads:JSON];
    success(messages);
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    failure(error);
  }];
}

/** 
 Returns the upload object related to the supplied upload message id.
 */

- (void)getUploadForRoomWithID:(NSString*)roomID
               uploadMessageID:(NSString*)uploadMessageID
  success:(void (^)(IFToastingUpload *upload))success
  failure:(void (^)(NSError *error))failure
{
  NSString *path = [NSString stringWithFormat:@"room/%@/messages/%@/upload.json", roomID, uploadMessageID];
  [self.apiClient getPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id JSON) {
    IFToastingUpload *upload = [[IFToastingUpload alloc] initWithAttributes:JSON[@"upload"]];
    success(upload);
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    failure(error);
  }];
}

///-----------------------------------------------------------------------------
#pragma mark - Streaming
///-----------------------------------------------------------------------------

/** 
 The Streaming API allows you to monitor a room in real time.
 The authenticated user must already have joined the room in order to
 use this API.

 Our servers will try to hold the streaming connections open indefinitely. 
 However, API clients must be able to handle occasional timeouts or disruptions. 
 Upon unexpected disconnection, API clients should wait for a few seconds 
 before trying to reconnect.
*/
- (IFToastingRoomStreamClient*)stremingClientForRoom:(NSString*)roomID;
{
  IFToastingRoomStreamClient *streamClient = [[IFToastingRoomStreamClient alloc] initWithRoom:roomID];
  [streamClient setAuthorizationToken:self.authorizationToken];
  return streamClient;
}

///-----------------------------------------------------------------------------
#pragma mark - Private helpers
///-----------------------------------------------------------------------------

- (NSArray*)convertJsonToMessages:(NSDictionary*)json {
  NSMutableArray *messages = [NSMutableArray array];
  NSArray *dictionaries = json[@"messages"];
  for (NSDictionary *attributes in dictionaries) {
    IFToastingMessage *message = [[IFToastingMessage alloc] initWithAttributes:attributes];
    [messages addObject:message];
  }
  return messages;
}

- (NSArray*)convertJsonToRooms:(NSDictionary*)json {
  NSMutableArray *rooms = [NSMutableArray array];
  NSArray *dictionaries = json[@"rooms"];
  for (NSDictionary *attributes in dictionaries) {
    IFToastingRoom *room = [[IFToastingRoom alloc] initWithAttributes:attributes];
    [rooms addObject:room];
  }
  return rooms;
}

- (NSArray*)convertJsonToUploads:(NSDictionary*)json {
  NSMutableArray *rooms = [NSMutableArray array];
  NSArray *dictionaries = json[@"uploads"];
  for (NSDictionary *attributes in dictionaries) {
    IFToastingUpload *upload = [[IFToastingUpload alloc] initWithAttributes:attributes];
    [rooms addObject:upload];
  }
  return rooms;
}

@end
