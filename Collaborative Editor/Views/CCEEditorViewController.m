//
//  CCEEditorViewController.m
//  Collaborative Editor
//
//  Created by Kevin Li on 12/28/14.
//  Copyright (c) 2014 Kevin Li. All rights reserved.
//

#import "CCEEditorViewController.h"
#import <Google-Diff-Match-Patch/DiffMatchPatch.h>
#import "Diff+Encoding.h"

@interface CCEEditorViewController ()

@property (weak) IBOutlet CCEWebView *editorView;

@property (atomic, copy) NSString *documentContents;
@property (atomic, copy) NSString *lastSeenContent;
@property (nonatomic, strong) WebViewJavascriptBridge *bridge;
@property BOOL isServer;

@property (atomic, strong) DiffMatchPatch *diffEngine;

@property (nonatomic, strong) dispatch_queue_t transmissionQueue;

@property BOOL textChanged;
@property int updateCount;

- (void)openDocument;

- (void)configureBridge;
- (void)loadEditor;
- (void)changeSyntax:(NSString *)syntax;

- (void)receivedUpdate;
- (void)receivedText;

@end

@implementation CCEEditorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    self.isServer = [CCETransmissionService sharedManager].isServer;
    
    self.diffEngine = [[DiffMatchPatch alloc]init];
    
    self.transmissionQueue = dispatch_queue_create("com.grumblus.cce.transmitqueue", DISPATCH_QUEUE_SERIAL);
    
    self.textChanged = NO;
    self.updateCount = 0;
    
    [self loadEditor];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receivedUpdate) name:@"receivedUpdate" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receivedText) name:@"updatedDocument" object:nil];
    
}

- (void)openDocument {
    if (self.isServer) {
        self.documentContents = [CCETransmissionService sharedManager].masterServer.document.currentText;
    }
    else {
        self.documentContents = [CCETransmissionService sharedManager].slaveClient.document.currentText;
    }
    self.lastSeenContent = self.documentContents;
    
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
    
//     setup handlers
/*    [self.bridge registerHandler:@"changeCursor" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"PUSH CURSOR CHANGE");
        NSDictionary *cursorData = [data copy];
        dispatch_async(self.transmissionQueue, ^(void) {
            [[CCETransmissionService sharedManager]transmitState:cursorData];
        });
    }];
    
    [self.bridge registerHandler:@"debug" handler:^(id data, WVJBResponseCallback callback) {
        NSLog(@"%@",data);
    }];
    
 
    */
    [self.bridge registerHandler:@"textChange" handler:^(id data, WVJBResponseCallback callback) {
        
        NSString *currentText = [data objectForKey:@"text"];
        NSDictionary *cursorState = [[data objectForKey:@"cursor"] copy];
        

        // at least one change has occurred during the past two update cycles, calculate the diff
        NSString *oldString = [self.documentContents copy];
        NSString *newString = [currentText copy];
        
        self.documentContents = currentText;
        self.lastSeenContent = self.documentContents;
        
        dispatch_async(self.transmissionQueue, ^{
            
            NSMutableArray *diffs = [self.diffEngine diff_mainOfOldString:oldString andNewString:newString];
            
            [[CCETransmissionService sharedManager]transmitDiff:diffs andState:cursorState];
            
        });
        
    }];
    
    [self.bridge registerHandler:@"currentText" handler:^(id data, WVJBResponseCallback callback) {
        
        self.lastSeenContent = [data objectForKey:@"text"];
        
    }];
    
}

- (void)changeSyntax:(NSString *)syntax {
    if (self.editorReady) {
        [self.bridge callHandler:@"changeSyntax" data:syntax];
    }
}

- (void)receivedUpdate {
    NSArray *currentDocumentState;
    if (self.isServer) {
        currentDocumentState = [CCETransmissionService sharedManager].masterServer.currentState;
    }
    else {
        currentDocumentState = [CCETransmissionService sharedManager].slaveClient.currentState;
    }

    dispatch_async(dispatch_get_main_queue(), ^{
            [self.bridge callHandler:@"updateCursor" data:currentDocumentState];
    });

}

- (void)receivedText {
    
    NSString *proposedString;
    
    if (self.isServer) {
        proposedString = [CCETransmissionService sharedManager].masterServer.document.currentText;
    }
    else {
        proposedString = [CCETransmissionService sharedManager].slaveClient.document.currentText;
    }

    if (![self.lastSeenContent isEqualToString:self.documentContents]) {
        NSLog(@"merge");
        // content has changed since the last contact with the server
        // merge the received string from the server with the current text on screen
        NSMutableArray *patches = [self.diffEngine patch_makeFromOldString:self.lastSeenContent andNewString:proposedString];
        self.documentContents = [[self.diffEngine patch_apply:patches toString:self.lastSeenContent]objectAtIndex:0];
        self.lastSeenContent = self.documentContents;
    }
    else {
        self.documentContents = proposedString;
    }

    
    self.textChanged = NO;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.bridge callHandler:@"pushText" data:self.documentContents];
    });
    
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
