//
//  IFToastingRoomStreamClient.h
//  CampfireTest
//
//  Created by Fabio Pelosin on 23/01/13.
//  Copyright (c) 2013 Discontinuity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IFToastingMessage.h"

@protocol IFToastingRoomStreamClientDelegate;

///-----------------------------------------------------------------------------
/// IFToastingRoomStreamClient
///-----------------------------------------------------------------------------

@interface IFToastingRoomStreamClient : NSObject

- (id)initWithRoom:(NSString *)room;

@property NSString *authorizationToken;

@property (weak) id <IFToastingRoomStreamClientDelegate> delegate;

- (void)openConnection;

- (void)openConnectionWithSuccess:(void (^)())success
                          failure:(void (^)(NSError *error))failure;

- (void)closeConnection;

@end

///-----------------------------------------------------------------------------
/// IFToastingRoomStreamClientDelegate
///-----------------------------------------------------------------------------

@protocol IFToastingRoomStreamClientDelegate <NSObject>

- (void)client:(IFToastingRoomStreamClient*)client didReceiveMessage:(IFToastingMessage*)message;
- (void)client:(IFToastingRoomStreamClient*)client didFailWithError:(NSError*)error;

@end
