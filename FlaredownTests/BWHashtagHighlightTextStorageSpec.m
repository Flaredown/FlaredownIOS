//
//  BWHashtagHighlightTextStorageSpec.m
//  Flaredown
//
//  Created by joshua may on 14/03/2015.
//  Copyright 2015 Flaredown. All rights reserved.
//

#define EXP_SHORTHAND
#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <Expecta+Snapshots/EXPMatchers+FBSnapshotTest.h>

#import "FDHashtagFinder.h"
#import "FDHashtagHighlightTextStorage.h"

SpecBegin(BWHashtagHighlightTextStorage)

describe(@"BWHashtagHighlightTextStorage", ^{
    NSDictionary *hashtagAttributes = @{
                                        NSForegroundColorAttributeName: [UIColor greenColor],
                                        NSBackgroundColorAttributeName: [UIColor yellowColor],
                                        };
    
    it(@"should highlight hashtags in string", ^{
        FDHashtagHighlightTextStorage *textStorage = [[FDHashtagHighlightTextStorage alloc] initWithHashtagFinder:FDHashtagFinder.new];
        textStorage.hashtagAttributes = hashtagAttributes;

        [textStorage appendAttributedString:[[NSAttributedString alloc] initWithString:@"foo #bar baz q#ux"]];

        NSDictionary *attributes;

        // first section
        attributes = [textStorage.attributedString attributesAtIndex:0 effectiveRange:NULL];
        expect(attributes[NSForegroundColorAttributeName]).to.beNil;
        expect(attributes[NSBackgroundColorAttributeName]).to.beNil;

        // section section: hashtag
        attributes = [textStorage.attributedString attributesAtIndex:4 effectiveRange:NULL];
        expect(attributes[NSForegroundColorAttributeName]).to.equal(hashtagAttributes[NSForegroundColorAttributeName]);
        expect(attributes[NSBackgroundColorAttributeName]).to.equal(hashtagAttributes[NSBackgroundColorAttributeName]);

        // third section: back to normal
        attributes = [textStorage.attributedString attributesAtIndex:5 effectiveRange:NULL];
        expect(attributes[NSForegroundColorAttributeName]).to.beNil;
        expect(attributes[NSBackgroundColorAttributeName]).to.beNil;
    });
});

SpecEnd
