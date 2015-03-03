//
//  FDTrackableResult.m
//  Flaredown
//
//  Created by Cole Cunningham on 2/18/15.
//  Copyright (c) 2015 Flaredown. All rights reserved.
//

#import "FDTrackableResult.h"

@implementation FDTrackableResult

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if(self) {
        _name = [dictionary objectForKey:@"name"];
//        _count = [[dictionary objectForKey:@"count"] integerValue];
        _count = 0;
    }
    return self;
}

@end
