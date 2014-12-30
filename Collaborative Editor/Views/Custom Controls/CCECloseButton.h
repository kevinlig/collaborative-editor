//
//  CCECloseButton.h
//  Collaborative Editor
//
//  Created by Kevin Li on 12/29/14.
//  Copyright (c) 2014 Kevin Li. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface CCECloseButton : NSButton

/// @brief The image that is diplayed on the button in its standard state.
@property (nonatomic, strong) NSImage *primaryImage;
/// @brief The image that is displayed on the button when it is being hovered over/clicked.
@property (nonatomic, strong) NSImage *secondaryImage;

@end
