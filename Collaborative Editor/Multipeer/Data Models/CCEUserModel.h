//
//  CCEUserModel.h
//  Collaborative Editor
//
//  Created by Kevin Li on 1/2/15.
//  Copyright (c) 2015 Kevin Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@interface CCEUserModel : NSObject

/// @brief The underlying MCPeerID object.
@property (nonatomic, strong) MCPeerID *peerId;
/// @brief The displayable user name of the client.
@property (nonatomic, strong) NSString *userName;
/// @brief Indicates if the client is online or not.
@property BOOL isOnline;
/// @brief The color that the client is associated with.
@property (nonatomic, strong) NSString *displayColor;
/// @brief The time that the client was last seen.
@property (nonatomic, strong) NSDate *lastSeen;

@property int internalId;

/// @brief The user's current cursor position and selection.
@property (nonatomic, strong) NSMutableDictionary *cursorState;


@end
