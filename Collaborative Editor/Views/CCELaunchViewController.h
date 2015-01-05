//
//  CCELaunchViewController.h
//  Collaborative Editor
//
//  Created by Kevin Li on 12/29/14.
//  Copyright (c) 2014 Kevin Li. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CCEServerConfigModal.h"
#import "CCEServerDetailModal.h"
#import "CCEJoinSessionModal.h"

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

/*!
 * @discussion Launch the editor window as a client.
 */
- (void)startDocumentClient;

@end

@interface CCELaunchViewController : NSViewController <CCEServerConfigModalDelegate, CCEServerDetailModalDelegate, CCEJoinSessionModalDelegate>

@property id<CCELaunchViewDelegate> delegate;

/// @brief The user name that will displayed to other users.
@property (nonatomic, strong) NSString *userName;

@end
