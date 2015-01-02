//
//  CCEClientModel.h
//  Collaborative Editor
//
//  Created by Kevin Li on 1/2/15.
//  Copyright (c) 2015 Kevin Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@interface CCEClientModel : NSObject

/// @brief The underlying MCPeerID object.
@property (nonatomic, strong) MCPeerID *peerId;
/// @brief The displayable user name of the client.
@property (nonatomic, strong) NSString *userName;
/// @brief Indicates if the client is online or not.
@property BOOL isOnline;
/// @brief The color that the client is associated with.
@property (nonatomic, strong) NSColor *displayColor;
/// @brief The time that the client was last seen.
@property (nonatomic, strong) NSDate *lastSeen;
/// @brief The edit priority order that the client will be given if conflicting edits occur.
@property int priority;

@end
