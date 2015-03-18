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
#import "CCEUserModel.h"
#import "CCEDocumentModel.h"
#import "TransmissionMessage.pb.h"

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

/// @brief A dictionary of clients that are connected to the server.
@property (nonatomic, strong) NSMutableDictionary *connectedPeers;
/// @brief A dictionary of user names.
@property (nonatomic, strong) NSMutableDictionary *currentUserNames;
/// @brief An array of peer IDs to broadcast to (since we don't need to broadcast to ourselves, this should exclude the master server).
@property (nonatomic, strong) NSMutableArray *allUsers;

/// @brief The document being shared in the session.
@property (nonatomic, strong) CCEDocumentModel *document;

/// @brief An array of dictionaries (user numeric identifier + state data) showing each connected user's cursor/selection state.
@property (nonatomic, strong) NSMutableArray *currentState;



/*!
 * @discussion Sets up the multipeer network that will be used to connect clients together.
 * @return The 4-character code that clients will need to provide in order to connect into the server.
 */
- (NSString *)configureServer;

/*!
 * @discussion Starts the multipeer service and begins advertising the server's presence.
 */
- (void)startServer;

- (void)updateState:(NSDictionary *)updatedState;
- (void)broadcastState;

- (void)updateDiff:(NSMutableArray *)diffArray;


- (void)sendBuffer:(Transmission *)protoBuffer toUsers:(NSArray *)recipients;

- (void)notifyQueueChanged:(NSArray *)recipients;

- (NSMutableArray *)buildUserList:(NSString *)recipientUserName;

@end
