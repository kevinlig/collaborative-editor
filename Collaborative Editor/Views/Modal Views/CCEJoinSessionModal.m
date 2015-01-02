//
//  CCEJoinSessionModal.m
//  Collaborative Editor
//
//  Created by Kevin Li on 1/2/15.
//  Copyright (c) 2015 Kevin Li. All rights reserved.
//

#import "CCEJoinSessionModal.h"

@interface CCEJoinSessionModal ()

@property (weak) IBOutlet NSTextField *sessionCodeField;
@property (weak) IBOutlet NSTextField *userNameField;

@property (weak) IBOutlet NSButton *doneButton;
@property (weak) IBOutlet NSButton *cancelButton;

- (IBAction)pressedCancel:(id)sender;
- (IBAction)pressedDone:(id)sender;

- (void)textFieldChanged;

@end

@implementation CCEJoinSessionModal

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged) name:NSControlTextDidChangeNotification object:nil];
    
    self.spinner.hidden = YES;
}

- (IBAction)pressedCancel:(id)sender {
    [self.delegate joinSessionModalCancelled];
}

- (IBAction)pressedDone:(id)sender {
    [self.delegate joinSessionModalWithSessionCode:self.sessionCodeField.stringValue andUserName:self.userNameField.stringValue];
    
    // start the spinner
    self.spinner.hidden = NO;
    [self.spinner startAnimation:self];
    
    self.doneButton.enabled = NO;
}

#pragma mark - Text field change event
- (void)textFieldChanged {
    if (self.sessionCodeField.stringValue.length == 4 && self.userNameField.stringValue.length > 1) {
        // ready to go
        self.doneButton.enabled = YES;
    }
    else {
        self.doneButton.enabled = NO;
    }
}

@end
