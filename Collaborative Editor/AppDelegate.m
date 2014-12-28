//
//  AppDelegate.m
//  Collaborative Editor
//
//  Created by Kevin Li on 12/28/14.
//  Copyright (c) 2014 Kevin Li. All rights reserved.
//

#import "AppDelegate.h"
#import "CCEEditorViewController.h"
#import "CCEFooterBarViewController.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@property (nonatomic, strong) CCEEditorViewController *editorViewController;
@property (nonatomic, strong) CCEFooterBarViewController *footerViewController;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    
    // insert the editor view controller into the window
    self.editorViewController = [[CCEEditorViewController alloc]initWithNibName:@"CCEEditorViewController" bundle:nil];
    
    [self.window.contentView addSubview:self.editorViewController.view];
    [self.window.contentView setAutoresizesSubviews:YES];
    self.editorViewController.view.translatesAutoresizingMaskIntoConstraints = NO;

    // also insert the footer bar
    self.footerViewController = [[CCEFooterBarViewController alloc]initWithNibName:@"CCEFooterBarViewController" bundle:nil];
    [self.window.contentView addSubview:self.footerViewController.view];
    self.footerViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    
    // make subviews resize with window via autolayout constraints
    NSDictionary *viewsDictionary = @{@"editorView":self.editorViewController.view, @"footerView":self.footerViewController.view};
    NSArray *editorConstraintsH = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[editorView]-0-|" options:0 metrics:nil views:viewsDictionary];
    NSArray *footerConstraintsH = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[footerView]-0-|" options:0 metrics:nil views:viewsDictionary];
    NSArray *windowConstraintsV = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[editorView][footerView(30)]-0-|" options:0 metrics:nil views:viewsDictionary];

    [self.window.contentView addConstraints:editorConstraintsH];
    [self.window.contentView addConstraints:footerConstraintsH];
    [self.window.contentView addConstraints:windowConstraintsV];


}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end
