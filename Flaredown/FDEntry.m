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
#import "FDTreatment.h"

@implementation FDEntry

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if(self) {
        _entryId = [dictionary objectForKey:@"id"];
        _date = [dictionary objectForKey:@"date"];
        _catalogs = [dictionary objectForKey:@"catalogs"];
        
        _questions = [[NSMutableArray alloc] init];
        int section = 0;
        for (NSString *catalog in _catalogs) {
            NSArray *catalogDefinition = [[dictionary objectForKey:@"catalog_definitions"] objectForKey:catalog];
            for(int i = 0; i < catalogDefinition.count; i++) {
                for (NSDictionary *questionDefinition in catalogDefinition[i]) {
                    [_questions addObject:[[FDQuestion alloc] initWithDictionary:questionDefinition catalog:catalog section:section]];
                }
                section++;
            }
        }
        
        _notes = ![[NSNull null] isEqual:[dictionary objectForKey:@"notes"]] ?  [dictionary objectForKey:@"notes"]: @"";
        
        NSMutableArray *mutableResponses = [[NSMutableArray alloc] init];
        for(NSDictionary *response in [dictionary objectForKey:@"responses"]) {
            [mutableResponses addObject:[[FDResponse alloc] initWithDictionary:response]];
        }
        _responses = mutableResponses;
        
        _treatments = [[NSMutableArray alloc] init];
        for(NSDictionary *treatment in [dictionary objectForKey:@"treatments"]) {
            [_treatments addObject:[[FDTreatment alloc] initWithDictionary:treatment]];
        }
        
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
    NSMutableArray *mutableTreatments = [[NSMutableArray alloc] init];
    for(FDTreatment *treatment in _treatments) {
        [mutableTreatments addObject:[treatment dictionaryCopy]];
    }
    return @{
             @"id":_entryId,
             @"date":_date,
             @"catalogs":_catalogs,
             @"questions":mutableQuestions,
             @"notes":_notes,
             @"responses":mutableResponses,
             @"treatments":mutableTreatments,
             @"scores":_scores
             };
}

- (NSDictionary *)responseDictionaryCopy
{
    NSMutableArray *mutableResponses = [[NSMutableArray alloc] init];
    for(FDResponse *response in _responses) {
        [mutableResponses addObject:[response dictionaryCopy]];
    }
    NSMutableArray *mutableTreatments = [[NSMutableArray alloc] init];
    for(FDTreatment *treatment in _treatments) {
        [mutableTreatments addObject:[treatment dictionaryCopy]];
    }
    return @{
             @"responses":mutableResponses,
             @"treatments":mutableTreatments,
             @"notes":_notes
             };
}

- (NSMutableArray *)questionsForCatalog:(NSString *)catalog
{
    if(![_catalogs containsObject:catalog])
        return nil;
    NSMutableArray *catalogQuestions = [[NSMutableArray alloc] init];
    for (FDQuestion *question in _questions) {
        if([[question catalog] isEqualToString:catalog])
            [catalogQuestions addObject:question];
    }
    if([catalogQuestions count] == 0)
        return nil;
    return catalogQuestions;
}

- (void)insertQuestion:(FDQuestion *)question atIndex:(NSInteger)index
{
    for(NSInteger i = index; i < [_questions count]; i++) {
        [_questions[i] setSection:[_questions[i] section]+1];
    }
    [_questions insertObject:question atIndex:index];
    
    //New response
    FDResponse *response = [[FDResponse alloc] initWithEntry:self question:question];
    if(![self responseForId:[response responseId]]) {
        [self insertResponse:response];
    }
}

- (void)removeQuestion:(FDQuestion *)question
{
    NSInteger index = [_questions indexOfObject:question];
    for(NSInteger i = index; i < [_questions count]; i++) {
        [_questions[i] setSection:[_questions[i] section]-1];
    }
    [_questions removeObject:question];
    
    //Remove response
    FDResponse *responseToRemove = [[FDResponse alloc] init];
    [responseToRemove setResponseIdWithEntryId:_entryId name:[question name]];
    [_responses removeObject:[self responseForId:[responseToRemove responseId]]];
}

- (void)insertResponse:(FDResponse *)response
{
    if(!response) {
        NSLog(@"Attempted to add null response");
        return;
    }
    for(int i = 0; i < [_responses count]; i++) {
        if([[_responses[i] name] isEqualToString:[response name]]) {
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
