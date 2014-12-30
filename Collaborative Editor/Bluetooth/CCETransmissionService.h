//
//  CCETranmissionService.h
//  Collaborative Editor
//
//  Created by Kevin Li on 12/28/14.
//  Copyright (c) 2014 Kevin Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCEMasterServer.h"

@interface CCETransmissionService : NSObject <CCEMasterServerDelegate>

@property BOOL isServer;
@property (nonatomic, strong) CCEMasterServer *masterServer;

+ (id)sharedManager;

- (void)startServer;
- (void)stopServer;

@end
