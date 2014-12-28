//
//  CCEWebView.m
//  Collaborative Editor
//
//  Created by Kevin Li on 12/28/14.
//  Copyright (c) 2014 Kevin Li. All rights reserved.
//

#import "CCEWebView.h"

@implementation CCEWebView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (BOOL)performDragOperation:(id<NSDraggingInfo>)sender {
    // disable drag and drop operations into the web view
    return NO;
}

- (BOOL)prepareForDragOperation:(id<NSDraggingInfo>)sender {
    // don't allow drag and drop into the web view
    return NO;
}

- (NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender {
    // no drag operations allowed
    return NSDragOperationNone;
}

@end
