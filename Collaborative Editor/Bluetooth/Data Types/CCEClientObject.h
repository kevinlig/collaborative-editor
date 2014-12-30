//
//  CCEClientObject.h
//  Collaborative Editor
//
//  Created by Kevin Li on 12/28/14.
//  Copyright (c) 2014 Kevin Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCEClientObject : NSObject

@property (nonatomic, strong) NSString *uuid;
@property (nonatomic, strong) NSString *displayName;
@property (nonatomic, strong) NSString *colorCode;
@property BOOL isAlive;

@end
