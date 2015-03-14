//
//  FDHashtagFinder.m
//  Flaredown
//
//  Created by joshua may on 14/03/2015.
//  Copyright (c) 2015 Flaredown. All rights reserved.
//

#import "FDHashtagFinder.h"

static NSString * const FDHashtagFinderRegexString = @"\\B(#\\w+)";

@interface FDHashtagFinder ()

@property (nonatomic, strong) NSRegularExpression *regex;

@end

@implementation FDHashtagFinder

- (instancetype)init {
    self = [super init];

    if (self) {
        _regex = [NSRegularExpression regularExpressionWithPattern:FDHashtagFinderRegexString
                                      options:0
                                      error:nil];
    }

    return self;
}

#pragma mark - API

- (NSArray *)rangesInString:(NSString *)string {
    return [self rangesInString:string range:NSMakeRange(0, string.length)];
}

- (NSArray *)rangesInString:(NSString *)string range:(NSRange)range {
    NSMutableArray *ranges = [NSMutableArray array];

    [self.regex enumerateMatchesInString:string
                                 options:0
                                   range:range
                              usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                                  NSRange range = [result rangeAtIndex:1];
                                  [ranges addObject:[NSValue valueWithRange:range]];
                              }];

    return ranges.copy;
}

@end
