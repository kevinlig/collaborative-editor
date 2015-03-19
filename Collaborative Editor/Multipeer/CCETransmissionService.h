//
//  CCETransmissionService.h
//  Collaborative Editor
//
//  Created by Kevin Li on 12/28/14.
//  Copyright (c) 2014 Kevin Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCEMasterServer.h"
#import "CCESlaveClient.h"

@interface CCETransmissionService : NSObject <CCEMasterServerDelegate, CCESlaveClientDelegate>

/// @brief Indicates whether the application is acting as a master server or a slave client.
@property BOOL isServer;
/// @brief The name of the user, as presented to other clients/server.
@property (nonatomic, copy) NSString *userName;
/// @brief The underlying server object (may be nil if the shared manager is not acting as a master server)
@property (nonatomic, strong) CCEMasterServer *masterServer;
/// @brief The 4-character access code for the server session
@property (nonatomic, copy) NSString *sessionCode;


/// @brief The underlying client object (may be nil if the shared manager is not acting as a slave client)
@property (nonatomic, strong) CCESlaveClient *slaveClient;



+ (CCETransmissionService *)sharedManager;

/*!
 * @discussion Creates and starts the master server.
 * @warning You must specify a userName before calling this method.
 */
- (void)startServer;

- (void)startClient;

- (void)transmitState:(NSDictionary *)stateData;

- (void)transmitDiff:(NSMutableArray *)diffArray;

- (void)transmitDiff:(NSMutableArray *)diffArray andState:(NSDictionary *)stateData;

@end