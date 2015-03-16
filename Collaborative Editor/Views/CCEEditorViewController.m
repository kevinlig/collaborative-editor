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

- (void)configureBridge;
- (void)loadEditor;
- (void)changeSyntax:(NSString *)syntax;

- (void)receivedUpdate;

@end

@implementation CCEEditorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    self.isServer = [CCETransmissionService sharedManager].isServer;
    
    [self loadEditor];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receivedUpdate) name:@"receivedUpdate" object:nil];
    
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

- (void)configureBridge {
    self.bridge = [WebViewJavascriptBridge bridgeForWebView:self.editorView handler:nil];
    
   

}

- (void)loadEditor {
    
    self.editorReady = NO;
    
    // setup a javascript bridge
    NSString *appLocation = [[NSBundle mainBundle]pathForResource:@"web/editor/index" ofType:@"html"];
    [self.editorView setMainFrameURL:appLocation];
    
    [self configureBridge];
    
    // setup handler for JS to call when it is fully loaded
    [self.bridge registerHandler:@"jsReady" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        self.editorReady = YES;
        
        // JS editor is ready, load a document if it is needed
        if (self.documentPath || !self.isServer) {
            // load the document
            [self openDocument];
        }
    }];
    
    // setup handlers
    [self.bridge registerHandler:@"changeCursor" handler:^(NSDictionary *cursorData, WVJBResponseCallback responseCallback) {
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
            [[CCETransmissionService sharedManager]transmitUpdate:cursorData];
        });
    }];
    
//    [self.bridge registerHandler:@"debug" handler:^(id data, WVJBResponseCallback callback) {
//        NSLog(@"%@",data);
//    }];
    
}

- (void)changeSyntax:(NSString *)syntax {
    if (self.editorReady) {
        [self.bridge callHandler:@"changeSyntax" data:syntax];
    }
}

- (void)receivedUpdate {
    NSDictionary *updatedDictionary = [CCETransmissionService sharedManager].slaveClient.lastUpdateData;
    [self.bridge callHandler:@"updateCursor" data:updatedDictionary];
}

#pragma mark - Editing style emulators
- (void)toggleVimMode {
    [self.bridge callHandler:@"toggleVim"];
}

- (void)toggleEmacsMode {
    [self.bridge callHandler:@"toggleEmacs"];
}

#pragma mark - Footer bar delegate
- (void)footerChangedSyntax:(NSString *)syntax {
    [self changeSyntax:syntax];
}

@end
