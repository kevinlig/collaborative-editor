//
//  CCEDocumentModel.h
//  Collaborative Editor
//
//  Created by Kevin Li on 1/4/15.
//  Copyright (c) 2015 Kevin Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCEDocumentModel : NSObject

/// @brief The original text of the document.
@property (nonatomic, strong) NSString *originalText;
/// @brief The document's name.
@property (nonatomic, strong) NSString *documentName;

@property (nonatomic, strong) NSMutableDictionary *userStates;

@end
