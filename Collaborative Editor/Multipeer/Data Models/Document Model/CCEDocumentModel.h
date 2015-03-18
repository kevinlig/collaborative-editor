//
//  CCEDocumentModel.h
//  Collaborative Editor
//
//  Created by Kevin Li on 1/4/15.
//  Copyright (c) 2015 Kevin Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Google-Diff-Match-Patch/DiffMatchPatch.h>
#import <Realm/Realm.h>
#import "CCERealmQueue.h"

@interface CCEDocumentModel : NSObject

/// @brief The original text of the document.
@property (nonatomic, copy) NSString *originalText;
/// @brief The document's name.
@property (nonatomic, copy) NSString *documentName;

@property int currentSequenceId;

@property (nonatomic, strong) NSMutableDictionary *userStates;


- (void)beginDiffQueue;

- (NSMutableArray *)diffToCurrentFrom:(int)sequenceId;
- (NSMutableArray *)addDiff:(NSMutableArray *)diff;

- (NSString *)forceTextToSequence:(int)sequenceId;

@end
