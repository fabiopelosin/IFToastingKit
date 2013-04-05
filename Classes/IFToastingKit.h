//
//  CFApiClient.h
//  CampfireTest
//
//  Created by Fabio Pelosin on 19/01/13.
//  Copyright (c) 2013 Discontinuity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperation.h"

#import "IFToastingMessage.h"
#import "IFToastingTweetDescription.h"
#import "IFToastingUpload.h"
#import "IFToastingAccount.h"
#import "IFToastingRoom.h"
#import "IFToastingUser.h"

#import "IFToastingRoomStreamClient.h"

@interface IFToastingKit : NSObject

- (id)initWithSubDomain:(NSString *)subdomain;

///-----------------------------------------------------------------------------
/// @name Authorization
///-----------------------------------------------------------------------------

/**
 Retives and stores the authentication token for the given user.
 Offered as a convenience. Use OAuth.
 */
- (void)authenticateUserWithName:(NSString*)name password:(NSString*)password
                         success:(void (^)(IFToastingUser *user))success
                         failure:(void (^)(NSError *error))failure;

/**
 The authorization token of the current user.
 */
@property (nonatomic, copy) NSString* authorizationToken;

///-----------------------------------------------------------------------------
/// @name Account
///-----------------------------------------------------------------------------

/**
 Returns info about the current account.
 */
- (void)getAccountWithsuccess:(void (^)(IFToastingAccount *account))success
                      failure:(void (^)(NSError *error))failure;

///-----------------------------------------------------------------------------
/// @name Rooms
///-----------------------------------------------------------------------------

/**
 Returns a collection of the rooms that are visible to the authenticated user.
 */
- (void)getRoomsWithSuccess:(void (^)(NSArray *rooms))success
                    failure:(void (^)(NSError *error))failure;

/**
 Returns a collection of the rooms that the authenticated user is present in.
 */
- (void)getPresenceWithSuccess:(void (^)(NSArray *rooms))success
                       failure:(void (^)(NSError *error))failure;

/**
 Returns an existing room.
 */
- (void)getRoomWithID:(NSString*)roomID
              success:(void (^)(IFToastingRoom *room))success
              failure:(void (^)(NSError *error))failure;

/**
 Updates an existing room.
 */
- (void)updateRoom:(NSString*)roomID name:(NSString*)name topic:(NSString*)topic
           success:(void (^)())success
           failure:(void (^)(NSError *error))failure;

/**
 Joins the room for the current user.
 */
- (void)joinRoom:(NSString*)roomID
         success:(void (^)())success
         failure:(void (^)(NSError *error))failure;

/**
 Leaves the room for the current user.
 */
- (void)leaveRoom:(NSString*)roomID
          success:(void (^)())success
          failure:(void (^)(NSError *error))failure;

/**
 Locks a room, preventing others from joining and stops transcripts from being logged.
 */
- (void)lockRoom:(NSString*)roomID
         success:(void (^)())success
         failure:(void (^)(NSError *error))failure;

/**
 Unlocks a room, allowing others to join and re-enables transcripts.
 */
- (void)unlockRoom:(NSString*)roomID
           success:(void (^)())success
           failure:(void (^)(NSError *error))failure;

///-----------------------------------------------------------------------------
/// @name Search
///-----------------------------------------------------------------------------

/**
 Returns all the messages across all rooms on this account containing the supplied term.
 */
- (void)getMessagesIncludingSearchTerm:(NSString*)searchTerm
                               success:(void (^)(NSArray *messages))success
                               failure:(void (^)(NSError *error))failure;

///-----------------------------------------------------------------------------
/// @name Messages
///-----------------------------------------------------------------------------

/**
 Sends a new message with the currently authenticated user as the sender.
 */
- (void)createMessageWithBody:(NSString*)body type:(IFToastingMessageUserPostType)type room:(NSString*)roomID
                      success:(void (^)(IFToastingMessage *message))success
                      failure:(void (^)(NSError *error))failure;

/**
 Returns a collection of upto 100 recent messages in the room.
 */
- (void)getRecentMessagesForRoom:(NSString*)roomID
                         success:(void (^)(NSArray *messages))success
                         failure:(void (^)(NSError *error))failure;

/**
 Highlights a message in the room's transcript.
 */
- (void)highlightMessage:(NSString*)messageID
                 success:(void (^)())success
                 failure:(void (^)(NSError *error))failure;

/**
 Removes a message highlight from the room's transcript.
 */
- (void)unhighlightMessage:(NSString*)messageID
                   success:(void (^)())success
                   failure:(void (^)(NSError *error))failure;

///-----------------------------------------------------------------------------
/// @name Transcripts
///-----------------------------------------------------------------------------

/**
 Returns all the messages sent today to a room.
 */
- (void)getTodayMessagesForRoom:(NSString*)roomID
                        success:(void (^)(NSArray *messages))success
                        failure:(void (^)(NSError *error))failure;

/**
 Returns all the messages sent on a specific date to a room.
 */
- (void)getMessagesForRoom:(NSString*)roomID
                      year:(NSString*)year
                     month:(NSString*)month
                       day:(NSString*)day
                   success:(void (^)(NSArray *messages))success
                   failure:(void (^)(NSError *error))failure;

///-----------------------------------------------------------------------------
/// @name Users
///-----------------------------------------------------------------------------

/**
 Returns an existing user.
 */
- (void)getUserWithID:(NSString*)userID
              success:(void (^)(IFToastingUser *user))success
              failure:(void (^)(NSError *error))failure;

/**
 Returns the user making the API request.
 */
- (void)getSelfWithSuccess:(void (^)(IFToastingUser *user))success
                   failure:(void (^)(NSError *error))failure;

///-----------------------------------------------------------------------------
/// @name Uploads
///-----------------------------------------------------------------------------

/**
 Uploads a file to the room.
 */
- (void)createUploadForRoomWithID:(NSString*)roomID
                          fileURL:(NSURL*)fileURL
                          success:(void (^)(IFToastingUpload *upload))success
                          failure:(void (^)(NSError *error))failure;

/**
 Returns a collection of upto 5 recently uploaded files in the room.
 */
- (void)getUploadsForRoomWithID:(NSString*)roomID
                        success:(void (^)(NSArray *uploads))success
                        failure:(void (^)(NSError *error))failure;

/**
 Returns the upload object related to the supplied upload message id.
 */
- (void)getUploadForRoomWithID:(NSString*)roomID
               uploadMessageID:(NSString*)uploadMessageID
                       success:(void (^)(IFToastingUpload *upload))success
                       failure:(void (^)(NSError *error))failure;

///-----------------------------------------------------------------------------
/// @name Streaming
///-----------------------------------------------------------------------------

/**
 Returns a streming client for the given room configured with the authorization 
 token.
 */
- (IFToastingRoomStreamClient*)stremingClientForRoom:(NSString*)roomID;

@end





