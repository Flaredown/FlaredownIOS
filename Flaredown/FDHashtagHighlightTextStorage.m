//
//  FDHashtagHighlightTextStorage.m
//  Flaredown
//
//  Created by joshua may on 14/03/2015.
//  Copyright (c) 2015 Flaredown. All rights reserved.
//

#import "FDHashtagHighlightTextStorage.h"

#import "FDHashtagFinder.h"

@interface FDHashtagHighlightTextStorage ()

@property (nonatomic, strong) FDHashtagFinder *hashtagFinder;

@property (nonatomic, strong) NSMutableAttributedString *backingStore;

@end

@implementation FDHashtagHighlightTextStorage

- (instancetype)initWithHashtagFinder:(FDHashtagFinder *)hashtagFinder {
    self = [super init];

    if (self) {
        _hashtagFinder = hashtagFinder;

        _backingStore = NSMutableAttributedString.new;
    }

    return self;
}

- (NSString *)string {
    return self.backingStore.string;
}

- (NSDictionary *)attributesAtIndex:(NSUInteger)location effectiveRange:(NSRangePointer)range {
    return [self.backingStore attributesAtIndex:location
                                 effectiveRange:range];
}

- (void)replaceCharactersInRange:(NSRange)range withString:(NSString *)str {
    [self beginEditing];
    [self.backingStore replaceCharactersInRange:range withString:str];
    [self edited:NSTextStorageEditedCharacters | NSTextStorageEditedAttributes range:range changeInLength:str.length - range.length];
    [self endEditing];
}

- (void)setAttributes:(NSDictionary *)attrs range:(NSRange)range {
    [self beginEditing];
    [self.backingStore setAttributes:attrs range:range];
    [self edited:NSTextStorageEditedAttributes range:range changeInLength:0];
    [self endEditing];
}

- (void)processEditing {
    [self performReplacementsForRange:self.editedRange];

    [super processEditing];
}

- (void)performReplacementsForRange:(NSRange)changedRange
{
    NSRange extendedRange;
    extendedRange = NSUnionRange(changedRange, [self.backingStore.string lineRangeForRange:NSMakeRange(changedRange.location, 0)]);
    extendedRange = NSUnionRange(changedRange, [self.backingStore.string lineRangeForRange:NSMakeRange(NSMaxRange(changedRange), 0)]);

    NSAssert(self.hashtagAttributes, @"Attempting to add nil hashtag attributes");

    // reset style inside of extendedRange - pretty heavyhanded, but works
    for (NSString *key in self.hashtagAttributes) {
        [self removeAttribute:key range:extendedRange];
    }

    NSArray *ranges = [self.hashtagFinder rangesInString:self.backingStore.string range:extendedRange];
    [ranges enumerateObjectsUsingBlock:^(NSValue *range, NSUInteger idx, BOOL *stop) {
        [self addAttributes:self.hashtagAttributes range:range.rangeValue];
    }];
}

#pragma mark - API

- (NSAttributedString *)attributedString {
    return self.backingStore.copy;
}

@end
