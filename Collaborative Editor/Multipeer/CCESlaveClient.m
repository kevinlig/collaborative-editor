//
//  CCESlaveClient.m
//  Collaborative Editor
//
//  Created by Kevin Li on 12/30/14.
//  Copyright (c) 2014 Kevin Li. All rights reserved.
//

#import "CCESlaveClient.h"

@interface CCESlaveClient ()

- (void)receivedUpdate:(NSDictionary *)updateData;

@end


@implementation CCESlaveClient

- (void)configureService {
    // set up the multipeer network
    self.peerId = [[MCPeerID alloc]initWithDisplayName:self.userName];
    NSString *serviceType = [NSString stringWithFormat:@"%@-%@", kCCEMultipeerServiceRoot, self.sessionCode];

    self.browser = [[MCNearbyServiceBrowser alloc]initWithPeer:self.peerId serviceType:serviceType];
    self.browser.delegate = self;
    
    self.session = [[MCSession alloc]initWithPeer:self.peerId];
    self.session.delegate = self;
}

- (void)startScanning {
    if (!self.browser) {
        [self configureService];
    }
    
    [self.browser startBrowsingForPeers];
    
}

- (void)receivedUpdate:(NSDictionary *)updateData {
    self.lastUpdateData = updateData;
    [[NSNotificationCenter defaultCenter]postNotificationName:@"receivedUpdate" object:nil];
}

#pragma mark - Browser delegate methods
- (void)browser:(MCNearbyServiceBrowser *)browser foundPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary *)info {
    // found the server, connect to it and stop scanning
    NSLog(@"%@",peerID);
    [self.browser invitePeer:peerID toSession:self.session withContext:nil timeout:30];
    [self.browser stopBrowsingForPeers];
}

#pragma mark - Session delegate methods
- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state {
    
}
- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID {
    // received data from the master server
    // convert the data to a dictionary
    NSDictionary *response = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSString *responseType = [response objectForKey:@"type"];
    
    if ([responseType isEqualToString:@"initial"]) {
        // this is the initial response after a connection
        
        self.document = [[CCEDocumentModel alloc]init];
        self.document.documentName = [response objectForKey:@"documentName"];
        self.document.originalText = [response objectForKey:@"originalText"];
        
        // display a user notification
        NSUserNotification *notification = [[NSUserNotification alloc]init];
        notification.title = @"Connected to session.";
        notification.informativeText = [NSString stringWithFormat:@"This session is hosted by %@.", [response objectForKey:@"serverName"]];
        [[NSUserNotificationCenter defaultUserNotificationCenter]deliverNotification:notification];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"initialContact" object:nil];
    }
    else if ([responseType isEqualToString:@"update"]) {
        
        [self receivedUpdate:response];
        
    }
}


@end
