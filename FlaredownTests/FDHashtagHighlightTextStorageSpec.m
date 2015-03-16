//
//  FDHashtagHighlightTextStorageSpec.m
//  Flaredown
//
//  Created by joshua may on 14/03/2015.
//  Copyright 2015 Flaredown. All rights reserved.
//

#define EXP_SHORTHAND
#import <Specta/Specta.h>
#import <Expecta/Expecta.h>

#import "FDHashtagFinder.h"
#import "FDHashtagHighlightTextStorage.h"

SpecBegin(FDHashtagHighlightTextStorage)

describe(@"FDHashtagHighlightTextStorage", ^{
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
        expect(attributes[NSForegroundColorAttributeName]).to.beNil();
        expect(attributes[NSBackgroundColorAttributeName]).to.beNil();

        // section section: hashtag
        attributes = [textStorage.attributedString attributesAtIndex:4 effectiveRange:NULL];
        expect(attributes[NSForegroundColorAttributeName]).to.equal(hashtagAttributes[NSForegroundColorAttributeName]);
        expect(attributes[NSBackgroundColorAttributeName]).to.equal(hashtagAttributes[NSBackgroundColorAttributeName]);

        // third section: back to normal
        attributes = [textStorage.attributedString attributesAtIndex:8 effectiveRange:NULL];
        expect(attributes[NSForegroundColorAttributeName]).to.beNil();
        expect(attributes[NSBackgroundColorAttributeName]).to.beNil();
    });

    it(@"should unhighlight hashtags when space added in existing hashtag", ^{
        FDHashtagHighlightTextStorage *textStorage = [[FDHashtagHighlightTextStorage alloc] initWithHashtagFinder:FDHashtagFinder.new];
        textStorage.hashtagAttributes = hashtagAttributes;

        NSDictionary *attributes;

        // before, should have colour
        [textStorage appendAttributedString:[[NSAttributedString alloc] initWithString:@"foo #barstool #baz q#ux"]];

        attributes = [textStorage.attributedString attributesAtIndex:9 effectiveRange:NULL];
        expect(attributes[NSForegroundColorAttributeName]).to.equal(hashtagAttributes[NSForegroundColorAttributeName]);
        expect(attributes[NSBackgroundColorAttributeName]).to.equal(hashtagAttributes[NSBackgroundColorAttributeName]);

        // after, colour boundaries should end after hashtag until next hashtag
        [textStorage replaceCharactersInRange:NSMakeRange(6, 0) withString:@" "];

        expect(textStorage.attributedString.string).to.equal(@"foo #b arstool #baz q#ux");
        //                                                     012345678901234567890123

        // 'b' character
        attributes = [textStorage.attributedString attributesAtIndex:5 effectiveRange:NULL];
        expect(attributes[NSForegroundColorAttributeName]).to.equal(hashtagAttributes[NSForegroundColorAttributeName]);
        expect(attributes[NSBackgroundColorAttributeName]).to.equal(hashtagAttributes[NSBackgroundColorAttributeName]);

        // new space character
        attributes = [textStorage.attributedString attributesAtIndex:6 effectiveRange:NULL];
        expect(attributes[NSForegroundColorAttributeName]).to.beNil();
        expect(attributes[NSBackgroundColorAttributeName]).to.beNil();

        // 'a' character
        attributes = [textStorage.attributedString attributesAtIndex:7 effectiveRange:NULL];
        expect(attributes[NSForegroundColorAttributeName]).to.beNil();
        expect(attributes[NSBackgroundColorAttributeName]).to.beNil();

        // 'l' character
        attributes = [textStorage.attributedString attributesAtIndex:13 effectiveRange:NULL];
        expect(attributes[NSForegroundColorAttributeName]).to.beNil();
        expect(attributes[NSBackgroundColorAttributeName]).to.beNil();


        // space character
        attributes = [textStorage.attributedString attributesAtIndex:14 effectiveRange:NULL];
        expect(attributes[NSForegroundColorAttributeName]).to.beNil();
        expect(attributes[NSBackgroundColorAttributeName]).to.beNil();

        // '#' character
        attributes = [textStorage.attributedString attributesAtIndex:15 effectiveRange:NULL];
        expect(attributes[NSForegroundColorAttributeName]).to.equal(hashtagAttributes[NSForegroundColorAttributeName]);
        expect(attributes[NSBackgroundColorAttributeName]).to.equal(hashtagAttributes[NSBackgroundColorAttributeName]);
    });
});

SpecEnd
