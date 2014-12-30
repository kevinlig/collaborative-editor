//
//  CCELaunchViewController.m
//  Collaborative Editor
//
//  Created by Kevin Li on 12/29/14.
//  Copyright (c) 2014 Kevin Li. All rights reserved.
//

#import "CCELaunchViewController.h"
#import "CCECloseButton.h"


@interface CCELaunchViewController ()

@property (weak) IBOutlet CCECloseButton *closeButton;
@property (nonatomic, strong) CCEServerConfigModal *serverConfigModal;

- (IBAction)closeWindow:(id)sender;
- (IBAction)startSession:(id)sender;
- (IBAction)joinSession:(id)sender;

@end

@implementation CCELaunchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    self.closeButton.primaryImage = [NSImage imageNamed:@"close"];
    self.closeButton.secondaryImage = [NSImage imageNamed:@"close_hover"];

}

- (IBAction)closeWindow:(id)sender {
    // quit the app
    [[NSApplication sharedApplication]terminate:self];
}

- (IBAction)startSession:(id)sender {
    
    // create a modal with server configuration options
    if (self.serverConfigModal) {
        self.serverConfigModal = nil;
    }
    self.serverConfigModal = [[CCEServerConfigModal alloc]initWithNibName:@"CCEServerConfigModal" bundle:nil];
    self.serverConfigModal.delegate = self;
    
    [self presentViewControllerAsSheet:self.serverConfigModal];
    
    
}
- (IBAction)joinSession:(id)sender {
    
}


#pragma mark - Server configuration modal delegate methods
- (void)cancelServerModal {
    [self dismissViewController:self.serverConfigModal];
}

- (void)createBlankDocument {
    [self dismissViewController:self.serverConfigModal];
    [self.delegate startBlankServer];
}

- (void)openDocumentAt:(NSString *)documentPath {
    [self dismissViewController:self.serverConfigModal];
    [self.delegate startDocumentServer:documentPath];
}

@end
