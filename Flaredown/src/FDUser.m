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
#import "FDCondition.h"

@implementation FDUser

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if(self) {
        NSDictionary *userDictionary = [dictionary objectForKey:@"user"];
        _userId = [[userDictionary objectForKey:@"id"] integerValue];
        _email = [userDictionary objectForKey:@"email"];
        _authenticationToken = [userDictionary objectForKey:@"authentication_token"];
        
        NSDictionary *settingsDictionary = [dictionary objectForKey:@"settings"];
        _birthDateDay = [[settingsDictionary objectForKey:@"dobDay"] integerValue];
        _birthDateMonth = [[settingsDictionary objectForKey:@"dobMonth"] integerValue];
        _birthDateYear = [[settingsDictionary objectForKey:@"dobYear"] integerValue];
        _location = [settingsDictionary objectForKey:@"location"];
        NSString *sex = [settingsDictionary objectForKey:@"sex"];
        if([sex isEqualToString:@"Male"]) {
            _sex = SexMale;
        } else if([sex isEqualToString:@"Female"]) {
            _sex = SexFemale;
        } else if([sex isEqualToString:@"Other"]) {
            _sex = SexOther;
        } else if([sex isEqualToString:@"Prefer not to disclose"]) {
            _sex = SexUndisclosed;
        } else {
            _sex = SexNone;
        }
        
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
        _conditions = [[NSMutableArray alloc] init];
        NSArray *conditionsMaster = [dictionary objectForKey:@"conditions"];
        NSArray *conditionIds = [userDictionary objectForKey:@"condition_ids"];
        for(int i = 0; i < conditionIds.count; i++) {
            NSInteger conditionId = (NSInteger)conditionIds[i];
            for (NSDictionary *condition in conditionsMaster) {
                if((NSInteger)[condition objectForKey:@"id"] == conditionId)
                    [_conditions addObject:[[FDCondition alloc] initWithDictionary:condition]];
            }
        }
    }
    return self;
}

- (NSDictionary *)dictionaryCopy
{
    NSString *sex;
    if(_sex == SexMale) {
        sex = @"Male";
    } else if(_sex == SexFemale) {
        sex = @"Female";
    } else if(_sex == SexOther) {
        sex = @"Other";
    } else if(_sex == SexUndisclosed) {
        sex = @"Prefer not to say";
    } else {
        sex = @"";
    }
    NSMutableArray *mutableTreatments = [[NSMutableArray alloc] init];
    for (FDTreatment *treatment in _treatments) {
        [mutableTreatments addObject:[treatment dictionaryCopy]];
    }
    NSMutableArray *mutableSymptoms = [[NSMutableArray alloc] init];
    for (FDSymptom *symptom in _symptoms) {
        [mutableSymptoms addObject:[symptom dictionaryCopy]];
    }
    NSMutableArray *mutableConditions = [[NSMutableArray alloc] init];
    for (FDCondition *condition in _conditions) {
        [mutableConditions addObject:[condition dictionaryCopy]];
    }
    return @{
             @"user":@{
                     @"id":[NSNumber numberWithInteger:_userId],
                     @"email":_email,
                     @"authentication_token":_authenticationToken
                     },
             @"treatments":mutableTreatments,
             @"symptoms":mutableSymptoms,
             @"conditions":mutableConditions,
             @"settings":@{
                         @"location":_location,
                         @"sex":sex,
                         @"dobDay":[NSNumber numberWithInteger:_birthDateDay],
                         @"dobMonth":[NSNumber numberWithInteger:_birthDateMonth],
                         @"dobYear":[NSNumber numberWithInteger:_birthDateYear]
                         }
             };
}

@end
