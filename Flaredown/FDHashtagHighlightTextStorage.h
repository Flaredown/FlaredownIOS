//
//  FDHashtagHighlightTextStorage.h
//  Flaredown
//
//  Created by joshua may on 14/03/2015.
//  Copyright (c) 2015 Flaredown. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FDHashtagFinder;

@interface FDHashtagHighlightTextStorage : NSTextStorage

- (instancetype)initWithHashtagFinder:(FDHashtagFinder *)hashtagFinder NS_DESIGNATED_INITIALIZER;

@property (nonatomic, strong, readonly) NSAttributedString *attributedString;

@property (nonatomic, strong) NSDictionary *hashtagAttributes;

@end
