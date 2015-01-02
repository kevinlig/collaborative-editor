//
//  CCESlaveClient.m
//  Collaborative Editor
//
//  Created by Kevin Li on 12/30/14.
//  Copyright (c) 2014 Kevin Li. All rights reserved.
//

#import "CCESlaveClient.h"

@interface CCESlaveClient ()

@end


@implementation CCESlaveClient

- (void)configureService {
    // set up the multipeer network
    self.peerId = [[MCPeerID alloc]initWithDisplayName:self.userName];
    NSString *serviceType = [NSString stringWithFormat:@"%@-%@", kCCEMultipeerServiceRoot, self.sessionCode];

    self.browser = [[MCNearbyServiceBrowser alloc]initWithPeer:self.peerId serviceType:serviceType];
    self.browser.delegate = self;
}

- (void)startScanning {
    if (!self.browser) {
        [self configureService];
    }
    
    [self.browser startBrowsingForPeers];
    
    NSLog(@"Looking for service %@", self.browser.serviceType);
}

#pragma mark - Browser delegate methods
- (void)browser:(MCNearbyServiceBrowser *)browser foundPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary *)info {
    NSLog(@"%@",peerID);
}


@end
