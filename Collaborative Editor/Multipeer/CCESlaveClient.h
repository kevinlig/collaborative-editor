//
//  CCESlaveClient.h
//  Collaborative Editor
//
//  Created by Kevin Li on 12/30/14.
//  Copyright (c) 2014 Kevin Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import "CCEServiceDefinitions.h"

@protocol CCESlaveClientDelegate <NSObject>


@end

@interface CCESlaveClient : NSObject <MCNearbyServiceBrowserDelegate>

@property id<CCESlaveClientDelegate> delegate;

@property BOOL isScanning;

/// @brief The user's display name, as presented to other clients. Will be used in the peer ID.
@property (nonatomic, strong) NSString *userName;

/// @brief Identifies the computer to other clients in the multipeer network.
@property (nonatomic, strong) MCPeerID *peerId;
/// @brief The communication session in the multipeer network.
@property (nonatomic, strong) MCSession *session;

/// @brief A random 4-character code that clients will provide in order to connect into the multipeer network.
@property (nonatomic, strong) NSString *sessionCode;

@property (nonatomic, strong) MCNearbyServiceBrowser *browser;

- (void)configureService;
- (void)startScanning;


@end