//
//  CCEFooterBarViewController.h
//  Collaborative Editor
//
//  Created by Kevin Li on 12/28/14.
//  Copyright (c) 2014 Kevin Li. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol CCEFooterBarDelegate <NSObject>

- (void)footerChangedSyntax:(NSString *)syntax;

@end

@interface CCEFooterBarViewController : NSViewController

@property id<CCEFooterBarDelegate> delegate;

@end
