//
//  CCEFooterBarViewController.h
//  Collaborative Editor
//
//  Created by Kevin Li on 12/28/14.
//  Copyright (c) 2014 Kevin Li. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol CCEFooterBarDelegate <NSObject>

/*!
 * @discussion Delegate method triggered when the user changes the document syntax type from the footer dropdown menu.
 * @param syntax The newly selected syntax, as expected by the Ace editor.
 */
- (void)footerChangedSyntax:(NSString *)syntax;

@end

@interface CCEFooterBarViewController : NSViewController

@property id<CCEFooterBarDelegate> delegate;

@end
