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

@property (weak) IBOutlet NSPopUpButton *syntaxDropdown;
@property (nonatomic, strong) NSDictionary *syntaxList;

- (IBAction)startServer:(id)sender;

- (void)populateSyntaxList;
- (IBAction)changeSyntax:(id)sender;

@end

@implementation CCEFooterBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    self.syntaxList = @{@"Objective-C": @"ace/mode/objectivec", @"JavaScript": @"ace/mode/javascript", @"PHP": @"ace/mode/php"};
    
    [self populateSyntaxList];
}

- (void)populateSyntaxList {


    NSMenu *syntaxMenu = self.syntaxDropdown.menu;
    
    for (NSString *syntax in self.syntaxList) {
        [syntaxMenu addItemWithTitle:syntax action:nil keyEquivalent:@""];
    }
}

- (IBAction)changeSyntax:(id)sender {
    NSString *displayTitle = self.syntaxDropdown.selectedItem.title;
    NSString *aceValue = [self.syntaxList objectForKey:displayTitle];
    [self.delegate footerChangedSyntax:aceValue];
}

- (IBAction)startServer:(id)sender {
    [[CCETransmissionService sharedManager]startServer];
}

@end
