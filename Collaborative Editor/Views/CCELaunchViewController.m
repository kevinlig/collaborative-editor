//
//  CCELaunchViewController.m
//  Collaborative Editor
//
//  Created by Kevin Li on 12/29/14.
//  Copyright (c) 2014 Kevin Li. All rights reserved.
//

#import "CCELaunchViewController.h"
#import "CCECloseButton.h"
#import "CCETransmissionService.h"

@interface CCELaunchViewController () {
    BOOL _createNew;
    NSString *_docPath;
}

@property (weak) IBOutlet CCECloseButton *closeButton;
@property (nonatomic, strong) CCEServerConfigModal *serverConfigModal;
@property (nonatomic, strong) CCEServerDetailModal *serverDetailModal;

- (IBAction)closeWindow:(id)sender;
- (IBAction)startSession:(id)sender;
- (IBAction)joinSession:(id)sender;

- (void)displayServerDetailModal;

@end

@implementation CCELaunchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    _createNew = YES;
    
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

- (void)displayServerDetailModal {
    
    // create a modal with server configuration options
    if (self.serverDetailModal) {
        self.serverDetailModal = nil;
    }
    self.serverDetailModal = [[CCEServerDetailModal alloc]initWithNibName:@"CCEServerDetailModal" bundle:nil];
    self.serverDetailModal.delegate = self;
    self.serverDetailModal.sessionCode =[[CCETransmissionService sharedManager]masterServer].sessionCode;
    
    [self presentViewControllerAsSheet:self.serverDetailModal];
    
}


#pragma mark - Server configuration modal delegate methods
- (void)cancelServerModal {
    [self dismissViewController:self.serverConfigModal];
}

- (void)createBlankDocument {
    self.userName = self.serverConfigModal.userName;
    [self dismissViewController:self.serverConfigModal];
    
    // start the server
    [[CCETransmissionService sharedManager]setUserName:self.userName];
    [[CCETransmissionService sharedManager]startServer];
    
    [self displayServerDetailModal];
    
    _createNew = YES;
}

- (void)openDocumentAt:(NSString *)documentPath {
    self.userName = self.serverConfigModal.userName;    
    [self dismissViewController:self.serverConfigModal];
    
    // start the server
    [[CCETransmissionService sharedManager]setUserName:self.userName];
    [[CCETransmissionService sharedManager]startServer];
    
    [self displayServerDetailModal];
    
    _createNew = NO;
    _docPath = documentPath;
}

#pragma mark - Server detail modal delegate methods
- (void)serverDetailModalClosed {
    if (_createNew) {
        [self.delegate startBlankServer];
    }
    else {
        [self.delegate startDocumentServer:_docPath];
    }
}

@end
