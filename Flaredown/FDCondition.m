//
//  FDCondition.m
//  Flaredown
//
//  Created by Cole Cunningham on 3/26/15.
//  Copyright (c) 2015 Flaredown. All rights reserved.
//

#import "FDCondition.h"
#import "FDEntry.h"

@implementation FDCondition

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if(self) {
        _conditionId = [dictionary objectForKey:@"id"];
        _name = [dictionary objectForKey:@"name"];
    }
    return self;
}

- (id)initWithTitle:(NSString *)title entry:(FDEntry *)entry
{
    self = [super init];
    if(self) {
        _conditionId = [NSString stringWithFormat:@"conditions_%@_%@", title, [entry entryId]];
        _name = title;
    }
    return self;
}

- (NSDictionary *)dictionaryCopy
{
    return @{
             @"id":_conditionId,
             @"name":_name,
             };
}

@end
