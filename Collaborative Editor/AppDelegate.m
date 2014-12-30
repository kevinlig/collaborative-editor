//
//  AppDelegate.m
//  Collaborative Editor
//
//  Created by Kevin Li on 12/28/14.
//  Copyright (c) 2014 Kevin Li. All rights reserved.
//

#import "AppDelegate.h"
#import "CCELaunchWindow.h"
#import "CCEEditorViewController.h"
#import "CCEFooterBarViewController.h"
#import "CCELaunchViewController.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@property (weak) IBOutlet CCELaunchWindow *launchWindow;
@property (nonatomic, strong) CCELaunchViewController *launchViewController;
@property (nonatomic, strong) CCEEditorViewController *editorViewController;
@property (nonatomic, strong) CCEFooterBarViewController *footerViewController;

- (void) displayEditorWindow;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    
    // display the launch window and center it in the screen
//    float launchHeight = 480;
//    float launchWidth = 700;
//    CGFloat xPos = NSWidth([[self.launchWindow screen] frame])/2 - launchWidth/2;
//    CGFloat yPos = NSHeight([[self.launchWindow screen] frame])/2 - launchHeight/2;
//    [self.launchWindow setFrame:NSMakeRect(xPos, yPos, launchWidth, launchHeight) display:YES];
//    
//    // add in the launch view controller
//    self.launchViewController = [[CCELaunchViewController alloc]initWithNibName:@"CCELaunchViewController" bundle:nil];
//    [self.launchWindow.contentView addSubview:self.launchViewController.view];
//    self.launchViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
//    
//    NSDictionary *launchViewsDictionary = @{@"launchView":self.launchViewController.view};
//    NSArray *launchConstraintsH = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[launchView]-0-|" options:0 metrics:nil views:launchViewsDictionary];
//    NSArray *launchConstraintsV = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[launchView]-0-|" options:0 metrics:nil views:launchViewsDictionary];
//    [self.launchWindow.contentView addConstraints:launchConstraintsH];
//    [self.launchWindow.contentView addConstraints:launchConstraintsV];
    
    [self displayEditorWindow];

}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
    [[NSNotificationCenter defaultCenter]postNotificationName:@"appKill" object:nil];
}

- (void) displayEditorWindow {
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
    
    // hook the footer bar delegate up to the editor view to allow for cross-view communication
    self.footerViewController.delegate = self.editorViewController;
}

@end
