//
//  CCELaunchWindow.m
//  Collaborative Editor
//
//  Created by Kevin Li on 12/29/14.
//  Copyright (c) 2014 Kevin Li. All rights reserved.
//

// based on https://developer.apple.com/library/mac/samplecode/RoundTransparentWindow/Listings/Classes_CustomWindow_m.html

#import "CCELaunchWindow.h"

@interface CCELaunchWindow ()

@property (assign) NSPoint initialLocation;

@end

@implementation CCELaunchWindow

- (id)initWithContentRect:(NSRect)contentRect styleMask:(NSUInteger)aStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag {
    
    self = [super initWithContentRect:contentRect styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:NO];
    
    if (self) {
        self.alphaValue = 1.0f;
        self.backgroundColor = [NSColor clearColor];
        self.opaque = NO;
    }
    
    return self;
}

/*
 Make the window have rounded corners
 */

- (void)setContentView:(NSView *)contentView {

    contentView.wantsLayer = YES;
    contentView.layer.frame = contentView.frame;
    contentView.layer.cornerRadius = 5.0f;
    contentView.layer.borderWidth = 0.0f;
    contentView.layer.masksToBounds = YES;
    
    [super setContentView:contentView];
}

- (BOOL)canBecomeKeyWindow {
    return YES;
}

- (void)mouseDown:(NSEvent *)theEvent {
    self.initialLocation = theEvent.locationInWindow;
}

- (void)mouseDragged:(NSEvent *)theEvent {
    NSRect screenVisibleFrame = [[NSScreen mainScreen] visibleFrame];
    NSRect windowFrame = [self frame];
    NSPoint newOrigin = windowFrame.origin;
    
    // Get the mouse location in window coordinates.
    NSPoint currentLocation = [theEvent locationInWindow];
    // Update the origin with the difference between the new mouse location and the old mouse location.
    newOrigin.x += (currentLocation.x - self.initialLocation.x);
    newOrigin.y += (currentLocation.y - self.initialLocation.y);
    
    // Don't let window get dragged up under the menu bar
    if ((newOrigin.y + windowFrame.size.height) > (screenVisibleFrame.origin.y + screenVisibleFrame.size.height)) {
        newOrigin.y = screenVisibleFrame.origin.y + (screenVisibleFrame.size.height - windowFrame.size.height);
    }
    
    // Move the window to the new location
    [self setFrameOrigin:newOrigin];
}

@end
