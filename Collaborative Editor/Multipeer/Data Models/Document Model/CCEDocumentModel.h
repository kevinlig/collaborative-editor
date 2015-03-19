//
//  CCEDocumentModel.h
//  Collaborative Editor
//
//  Created by Kevin Li on 1/4/15.
//  Copyright (c) 2015 Kevin Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Google-Diff-Match-Patch/DiffMatchPatch.h>

@interface CCEDocumentModel : NSObject

/// @brief The original text of the document.
@property (nonatomic, copy) NSString *currentText;
/// @brief Holds the text received from the server, but not yet merged with the document.
@property (nonatomic, copy) NSString *proposedText;
/// @brief The document's name.
@property (nonatomic, copy) NSString *documentName;

@property int currentSequenceId;

@property (nonatomic, strong) NSMutableDictionary *userStates;


- (NSMutableArray *)addDiff:(NSMutableArray *)diff;

@end
