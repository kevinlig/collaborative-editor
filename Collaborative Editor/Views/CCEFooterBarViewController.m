//
//  CCEFooterBarViewController.m
//  Collaborative Editor
//
//  Created by Kevin Li on 12/28/14.
//  Copyright (c) 2014 Kevin Li. All rights reserved.
//

#import "CCEFooterBarViewController.h"
#import "CCETransmissionService.h"

@interface CCEFooterBarViewController ()

- (IBAction)startServer:(id)sender;

@end

@implementation CCEFooterBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

- (IBAction)startServer:(id)sender {
    [[CCETransmissionService sharedManager]startServer];
}

@end
