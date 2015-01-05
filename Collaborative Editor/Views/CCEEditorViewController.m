//
//  CCEEditorViewController.m
//  Collaborative Editor
//
//  Created by Kevin Li on 12/28/14.
//  Copyright (c) 2014 Kevin Li. All rights reserved.
//

#import "CCEEditorViewController.h"

@interface CCEEditorViewController ()

@property (weak) IBOutlet CCEWebView *editorView;

@property (nonatomic, strong) NSString *documentContents;
@property (nonatomic, strong) WebViewJavascriptBridge *bridge;
@property BOOL isServer;

- (void)openDocument;

- (void) configureBridge;
- (void)loadEditor;
- (void)changeSyntax:(NSString *)syntax;

@end

@implementation CCEEditorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    self.isServer = [CCETransmissionService sharedManager].isServer;
    
    [self loadEditor];

}

- (void)openDocument {
    if (self.isServer) {
        self.documentContents = [CCETransmissionService sharedManager].masterServer.document.originalText;
    }
    else {
        self.documentContents = [CCETransmissionService sharedManager].slaveClient.document.originalText;
    }
    
    [self.bridge callHandler:@"pushFullDocument" data:self.documentContents];

}

- (void) configureBridge {
    self.bridge = [WebViewJavascriptBridge bridgeForWebView:self.editorView handler:nil];

}

- (void)loadEditor {
    
    self.editorReady = NO;
    
    // setup a javascript bridge
    NSString *appLocation = [[NSBundle mainBundle]pathForResource:@"web/editor/index" ofType:@"html"];
    [self.editorView setMainFrameURL:appLocation];
    
    [self configureBridge];
    
    // setup handler to JS to call when it is fully loaded
    [self.bridge registerHandler:@"jsReady" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        self.editorReady = YES;
        
        // JS editor is ready, load a document if it is needed
        if (self.documentPath || !self.isServer) {
            // load the document
            [self openDocument];
        }
    }];
}

- (void)changeSyntax:(NSString *)syntax {
    if (self.editorReady) {
        [self.bridge callHandler:@"changeSyntax" data:syntax];
    }
}

#pragma mark - Footer bar delegate
- (void)footerChangedSyntax:(NSString *)syntax {
    [self changeSyntax:syntax];
}

@end
