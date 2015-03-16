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
    self.document.originalText = @"";
    self.document.documentName = @"";
    
    // populate the user color array
    self.userColors = @[[NSColor colorWithHexString:@"e83a30"],[NSColor colorWithHexString:@"8930e8"],[NSColor colorWithHexString:@"3080e8"],[NSColor colorWithHexString:@"30e849"],[NSColor colorWithHexString:@"e8e230"]];
}

- (void)sendUpdate:(NSDictionary *)updateData {
    NSMutableDictionary *transmissionDictionary = [NSMutableDictionary dictionaryWithDictionary:updateData];
    [transmissionDictionary setObject:@([[NSDate date]timeIntervalSince1970]) forKey:@"time"];
    [transmissionDictionary setObject:self.userName forKey:@"user"];
    [transmissionDictionary setObject:@(0) forKey:@"priority"];
    [transmissionDictionary setObject:@"update" forKey:@"type"];
    
    NSData *transmissionData = [NSKeyedArchiver archivedDataWithRootObject:transmissionDictionary];
    
    NSMutableArray *peerArray = [NSMutableArray array];
    for (MCPeerID *client in self.connectedPeers) {
        [peerArray addObject:client];
    }
    
    [self.session sendData:transmissionData toPeers:peerArray withMode:MCSessionSendDataReliable error:nil];

}

- (void)updateState:(NSDictionary *)updatedState {
    
    // wrap the data into a Protobuf
    TransmissionBuilder *builder = [Transmission builder];
    [builder setType:TransmissionMessageTypeState];
    [builder setUserName:self.userName];
    
    TransmissionUserStateBuilder *stateBuilder = [TransmissionUserState builder];
    NSData *stateData = [NSKeyedArchiver archivedDataWithRootObject:updatedState];
    [stateBuilder setState:stateData];
    
    TransmissionUserState *state = [stateBuilder build];
    
    [builder setStatesArray:@[state]];
    
    // send the data
    [self sendBuffer:[builder build] toUsers:self.allUsers];
    
}

- (void)sendBuffer:(Transmission *)protoBuffer toUsers:(NSArray *)recipients {
    NSData *bufferData = protoBuffer.data;
    
    [self.session sendData:bufferData toPeers:recipients withMode:MCSessionSendDataReliable error:nil];
    
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
        newUser.displayColor = [self.userColors objectAtIndex:self.totalCount];
        
        self.totalCount++;
        
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
        [message setUserName:newUserName];
        
        TransmissionDocumentBuilder *documentBuilder = [TransmissionDocument builder];
        [documentBuilder setDocumentText:self.document.originalText];
        [documentBuilder setDocumentName:self.document.documentName];
        
        [message setDocument:[documentBuilder build]];
    
        NSData *responseData = [message build].data;
        
        [self.session sendData:responseData toPeers:@[peerID] withMode:MCSessionSendDataReliable error:nil];
    }
}

- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID {
    
}

@end
