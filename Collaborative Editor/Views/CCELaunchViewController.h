//
//  CCELaunchViewController.h
//  Collaborative Editor
//
//  Created by Kevin Li on 12/29/14.
//  Copyright (c) 2014 Kevin Li. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CCEServerConfigModal.h"

@protocol CCELaunchViewDelegate <NSObject>

/*!
 * @discussion Starts the server with a blank document.
 */
- (void)startBlankServer;
/*!
 * @discussion Starts the server using the contents of an existing file.
 * @param documentPath The file path of the target file.
 */
- (void)startDocumentServer: (NSString *)documentPath;

@end

@interface CCELaunchViewController : NSViewController <CCEServerConfigModalDelegate>

@property id<CCELaunchViewDelegate> delegate;

@end
