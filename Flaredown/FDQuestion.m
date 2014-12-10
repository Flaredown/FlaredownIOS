//
//  FDQuestion.m
//  Flaredown
//
//  Created by Cole Cunningham on 11/10/14.
//  Copyright (c) 2014 Flaredown. All rights reserved.
//

#import "FDQuestion.h"

@implementation FDQuestion

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if(self) {
        _catalog = [dictionary objectForKey:@"catalog"];
        _group = [dictionary objectForKey:@"group"];
        _questionId = [[dictionary objectForKey:@"id"] integerValue];
        _inputIds = [dictionary objectForKey:@"input_ids"];
        _kind = [dictionary objectForKey:@"kind"];
        _localizedName = [dictionary objectForKey:@"localized_name"];
        _name = [dictionary objectForKey:@"name"];
        _section = [[dictionary objectForKey:@"section"] integerValue];
    }
    return self;
}

- (NSDictionary *)dictionaryCopy
{
    return @{
             @"catalog":_catalog,
             @"group":_group,
             @"id":[NSNumber numberWithInteger:_questionId],
             @"input_ids":_inputIds,
             @"kind":_kind,
             @"localized_name":_localizedName,
             @"name":_name,
             @"section":[NSNumber numberWithInteger:_section]
             };
}

@end
