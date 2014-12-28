//
//  CCEMasterServer.m
//  Collaborative Editor
//
//  Created by Kevin Li on 12/28/14.
//  Copyright (c) 2014 Kevin Li. All rights reserved.
//

#import "CCEMasterServer.h"

@interface CCEMasterServer ()

@end

@implementation CCEMasterServer

- (id)init {
    self = [super init];
    if (self) {
        self.peripheralManager = [[CBPeripheralManager alloc]initWithDelegate:self queue:nil];
        self.isAdvertising = NO;
    }
    return self;
}

- (void)startAdvertising {
    NSDictionary *advertisementData = @{CBAdvertisementDataLocalNameKey: @"Collab Editor Server", CBAdvertisementDataServiceUUIDsKey: @[[CBUUID UUIDWithString:kCCEAdvertisementId]]};
    [self.peripheralManager startAdvertising:advertisementData];
    self.isAdvertising = YES;
}

- (void)stopAdvertising {
    if (self.isAdvertising != YES) {
        // not advertising
        return;
    }
    [self.peripheralManager stopAdvertising];
    self.isAdvertising = NO;
}


#pragma mark - CoreBluetooth delegate methods
- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral {
    
    if (peripheral.state == CBPeripheralManagerStatePoweredOn) {
        [self.delegate serverPoweredOn];
    }
    
}

@end
