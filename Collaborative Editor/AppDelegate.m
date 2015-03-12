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
#import "CCEUserListviewController.h"
#import "CCEFooterBarViewController.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@property (weak) IBOutlet CCELaunchWindow *launchWindow;
@property (nonatomic, strong) CCELaunchViewController *launchViewController;
@property (nonatomic, strong) CCEEditorViewController *editorViewController;
@property (nonatomic, strong) CCEUserListViewController *userListViewController;
@property (nonatomic, strong) CCEFooterBarViewController *footerViewController;

- (void) displayEditorWindowUsingDocument:(NSString *)documentPath;

- (IBAction)toggleVim:(id)sender;
- (IBAction)toggleEmacs:(id)sender;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    
    // display user notifications
    [[NSUserNotificationCenter defaultUserNotificationCenter] setDelegate:self];
    
    // display the launch window and center it in the screen
    float launchHeight = 480;
    float launchWidth = 700;
    CGFloat xPos = NSWidth([[self.launchWindow screen] frame])/2 - launchWidth/2;
    CGFloat yPos = NSHeight([[self.launchWindow screen] frame])/2 - launchHeight/2;
    [self.launchWindow setFrame:NSMakeRect(xPos, yPos, launchWidth, launchHeight) display:YES];
    
    // add in the launch view controller
    self.launchViewController = [[CCELaunchViewController alloc]initWithNibName:@"CCELaunchViewController" bundle:nil];
    [self.launchWindow.contentView addSubview:self.launchViewController.view];
    self.launchViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary *launchViewsDictionary = @{@"launchView":self.launchViewController.view};
    NSArray *launchConstraintsH = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[launchView]-0-|" options:0 metrics:nil views:launchViewsDictionary];
    NSArray *launchConstraintsV = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[launchView]-0-|" options:0 metrics:nil views:launchViewsDictionary];
    [self.launchWindow.contentView addConstraints:launchConstraintsH];
    [self.launchWindow.contentView addConstraints:launchConstraintsV];
    
    self.launchViewController.delegate = self;

}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
    [[NSNotificationCenter defaultCenter]postNotificationName:@"appKill" object:nil];
}

- (void) displayEditorWindowUsingDocument:(NSString *)documentPath {
    
    // open the window in the center of the screen
    float launchHeight = 700;
    float launchWidth = 900;
    CGFloat xPos = NSWidth([[self.window screen] frame])/2 - launchWidth/2;
    CGFloat yPos = NSHeight([[self.window screen] frame])/2 - launchHeight/2;
    [self.window setFrame:NSMakeRect(xPos, yPos, launchWidth, launchHeight) display:YES];
    
    if ([CCETransmissionService sharedManager].isServer) {
        if (documentPath) {
            [self.window setTitle:[NSString stringWithFormat:@"Collaborative Editor - %@",documentPath.lastPathComponent]];
        }
    }
    else {
        // check to see if there's a document title
        if (![[CCETransmissionService sharedManager].slaveClient.document.documentName isEqualToString:@""]) {
            // there is a title, set it
            [self.window setTitle:[NSString stringWithFormat:@"Collaborative Editor - %@",[CCETransmissionService sharedManager].slaveClient.document.documentName]];
        }
    }
    
    // insert the editor view controller into the window
    self.editorViewController = [[CCEEditorViewController alloc]initWithNibName:@"CCEEditorViewController" bundle:nil];
    self.editorViewController.documentPath = documentPath;
    
    [self.window.contentView addSubview:self.editorViewController.view];
    [self.window.contentView setAutoresizesSubviews:YES];
    self.editorViewController.view.translatesAutoresizingMaskIntoConstraints = NO;

    // also insert the footer bar
    self.footerViewController = [[CCEFooterBarViewController alloc]initWithNibName:@"CCEFooterBarViewController" bundle:nil];
    [self.window.contentView addSubview:self.footerViewController.view];
    self.footerViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    
    // insert the user list
    self.userListViewController = [[CCEUserListViewController alloc]initWithNibName:@"CCEUserListViewController" bundle:nil];
    [self.window.contentView addSubview:self.userListViewController.view];
    self.userListViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    
    // make subviews resize with window via autolayout constraints
    NSDictionary *viewsDictionary = @{@"editorView":self.editorViewController.view, @"userListView":self.userListViewController.view, @"footerView":self.footerViewController.view};
    NSArray *editorConstraintsH = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[editorView][userListView(150)]-0-|" options:0 metrics:nil views:viewsDictionary];
    NSArray *footerConstraintsH = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[footerView]-0-|" options:0 metrics:nil views:viewsDictionary];
    NSArray *windowConstraintsV = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[editorView][footerView(30)]-0-|" options:0 metrics:nil views:viewsDictionary];
    
    [self.window.contentView addConstraints:editorConstraintsH];
    [self.window.contentView addConstraints:footerConstraintsH];
    [self.window.contentView addConstraints:windowConstraintsV];
    
    // hook the footer bar delegate up to the editor view to allow for cross-view communication
    self.footerViewController.delegate = self.editorViewController;
    
    [self.window makeKeyAndOrderFront:self];
    [NSApp activateIgnoringOtherApps:YES];
}

#pragma mark - Editing style emulators
- (IBAction)toggleVim:(id)sender {
    if (self.editorViewController) {
        [self.editorViewController toggleVimMode];
    }
}

- (IBAction)toggleEmacs:(id)sender {
    if (self.editorViewController) {
        [self.editorViewController toggleEmacsMode];
    }
}

#pragma mark - Launch view delegate methods
- (void)startBlankServer {
    [self.launchWindow close];
    [self displayEditorWindowUsingDocument:nil];
}

- (void)startDocumentServer: (NSString *)documentPath {
    [self.launchWindow close];
    [self displayEditorWindowUsingDocument:documentPath];
}

- (void)startDocumentClient {
    [self.launchWindow close];
    // there's a big where sometimes this is executed on a background thread, force it to the main thread since it's UI/webview
    dispatch_async(dispatch_get_main_queue(), ^{
        [self displayEditorWindowUsingDocument:nil];
    });
}

#pragma mark - Notification center delegate
- (BOOL)userNotificationCenter:(NSUserNotificationCenter *)center shouldPresentNotification:(NSUserNotification *)notification{
    return YES;
}

@end
