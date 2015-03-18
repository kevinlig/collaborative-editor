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
        self.originalText = @"";
        self.documentName = @"";
        self.userStates = [NSMutableDictionary dictionary];
        
        self.diffEngine = [[DiffMatchPatch alloc]init];
    }
    return self;
}


- (void)beginDiffQueue {
    // create the Realm DB in memory
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    // purge any existing items in the realm
    [realm beginWriteTransaction];
    [realm deleteAllObjects];
    [realm commitWriteTransaction];
    
    // create a sequence item representing the initial document
    CCERealmQueue *firstSequence = [[CCERealmQueue alloc]init];
    firstSequence.sequenceId = 1;
    firstSequence.documentText = self.originalText;
    firstSequence.diffs = [NSKeyedArchiver archivedDataWithRootObject:@[]];
    firstSequence.isOriginal = YES;
    
    self.currentSequenceId = 1;
    
    // write to the DB
    [realm beginWriteTransaction];
    [realm addObject:firstSequence];
    [realm commitWriteTransaction];

}

- (NSMutableArray *)diffToCurrentFrom:(int)sequenceId {
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    CCERealmQueue *lastItem = [CCERealmQueue objectForPrimaryKey:@(sequenceId)];
    CCERealmQueue *currentItem = [CCERealmQueue objectForPrimaryKey:@(self.currentSequenceId)];
    
    // calculate the diffs between the two strings
    NSMutableArray *diffs = [self.diffEngine diff_mainOfOldString:lastItem.documentText andNewString:currentItem.documentText];
    
    return diffs;
}

- (NSMutableArray *)addDiff:(NSMutableArray *)diff {
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    // fetch the current sequence from the queue
    CCERealmQueue *curentSequence = [CCERealmQueue objectForPrimaryKey:@(self.currentSequenceId)];
    
    NSString *currentText = curentSequence.documentText;
    
    // calculate the patch operations
    NSMutableArray *receivedPatches = [self.diffEngine patch_makeFromDiffs:diff];
    
    // apply the patches to the current document text
    NSString *newText = [[self.diffEngine patch_apply:receivedPatches toString:currentText] firstObject];
    
    // create a new diff sequence item and add it to the queue such that it will bring the last sequence in the queue up to the newly generated document text
    NSMutableArray *newDiffs = [self.diffEngine diff_mainOfOldString:currentText andNewString:newText];
    
    // create the DB object
    CCERealmQueue *newSequence = [[CCERealmQueue alloc]init];
    newSequence.sequenceId = self.currentSequenceId + 1;
    newSequence.documentText = [newText copy];
    newSequence.diffs = [NSKeyedArchiver archivedDataWithRootObject:newDiffs];
    
    // save it
    [realm beginWriteTransaction];
    [realm addObject:newSequence];
    [realm commitWriteTransaction];
    
    // increment the document's last sequence ID
    self.currentSequenceId++;
    
    self.originalText = newText;
    
    return newDiffs;
}

- (NSString *)forceTextToSequence:(int)sequenceId {
    
    // fetch the text at the specified sequence number
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    CCERealmQueue *targetSequence = [CCERealmQueue objectInRealm:realm forPrimaryKey:@(sequenceId)];
    
    return targetSequence.documentText;
}


@end
