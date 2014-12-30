//
//  CCEServerConfigModal.h
//  Collaborative Editor
//
//  Created by Kevin Li on 12/29/14.
//  Copyright (c) 2014 Kevin Li. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol CCEServerConfigModalDelegate <NSObject>

/*!
 * @discussion Start the server using a blank document.
 */
- (void)createBlankDocument;
/*!
 * @discussion Start the server using the contents of an existing file.
 * @param documentPath The path of the file.
 */
- (void)openDocumentAt:(NSString *)documentPath;
/*!
 * @discussion User changed their mind, canceling the modal instead of starting a server.
 */
- (void)cancelServerModal;

@end

@interface CCEServerConfigModal : NSViewController

@property id<CCEServerConfigModalDelegate> delegate;

@end
