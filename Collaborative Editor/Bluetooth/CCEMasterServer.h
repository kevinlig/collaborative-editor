//
//  CCEMasterServer.h
//  Collaborative Editor
//
//  Created by Kevin Li on 12/28/14.
//  Copyright (c) 2014 Kevin Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "CCEBluetoothServiceDefinitions.h"
#import "NSTimer+Blocks.h"
#import "CCEClientObject.h"

@protocol CCEMasterServerDelegate <NSObject>

- (void)serverPoweredOn;

@end

@interface CCEMasterServer : NSObject <CBPeripheralManagerDelegate>

@property id<CCEMasterServerDelegate> delegate;

@property (nonatomic, strong) CBPeripheralManager *peripheralManager;
@property (nonatomic, strong) CBMutableService *mainService;
@property (nonatomic, strong) CBMutableCharacteristic *changesCharacteristic;
@property (nonatomic, strong) CBMutableCharacteristic *secondCharacteristic;
@property (nonatomic, strong) CBMutableCharacteristic *registrationCharacteristic;

@property (nonatomic, strong) NSMutableDictionary *subscribedClients;
@property BOOL isAdvertising;

- (void)startAdvertising;
- (void)stopAdvertising;
- (void)setupServices;


@end
