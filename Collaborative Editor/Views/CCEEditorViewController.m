//
//  CCEEditorViewController.m
//  Collaborative Editor
//
//  Created by Kevin Li on 12/28/14.
//  Copyright (c) 2014 Kevin Li. All rights reserved.
//

#import "CCEEditorViewController.h"

@interface CCEEditorViewController () {
    BOOL _firstLoad;
}

@property (weak) IBOutlet CCEWebView *editorView;

@property (nonatomic, strong) NSString *documentContents;

- (void)openDocument;

- (void)loadEditor;
- (void)changeSyntax:(NSString *)syntax;

@end

@implementation CCEEditorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    _firstLoad = YES;
    [self loadEditor];
    

}

- (void)openDocument {
    self.documentContents = [NSString stringWithContentsOfFile:self.documentPath encoding:NSUTF8StringEncoding error:nil];
    
    NSString *encodedData = [[self.documentContents dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn];
    
    NSString *execJs = [NSString stringWithFormat:@"editor.setValue(atob(\"%@\"));editor.selection.moveCursorTo(0,0);editor.selection.clearSelection();",encodedData];
    [self.editorView.windowScriptObject evaluateWebScript:execJs];
}

- (void)loadEditor {    
    NSString *appLocation = [[NSBundle mainBundle]pathForResource:@"web/editor/index" ofType:@"html"];
    [self.editorView setMainFrameURL:appLocation];
}

- (void)changeSyntax:(NSString *)syntax {
    NSString *execJs = [NSString stringWithFormat:@"editor.getSession().setMode(\"%@\");", syntax];
    [self.editorView.windowScriptObject evaluateWebScript:execJs];
}

#pragma mark - Footer bar delegate
- (void)footerChangedSyntax:(NSString *)syntax {
    [self changeSyntax:syntax];
}

#pragma mark - Webkit JS delegates
- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame {
    
    if (_firstLoad && self.documentPath) {
        // give it 200ms to finish executing, then load in the data
        [self performSelector:@selector(openDocument) withObject:nil afterDelay:0.2f];
    }
    
    _firstLoad = NO;
}
@end
