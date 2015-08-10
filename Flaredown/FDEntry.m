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
        _catalogs = [[dictionary objectForKey:@"catalogs"] mutableCopy];
        
        _questions = [[NSMutableArray alloc] init];
        int section = 0;
        
        if([_catalogs containsObject:@"conditions"]) {
            NSArray *catalogDefinition = [[dictionary objectForKey:@"catalog_definitions"] objectForKey:@"conditions"];
            for(int i = 0; i < catalogDefinition.count; i++) {
                for (NSDictionary *questionDefinition in catalogDefinition[i]) {
                    [_questions addObject:[[FDQuestion alloc] initWithDictionary:questionDefinition catalog:@"conditions" section:section]];
                }
                section++;
            }
        }
        
        for (NSString *catalog in _catalogs) {
            if(![catalog isEqualToString:@"conditions"]) {
                NSArray *catalogDefinition = [[dictionary objectForKey:@"catalog_definitions"] objectForKey:catalog];
                for(int i = 0; i < catalogDefinition.count; i++) {
                    for (NSDictionary *questionDefinition in catalogDefinition[i]) {
                        [_questions addObject:[[FDQuestion alloc] initWithDictionary:questionDefinition catalog:catalog section:section]];
                    }
                    section++;
                }
            }
        }
        
        _notes = ([dictionary objectForKey:@"notes"] && ![[NSNull null] isEqual:[dictionary objectForKey:@"notes"]]) ? [dictionary objectForKey:@"notes"]: @"";
        
        NSMutableArray *mutableResponses = [[NSMutableArray alloc] init];
        for(NSDictionary *response in [dictionary objectForKey:@"responses"]) {
            [mutableResponses addObject:[[FDResponse alloc] initWithDictionary:response]];
        }
        _responses = mutableResponses;
        
        _treatments = [[NSMutableArray alloc] init];
        NSMutableArray *allTreatments = [[NSMutableArray alloc] init];
        for(NSDictionary *treatment in [dictionary objectForKey:@"treatments"]) {
            [allTreatments addObject:[[FDTreatment alloc] initWithDictionary:treatment]];
        }
        for(FDTreatment *newTreatment in allTreatments) {
            bool found = NO;
            for(FDTreatment *masterTreatment in _treatments) {
                if([[masterTreatment name] isEqualToString:[newTreatment name]]) {
                    [[masterTreatment doses] addObject:[newTreatment doses][0]];
                    found = YES;
                }
                break;
            }
            if(!found)
               [_treatments addObject:newTreatment];
        }
        
        _scores = [dictionary objectForKey:@"scores"] ? [dictionary objectForKey:@"scores"] : [[NSMutableArray alloc] init];
        _tags = [dictionary objectForKey:@"tags"] ? [[dictionary objectForKey:@"tags"] mutableCopy] : [[NSMutableArray alloc] init];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
        _createdAt = [dateFormatter dateFromString:[dictionary objectForKey:@"created_at"]];
        _updatedAt = [dateFormatter dateFromString:[dictionary objectForKey:@"updated_at"]];
    }
    return self;
}

- (NSDictionary *)dictionaryCopy
{
    NSMutableDictionary *catalogDefinitions = [[NSMutableDictionary alloc] init];
    for (NSString *catalog in _catalogs) {
        [catalogDefinitions setObject:[[NSMutableArray alloc] init] forKey:catalog];
    }

    int lastSection = -1;
    for (FDQuestion *question in _questions) {
        NSMutableArray *catalogDefinition = [catalogDefinitions objectForKey:[question catalog]];
        if([question section] != lastSection) {
            [catalogDefinition addObject:[[NSMutableArray alloc] init]];
            lastSection = [question section];
        }
        [[catalogDefinition lastObject] addObject:[question dictionaryCopy]];
    }
    
    NSMutableArray *mutableResponses = [[NSMutableArray alloc] init];
    for (FDResponse *response in _responses) {
        [mutableResponses addObject:[response dictionaryCopy]];
    }
    NSMutableArray *mutableTreatments = [[NSMutableArray alloc] init];
    for(FDTreatment *treatment in _treatments) {
        if([[treatment doses] count] == 0)
            [mutableTreatments addObject:[treatment dictionaryCopy]];
        else {
            NSArray *treatmentDictionaries = [treatment arrayCopy];
            for (NSDictionary *treatmentDictionary in treatmentDictionaries) {
                [mutableTreatments addObject:treatmentDictionary];
            }
        }
    }
    return @{
             @"id":_entryId,
             @"date":_date,
             @"catalogs":_catalogs,
             @"catalog_definitions":catalogDefinitions,
             @"notes":_notes,
             @"responses":mutableResponses,
             @"treatments":mutableTreatments,
             @"scores":_scores ?: [[NSArray alloc] init],
             @"tags":_tags
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
        if([[treatment doses] count] == 0)
            [mutableTreatments addObject:[treatment dictionaryCopy]];
        else {
            NSArray *treatmentDictionaries = [treatment arrayCopy];
            for (NSDictionary *treatmentDictionary in treatmentDictionaries) {
                [mutableTreatments addObject:treatmentDictionary];
            }
        }
    }
    return @{
             @"responses":mutableResponses,
             @"treatments":mutableTreatments,
             @"notes":_notes,
             @"tags":_tags
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
    
    if(![_catalogs containsObject:[question catalog]])
        [_catalogs addObject:[question catalog]];
    
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

- (FDResponse *)responseForQuestion:(FDQuestion *)question
{
    FDResponse *response = [[FDResponse alloc] init];
    [response setResponseIdWithEntryId:[self entryId] name:[question name]];
    return [self responseForId:[response responseId]];
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
