//
//  FDHashtagTextView.m
//  Flaredown
//
//  Created by joshua may on 14/03/2015.
//  Copyright (c) 2015 Flaredown. All rights reserved.
//

#import "FDHashtagTextView.h"

#import "FDHashtagFinder.h"
#import "FDHashtagHighlightTextStorage.h"

@implementation FDHashtagTextView

- (instancetype)initWithFrame:(CGRect)frame {
    FDHashtagHighlightTextStorage *textStorage = [[FDHashtagHighlightTextStorage alloc] initWithHashtagFinder:FDHashtagFinder.new];
    textStorage.hashtagAttributes = @{
                                      NSForegroundColorAttributeName: [UIColor blueColor],
                                      };

    NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
    NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:CGSizeMake(frame.size.width,  CGFLOAT_MAX)];

    [layoutManager addTextContainer:textContainer];
    [textStorage addLayoutManager:layoutManager];

    return [self initWithFrame:frame textContainer:textContainer];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    NSAssert(NO, @"IB can't be used. Must be instantiated in code, so `.textContainer` can be injected");
    return nil;
}

@end
