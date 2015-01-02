//
//  CCEMasterServer.m
//  Collaborative Editor
//
//  Created by Kevin Li on 12/29/14.
//  Copyright (c) 2014 Kevin Li. All rights reserved.
//

#import "CCEMasterServer.h"

@interface CCEMasterServer ()

@property int totalCount;

@end

@implementation CCEMasterServer

- (NSString *)configureServer {
    // generate a random session code (in case there are other users nearby)
    self.sessionCode = [NSString randomizedString];
    
    // set up the multipeer network
    self.peerId = [[MCPeerID alloc]initWithDisplayName:self.userName];
    self.session = [[MCSession alloc]initWithPeer:self.peerId];
    self.session.delegate = self;
    
    return self.sessionCode;
    
}
- (void)startServer {
    // check if we've configured the network yet
    if (!self.session) {
        [self configureServer];
    }
    
    // begin advertising the server's presence
    NSString *serviceName = [NSString stringWithFormat:@"%@-%@", kCCEMultipeerServiceRoot, self.sessionCode];
    self.advertiser = [[MCAdvertiserAssistant alloc]initWithServiceType:serviceName discoveryInfo:nil session:self.session];
    
    [self.advertiser start];
    
    self.advertising = YES;
    
    self.connectedPeers = [NSMutableDictionary dictionary];
    self.totalCount = 0;
}

#pragma mark - MCSession delegate methods
- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state {
    if (state == MCSessionStateConnected) {
        if (![self.connectedPeers objectForKey:peerID.displayName]) {
            // only accept if the display name doesn't yet exist
            
            self.totalCount++;
            
            // create a new client object
            CCEClientModel *newClient = [[CCEClientModel alloc]init];
            newClient.peerId = peerID;
            newClient.userName = peerID.displayName;
            newClient.isOnline = YES;
            newClient.priority = self.totalCount;
            
            // TODO: add color
            
            [self.connectedPeers setObject:newClient forKey:peerID.displayName];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"clientConnected" object:nil];
        }
    }
}

@end
