//
//  CCETransmissionService.h
//  Collaborative Editor
//
//  Created by Kevin Li on 12/28/14.
//  Copyright (c) 2014 Kevin Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCEMasterServer.h"

@interface CCETransmissionService : NSObject <CCEMasterServerDelegate>

/// @brief Indicates whether the application is acting as a master server or a slave client.
@property BOOL isServer;
/// @brief The name of the user, as presented to other clients/server.
@property (nonatomic, strong) NSString *userName;
/// @brief The underlying server object (may be nil if the shared manager is not acting as a master server)
@property (nonatomic, strong) CCEMasterServer *masterServer;

+ (id)sharedManager;

/*!
 * @discussion Creates and starts the master server.
 * @warning You must specify a userName before calling this method.
 */
- (void)startServer;

@end