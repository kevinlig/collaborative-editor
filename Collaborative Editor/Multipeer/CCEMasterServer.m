//
//  CCEMasterServer.m
//  Collaborative Editor
//
//  Created by Kevin Li on 12/29/14.
//  Copyright (c) 2014 Kevin Li. All rights reserved.
//

#import "CCEMasterServer.h"

@interface CCEMasterServer ()



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
}

#pragma mark - MCSession delegate methods
- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state {
    
}

@end
