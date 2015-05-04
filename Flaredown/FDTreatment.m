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

@synthesize quantity = _quantity;

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if(self) {
        _treatmentId = [dictionary objectForKey:@"id"];
        _name = [dictionary objectForKey:@"name"];
        _quantity = [[dictionary objectForKey:@"quantity"] isEqual:[NSNull null]] ? 0 : [[dictionary objectForKey:@"quantity"] floatValue];
        _unit = ![dictionary objectForKey:@"unit"] || [[dictionary objectForKey:@"unit"] isEqual:[NSNull null]] ? @"" : [dictionary objectForKey:@"unit"];
        _taken = [dictionary objectForKey:@"taken"] ? [[dictionary objectForKey:@"taken"] boolValue]: NO;
    }
    return self;
}

- (id)initWithTitle:(NSString *)title quantity:(float)quantity unit:(NSString *)unit entry:(FDEntry *)entry
{
    self = [super init];
    if(self) {
        _treatmentId = [NSString stringWithFormat:@"%@___%@", title, [entry entryId]];
        _name = title;
        _quantity = quantity;
        _unit = unit;
        _taken = NO;
    }
    return self;
}

- (NSDictionary *)dictionaryCopy
{
    return @{
             @"id":_treatmentId,
             @"name":_name,
             @"quantity":_taken ? [FDStyle trimmedDecimal:_quantity] : [NSNull null],
             @"unit":_unit,
             @"taken":@(_taken)
             };
}

@end
