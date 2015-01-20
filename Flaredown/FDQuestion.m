//
//  FDQuestion.m
//  Flaredown
//
//  Created by Cole Cunningham on 11/10/14.
//  Copyright (c) 2014 Flaredown. All rights reserved.
//

#import "FDQuestion.h"
#import "FDInput.h"
#import "FDSymptom.h"

@implementation FDQuestion

- (id)initWithDictionary:(NSDictionary *)dictionary catalog:(NSString *)catalog section:(NSInteger)section
{
    self = [super init];
    if(self) {
        _catalog = catalog;
//        _group = [dictionary objectForKey:@"group"];
//        _questionId = [[dictionary objectForKey:@"id"] integerValue];
        
        NSMutableArray *inputs = [[NSMutableArray alloc] init];
        for (NSDictionary *inputDefinition in [dictionary objectForKey:@"inputs"]) {
            [inputs addObject:[[FDInput alloc] initWithDictionary:inputDefinition]];
        }
        _inputs = [inputs copy];
        
//        _inputIds = [dictionary objectForKey:@"input_ids"];
        _kind = [dictionary objectForKey:@"kind"];
//        _localizedName = [dictionary objectForKey:@"localized_name"];
        _name = [dictionary objectForKey:@"name"];
        _section = section;
    }
    return self;
}

- (id)initWithSymptom:(FDSymptom *)symptom section:(NSInteger)section
{
    self = [super init];
    if(self) {
        _catalog = @"symptoms";
        NSMutableArray *inputs = [[NSMutableArray alloc] init];
        //default inputs
        for(int i = 0; i < 5; i++) {
            [inputs addObject:[[FDInput alloc] initWithDictionary:@{
                                                                   @"helper":[NSNull null],
                                                                   @"label":@"",
                                                                   @"meta_label":@"",
                                                                   @"value":[NSNumber numberWithInt:i]
                                                                   }]];
        }
        _inputs = [inputs copy];
        _kind = @"select";
        _name = [symptom name];
        _section = section;
    }
    return self;
}

- (NSDictionary *)dictionaryCopy
{
    NSMutableArray *mutableInputs = [[NSMutableArray alloc] init];
    for (FDInput *input in _inputs) {
        [mutableInputs addObject:[input dictionaryCopy]];
    }
    return @{
//             @"catalog":_catalog,
//             @"group":_group,
//             @"id":[NSNumber numberWithInteger:_questionId],
//             @"input_ids":_inputIds,
             @"inputs":mutableInputs,
             @"kind":_kind,
//             @"localized_name":_localizedName,
             @"name":_name,
//             @"section":[NSNumber numberWithInteger:_section]
             };
}

@end
