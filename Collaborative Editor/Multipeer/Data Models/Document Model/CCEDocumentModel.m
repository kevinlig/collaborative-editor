//
//  CCEDocumentModel.m
//  Collaborative Editor
//
//  Created by Kevin Li on 1/4/15.
//  Copyright (c) 2015 Kevin Li. All rights reserved.
//

#import "CCEDocumentModel.h"

#define REALM_IDENTIFIER @"com.grumblus.cce.docrealm"

@interface CCEDocumentModel ()

@property (nonatomic, strong) DiffMatchPatch *diffEngine;

@end

@implementation CCEDocumentModel

- (id)init {
    self = [super init];
    if (self) {
        self.currentText = @"";
        self.documentName = @"";
        self.userStates = [NSMutableDictionary dictionary];
        
        self.diffEngine = [[DiffMatchPatch alloc]init];
        
        self.currentSequenceId = 1;
    }
    return self;
}


- (NSMutableArray *)addDiff:(NSMutableArray *)diff {
    
    // calculate the patch operations
    NSMutableArray *receivedPatches = [self.diffEngine patch_makeFromDiffs:diff];
    
    // apply the patches to the current document text
    NSString *newText = [[self.diffEngine patch_apply:receivedPatches toString:self.currentText] firstObject];
    
    // create a new diff sequence item and add it to the queue such that it will bring the last sequence in the queue up to the newly generated document text
    NSMutableArray *newDiffs = [self.diffEngine diff_mainOfOldString:self.currentText andNewString:newText];
    
    // increment the document's last sequence ID
    self.currentSequenceId++;
    
    self.currentText = newText;
    
    return newDiffs;
}


@end
