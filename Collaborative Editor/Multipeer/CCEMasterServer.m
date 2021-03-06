//
//  CCEMasterServer.m
//  Collaborative Editor
//
//  Created by Kevin Li on 12/29/14.
//  Copyright (c) 2014 Kevin Li. All rights reserved.
//

#import "CCEMasterServer.h"
#import <HexColors/HexColor.h>

@interface CCEMasterServer ()

@property int totalCount;

@property (nonatomic, strong) CCEUserModel *serverUser;

@property (nonatomic, strong) NSArray *userColors;

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
    self.allUsers = [NSMutableArray array];
    self.totalCount = 0;
    self.document = [[CCEDocumentModel alloc]init];
    self.document.currentText = @"";
    self.document.documentName = @"";
    
    // populate the user color array
    self.userColors = @[@"e83a30",@"c69cf4",@"3080e8",@"109121",@"c76f16"];
    
    // create the server user
    self.serverUser = [[CCEUserModel alloc]init];
    self.serverUser.peerId = self.peerId;
    self.serverUser.userName = self.userName;
    self.serverUser.isOnline = YES;
    self.serverUser.internalId = self.totalCount;
    
    self.serverUser.displayColor = [self.userColors objectAtIndex:self.totalCount];
    
    self.totalCount++;

}

- (NSMutableArray *)buildUserList:(NSString *)recipientUserName {
    NSMutableArray *userList = [NSMutableArray array];
    
    for (MCPeerID *peer in self.allUsers) {
        CCEUserModel *user = [self.connectedPeers objectForKey:peer];
        
        TransmissionUserBuilder *userBuilder = [TransmissionUser builder];
        [userBuilder setId:user.internalId];
        [userBuilder setUserName:user.userName];
        [userBuilder setColor:user.displayColor];
        
        if (recipientUserName && [recipientUserName isEqualToString:user.userName]) {
            [userBuilder setIsYou:YES];
        }
        else {
            [userBuilder setIsYou:NO];
        }
        
        [userBuilder setIsServer:NO];
        
        TransmissionUser *userMsg = [userBuilder build];
        [userList addObject:userMsg];
    }
    
    // add in the current server user
    TransmissionUserBuilder *serverUser = [TransmissionUser builder];
    [serverUser setId:self.serverUser.internalId];
    [serverUser setUserName:self.serverUser.userName];
    [serverUser setColor:self.serverUser.displayColor];
    [serverUser setIsYou:NO];
    [serverUser setIsServer:YES];
    
    TransmissionUser *serverUserMsg = [serverUser build];
    [userList addObject:serverUserMsg];
    
    return userList;
}

- (void)updateState:(NSDictionary *)updatedState {
    
    // add the state to the document model
    [self.document.userStates setObject:updatedState forKey:self.serverUser.userName];
    
    [self broadcastState];
    
}

- (NSArray *)packageCurrentStates {
    
    NSMutableArray *stateArray = [NSMutableArray array];
    
    for (NSString *userName in self.document.userStates.allKeys) {
        NSDictionary *userState = [self.document.userStates objectForKey:userName];
        
        TransmissionUserStateBuilder *stateBuilder = [TransmissionUserState builder];
        NSData *stateData = [NSKeyedArchiver archivedDataWithRootObject:userState];
        [stateBuilder setState:stateData];
        [stateBuilder setUserName:userName];
        
        [stateArray addObject:[stateBuilder build]];
        
    }

    return stateArray;
}

- (void)broadcastState {
    // wrap the data into a Protobuf
    TransmissionBuilder *builder = [Transmission builder];
    [builder setType:TransmissionMessageTypeState];
    
    [builder setStatesArray:[self packageCurrentStates]];
    
    // send the data
    [self sendBuffer:[builder build] toUsers:self.allUsers];
    
    // now locally update the server's own UI with the latest data, since we don't need to transmit this data to ourselves
    // create the local state array
    self.currentState = [NSMutableArray array];
    // iterate through all the states in the document, excluding ourselves
    for (NSString *thisUserName in self.document.userStates.allKeys) {
        
        if ([thisUserName isEqualToString:self.serverUser.userName]) {
            continue;
        }
        
        // we need the user model in order to retrieve the numeric identifier (used by the JS)
        CCEUserModel *userModel = [self.currentUserNames objectForKey:thisUserName];
        
        NSDictionary *stateWrapper = @{@"user":@(userModel.internalId), @"state":[self.document.userStates objectForKey:thisUserName]};
        
        // push the assembled dictionary into the state array
        [self.currentState addObject:stateWrapper];
    }
    // we've updated the state array, notify the editor to update the UI
    [[NSNotificationCenter defaultCenter]postNotificationName:@"receivedUpdate" object:nil];

}

- (void)updateDiff:(NSMutableArray *)diffArray {
    
    [self.document addDiff:diffArray];

    [self broadcastChangedText:self.allUsers];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"updatedDocument" object:nil];

}

- (void)updateDiff:(NSMutableArray *)diffArray andState:(NSDictionary *)updatedState {
    
    [self.document addDiff:diffArray];
    // add the state to the document model
    [self.document.userStates setObject:updatedState forKey:self.serverUser.userName];
    
    [self broadcastChangedText:self.allUsers];
    
}

- (void)broadcastChangedText:(NSArray *)recipients {
    
    TransmissionTextUpdateItemBuilder *textItemBuilder = [TransmissionTextUpdateItem builder];
    [textItemBuilder setSequenceId:self.document.currentSequenceId];
    [textItemBuilder setText:self.document.currentText];
    
    // send the data
    TransmissionBuilder *builder = [Transmission builder];
    [builder setType:TransmissionMessageTypeStateTextCombo];
    [builder setTextUpdate:[textItemBuilder build]];
    [builder setStatesArray:[self packageCurrentStates]];
    
    [self sendBuffer:[builder build] toUsers:recipients];

    [[NSNotificationCenter defaultCenter]postNotificationName:@"updatedDocument" object:nil];
    
}

- (void)sendBuffer:(Transmission *)protoBuffer toUsers:(NSArray *)recipients {
    NSData *bufferData = protoBuffer.data;
    
    if ([self.allUsers count] > 0) {
        [self.session sendData:bufferData toPeers:recipients withMode:MCSessionSendDataReliable error:nil];
    }
    
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
        
        // create a new user
        CCEUserModel *newUser = [[CCEUserModel alloc]init];
        newUser.peerId = peerID;
        newUser.userName = newUserName;
        newUser.isOnline = YES;
        newUser.internalId = self.totalCount;
        
        newUser.displayColor = [self.userColors objectAtIndex:self.totalCount];
        
        [self.connectedPeers setObject:newUser forKey:peerID];
        [self.currentUserNames setObject:newUser forKey:newUserName];
        [self.allUsers addObject:peerID];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"clientConnected" object:nil];
        
        // display a notification
        NSUserNotification *notification = [[NSUserNotification alloc]init];
        notification.title = [NSString stringWithFormat:@"%@ has joined the session.", newUserName];
        notification.informativeText = [NSString stringWithFormat:@"%@ can now view the document and make changes.", newUserName];
        [[NSUserNotificationCenter defaultUserNotificationCenter]deliverNotification:notification];
        
        // okay let's respond to the client
//        NSDictionary *response = @{@"type":@"initial", @"serverName": self.userName, @"userName":newUserName, @"originalText":self.document.originalText, @"documentName":self.document.documentName};
//        NSData *oldData = [NSKeyedArchiver archivedDataWithRootObject:response];
//      
        
        TransmissionBuilder *message = [Transmission builder];
        [message setType:TransmissionMessageTypeInitial];
        [message setServerName:self.userName];
                
        [message setUserListArray:[self buildUserList:newUserName]];
        
        TransmissionDocumentBuilder *documentBuilder = [TransmissionDocument builder];
        [documentBuilder setDocumentText:self.document.currentText];
        [documentBuilder setDocumentName:self.document.documentName];
        
        [message setDocument:[documentBuilder build]];
    
        NSData *responseData = [message build].data;
        
        [self.session sendData:responseData toPeers:@[peerID] withMode:MCSessionSendDataReliable error:nil];
         
        self.totalCount++;
    }
}

- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID {

    // parse the message
    Transmission *message = [Transmission parseFromData:data];
    
    if (message.type == TransmissionMessageTypeUpdateState) {
        // user is pushing a new state
        
        TransmissionUserState *stateMessage = [message.states objectAtIndex:0];
        
        NSDictionary *stateData = [NSKeyedUnarchiver unarchiveObjectWithData:stateMessage.state];
        
        // add the state to the document model
        [self.document.userStates setObject:stateData forKey:stateMessage.userName];
        
        [self broadcastState];
    }
    else if (message.type == TransmissionMessageTypeUpdateCombo) {
        // user is pushing a combination of state and text
        
        TransmissionChangeItem *changeItem = message.changeItem;
        
        NSArray *diffs = [NSKeyedUnarchiver unarchiveObjectWithData:changeItem.diff];
        [self.document addDiff:[diffs mutableCopy]];
        [self broadcastChangedText:self.allUsers];
        
    }
}

@end
