//
//  CCESlaveClient.m
//  Collaborative Editor
//
//  Created by Kevin Li on 12/30/14.
//  Copyright (c) 2014 Kevin Li. All rights reserved.
//

#import "CCESlaveClient.h"
#import "TransmissionMessage.pb.h"
#import <Google-Diff-Match-Patch/DiffMatchPatch.h>

@interface CCESlaveClient ()

@property (nonatomic, strong) DiffMatchPatch *diffEngine;

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
    
    self.diffEngine = [[DiffMatchPatch alloc]init];
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

- (void)transmitDiff:(NSMutableArray *)diffArray andState:(NSDictionary *)updatedState {
    
    TransmissionBuilder *builder = [Transmission builder];
    [builder setType:TransmissionMessageTypeUpdateCombo];
    
    TransmissionUserStateBuilder *stateBuilder = [TransmissionUserState builder];
    [stateBuilder setUserName:self.userName];
    [stateBuilder setState:[NSKeyedArchiver archivedDataWithRootObject:updatedState]];
    
    TransmissionUserState *userState = [stateBuilder build];
    [builder setStatesArray:@[userState]];
    
    TransmissionChangeItemBuilder *textBuilder = [TransmissionChangeItem builder];
    [textBuilder setLastSequence:self.document.currentSequenceId];
    [textBuilder setDiff:[NSKeyedArchiver archivedDataWithRootObject:diffArray]];
    
    [builder setChangeItem:[textBuilder build]];
    
    [self sendMessageToServer:[builder build]];
    
}

- (void)requestLatestData {
    
    TransmissionBuilder *builder = [Transmission builder];
    [builder setType:TransmissionMessageTypeReqText];
    [builder setSequenceId:self.document.currentSequenceId];
    
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
            self.document.currentText = message.document.documentText;
            self.document.currentSequenceId = 1;
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
        
        // we need to create an array of dictionaries, which will contain a user's numeric identifier and their state data
        NSMutableArray *userStates = [NSMutableArray array];
        
        // iterate through each state item passed in the message (there should be one state per user that has interacted with the editor before)
        for (TransmissionUserState *currentState in message.states) {
            
            if ([currentState.userName isEqualToString:self.userName]) {
                // we don't need to see our own state so we can skip this one
                continue;
            }
            
            NSDictionary *stateDict = [NSKeyedUnarchiver unarchiveObjectWithData:currentState.state];
            
            CCEUserModel *currentUser = [self.userDict objectForKey:currentState.userName];
            NSDictionary *wrapperDict = @{@"user":@(currentUser.internalId), @"state":stateDict};
            
            [userStates addObject:wrapperDict];
        
        }
        
        self.currentState = [userStates copy];
        
        // okay, we're done, notify the editor JS that it's ready to be displayed
        [[NSNotificationCenter defaultCenter]postNotificationName:@"receivedUpdate" object:nil];
        
    }
    else if (message.type == TransmissionMessageTypeStateTextCombo) {
        // received a combination text/state broadcast
        
        TransmissionTextUpdateItem *item = message.textUpdate;
        
        self.document.currentSequenceId = item.sequenceId;
        NSString *newString = item.text;
        
        self.document.currentText = newString;
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"updatedDocument" object:nil];
        
    }
    
}


@end
