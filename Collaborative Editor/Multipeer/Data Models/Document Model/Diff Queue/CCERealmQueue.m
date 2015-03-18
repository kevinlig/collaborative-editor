//
//  CCERealmQueue.m
//  Collaborative Editor
//
//  Created by Kevin Li on 3/17/15.
//  Copyright (c) 2015 Kevin Li. All rights reserved.
//

#import "CCERealmQueue.h"

@implementation CCERealmQueue

+ (NSString *)primaryKey {
    return @"sequenceId";
}


+ (NSDictionary *)defaultPropertyValues {
    return @{
             @"isOriginal": @(NO)
        };
}

@end
