//
//  CCETranmissionService.m
//  Collaborative Editor
//
//  Created by Kevin Li on 12/28/14.
//  Copyright (c) 2014 Kevin Li. All rights reserved.
//

#import "CCETransmissionService.h"

@implementation CCETransmissionService

+ (id)sharedManager {

    static CCETransmissionService *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc]init];
    });
    
    return sharedManager;
}

- (id)init {
    self = [super init];
    if (self) {
        self.isServer = NO;

    }
    return self;
}

- (void)startServer {
    if (self.masterServer) {
        // server has already started!
        return;
    }
    
    self.masterServer = [[CCEMasterServer alloc]init];
    self.masterServer.delegate = self;
    // listen for app termination notice
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(stopServer) name:@"appKill" object:nil];
    self.isServer = YES;
    
}

#pragma mark - Server delegate methods
- (void)serverPoweredOn {
    // server started, start advertising
    [self.masterServer startAdvertising];
}

@end
