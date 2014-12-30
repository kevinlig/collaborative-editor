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
    if (self.masterServer && self.masterServer.advertising) {
        // server has already started and is advertising
        return;
    }
    
    self.masterServer = [[CCEMasterServer alloc]init];
    self.masterServer.delegate = self;
    self.masterServer.userName = self.userName;
    self.isServer = YES;
    
    [self.masterServer startServer];
    
}

#pragma mark - Server delegate methods


@end