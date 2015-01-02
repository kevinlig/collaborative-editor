//
//  CCEJoinSessionModal.h
//  Collaborative Editor
//
//  Created by Kevin Li on 1/2/15.
//  Copyright (c) 2015 Kevin Li. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol CCEJoinSessionModalDelegate <NSObject>

/*!
 * @discussion Delegate method that is triggered when the Done button is clicked.
 * @param sessionCode The 4-digit access code entered by the user.
 * @param userName The displayable user name entered by the user.
 */
- (void)joinSessionModalWithSessionCode:(NSString *)sessionCode andUserName:(NSString *)userName;
/*!
 * @discussion Delegate method that is triggered when the Cancel button is clicked.
 */
- (void)joinSessionModalCancelled;

@end

@interface CCEJoinSessionModal : NSViewController

@property id<CCEJoinSessionModalDelegate> delegate;

/// @brief The spinner in the modal window.
@property (weak) IBOutlet NSProgressIndicator *spinner;

@end
