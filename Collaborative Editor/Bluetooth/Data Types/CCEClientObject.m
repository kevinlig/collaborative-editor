//
//  CCEClientObject.m
//  Collaborative Editor
//
//  Created by Kevin Li on 12/28/14.
//  Copyright (c) 2014 Kevin Li. All rights reserved.
//

#import "CCEClientObject.h"

@implementation CCEClientObject

- (id)init {
    self = [super init];
    if (self) {
        self.uuid = @"";
        self.displayName = @"";
        self.colorCode = @"FFFFFF";
        self.isAlive = NO;
    }
    return self;
}

@end
