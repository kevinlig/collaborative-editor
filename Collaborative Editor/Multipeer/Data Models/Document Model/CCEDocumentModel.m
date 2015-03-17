//
//  CCEDocumentModel.m
//  Collaborative Editor
//
//  Created by Kevin Li on 1/4/15.
//  Copyright (c) 2015 Kevin Li. All rights reserved.
//

#import "CCEDocumentModel.h"

@implementation CCEDocumentModel

- (id)init {
    self = [super init];
    if (self) {
        self.originalText = @"";
        self.documentName = @"";
        self.userStates = [NSMutableDictionary dictionary];
    }
    return self;
}


@end
