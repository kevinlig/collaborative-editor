//
//  CCEMasterServer.h
//  Collaborative Editor
//
//  Created by Kevin Li on 12/29/14.
//  Copyright (c) 2014 Kevin Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import "CCEServiceDefinitions.h"
#import "NSString+Random.h"

@protocol CCEMasterServerDelegate <NSObject>


@end

@interface CCEMasterServer : NSObject <MCSessionDelegate>

@property id<CCEMasterServerDelegate> delegate;

/// @brief The user's display name, as presented to other clients. Will be used in the peer ID.
@property (nonatomic, strong) NSString *userName;

/// @brief Identifies the computer to other clients in the multipeer network.
@property (nonatomic, strong) MCPeerID *peerId;
/// @brief The communication session in the multipeer network.
@property (nonatomic, strong) MCSession *session;
/// @brief The advertisement service for broadcasting the server's presence.
@property (nonatomic, strong) MCAdvertiserAssistant *advertiser;

/// @brief A random 4-character code that clients will provide in order to connect into the multipeer network.
@property (nonatomic, strong) NSString *sessionCode;

/// @brief Indicates if the server is currently advertising its presence.
@property BOOL advertising;

/*!
 * @discussion Sets up the multipeer network that will be used to connect clients together.
 * @return The 4-character code that clients will need to provide in order to connect into the server.
 */
- (NSString *)configureServer;

/*!
 * @discussion Starts the multipeer service and begins advertising the server's presence.
 */
- (void)startServer;

@end