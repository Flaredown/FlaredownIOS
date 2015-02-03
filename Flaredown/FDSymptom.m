//
//  FDSymptom.m
//  Flaredown
//
//  Created by Cole Cunningham on 1/18/15.
//  Copyright (c) 2015 Flaredown. All rights reserved.
//

#import "FDSymptom.h"
#import "FDEntry.h"

@implementation FDSymptom

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if(self) {
        _symptomId = [dictionary objectForKey:@"id"];
        _name = [dictionary objectForKey:@"name"];
    }
    return self;
}

- (id)initWithTitle:(NSString *)title entry:(FDEntry *)entry
{
    self = [super init];
    if(self) {
        _symptomId = [NSString stringWithFormat:@"symptoms_%@_%@", title, [entry entryId]];
        _name = title;
    }
    return self;
}

- (NSDictionary *)dictionaryCopy
{
    return @{
             @"id":_symptomId,
             @"name":_name,
             };
}

@end
