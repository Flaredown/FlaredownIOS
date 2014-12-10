//
//  FDEntry.m
//  Flaredown
//
//  Created by Cole Cunningham on 11/3/14.
//  Copyright (c) 2014 Flaredown. All rights reserved.
//

#import "FDEntry.h"
#import "FDQuestion.h"
#import "FDResponse.h"

@implementation FDEntry

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if(self) {
        _entryId = [dictionary objectForKey:@"id"];
        _date = [dictionary objectForKey:@"date"];
        NSMutableArray *mutableQuestions = [[NSMutableArray alloc] init];
        for (NSDictionary *question in [dictionary objectForKey:@"questions"]) {
            [mutableQuestions addObject:[[FDQuestion alloc] initWithDictionary:question]];
        }
        _questions = [mutableQuestions copy];
        NSMutableArray *mutableResponses = [[NSMutableArray alloc] init];
        for(NSDictionary *response in [dictionary objectForKey:@"responses"]) {
            [mutableResponses addObject:[[FDResponse alloc] initWithDictionary:response]];
        }
        _responses = mutableResponses;
        _scores = [dictionary objectForKey:@"scores"];
    }
    return self;
}

- (NSDictionary *)dictionaryCopy
{
    NSMutableArray *mutableQuestions = [[NSMutableArray alloc] init];
    for (FDQuestion *question in _questions) {
        [mutableQuestions addObject:[question dictionaryCopy]];
    }
    NSMutableArray *mutableResponses = [[NSMutableArray alloc] init];
    for (FDResponse *response in _responses) {
        [mutableResponses addObject:[response dictionaryCopy]];
    }
    return @{
             @"id":_entryId,
             @"date":_date,
             @"questions":mutableQuestions,
             @"responses":mutableResponses,
             @"scores":_scores
             };
}

- (void)insertResponse:(FDResponse *)response
{
    if(!response) {
        NSLog(@"Attempted to add null response");
        return;
    }
    for(int i = 0; i < [_responses count]; i++) {
        if([[_responses[i] responseId] isEqualToString:[response responseId]]) {
            [_responses setObject:response atIndexedSubscript:i];
            return;
        }
    }
    [_responses addObject:response];
}

- (void)removeResponse:(FDResponse *)response
{
    [_responses removeObject:response];
}

- (FDResponse *)responseForId:(NSString *)responseId
{
    for (FDResponse *response in _responses) {
        if([[response responseId] isEqualToString:responseId])
            return response;
    }
    return nil;
}

@end
