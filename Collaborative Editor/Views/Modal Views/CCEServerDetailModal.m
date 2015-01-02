//
//  CCEServerDetailModal.m
//  Collaborative Editor
//
//  Created by Kevin Li on 12/30/14.
//  Copyright (c) 2014 Kevin Li. All rights reserved.
//

#import "CCEServerDetailModal.h"

@interface CCEServerDetailModal ()

@property (weak) IBOutlet NSTextField *accessCodeField;
@property (weak) IBOutlet NSTextField *numberJoinedField;

@property int totalConnected;

- (IBAction)closeModal:(id)sender;
- (void)clientConnected;

@end

@implementation CCEServerDetailModal

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    self.accessCodeField.stringValue = self.sessionCode;
    self.totalConnected = 0;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(clientConnected) name:@"clientConnected" object:nil];
}

- (IBAction)closeModal:(id)sender {
    [self.delegate serverDetailModalClosed];
}

- (void)clientConnected {
    self.totalConnected++;
    
    self.numberJoinedField.stringValue = [NSString stringWithFormat:@"%i of 4 maximum people have joined.", self.totalConnected];
}

@end
