//
//  CCESlaveClient.m
//  Collaborative Editor
//
//  Created by Kevin Li on 12/30/14.
//  Copyright (c) 2014 Kevin Li. All rights reserved.
//

#import "CCESlaveClient.h"
#import "TransmissionMessage.pb.h"

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
    
    self.userList = [NSMutableArray array];
    self.userDict = [NSMutableDictionary dictionary];
}

- (void)startScanning {
    if (!self.browser) {
        [self configureService];
    }
    
    [self.browser startBrowsingForPeers];
    
}

- (void)receivedUpdate:(NSDictionary *)updateData {
//    self.lastUpdateData = updateData;
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"receivedUpdate" object:nil];
}

- (void)sendMessageToServer:(Transmission *)message {
    [self.session sendData:message.data toPeers:@[self.serverPeer] withMode:MCSessionSendDataReliable error:nil];
}

- (void)transmitState:(NSDictionary *)stateData {
    
    TransmissionBuilder *builder = [Transmission builder];
    [builder setType:TransmissionMessageTypeUpdateState];
    
    TransmissionUserStateBuilder *stateBuilder = [TransmissionUserState builder];
    [stateBuilder setUserName:self.userName];
    [stateBuilder setState:[NSKeyedArchiver archivedDataWithRootObject:stateData]];
    
    TransmissionUserState *userState = [stateBuilder build];
    
    [builder setStatesArray:@[userState]];
    
    [self sendMessageToServer:[builder build]];
    
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

    // parse the response
    Transmission *message = [Transmission parseFromData:data];
    
    if (message.type == TransmissionMessageTypeInitial) {
        // this is the initial response after a connection
        
        self.document = [[CCEDocumentModel alloc]init];
        if (message.document) {
            self.document.documentName = message.document.documentName;
            self.document.originalText = message.document.documentText;
        }
        
        // populate the current user list
        for (TransmissionUser *transmittedUser in message.userList) {
            CCEUserModel *user = [[CCEUserModel alloc]init];
            user.internalId = transmittedUser.id;
            user.userName = transmittedUser.userName;
            user.displayColor = transmittedUser.color;
            
            [self.userList addObject:user];
            [self.userDict setObject:user forKey:transmittedUser.userName];
            
            if (transmittedUser.isYou) {
                self.userName = transmittedUser.userName;
            }
        }
        
        // display a user notification
        NSUserNotification *notification = [[NSUserNotification alloc]init];
        notification.title = @"Connected to session.";
        notification.informativeText = [NSString stringWithFormat:@"This session is hosted by %@.", message.serverName];
        [[NSUserNotificationCenter defaultUserNotificationCenter]deliverNotification:notification];
        
        self.serverPeer = peerID;
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"initialContact" object:nil];
    }
    else if (message.type == TransmissionMessageTypeState) {
        // received a state message
        // TEMP CODE
        
        NSMutableArray *userStates = [NSMutableArray array];
        
        for (TransmissionUserState *currentState in message.states) {
            
            if ([currentState.userName isEqualToString:self.userName]) {
                // we don't need to see our own state
                continue;
            }
            
            NSDictionary *stateDict = [NSKeyedUnarchiver unarchiveObjectWithData:currentState.state];
            
            CCEUserModel *currentUser = [self.userDict objectForKey:currentState.userName];
            NSDictionary *wrapperDict = @{@"user":@(currentUser.internalId), @"state":stateDict};
            
            [userStates addObject:wrapperDict];
        
        }
        
        self.currentState = [userStates copy];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"receivedUpdate" object:nil];
        
    }
//    else if ([responseType isEqualToString:@"update"]) {
//        
//        [self receivedUpdate:response];
//        
//    }
}


@end
