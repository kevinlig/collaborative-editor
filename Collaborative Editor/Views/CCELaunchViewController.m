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
    
}
- (IBAction)joinSession:(id)sender {
    
}

@end
