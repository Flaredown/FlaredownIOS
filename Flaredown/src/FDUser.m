//
//  FDUser.m
//  Flaredown
//
//  Created by Cole Cunningham on 11/3/14.
//  Copyright (c) 2014 Flaredown. All rights reserved.
//

#import "FDUser.h"
#import "FDTreatment.h"
#import "FDSymptom.h"

@implementation FDUser

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if(self) {
        NSDictionary *userDictionary = [dictionary objectForKey:@"user"];
        _userId = [[userDictionary objectForKey:@"id"] integerValue];
        _email = [userDictionary objectForKey:@"email"];
        _authenticationToken = [userDictionary objectForKey:@"authentication_token"];
        
        _treatments = [[NSMutableArray alloc] init];
        NSArray *treatmentsMaster = [dictionary objectForKey:@"treatments"];
        NSArray *treatmentIds = [userDictionary objectForKey:@"treatment_ids"];
        for(int i = 0; i < treatmentIds.count; i++) {
            NSInteger treatmentId = (NSInteger)treatmentIds[i];
            for (NSDictionary *treatment in treatmentsMaster) {
                if((NSInteger)[treatment objectForKey:@"id"] == treatmentId)
                    [_treatments addObject:[[FDTreatment alloc] initWithDictionary:treatment]];
            }
        }
        
        _symptoms = [[NSMutableArray alloc] init];
        NSArray *symptomsMaster = [dictionary objectForKey:@"symptoms"];
        NSArray *symptomIds = [userDictionary objectForKey:@"symptom_ids"];
        for(int i = 0; i < symptomIds.count; i++) {
            NSInteger symptomId = (NSInteger)symptomIds[i];
            for (NSDictionary *symptom in symptomsMaster) {
                if((NSInteger)[symptom objectForKey:@"id"] == symptomId)
                    [_symptoms addObject:[[FDSymptom alloc] initWithDictionary:symptom]];
            }
        }
    }
    return self;
}

- (NSDictionary *)dictionaryCopy
{
    return @{
             @"id":[NSNumber numberWithInteger:_userId],
             @"email":_email,
             @"authentication_token":_authenticationToken
             };
}

@end
