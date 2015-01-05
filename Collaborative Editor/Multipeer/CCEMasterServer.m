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
    self.currentUserNames = [NSMutableDictionary dictionary];
    self.totalCount = 0;
    self.document = [[CCEDocumentModel alloc]init];
    self.document.originalText = @"";
    self.document.documentName = @"";
}

#pragma mark - MCSession delegate methods
- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state {
    if (state == MCSessionStateConnected) {
        NSString *newUserName = peerID.displayName;
        
        if ([peerID.displayName isEqualToString:self.userName] || [self.currentUserNames objectForKey:peerID]) {
            // handle a case where the user name already exists
            newUserName = [NSString stringWithFormat:@"%@ (%@)",peerID.displayName,[NSString randomizedString]];
            
            // TODO: come up with a way of generating display names that is collision proof
        }
        
        self.totalCount++;
        
        // create a new client object
        CCEClientModel *newClient = [[CCEClientModel alloc]init];
        newClient.peerId = peerID;
        newClient.userName = newUserName;
        newClient.isOnline = YES;
        newClient.priority = self.totalCount;
        
        // TODO: add color
        
        [self.connectedPeers setObject:newClient forKey:peerID];
        [self.currentUserNames setObject:@(1) forKey:newUserName];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"clientConnected" object:nil];
        
        // display a notification
        NSUserNotification *notification = [[NSUserNotification alloc]init];
        notification.title = [NSString stringWithFormat:@"%@ has joined the session.", newUserName];
        notification.informativeText = [NSString stringWithFormat:@"%@ can now view the document and make changes.", newUserName];
        [[NSUserNotificationCenter defaultUserNotificationCenter]deliverNotification:notification];
        
        // okay let's respond to the client
        NSDictionary *response = @{@"type":@"initial", @"userName":newUserName, @"originalText":self.document.originalText, @"documentName":self.document.documentName};
        NSData *responseData = [NSKeyedArchiver archivedDataWithRootObject:response];
        [self.session sendData:responseData toPeers:@[peerID] withMode:MCSessionSendDataReliable error:nil];
    }
}

@end
