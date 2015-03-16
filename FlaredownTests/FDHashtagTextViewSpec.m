//
//  FDHashtagTextViewSpec.m
//  Flaredown
//
//  Created by joshua may on 14/03/2015.
//  Copyright 2015 Flaredown. All rights reserved.
//

#define EXP_SHORTHAND
#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <Expecta+Snapshots/EXPMatchers+FBSnapshotTest.h>

#import "FDHashtagHighlightTextStorage.h"
#import "FDHashtagTextView.h"


SpecBegin(FDHashtagTextView)

__block CGRect frame = CGRectMake(0, 0, 320, 200);

describe(@"FDHashtagTextView", ^{
    it(@"should highlight hashtags", ^{
        FDHashtagTextView *textView = [[FDHashtagTextView alloc] initWithFrame:frame];

        textView.attributedText = [[NSMutableAttributedString alloc] initWithString:@"foo #bar baz q#ux"];

        expect(textView).to.haveValidSnapshot();
    });
});

SpecEnd
