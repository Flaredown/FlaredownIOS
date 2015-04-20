//
//  FDResponse.m
//  Flaredown
//
//  Created by Cole Cunningham on 11/10/14.
//  Copyright (c) 2014 Flaredown. All rights reserved.
//

#import "FDResponse.h"
#import "FDEntry.h"
#import "FDQuestion.h"

@implementation FDResponse

@synthesize value = _value;

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    
    self = [super init];
    if(self) {
        _responseId = [dictionary objectForKey:@"id"];
        _name = [dictionary objectForKey:@"name"];
        _value = [dictionary objectForKey:@"value"] == [NSNull null] ? -1 : [[dictionary objectForKey:@"value"] intValue];
        _catalog = [dictionary objectForKey:@"catalog"];
        _responded = NO;
    }
    return self;
}

- (id)initWithEntry:(FDEntry *)entry question:(FDQuestion *)question
{
    self = [super init];
    if(self) {
        [self setResponseIdWithEntryId:[entry entryId] name:[question name]];
        _name = [question name];
        _value = -1;
        _catalog = [question catalog];
        _responded = NO;
    }
    return self;
}

- (NSDictionary *)dictionaryCopy
{
    return @{
             @"id":_responseId,
             @"name":_name,
             @"value":_responded ? [NSNumber numberWithInteger:_value] : [NSNull null],
             @"catalog":_catalog
             };
}

- (int)value
{
    return _value;
}

- (void)setValue:(int)value
{
    if(!_responded)
        _responded = YES;
    _value = value;
}

- (void)setResponseIdWithEntryId:(NSString *)entryId name:(NSString *)name
{
    _responseId = [NSString stringWithFormat:@"%@_%@", name, entryId];
}

@end
