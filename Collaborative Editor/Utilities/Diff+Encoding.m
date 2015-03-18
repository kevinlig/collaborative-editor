//
//  Diff+Encoding.m
//  Collaborative Editor
//
//  Created by Kevin Li on 3/17/15.
//  Copyright (c) 2015 Kevin Li. All rights reserved.
//

#import "Diff+Encoding.h"

@implementation Diff (CCEEncoding)

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    
    
    self.operation = [decoder decodeIntForKey:@"operation"];
    self.text = [decoder decodeObjectForKey:@"text"];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    
    [encoder encodeInt:self.operation forKey:@"operation"];
    [encoder encodeObject:self.text forKey:@"text"];
    
}


@end
