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

- (IBAction)closeModal:(id)sender;

@end

@implementation CCEServerDetailModal

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    self.accessCodeField.stringValue = self.sessionCode;
}

- (IBAction)closeModal:(id)sender {
    [self.delegate serverDetailModalClosed];
}

@end
