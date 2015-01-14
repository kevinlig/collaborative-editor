//
//  CCEEditorViewController.h
//  Collaborative Editor
//
//  Created by Kevin Li on 12/28/14.
//  Copyright (c) 2014 Kevin Li. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
#import "CCETransmissionService.h"
#import "CCEWebView.h"
#import "CCEFooterBarViewController.h"
#import "WebViewJavascriptBridge.h"

@interface CCEEditorViewController : NSViewController <CCEFooterBarDelegate>

/// @brief The file path of the file to load (may be nil if using a blank document).
@property (nonatomic, strong) NSString *documentPath;

/// @brief Indicates whether the JS editor has been fully loaded and can receive commands.
@property BOOL editorReady;

/*!
 * @discussion Toggles Vim mode in editor.
 */
- (void)toggleVimMode;

/*!
 * @discussion Toggles Emacs mode in editor.
 */
- (void)toggleEmacsMode;

@end
