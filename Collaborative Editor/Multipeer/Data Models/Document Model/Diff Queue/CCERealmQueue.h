//
//  CCERealmQueue.h
//  Collaborative Editor
//
//  Created by Kevin Li on 3/17/15.
//  Copyright (c) 2015 Kevin Li. All rights reserved.
//

#import "RLMObject.h"

@interface CCERealmQueue : RLMObject

@property int sequenceId;
@property NSData *diffs;
@property NSString *documentText;
@property BOOL isOriginal;

@end
