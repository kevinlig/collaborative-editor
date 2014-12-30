//
//  CCEMasterServer.m
//  Collaborative Editor
//
//  Created by Kevin Li on 12/28/14.
//  Copyright (c) 2014 Kevin Li. All rights reserved.
//

#import "CCEMasterServer.h"

@interface CCEMasterServer ()

- (void)testEvent;

- (CCEClientObject *)findClientWithIdentifier:(NSString *)identifier;
- (void)updateClientList:(CCEClientObject *)client;

@end

@implementation CCEMasterServer

- (id)init {
    self = [super init];
    if (self) {
        self.peripheralManager = [[CBPeripheralManager alloc]initWithDelegate:self queue:nil];
        self.isAdvertising = NO;
        self.subscribedClients = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)startAdvertising {
    NSDictionary *advertisementData = @{CBAdvertisementDataLocalNameKey: @"Collab Editor Server", CBAdvertisementDataServiceUUIDsKey: @[[CBUUID UUIDWithString:kCCEAdvertisementId]]};
    [self.peripheralManager startAdvertising:advertisementData];
    self.isAdvertising = YES;
    
    // also set up the services
    [self setupServices];
}

- (void)stopAdvertising {
    if (self.isAdvertising != YES) {
        // not advertising
        return;
    }
    [self.peripheralManager stopAdvertising];
    self.isAdvertising = NO;
}

- (void)setupServices {
    // set up the Bluetooth service and its associated characteristics
    self.mainService = [[CBMutableService alloc]initWithType:[CBUUID UUIDWithString:kCCEPrimaryServiceId] primary:YES];
    
    self.changesCharacteristic = [[CBMutableCharacteristic alloc]initWithType:[CBUUID UUIDWithString:kCCEChangesCharacteristicId] properties:CBCharacteristicPropertyRead|CBCharacteristicPropertyNotify value:nil permissions:CBAttributePermissionsReadable];
    self.secondCharacteristic = [[CBMutableCharacteristic alloc]initWithType:[CBUUID UUIDWithString:kCCEOriginalDataCharacteristicId] properties:CBCharacteristicPropertyRead|CBCharacteristicPropertyNotify value:nil permissions:CBAttributePermissionsReadable];
    
    // the registration characteristic will be hit first by newly connect clients, we will get their display name from it
    self.registrationCharacteristic = [[CBMutableCharacteristic alloc]initWithType:[CBUUID UUIDWithString:kCCERegistrationCharacteristicId] properties:CBCharacteristicPropertyWrite value:nil permissions:CBAttributePermissionsWriteable];
    
    self.mainService.characteristics = @[self.changesCharacteristic, self.secondCharacteristic, self.registrationCharacteristic];
    
    [self.peripheralManager addService:self.mainService];
    
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(testEvent) userInfo:nil repeats:YES];
}


- (void)testEvent {
    NSString *timeString = [NSString stringWithFormat:@"Characteristic 1 is %f",[[NSDate date]timeIntervalSince1970]];
    NSData *rawData = [timeString dataUsingEncoding:NSUTF8StringEncoding];
    NSData *transmittableData = [NSData dataWithBytes:rawData.bytes length:rawData.length];
    
    NSString *timeString2 = [NSString stringWithFormat:@"Characteristic 2 is %f",[[NSDate date]timeIntervalSince1970]];
    NSData *rawData2 = [timeString2 dataUsingEncoding:NSUTF8StringEncoding];
    NSData *transmittableData2 = [NSData dataWithBytes:rawData2.bytes length:rawData2.length];
    
    [self.peripheralManager updateValue:transmittableData forCharacteristic:self.changesCharacteristic onSubscribedCentrals:nil];
    
    [NSTimer scheduledTimerWithTimeInterval:0.05f block:^{
        [self.peripheralManager updateValue:transmittableData2 forCharacteristic:self.secondCharacteristic onSubscribedCentrals:nil];
    } repeats:NO];

}

- (CCEClientObject *)findClientWithIdentifier:(NSString *)identifier {
    if ([self.subscribedClients objectForKey:identifier]) {
        return (CCEClientObject *)[self.subscribedClients objectForKey:identifier];
    }
    return nil;
}

- (void)updateClientList:(CCEClientObject *)client {
    [self.subscribedClients setObject:client forKey:client.uuid];
}

#pragma mark - CoreBluetooth delegate methods
- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral {
    
    if (peripheral.state == CBPeripheralManagerStatePoweredOn) {
        [self.delegate serverPoweredOn];
    }
    
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didSubscribeToCharacteristic:(CBCharacteristic *)characteristic {

    NSString *clientUUID = [central.identifier UUIDString];
    
    // check if we've seen this client before
    CCEClientObject *subscribedClient = [self findClientWithIdentifier:clientUUID];
    if (subscribedClient) {
        
        // already seeen it, set state to alive (if necessary)
        if (subscribedClient.isAlive != YES) {
            subscribedClient.isAlive = YES;
            [self updateClientList:subscribedClient];
        }
        return;
    }
    
    // otherwise, create a new client record
    subscribedClient = [[CCEClientObject alloc]init];
    subscribedClient.uuid = clientUUID;
    subscribedClient.isAlive = YES;
    [self updateClientList:subscribedClient];
}


- (void)peripheralManager:(CBPeripheralManager *)peripheral didReceiveWriteRequests:(NSArray *)requests {
    // we've received an input from a connected client
    // this could be for initial registration or it could contain a list of client-performed operations
    
    for (CBATTRequest *request in requests) {
        if ([request.characteristic.UUID isEqual:[CBUUID UUIDWithString:kCCERegistrationCharacteristicId]]) {
            // this is a registration request, which will contain a string display name
            NSString *output = [[NSString alloc]initWithData:request.value encoding:NSUTF8StringEncoding];

            // received, respond back
            [peripheral respondToRequest:request withResult:CBATTErrorSuccess];
            
           
            // check if we've seen this client before
            NSString *clientUUID = [request.central.identifier UUIDString];
            CCEClientObject *subscribedClient = [self findClientWithIdentifier:clientUUID];
            if (subscribedClient) {
                
                // already seeen it, set state to alive and update the display name
                subscribedClient.isAlive = YES;
                subscribedClient.displayName = output;
                [self updateClientList:subscribedClient];
                
                return;
            }
            
            // otherwise, create a new client record
            subscribedClient = [[CCEClientObject alloc]init];
            subscribedClient.uuid = clientUUID;
            subscribedClient.isAlive = YES;
            subscribedClient.displayName = output;
            [self updateClientList:subscribedClient];
        }
    }
}

@end
