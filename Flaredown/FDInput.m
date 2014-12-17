//
//  FDInput.m
//  Flaredown
//
//  Created by Cole Cunningham on 11/10/14.
//  Copyright (c) 2014 Flaredown. All rights reserved.
//

#import "FDInput.h"

@implementation FDInput

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if(self) {
        _helper = [dictionary objectForKey:@"helper"];
//        _inputId = [[dictionary objectForKey:@"id"] intValue];
        _label = [dictionary objectForKey:@"label"];
        _metaLabel = [dictionary objectForKey:@"meta_label"];
        _value = [[dictionary objectForKey:@"value"] intValue];
    }
    return self;
}

- (NSDictionary *)dictionaryCopy
{
    return @{
             @"helper":_helper,
//             @"id":[NSNumber numberWithInteger:_inputId],
             @"label":_label,
             @"meta_label":_metaLabel,
             @"value":[NSNumber numberWithInteger:_value]
             };
}

@end
