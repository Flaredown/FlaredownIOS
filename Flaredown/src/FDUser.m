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

#import "FDAnalyticsManager.h"
#import "FDStyle.h"

@implementation FDUser

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if(self) {
        NSDictionary *userDictionary = [dictionary objectForKey:@"user"];
        if(!userDictionary)
            userDictionary = [dictionary objectForKey:@"current_user"];
        _userId = [[userDictionary objectForKey:@"id"] integerValue];
        _email = [userDictionary objectForKey:@"email"];
        _authenticationToken = [userDictionary objectForKey:@"authentication_token"];
        
        NSDictionary *settingsDictionary = [userDictionary objectForKey:@"settings"];
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
        
        _onboarded = [[settingsDictionary objectForKey:@"onboarded"] boolValue];
        _createdAt = [FDStyle dateFromString:[userDictionary objectForKey:@"created_at"] detailed:YES];
        if([dictionary objectForKey:@"updated_at"])
            _updatedAt = [FDStyle dateFromString:[dictionary objectForKey:@"updated_at"] detailed:YES];
        else
            _updatedAt = [NSDate date];
        
        _previousDoses = [[NSMutableDictionary alloc] init];
        NSArray *settingsKeys = [settingsDictionary allKeys];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(SELF BEGINSWITH %@)",@"treatment_"];
        NSArray *treatmentKeys = [settingsKeys filteredArrayUsingPredicate:predicate];
        for(NSString *key in treatmentKeys) {
            NSString *treatmentPair = [key stringByReplacingOccurrencesOfString:@"treatment_" withString:@""];
            NSArray *components = [treatmentPair componentsSeparatedByString:@"_"];
            NSString *treatmentName = components[0];
            NSString *treatmentUnit, *doseKey;
            float quantity;
            if([components count] == 2) {
                doseKey = components[1];
                treatmentUnit = [settingsDictionary objectForKey:[NSString stringWithFormat:@"treatment_%@_unit", treatmentName]];
                quantity = [[settingsDictionary objectForKey:[NSString stringWithFormat:@"treatment_%@_quantity", treatmentName]] floatValue];
            } else {//prevent duplicate doses
                doseKey = components[2];
                NSInteger index = [components[1] integerValue];
                treatmentUnit = [settingsDictionary objectForKey:[NSString stringWithFormat:@"treatment_%@_%i_unit", treatmentName, index]];
                quantity = [[settingsDictionary objectForKey:[NSString stringWithFormat:@"treatment_%@_%i_quantity", treatmentName, index]] floatValue];
            }
            if([doseKey isEqualToString:@"unit"]) {
                FDDose *dose = [[FDDose alloc] init];
                [dose setQuantity:quantity];
                [dose setUnit:treatmentUnit];
                if(![_previousDoses objectForKey:treatmentName]) {
                    [_previousDoses setObject:[[NSMutableArray alloc] init] forKey:treatmentName];
                }
                [[_previousDoses objectForKey:treatmentName] addObject:dose];
            }
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
        [[FDAnalyticsManager sharedManager] registerUser:self];
    }
    return self;
}

- (NSString *)sexString
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
    return sex;
}

- (NSDate *)birthdayDate
{
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:_birthDateDay];
    [components setMonth:_birthDateMonth];
    [components setYear:_birthDateYear];
    NSDate *date = [components date];
    return date;
}

- (NSDictionary *)dictionaryCopy
{
    NSString *sex = [self sexString];
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
    NSMutableDictionary *settingsDictionary = [@{
                                                @"location":_location,
                                                @"sex":sex,
                                                @"dobDay":[NSNumber numberWithInteger:_birthDateDay],
                                                @"dobMonth":[NSNumber numberWithInteger:_birthDateMonth],
                                                @"dobYear":[NSNumber numberWithInteger:_birthDateYear],
                                                @"onboarded":@(_onboarded)
                                                } mutableCopy];
    for(NSString *treatmentName in _previousDoses) {
        for(FDDose *dose in [_previousDoses objectForKey:treatmentName]) {
            NSString *treatmentUnitKey = [NSString stringWithFormat:@"treatment_%@_unit", treatmentName];
            NSString *treatmentQuantityKey = [NSString stringWithFormat:@"treatment_%@_quantity", treatmentName];
            [settingsDictionary setObject:[dose unit] forKey:treatmentUnitKey];
            [settingsDictionary setObject:@([dose quantity]) forKey:treatmentQuantityKey];
        }
    }

    return @{
             @"user":@{
                     @"id":[NSNumber numberWithInteger:_userId],
                     @"email":_email,
                     @"authentication_token":_authenticationToken,
                     @"created_at":[FDStyle dateStringForDate:_createdAt detailed:YES],
                     @"updated_at":[FDStyle dateStringForDate:_updatedAt detailed:YES],
                     @"settings":settingsDictionary
                     },
             @"treatments":mutableTreatments,
             @"symptoms":mutableSymptoms,
             @"conditions":mutableConditions
             };
}

@end
