//
//  FDResponse.m
//  Flaredown
//
//  Created by Cole Cunningham on 11/10/14.
//  Copyright (c) 2014 Flaredown. All rights reserved.
//

#import "FDResponse.h"

@implementation FDResponse

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if(self) {
        _responseId = [dictionary objectForKey:@"id"];
        _name = [dictionary objectForKey:@"name"];
        _value = [[dictionary objectForKey:@"value"] intValue];
        _catalog = [dictionary objectForKey:@"catalog"];
    }
    return self;
}

- (NSDictionary *)dictionaryCopy
{
    return @{
             @"id":_responseId,
             @"name":_name,
             @"value":[NSNumber numberWithInteger:_value],
             @"catalog":_catalog
             };
}

- (void)setResponseIdWithEntryId:(NSString *)entryId name:(NSString *)name
{
    _responseId = [NSString stringWithFormat:@"%@_%@", name, entryId];
}

@end
