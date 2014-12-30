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

- (void)loadEditor;
- (void)changeSyntax:(NSString *)syntax;

@end

@implementation CCEEditorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    [self loadEditor];

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

@end
