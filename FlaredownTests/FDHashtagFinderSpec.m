//
//  FDHashtagFinderSpec.m
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


SpecBegin(FDHashtagFinder)

describe(@"FDHashtagFinder", ^{
    FDHashtagFinder *finder = [[FDHashtagFinder alloc] init];

    it(@"should return an empty array for no hashtags", ^{
        NSArray *matches = [finder rangesInString:@"foo bar baz"];
        expect(matches.count).to.equal(0);
    });

    it(@"should not match hashes in the middle of words", ^{
        NSArray *matches = [finder rangesInString:@"foo b#ar baz"];
        expect(matches.count).to.equal(0);
    });

    it(@"should find hashtag mid-sentence", ^{
        NSArray *matches = [finder rangesInString:@"foo #bar baz"];
        expect(matches.count).to.equal(1);

        NSValue *rangeValue = matches[0];
        expect(rangeValue.rangeValue.location).to.equal(4);
        expect(rangeValue.rangeValue.length).to.equal(4);
    });

    it(@"should break on punctuation", ^{
        NSArray *matches = [finder rangesInString:@"foo #b'ar baz"];
        expect(matches.count).to.equal(1);

        NSValue *rangeValue = matches[0];
        expect(rangeValue.rangeValue.location).to.equal(4);
        expect(rangeValue.rangeValue.length).to.equal(2);
    });


    it(@"should find hashtag at start of sentence", ^{
        NSArray *matches = [finder rangesInString:@"#foo bar baz"];
        expect(matches.count).to.equal(1);

        NSValue *rangeValue = matches[0];
        expect(rangeValue.rangeValue.location).to.equal(0);
        expect(rangeValue.rangeValue.length).to.equal(4);
    });

    it(@"should find hashtag at end of sentence", ^{
        NSArray *matches = [finder rangesInString:@"foo bar #baz"];
        expect(matches.count).to.equal(1);

        NSValue *rangeValue = matches[0];
        expect(rangeValue.rangeValue.location).to.equal(8);
        expect(rangeValue.rangeValue.length).to.equal(4);
    });

    it(@"should find multiple hashtags", ^{
        NSArray *matches = [finder rangesInString:@"foo #bar #baz qux"];
        expect(matches.count).to.equal(2);

        NSValue *rangeValue = matches[0];
        expect(rangeValue.rangeValue.location).to.equal(4);
        expect(rangeValue.rangeValue.length).to.equal(4);

        rangeValue = matches[1];
        expect(rangeValue.rangeValue.location).to.equal(9);
        expect(rangeValue.rangeValue.length).to.equal(4);
    });

    it(@"should find hashtag in specified range", ^{
        NSArray *matches = [finder rangesInString:@"#foo bar #baz qux" range:NSMakeRange(5, 10)];
        expect(matches.count).to.equal(1);

        NSValue *rangeValue = matches[0];
        expect(rangeValue.rangeValue.location).to.equal(9);
        expect(rangeValue.rangeValue.length).to.equal(4);
    });
});

SpecEnd
