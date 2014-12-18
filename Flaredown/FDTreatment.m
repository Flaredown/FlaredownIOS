//
//  FDTreatment.m
//  Flaredown
//
//  Created by Cole Cunningham on 12/17/14.
//  Copyright (c) 2014 Flaredown. All rights reserved.
//

#import "FDTreatment.h"

@implementation FDTreatment

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if(self) {
        _treatmentId = [dictionary objectForKey:@"id"];
        _name = [dictionary objectForKey:@"name"];
        _quantity = [[dictionary objectForKey:@"quantity"] floatValue];
        _unit = [dictionary objectForKey:@"unit"];
    }
    return self;
}

- (NSDictionary *)dictionaryCopy
{
    return @{
             @"id":_treatmentId,
             @"name":_name,
             @"quantity":[NSString stringWithFormat:@"%f", _quantity],
             @"unit":_unit
             };
}


@end
