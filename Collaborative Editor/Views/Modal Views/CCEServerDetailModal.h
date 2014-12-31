//
//  CCEServerDetailModal.h
//  Collaborative Editor
//
//  Created by Kevin Li on 12/30/14.
//  Copyright (c) 2014 Kevin Li. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol CCEServerDetailModalDelegate <NSObject>

/*!
 * @discussion Delegate method triggered when the modal is closed
 */
- (void)serverDetailModalClosed;

@end

@interface CCEServerDetailModal : NSViewController

@property id<CCEServerDetailModalDelegate> delegate;


/// @brief The access code required to enter the session.
@property (nonatomic, strong) NSString *sessionCode;

@end
