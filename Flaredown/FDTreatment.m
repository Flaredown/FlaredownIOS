//
//  FDTreatment.m
//  Flaredown
//
//  Created by Cole Cunningham on 12/17/14.
//  Copyright (c) 2014 Flaredown. All rights reserved.
//

#import "FDTreatment.h"
#import "FDEntry.h"

#import "FDStyle.h"

@implementation FDTreatment

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if(self) {
        _treatmentId = [dictionary objectForKey:@"id"];
        _name = [dictionary objectForKey:@"name"];
        
        _doses = [[NSMutableArray alloc] init];
        float quantity = [[dictionary objectForKey:@"quantity"] isEqual:[NSNull null]] ? 0 : [[dictionary objectForKey:@"quantity"] floatValue];
        NSString *unit = ![dictionary objectForKey:@"unit"] || [[dictionary objectForKey:@"unit"] isEqual:[NSNull null]] ? @"" : [dictionary objectForKey:@"unit"];
        if([dictionary objectForKey:@"quantity"] != [NSNull null] && [dictionary objectForKey:@"unit"] != [NSNull null]) {
            FDDose *dose = [[FDDose alloc] init];
            [dose setQuantity:quantity];
            [dose setUnit:unit];
            [_doses addObject:dose];
        }
    }
    return self;
}

- (id)initWithTitle:(NSString *)title entry:(FDEntry *)entry
{
    self = [super init];
    if(self) {
        _treatmentId = [NSString stringWithFormat:@"%@___%@", title, [entry entryId]];
        _name = title;
    }
    return self;
}

- (NSArray *)arrayCopy
{
    NSMutableArray *treatments = [[NSMutableArray alloc] init];
    for (FDDose *dose in _doses) {
        [treatments addObject:[self dictionaryCopyWithDose:dose]];
    }
    return [treatments copy];
}

- (NSDictionary *)dictionaryCopy
{
    return @{
             @"id":_treatmentId,
             @"name":_name,
             @"quantity":[NSNull null],
             @"unit":[NSNull null],
             };
}

- (NSDictionary *)dictionaryCopyWithDose:(FDDose *)dose
{
    return @{
             @"id":_treatmentId,
             @"name":_name,
             @"quantity":[FDStyle trimmedDecimal:[dose quantity]],
             @"unit":[dose unit],
             };
}

@end
