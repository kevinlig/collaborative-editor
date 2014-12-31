//
//  CCEServerConfigModal.m
//  Collaborative Editor
//
//  Created by Kevin Li on 12/29/14.
//  Copyright (c) 2014 Kevin Li. All rights reserved.
//

#import "CCEServerConfigModal.h"

@interface CCEServerConfigModal () {
    BOOL _createNew;
}

@property (weak) IBOutlet NSButtonCell *blankRadio;
@property (weak) IBOutlet NSButtonCell *existingRadio;

@property (weak) IBOutlet NSButton *doneButton;
@property (weak) IBOutlet NSButton *openButton;

@property (weak) IBOutlet NSTextField *fileNameLabel;

@property (weak) IBOutlet NSTextField *displayNameField;

@property (nonatomic, strong) NSString *filePath;


- (IBAction)clickedCancel:(id)sender;
- (IBAction)clickedDone:(id)sender;

- (IBAction)clickedRadio:(id)sender;

- (IBAction)clickedOpen:(id)sender;

- (void)displayNameChanged:(NSTextField *)field;

@end

@implementation CCEServerConfigModal

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    _createNew = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(displayNameChanged:) name:NSControlTextDidChangeNotification object:nil];

}

- (IBAction)clickedRadio:(id)sender {

    NSButtonCell *clickedButton = [[sender cells]objectAtIndex:0];
    
    if (clickedButton == self.blankRadio) {
        if (self.blankRadio.state == 0) {
            self.blankRadio.state = 1;
            _createNew = YES;
        }
        else {
            self.existingRadio.state = 0;
            _createNew = YES;
        }
        
        if (![self.displayNameField.stringValue isEqualToString:@""]) {
            [self.doneButton setEnabled:YES];
        }
        
        [self.openButton setEnabled:NO];
        [self.openButton setHidden:YES];
        [self.fileNameLabel setHidden:YES];
    }
    else if (clickedButton == self.existingRadio) {
        if (self.existingRadio.state == 0) {
            self.existingRadio.state = 1;
            _createNew = NO;
        }
        else {
            self.blankRadio.state = 0;
            _createNew = NO;
        }
        
        if (self.filePath && ![self.displayNameField.stringValue isEqualToString:@""]) {
            [self.doneButton setEnabled:YES];
        }
        else {
            [self.doneButton setEnabled:NO];
        }

        [self.openButton setEnabled:YES];
        [self.openButton setHidden:NO];
        [self.fileNameLabel setHidden:NO];
    }
}

- (IBAction)clickedOpen:(id)sender {
    // show a file dialog
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    openPanel.canChooseFiles = YES;
    openPanel.canChooseDirectories = NO;
    openPanel.canCreateDirectories = NO;
    
    openPanel.title = @"Select a file";
    
    if ([openPanel runModal] == NSModalResponseOK) {
        self.filePath = openPanel.URL.path;
        self.fileNameLabel.stringValue = self.filePath.lastPathComponent;
        
        if (![self.displayNameField.stringValue isEqualToString:@""]) {
            [self.doneButton setEnabled:YES];
        }
    }
}

- (IBAction)clickedCancel:(id)sender {
    [self.delegate cancelServerModal];
}

- (IBAction)clickedDone:(id)sender {
    
    self.userName = self.displayNameField.stringValue;
    
    if (_createNew) {
        // create a new blank file
        [self.delegate createBlankDocument];
    }
    else {
        // open an existing file
        [self.delegate openDocumentAt:self.filePath];
    }
}

#pragma mark - Display name delegate
- (void)displayNameChanged:(NSTextField *)field {
    
    if (_createNew && ![self.displayNameField.stringValue isEqualToString:@""]) {
        [self.doneButton setEnabled:YES];
    }
    else if (self.filePath && ![self.displayNameField.stringValue isEqualToString:@""]) {
        [self.doneButton setEnabled:YES];
    }
    else {
        [self.doneButton setEnabled:NO];
    }
}

@end
